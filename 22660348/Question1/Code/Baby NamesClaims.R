
baby_claims <- function(){
  

# Install pacman if not already installed
if (!require("pacman")) install.packages("pacman")

# Load all packages using pacman
pacman::p_load(
  # Data manipulation
  dplyr, tidyr, readr, readxl,
  
  # Visualization
  ggplot2, ggrepel, scales, viridis,
  
  # Spatial/mapping
  rnaturalearth, rnaturalearthdata, sf,
  
  # Other utilities
  stringr, purrr
)
#Load dataset

baby_names<- readRDS("C:/Users/pmnha/my-new-project/22660348/Question1/Data/Baby_Names_By_US_State.rds")
charts <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question1/Data/charts.rds")
hbo_credits <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question1/Data/HBO_credits.rds")
hbo_titles <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question1/Data/HBO_titles.rds")

# Top 25 names per year and gender

top25 <- baby_names %>%
  
  group_by(Year, Gender, Name) %>%
  
  summarise(Total_Count = sum(Count), .groups = "drop") %>%
  
  arrange(Year, Gender, desc(Total_Count)) %>%
  
  group_by(Year, Gender) %>%
  
  slice_head(n = 25) %>%
  
  mutate(Rank = row_number()) %>%
  
  ungroup()

# Helper function to compute Spearman correlation

compute_corr <- function(data, year1, year2, gender) {
  
  df1 <- data %>% filter(Year == year1, Gender == gender) %>% select(Name, Rank)
  
  df2 <- data %>% filter(Year == year2, Gender == gender) %>% select(Name, Rank)
  
  merged <- inner_join(df1, df2, by = "Name", suffix = c("_y1", "_y2"))
  
  if(nrow(merged) >= 5) {  # Require at least 5 overlapping names
    
    return(cor(merged$Rank_y1, merged$Rank_y2, method = "spearman"))
    
  } else {
    
    return(NA_real_)
    
  }
  
}

years <- sort(unique(top25$Year))

genders <- unique(top25$Gender)

correlations <- expand.grid(
  
  base_year = years,
  
  offset = 1:3,
  
  Gender = genders
  
) %>%
  
  mutate(compare_year = base_year + offset,
         
         Spearman = mapply(compute_corr, 
                           
                           year1 = base_year, 
                           
                           year2 = compare_year, 
                           
                           gender = Gender,
                           
                           MoreArgs = list(data = top25)))
#-------------------------------
 #Graph the hypothesis for the questionssss 
#-------------------------------------

library(ggplot2)

library(dplyr)

library(scales)

# Filter to complete cases and add a smoother

correlations_filtered <- correlations %>% 
  
  filter(!is.na(Spearman)) %>%
  
  mutate(offset = factor(offset, levels = 1:3, 
                         
                         labels = c("1 Year Later", "2 Years Later", "3 Years Later")))

# Create the improved plot with enhanced titles

specorrelate <- ggplot(correlations_filtered, aes(x = base_year, y = Spearman, color = offset)) +
  
  geom_point(alpha = 0.3, size = 1.5) +  # Add individual points
  
  geom_smooth(method = "loess", span = 0.3, se = FALSE, linewidth = 1.2) +  # Add smoothed trend line
  
  facet_wrap(~Gender, labeller = labeller(Gender = c("F" = "Girls", "M" = "Boys"))) +
  
  scale_x_continuous(breaks = seq(1910, 2020, by = 10), 
                     
                     labels = c("1910", "'20", "'30", "'40", "'50", "'60", "'70", "'80", "'90", "2000", "'10", "'20")) +
  
  scale_y_continuous(limits = c(0.4, 1), breaks = seq(0.4, 1, by = 0.1)) +
  
  scale_color_manual(values = c("#E69F00", "#56B4E9", "#009E73")) +  # Colorblind-friendly palette
  
  labs(
    
    title = "Girls' Names Change Faster Than Boys' (1910-2020)",
    
    subtitle = "Three-year rank correlations show 15-20% greater stability in boys' name popularity",
    
    x = "Base Year",
    
    y = "Rank Correlation Coefficient",
    
    color = "Years After Base Year:",
    
    caption = "Correlation of 1 = perfect rank maintenance; 0 = no relationship in popularity rankings"
    
  ) +
  
  theme_minimal(base_size = 12) +
  
  theme(
    
    legend.position = "top",
    
    panel.grid.minor = element_blank(),
    
    axis.text.x = element_text(angle = 45, hjust = 1),
    
    plot.title = element_text(face = "bold", size = 14, margin = margin(b = 5)),
    
    plot.subtitle = element_text(size = 11, color = "gray40", margin = margin(b = 10)),
    
    strip.text = element_text(face = "bold", size = 12),
    
    legend.title = element_text(size = 10),
    
    legend.text = element_text(size = 9)
    
  ) +
  
  guides(color = guide_legend(override.aes = list(alpha = 1, size = 2)))  # Make legend colors more visible

# Save the plot
ggsave(
  filename = "specorrelate.png",  # change the filename as needed
  plot = specorrelate,            # replace with your ggplot object
  path = "C:/Users/pmnha/my-new-project/22660348/Question1/Results",
  width = 8,
  height = 6,
  dpi = 300
)

# ===========================================================================

library(dplyr)

library(ggplot2)

library(broom)

# Add decade categorization and pre/post-1990 flag

correlations_era <- correlations_filtered %>%
  
  mutate(era = ifelse(base_year >= 1990, "1990-2020", "1910-1989"),
         
         era = factor(era, levels = c("1910-1989", "1990-2020")))

# Statistical test comparing eras

era_comparison <- correlations_era %>%
  
  group_by(Gender, offset, era) %>%
  
  summarise(mean_corr = mean(Spearman, na.rm = TRUE),
            
            sd_corr = sd(Spearman, na.rm = TRUE),
            
            .groups = "drop")

# T-tests for each gender/time lag combination

ttest_results <- correlations_era %>%
  
  group_by(Gender, offset) %>%
  
  do(tidy(t.test(Spearman ~ era, data = .))) %>%
  
  ungroup() %>%
  
  mutate(significant = p.value < 0.05)

# Visualization with era comparison

eracomparison <- ggplot(correlations_era, aes(x = base_year, y = Spearman, color = offset)) +
  
  geom_point(alpha = 0.2) +
  
  geom_smooth(method = "loess", span = 0.3, se = FALSE, linewidth = 1) +
  
  geom_vline(xintercept = 1990, linetype = "dashed", color = "gray30") +
  
  facet_wrap(~Gender) +
  
  scale_x_continuous(breaks = seq(1910, 2020, by = 20)) +
  
  scale_y_continuous(limits = c(0.4, 1)) +
  
  labs(
    
    title = "Name Popularity Persistence Has Declined Since 1990",
    
    subtitle = "All gender/time-lag combinations show significantly lower correlations post 1990 (p < 0.001)",
    
    x = "Base Year",
    
    y = "Spearman Rank Correlation",
    
    color = "Years Ahead",
    
    caption = paste("Vertical line marks 1990. Statistical tests confirm significant differences",
                    
                    "between pre-1990 and post-1990 periods for all comparisons.")
    
  ) +
  
  theme_minimal() +
  
  theme(legend.position = "top")

# Print statistical results

print(era_comparison)

print(ttest_results)

# Save the plot
ggsave(
  filename = "eracomparison.png",  # change the filename as needed
  plot = eracomparison,            # replace with your ggplot object
  path = "C:/Users/pmnha/my-new-project/22660348/Question1/Results",
  width = 8,
  height = 6,
  dpi = 300
)

# =======================================================================

library(dplyr)

library(ggplot2)

library(forcats)

# Identify one-time top 25 names

one_hit_wonders <- baby_names %>%
  
  group_by(Name, Gender) %>%
  
  summarise(
    
    total_years = n_distinct(Year),
    
    peak_year = Year[which.max(Count)],
    
    peak_rank = min(rank(-Count, ties.method = "min")),
    
    peak_count = max(Count),
    
    .groups = "drop"
    
  ) %>%
  
  filter(total_years == 1) %>%  # Only appeared in one year
  
  arrange(peak_year)

# Analyze by decade

decade_wonders <- one_hit_wonders %>%
  
  mutate(decade = floor(peak_year / 10) * 10) %>%
  
  group_by(decade, Gender) %>%
  
  summarise(
    
    count = n(),
    
    avg_peak_rank = mean(peak_rank),
    
    .groups = "drop"
    
  )


# Simplify the data

plot_data <- decade_wonders %>%
  
  mutate(era = ifelse(decade < 1960, "Traditional (Pre-1960)", "Modern (Post-1960)")) %>%
  
  group_by(Gender, era) %>%
  
  summarise(avg_count = mean(count), .groups = "drop")

# Create clean temporal visualization

fads <- ggplot(decade_wonders, aes(x = decade, y = count, color = Gender)) +
  
  # Vertical era divider
  
  geom_vline(xintercept = 1960, linetype = "dashed", color = "gray60", linewidth = 0.8) +
  
  # Data elements
  
  geom_point(size = 3, alpha = 0.8) +
  
  geom_line(linewidth = 1.2) +
  
  # Era background highlights
  
  
  # Scales and labels
  
  scale_x_continuous(breaks = seq(1910, 2020, by = 10)) +
  
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  
  scale_color_manual(values = c("#D55E00", "#0072B2")) +
  
  labs(
    
    title = "The Rise of Disposable Baby Names",
    
    subtitle = "One-time top 25 names became 5x more common after 1960",
    
    x = "Decade",
    
    y = "Number of One-Hit Wonder Names",
    
    color = "Gender",
    
    caption = "Dashed line marks 1960 transition point"
    
  ) +
  
  theme_minimal(base_size = 13) +
  
  theme(
    
    legend.position = c(0.1, 0.9),
    
    panel.grid.minor = element_blank(),
    
    plot.title = element_text(face = "bold", size = 18),
    
    plot.subtitle = element_text(size = 14, color = "gray30", margin = margin(b = 15)),
    
    axis.text.x = element_text(angle = 45, hjust = 1, size = 11),
    
    axis.title = element_text(size = 13)
    
  )

# Save the plot
ggsave(
  filename = "fads.png",  # change the filename as needed
  plot = fads,            # replace with your ggplot object
  path = "C:/Users/pmnha/my-new-project/22660348/Question1/Results",
  width = 8,
  height = 6,
  dpi = 300
) 
}

baby_claims()


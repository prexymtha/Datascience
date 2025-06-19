#Load all libraries 
baby_length <- function () {
  

  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(readr, dplyr, ggplot2)
  

#Load dataset

baby_names<- readRDS("C:/Users/pmnha/my-new-project/22660348/Question1/Data/Baby_Names_By_US_State.rds")
charts <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question1/Data/charts.rds")
hbo_credits <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question1/Data/HBO_credits.rds")
hbo_titles <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question1/Data/HBO_titles.rds")




top_25_names_per_year_gender <- baby_names %>%
  group_by(Year, Gender, Name) %>%
  summarise(Total = sum(Count), .groups = "drop") %>%
  arrange(Year, Gender, desc(Total)) %>%
  group_by(Year, Gender) %>%
  slice_head(n = 25)

name_longevity <- top_25_names_per_year_gender %>%
  group_by(Name, Gender) %>%
  summarise(YearsInTop25 = n_distinct(Year), .groups = "drop") %>%
  filter(YearsInTop25 >= 10) %>%
  arrange(desc(YearsInTop25))


# Prepare data with percentage and year labels
top_surges <- baby_names %>%
  group_by(Year, Name, Gender) %>%
  summarise(Total = sum(Count), .groups = "drop") %>%
  arrange(Name, Gender, Year) %>%
  group_by(Name, Gender) %>%
  mutate(
    Change = Total - lag(Total),
    Pct_Increase = Change / lag(Total) * 100,
    Label = sprintf("%s\n%s (%d)", 
                    Name, 
                    percent(Pct_Increase/100, accuracy = 0.1), 
                    Year)
  ) %>%
  ungroup() %>%
  arrange(desc(Change)) %>%
  filter(!is.na(Change)) %>%
  group_by(Gender) %>%
  slice_max(Change, n = 10) %>%
  ungroup() %>%
  mutate(
    Gender = factor(Gender, levels = c("F", "M")), # Force female-first ordering
    Label = fct_reorder(Label, Change)
  )

# Create plot with adjusted spacing
yearonyear <- ggplot(top_surges, aes(x = Change, y = Label, color = Gender)) +
  geom_segment(aes(xend = 0, yend = Label), linewidth = 2) +
  geom_point(size = 4) +
  facet_wrap(~Gender, scales = "free_y", ncol = 2) +
  scale_color_manual(values = c("F" = "#e91e63", "M" = "#3498db")) +
  labs(
    title = "Top 10 Names with Biggest Year-on-Year Surges",
    subtitle = "Percentage increase and year shown for each name",
    x = "Increase in Births (Year-over-Year)",
    y = "",
    caption = "Data: US Baby Names (1910-2020)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    strip.text = element_text(face = "bold", size = 12),
    panel.spacing = unit(1.5, "lines"), # Add space between facets
    axis.text.y = element_text(size = 9, lineheight = 0.9), # Better multi-line spacing
    panel.grid.major.y = element_blank()
  ) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.15))) # Add right margin

# Save the plot
ggsave(
  filename = "yearonyear.png",  # change the filename as needed
  plot = yearonyear,            # replace with your ggplot object
  path = "C:/Users/pmnha/my-new-project/22660348/Question1/Results",
  width = 8,
  height = 6,
  dpi = 300
)

library(tidyverse)
library(ggplot2)

library(tidyverse)
library(ggplot2)

# Calculate years in Top 25 (filtering for >= 10 years) and keep top 15 per gender
name_longevity <- top_25_names_per_year_gender %>%
  group_by(Name, Gender) %>%
  summarise(YearsInTop25 = n_distinct(Year), .groups = "drop") %>%
  filter(YearsInTop25 >= 10) %>%
  group_by(Gender) %>%  # Group by gender before slicing
  arrange(desc(YearsInTop25), .by_group = TRUE) %>%  # Sort within each gender
  slice_head(n = 15) %>%  # Keep top 15 per gender
  ungroup() %>%
  mutate(Gender = factor(Gender, levels = c("M", "F")))  # Ensure M/F ordering

# Create the plot
nametime <- ggplot(name_longevity, aes(x = YearsInTop25, y = reorder(Name, YearsInTop25), fill = Gender)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Gender, scales = "free_y", ncol = 2) +  # Side-by-side
  scale_fill_manual(values = c("M" = "#1f77b4", "F" = "#ff7f0e")) +  # Blue/Orange
  labs(
    title = "Top 15 Baby Names with Longest Longevity in Top 25 (10+ Years)",
    x = "Years in Top 25",
    y = "Name",
    caption = "Data: US Baby Names (1910-2020)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    strip.text = element_text(face = "bold")  # Bold facet labels
  )

# Save the plot
ggsave(
  filename = "nametime.png",  # change the filename as needed
  plot = nametime,            # replace with your ggplot object
  path = "C:/Users/pmnha/my-new-project/22660348/Question1/Results",
  width = 8,
  height = 6,
  dpi = 300
) 

#Y-O-Y changes 

}
baby_length()


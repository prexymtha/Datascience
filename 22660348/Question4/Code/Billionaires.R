Bespoke_Read_Function <- function(data_path, info_path) {
  # Load/install all required packages using pacman
  if (!require(pacman)) install.packages("pacman")
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
  # Step 1: Read and prepare the info file
  Info_File <- read_excel(info_path) %>%
    select(Key, `Column Type`) %>%  # Use only these two columns 
    rename(column = Key, type = `Column Type`) %>%
    mutate(column = tolower(column))  # Ensure consistent case
  
  # Step 2: Read billionaires data column names
  billionaires_cols <- names(read_csv(data_path, n_max = 0)) %>%
    tolower()  # Match case with Info_File
  
  # Step 3: Create column type specification
  col_spec <- list()
  
  for (col in billionaires_cols) {
    col_info <- Info_File %>% filter(column == col)
    
    if (nrow(col_info) == 1) {
      col_spec[[col]] <- switch(col_info$type,
                                "String" = col_character(),
                                "Integer" = col_integer(),
                                "Float" = col_double(),
                                col_character()) # default
    } else {
      warning(paste("Column", col, "not found in Info_File. Defaulting to character."))
      col_spec[[col]] <- col_character()
    }
  }
  
  # Step 4: Read data 
  billionaires <- read_csv(
    data_path,
    col_types = do.call(cols, col_spec),
    name_repair = "minimal"  # Preserve original column names
  )
  
  return(billionaires)
}

#Call the function 
billionaires <- Bespoke_Read_Function(
  "C:/Users/pmnha/OneDrive/Desktop/Masters 2025_Economics/Datascience/Exam/22660348/Question4/Data/billionaires.csv",
  "C:/Users/pmnha/OneDrive/Desktop/Masters 2025_Economics/Datascience/Exam/22660348/Question4/Data/Info_File.xlsx"
)

#Question : In the US , you saw an increasing number of new billionaires emerge 
#that had little to no familial ties to generetional wealth 
#We do a temporal trend analysis : Shows the trend of self-made billionaires over time

# Create a cleaner version of inheritance types for grouping and plotting
inheritance_plot <- billionaires %>%
  filter(location.citizenship == "United States",
         !is.na(wealth.how.inherited)) %>%
  mutate(inheritance_group = case_when(
    wealth.how.inherited == "not inherited" ~ "Not Inherited",
    wealth.how.inherited == "father" ~ "Father",
    wealth.how.inherited == "spouse/widow" ~ "Spouse/Widow",
    grepl("generation", wealth.how.inherited) ~ "Multi-Generational",
    TRUE ~ "Other"
  )) %>%
  count(year, inheritance_group) %>%
  ggplot(aes(x = year, y = n, fill = inheritance_group)) +
  geom_area(alpha = 0.8) +
  labs(
    title = "US Billionaires by Wealth Inheritance Type",
    x = "Year", y = "Count", fill = "Inheritance Type"
  ) +
  scale_fill_manual(values = c(
    "Not Inherited" = "#ff7f0e",
    "Father" = "#d62728",
    "Spouse/Widow" = "#2ca02c",
    "Multi-Generational" = "#9467bd",
    "Other" = "#8c564b"
  )) +
  theme_minimal()

#save 
ggsave(
  filename = "inheritance.png",
  plot = inheritance_plot,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)

#BUBBLE PLOT
# Prepare the data
bubble_data_year <- billionaires %>%
  filter(
    location.citizenship == "United States",
    wealth.how.inherited %in% c(
      "not inherited", "father", "spouse/widow",
      "3rd generation", "4th generation", "5th generation or longer"
    ),
    !is.na(wealth.how.industry),
    !is.na(year)
  ) %>%
  count(year, wealth.how.inherited, wealth.how.industry, name = "count") %>%
  mutate(
    highlight = ifelse(wealth.how.inherited == "not inherited", "Not Inherited", "Other"),
    x_label = ifelse(wealth.how.inherited == "not inherited", "Not Inherited", "")
  )

# Plot
bubble <- ggplot(bubble_data_year, aes(
  x = x_label,
  y = wealth.how.industry,
  size = count,
  color = highlight
)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_color_manual(values = c("Not Inherited" = "#1f77b4", "Other" = "gray80")) +
  scale_size_area(max_size = 15) +
  facet_wrap(~ year, ncol = 3) +
  labs(
    title = "Surge of New-Money In the US: Industry Breakdown Over Time (1990s–2010s)",  #need to italic subtitle
    subtitle = "Forget trust funds – this is how tech wizards,hedge fund sharks, and disruptors built their billions",
    x = "Inheritance Type",
    x = "Inheritance Type",
    y = "Industry",
    size = "Number of Billionaires"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(face = "bold", color = "#1f77b4"),
    strip.text = element_text(face = "bold")
  )

#save
ggsave(
  filename = "bubble.png",
  plot = bubble,  # Replace with your actual plot object name
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)


#Other development markets and emerging markets tend to have less enterpreneurial successes and tend to house mostly inhereted wealth
#classify market types 
market_type <- function(country) {
  if (country %in% c(
    "United States", "Switzerland", "Germany", "Japan", "Sweden", "France", "Canada",
    "South Korea", "Italy", "Singapore", "United Kingdom", "Australia", "Netherlands",
    "Ireland", "Israel", "Denmark", "Austria", "New Zealand", "Norway", "Belgium",
    "Finland", "Portugal"
  )) {
    return("Developed")
    
  } else if (country %in% c(
    "Mexico", "Hong Kong", "Taiwan", "Philippines", "Indonesia", "Malaysia", "Brazil",
    "Russia", "India", "Thailand", "Turkey", "Chile", "China", "Argentina", "Greece",
    "Colombia", "Cyprus", "South Africa", "Ukraine", "Czech Republic", "Egypt", 
    "Poland", "Romania", "Vietnam", "Peru", "Kazakhstan", "Lithuania"
  )) {
    return("Emerging")
    
  } else if (country %in% c(
    "Saudi Arabia", "Kuwait", "United Arab Emirates", "Bahrain", "Oman", "Qatar", "Angola", "Algeria"
  )) {
    return("Oil Economy")
    
  } else {
    return("Other")
  }
}

#billionaires$market_type <- factor(billionaires$market_type, 
#levels = c("Developed", "Emerging", "Oil Economy", "Other"))


billionaires$market_type <- sapply(billionaires$location.citizenship, market_type)
table(billionaires$market_type)
head(billionaires[, c("location.citizenship", "market_type")])




# Step 1: Reclassify market types with US separate
billionaires <- billionaires %>%
  mutate(
    wealth_origin_grouped = ifelse(wealth.how.inherited == "not inherited", "Not Inherited", "Inherited"),
    market_type_clean = case_when(
      location.citizenship == "United States" ~ "United States",
      market_type == "Developed Market" ~ "Developed Market (excl. US)",
      TRUE ~ market_type
    )
  )

# Step 2: Summarize grouped data
wealth_by_market <- billionaires %>%
  group_by(market_type_clean, wealth_origin_grouped) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(market_type_clean) %>%
  mutate(percentage = count / sum(count) * 100)

# Step 3: Lollipop chart with improved styling
wealthbyregion <- ggplot(wealth_by_market, aes(x = reorder(market_type_clean, percentage), y = percentage, color = wealth_origin_grouped)) +
  geom_segment(aes(xend = market_type_clean, y = 0, yend = percentage),
               color = "gray75", size = 0.7) +  # Fainter lines
  geom_point(size = 6, alpha = 0.95) +         # Darker, clearer bubbles
  coord_flip() +
  labs(
    title = "Entrepreneurial vs Inherited Wealth by Market Type (US Treated Separately)",
    y = "Percentage of Billionaires",
    x = "Market Type",
    color = "Wealth Origin"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 12),
    legend.position = "top"
  )

#Save
ggsave(
  filename = "wealthbyregion.png",
  plot = wealthbyregion,  # Replace with your actual plot object name
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)



# Reclassify market type: separate US as before so you can see effects of developed economy without US 
billionaires <- billionaires %>%
  mutate(
    market_type_clean = case_when(
      location.citizenship == "United States" ~ "United States",
      TRUE ~ market_type
    ),
    wealth_origin_grouped = ifelse(`wealth.how.inherited` == "not inherited", "Not Inherited", "Inherited"),
    wealth.how.industry_clean = case_when(
      # Clean typos or group related industries
      grepl("Technology", wealth.how.industry, ignore.case = TRUE) ~ "Technology",
      grepl("Consumer", wealth.how.industry, ignore.case = TRUE) ~ "Consumer Services",
      grepl("Retail", wealth.how.industry, ignore.case = TRUE) ~ "Retail/Restaurant",
      grepl("Real Estate", wealth.how.industry, ignore.case = TRUE) ~ "Real Estate",
      grepl("Financial|banking|hedge|venture|private equity|money management", wealth.how.industry, ignore.case = TRUE) ~ "Financial Services",
      grepl("Mining|Energy|Industrial|Construction|Metals", wealth.how.industry, ignore.case = TRUE) ~ "Industrial/Mining/Energy",
      is.na(wealth.how.industry) ~ "Unknown",
      TRUE ~ "Other"
    )
  )

industry_dist <- billionaires %>%
  filter(wealth_origin_grouped == "Not Inherited") %>%  # Focus on self-made
  group_by(market_type_clean, wealth.how.industry_clean) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(market_type_clean) %>%
  mutate(percentage = count / sum(count) * 100)


# Prepare data -
industry_dist <- billionaires %>%
  filter(wealth_origin_grouped == "Not Inherited") %>%
  mutate(
    market_type_clean = case_when(
      location.citizenship == "United States" ~ "United States",
      TRUE ~ market_type
    ),
    wealth.how.industry_clean = case_when(
      grepl("Technology", wealth.how.industry, ignore.case = TRUE) ~ "Technology",
      grepl("Consumer", wealth.how.industry, ignore.case = TRUE) ~ "Consumer Services",
      TRUE ~ "Other"
    )
  ) %>%
  group_by(market_type_clean, wealth.how.industry_clean) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(market_type_clean) %>%
  mutate(percentage = count / sum(count) * 100)

# Define colors: highlight Technology & Consumer Services
fill_colors <- c(
  "Technology" = "#1f78b4",        # blue
  "Consumer Services" = "#33a02c", # green
  "Other" = "grey95"                # light grey
)

# Plot stacked bar chart (diversity chart style)
industrydominance <- ggplot(industry_dist, aes(x = market_type_clean, y = percentage, fill = wealth.how.industry_clean)) +
  geom_col(color = "black", size = 0.15) +  # small border to separate segments
  scale_fill_manual(values = fill_colors) +
  coord_flip() +
  labs(
    title = "Industry Diversity of Self-Made Billionaires by Market Type",
    subtitle = "Technology & Consumer Services Highlighted",
    x = "Market Type",
    y = "Percentage of Self-Made Billionaires",
    fill = "Industry"
  ) +
  theme_minimal() +
  theme(legend.position = "top")

#save 
ggsave(
  filename = "industrydominance.png",
  plot = industrydominance,  # Replace with your actual plot object name
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)

#FOUNDER AGE ANALYSIS 
# Age distribution of self-made founders
# Create founder age distribution plot
founder_age_plot <- billionaires %>%
  filter(company.relationship == "founder") %>%
  ggplot(aes(x = demographics.age, fill = wealth.how.industry_clean)) +
  geom_density(alpha = 0.7) +
  facet_grid(year~market_type_clean) +
  labs(title = "Founder Age Distribution by Market Type",
       x = "Age",
       y = "Density", 
       fill = "Industry") +
  theme_minimal() +
  theme(legend.position = "bottom",
        strip.text = element_text(size = 8),  # Adjust facet label size
        axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels

# Save the plot
ggsave(
  filename = "founder_age_by_market_type.png",
  plot = founder_age_plot,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 12,  # Wider to accommodate facets
  height = 10,  # Taller for year facets
  dpi = 300,
  limitsize = FALSE  # Allows larger dimensions
)
#Growth Mechanismsss


# 1. Regional Wealth Concentration Analysis ---------------------------------

# Top countries by billionaire count
top_countries <- billionaires %>%
  count(`location.country code`, name = "billionaire_count") %>%
  arrange(desc(billionaire_count)) %>%
  head(20)

# Top countries by total wealth
top_wealth <- billionaires %>%
  group_by(`location.country code`) %>%
  summarise(total_wealth = sum(`wealth.worth in billions`)) %>%
  arrange(desc(total_wealth)) %>%
  head(20)

# Time trend by region
regional_trend <- billionaires %>%
  group_by(year, location.region) %>%
  summarise(
    count = n(),
    total_wealth = sum(`wealth.worth in billions`),
    .groups = "drop"
  )

# Visualization: Top countries by billionaire count
topcountries <- ggplot(top_countries, aes(x = reorder(`location.country code`, billionaire_count), 
                          y = billionaire_count)) +
  geom_col(fill = "#1f77b4") +
  coord_flip() +
  labs(title = "Top 20 Countries by Billionaire Count",
       x = "Country Code",
       y = "Number of Billionaires") +
  theme_minimal()
#save 
#save 
ggsave(
  filename = "topcountries.png",
  plot = topcountries,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)

# Visualization: Wealth concentration over time by region
regional <- ggplot(regional_trend, aes(x = year, y = total_wealth, color = location.region)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_y_continuous(labels = scales::dollar_format(suffix = "B")) +
  labs(title = "Total Billionaire Wealth by Region Over Time",
       x = "Year",
       y = "Total Wealth (Billions USD)",
       color = "Region") +
  theme_minimal() +
  theme(legend.position = "bottom")
#save 
#save 
ggsave(
  filename = "regional.png",
  plot = regional,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)


# 2. Market Type Influence Analysis ----------------------------------------

# Billionaire growth by market type
market_growth <- billionaires %>%
  group_by(year, market_type) %>%
  summarise(
    count = n(),
    total_wealth = sum(`wealth.worth in billions`),
    .groups = "drop"
  ) %>%
  complete(year, market_type, fill = list(count = 0, total_wealth = 0))

# Calculate growth rates
market_growth <- market_growth %>%
  group_by(market_type) %>%
  mutate(
    count_growth = (count - lag(count))/lag(count),
    wealth_growth = (total_wealth - lag(total_wealth))/lag(total_wealth)
  ) %>%
  ungroup()

# Visualization: Billionaire count by market type
billmarket <- ggplot(market_growth, aes(x = year, y = count, color = market_type)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(title = "Billionaire Count by Market Type Over Time",
       x = "Year",
       y = "Number of Billionaires",
       color = "Market Type") +
  theme_minimal() +
  scale_color_viridis_d()

#save
#save 
ggsave(
  filename = "billmarket.png",
  plot = billmarket,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)

# Visualization: Wealth growth comparison
wealthgrowth <- ggplot(market_growth, aes(x = year, y = wealth_growth, fill = market_type)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Wealth Growth Rate by Market Type",
       x = "Year",
       y = "Annual Growth Rate",
       fill = "Market Type") +
  theme_minimal()

#save 
ggsave(
  filename = "wealthgrowth.png",
  plot = wealthgrowth,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)

# 3. Geographic Wealth Distribution Map ------------------------------------

# Get world map data
world <- ne_countries(scale = "medium", returnclass = "sf")

# Prepare billionaire data for mapping
country_wealth <- billionaires %>%
  group_by(`location.country code`) %>%
  summarise(
    billionaire_count = n(),
    total_wealth = sum(`wealth.worth in billions`),
    .groups = "drop"
  )

# Merge with map data
world_wealth <- world %>%
  left_join(country_wealth, by = c("iso_a3" = "location.country code"))

# Visualization: World map of billionaire wealth
wealthmap <- ggplot(world_wealth) +
  geom_sf(aes(fill = total_wealth)) +
  scale_fill_viridis_c(
    name = "Total Wealth (Billions USD)",
    trans = "log10",
    labels = scales::dollar_format(),
    na.value = "grey90"
  ) +
  labs(title = "Global Distribution of Billionaire Wealth",
       subtitle = "Total net worth of billionaires by country") +
  theme_minimal() +
  theme(legend.position = "bottom")
#Save
#save 
ggsave(
  filename = "wealthmap.png",
  plot = wealthmap,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)


#Top 5 industries per market type 
# 5. Industry Concentration Analysis - Improved Version -------------------

# Calculate top industries by market type
top_industries <- billionaires %>%
  group_by(market_type, `wealth.how.industry_clean`) %>%
  summarise(
    count = n(),
    total_wealth = sum(`wealth.worth in billions`),
    .groups = "drop"
  ) %>%
  group_by(market_type) %>%
  arrange(desc(total_wealth), .by_group = TRUE) %>%
  slice_head(n = 5) %>%  # Top 5 industries per market type
  ungroup() %>%
  mutate(industry_label = paste0(`wealth.how.industry_clean`, " ($", 
                                 round(total_wealth), "B)"))

# Create a clean visualization
industrypermarket <- ggplot(top_industries, 
       aes(x = total_wealth, 
           y = reorder(industry_label, total_wealth),
           fill = market_type)) +
  geom_col() +
  facet_wrap(~market_type, scales = "free_y", ncol = 1) +
  scale_x_continuous(labels = scales::dollar_format(suffix = "B")) +
  labs(title = "Top Industries by Billionaire Wealth Across Market Types",
       subtitle = "Showing top 5 industries per market type",
       x = "Total Wealth (Billions USD)",
       y = "Industry",
       fill = "Market Type") +
  theme_minimal() +
  theme(legend.position = "none",
        strip.text = element_text(face = "bold", size = 10),
        panel.spacing = unit(1, "lines"),
        axis.text.y = element_text(size = 9))

#save 
#save 
ggsave(
  filename = "industrypermarket.png",
  plot = industrypermarket,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)


#Age Analysis 

# Calculate average age by year
age_trends <- billionaires %>%
  filter(!is.na(demographics.age)) %>%  # Remove NA ages
  group_by(year) %>%
  summarise(
    avg_age = mean(demographics.age),
    median_age = median(demographics.age),
    count = n(),
    .groups = "drop"
  )

# Visualization: Age trends over time
ageave <- ggplot(age_trends, aes(x = year)) +
  geom_line(aes(y = avg_age, color = "Average Age"), size = 1.2) +
  geom_line(aes(y = median_age, color = "Median Age"), size = 1.2) +
  geom_point(aes(y = avg_age, color = "Average Age"), size = 2) +
  geom_point(aes(y = median_age, color = "Median Age"), size = 2) +
  scale_color_manual(values = c("Average Age" = "#1f77b4", "Median Age" = "#ff7f0e")) +
  labs(title = "Billionaire Age Trends Over Time",
       subtitle = "Are billionaires getting younger?",
       x = "Year",
       y = "Age",
       color = "Metric") +
  theme_minimal() +
  theme(legend.position = "bottom")

#save
#save 
ggsave(
  filename = "ageave.png",
  plot = ageave,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)

# Distribution y decade 
# Create age distribution by decade plot
age_decade_plot <- billionaires %>%
  filter(!is.na(demographics.age)) %>%
  mutate(decade = floor(year / 10) * 10) %>%
  ggplot(aes(x = demographics.age, fill = factor(decade))) +
  geom_density(alpha = 0.5) +
  facet_wrap(~decade, ncol = 2) +
  labs(title = "Age Distribution by Decade",
       x = "Age",
       y = "Density",
       fill = "Decade") +
  theme_minimal() +
  theme(legend.position = "none")  # Remove redundant legend since facets show decades

# Save the plot
ggsave(
  filename = "age_distribution_by_decade.png",
  plot = age_decade_plot,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, 
  height = 8,  # Slightly taller to accommodate facets
  dpi = 300
)

#gender age 
# 2. Gender Representation Analysis ---------------------------------------

# Calculate gender proportion over time
gender_trends <- billionaires %>%
  mutate(gender = factor(demographics.gender, 
                         levels = c("male", "female"),
                         labels = c("Male", "Female"))) %>%
  filter(!is.na(gender)) %>%
  count(year, gender) %>%
  group_by(year) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

# Visualization: Gender proportion over time do ggsave 
genderage <- ggplot(gender_trends, aes(x = year, y = prop, color = gender)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Gender Representation Among Billionaires",
       subtitle = "Proportion of female billionaires over time",
       x = "Year",
       y = "Proportion",
       color = "Gender") +
  theme_minimal()

#save 
ggsave(
  filename = "genderage.png",
  plot = genderage,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)

# Gender breakdown by market type
gender_market <- billionaires %>%
  filter(!is.na(demographics.gender)) %>%
  count(market_type, demographics.gender) %>%
  group_by(market_type) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

# Visualization: Gender by market type
marketgender <- ggplot(gender_market, aes(x = market_type, y = prop, fill = demographics.gender)) +
  geom_col(position = "fill") +
  geom_text(aes(label = scales::percent(prop, accuracy = 1)), 
            position = position_fill(vjust = 0.5)) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Gender Distribution by Market Type",
       x = "Market Type",
       y = "Percentage",
       fill = "Gender") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#save 
ggsave(
  filename = "marketgender.png",
  plot = marketgender,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, height = 6, dpi = 300
)

# Combined Age & Gender Analysis ---------------------------------------
  
# Create age trends by market type plot
age_market_plot <- billionaires %>%
  filter(!is.na(demographics.age), !is.na(demographics.gender)) %>%
  group_by(year, market_type, demographics.gender) %>%
  summarise(avg_age = mean(demographics.age), .groups = "drop") %>%
  ggplot(aes(x = year, y = avg_age, color = demographics.gender)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  facet_wrap(~market_type) +
  labs(title = "Average Age by Gender and Market Type",
       x = "Year",
       y = "Average Age",
       color = "Gender") +
  theme_minimal()

# Save the plot
ggsave(
  filename = "age_trends_by_market_type.png",
  plot = age_market_plot,
  path = "C:/Users/pmnha/my-new-project/22660348/Question4/Results",
  width = 10, 
  height = 6, 
  dpi = 300
)
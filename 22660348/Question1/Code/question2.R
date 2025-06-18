library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)

baby_names <- read_rds("Precious Project/Exam/Baby_Names_By_US_State.rds")
charts <- read_rds("Precious Project/Exam/charts.rds")
hbo_credits <- read_rds("Precious Project/Exam/HBO_credits.rds")
hbo_titles <- read_rds("Precious Project/Exam/HBO_titles.rds")

# First, separate into boys and girls names
baby_names <- baby_names %>%
  filter(Gender %in% c("M", "F")) %>%
  mutate(Gender = ifelse(Gender == "M", "Boy", "Girl"))

# Function to calculate rank correlations for a given gender
calculate_rank_correlations <- function(gender) {
  # Get top 25 names for each year
  top_names <- baby_names %>%
    filter(Gender == gender) %>%
    group_by(Year) %>%
    arrange(desc(Count)) %>%
    slice_head(n = 25) %>%
    mutate(rank = row_number()) %>%
    ungroup() %>%
    select(Year, Name, rank)
  
  # Create a complete grid of years and names to ensure all combinations
  all_years <- unique(top_names$Year)
  all_names <- unique(top_names$Name)
  complete_grid <- expand.grid(Year = all_years, Name = all_names)
  
  # Join with ranks and fill missing ranks with 26 (below our top 25)
  ranked_names <- complete_grid %>%
    left_join(top_names, by = c("Year", "Name")) %>%
    mutate(rank = ifelse(is.na(rank), 26, rank))
  
  # Pivot to wide format with years as columns
  rank_matrix <- ranked_names %>%
    pivot_wider(names_from = Year, values_from = rank)
  
  # Calculate correlations between each year and the next 3 years
  years <- sort(unique(top_names$Year))
  cor_results <- data.frame()
  
  for (i in 1:(length(years)-3)) {
    current_year <- years[i]
    
    for (j in 1:3) {
      future_year <- years[i+j]
      
      # Get ranks for current and future year
      current_ranks <- rank_matrix[[as.character(current_year)]]
      future_ranks <- rank_matrix[[as.character(future_year)]]
      
      # Calculate Spearman correlation
      cor_test <- cor.test(current_ranks, future_ranks, method = "spearman")
      
      # Store results
      cor_results <- rbind(cor_results, data.frame(
        current_year = current_year,
        future_year = future_year,
        years_ahead = j,
        correlation = cor_test$estimate,
        p_value = cor_test$p.value,
        gender = gender
      ))
    }
  }
  return(cor_results)
}

# Calculate for both genders
boy_correlations <- calculate_rank_correlations("Boy")
girl_correlations <- calculate_rank_correlations("Girl")

# Combine results
all_correlations <- rbind(boy_correlations, girl_correlations)

# Plot the results
ggplot(all_correlations, aes(x = current_year, y = correlation, color = factor(years_ahead))) +
  geom_line() +
  facet_wrap(~gender) +
  labs(title = "Persistence of Baby Name Popularity Over Time",
       subtitle = "Spearman rank correlation between current year's top 25 names and future years",
       x = "Current Year",
       y = "Spearman Rank Correlation",
       color = "Years Ahead") +
  theme_minimal()
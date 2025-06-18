library(tidyverse)
library(ggthemes)

# Load and clean data (pure function)
prepare_movie_data <- function() {
  titles <- read_rds("Precious Project/Exam/titles.rds")
  movies <- read_csv("Precious Project/Exam/netflix_movies.csv")
  
  titles %>%
    filter(type == "MOVIE") %>%
    inner_join(movies, by = "title") %>%
    select(title, imdb_score, runtime, release_year = release_year.x) %>%
    mutate(
      age = 2025 - release_year,  # Assuming current year is 2025 per exam doc
      runtime_bins = cut(
        runtime, 
        breaks = c(0, 30, 60, 90, 120, 150, 180, 240),
        labels = c("<30m", "30-60m", "60-90m", "90-120m", "120-150m", "150-180m", ">180m")
      )
    ) %>%
    filter(!is.na(runtime), !is.na(imdb_score))
}

movie_data <- prepare_movie_data()

runtime_stats <- movie_data %>%
  group_by(runtime_bins) %>%
  summarise(
    avg_rating = mean(imdb_score),
    count = n(),
    .groups = "drop"
  ) %>%
  filter(count >= 10)  # Ensure statistical significance

# Optimal runtime identification
optimal_runtime <- runtime_stats %>%
  slice_max(avg_rating, n = 1)


age_stats <- movie_data %>%
  mutate(age_group = cut(
    age, 
    breaks = c(0, 1, 3, 5, 10, 20, 50),
    labels = c("<1y", "1-3y", "3-5y", "5-10y", "10-20y", ">20y")
  )) %>%
  group_by(age_group) %>%
  summarise(
    avg_rating = mean(imdb_score),
    count = n(),
    .groups = "drop"
  )


ggplot(movie_data, aes(x = runtime_bins, y = imdb_score, fill = runtime_bins)) +
  geom_violin(alpha = 0.7) +
  geom_boxplot(width = 0.1, fill = "white") +
  geom_hline(
    yintercept = optimal_runtime$avg_rating, 
    linetype = "dashed", color = "#E50914"
  ) +
  annotate(
    "text", 
    x = 4, y = optimal_runtime$avg_rating + 0.2,
    label = paste("Peak: ", optimal_runtime$runtime_bins, " (", round(optimal_runtime$avg_rating, 1), ")"),
    color = "#E50914"
  ) +
  labs(
    title = "IMDb Ratings by Movie Runtime",
    subtitle = "Dashed line indicates optimal runtime bin",
    x = "Runtime", y = "IMDb Rating"
  ) +
  scale_fill_brewer(palette = "Reds") +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(age_stats, aes(x = age_group, y = avg_rating, group = 1)) +
  geom_line(color = "#E50914", linewidth = 1.5) +
  geom_point(size = 3, color = "#221F1F") +
  labs(
    title = "Content Aging vs. Audience Engagement",
    x = "Age Group (years)", y = "Avg IMDb Rating"
  ) +
  theme_minimal()
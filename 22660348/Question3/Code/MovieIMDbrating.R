# Load required packages using pacman
if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes)

# Data Preparation Module
prepare_movie_data <- function(titles_path, movies_path, current_year = 2025) {
  titles <- readRDS(titles_path)
  movies <- read_csv(movies_path)
  
  titles %>%
    filter(type == "MOVIE") %>%
    inner_join(movies, by = "title") %>%
    select(title, imdb_score, runtime, release_year = release_year.x) %>%
    mutate(
      age = current_year - release_year,
      runtime_bins = cut(
        runtime, 
        breaks = c(0, 30, 60, 90, 120, 150, 180, 240),
        labels = c("<30m", "30-60m", "60-90m", "90-120m", "120-150m", "150-180m", ">180m")
      )
    ) %>%
    filter(!is.na(runtime), !is.na(imdb_score))
}

# Analysis Module
calculate_runtime_stats <- function(data, min_count = 10) {
  data %>%
    group_by(runtime_bins) %>%
    summarise(
      avg_rating = mean(imdb_score),
      count = n(),
      .groups = "drop"
    ) %>%
    filter(count >= min_count)
}

calculate_age_stats <- function(data) {
  data %>%
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
}

# Visualization Module
create_rating_plot <- function(data, optimal_runtime, save_path = NULL) {
  plot <- ggplot(data, aes(x = runtime_bins, y = imdb_score, fill = runtime_bins)) +
    geom_violin(alpha = 0.7) +
    geom_boxplot(width = 0.1, fill = "white") +
    geom_hline(
      yintercept = optimal_runtime$avg_rating, 
      linetype = "dashed", color = "#E50914"
    ) +
    labs(
      title = "IMDb Ratings by Movie Runtime",
      subtitle = "Dashed line indicates optimal runtime bin",
      x = "Runtime", y = "IMDb Rating"
    ) +
    scale_fill_brewer(palette = "Reds") +
    theme_minimal() +
    theme(legend.position = "none")
  
  if (!is.null(save_path)) {
    ggsave(
      filename = "IMDbratings.png",
      plot = plot,
      path = save_path,
      width = 10,
      height = 6,
      dpi = 300
    )
  }
  
  return(plot)
}

create_engagement_plot <- function(age_stats, save_path = NULL) {
  plot <- ggplot(age_stats, aes(x = age_group, y = avg_rating, group = 1)) +
    geom_line(color = "#E50914", linewidth = 1.5) +
    geom_point(size = 3, color = "#221F1F") +
    labs(
      title = "Content Aging vs. Audience Engagement",
      x = "Age Group (years)", y = "Avg IMDb Rating"
    ) +
    theme_minimal()
  
  if (!is.null(save_path)) {
    ggsave(
      filename = "audienceengage.png",
      plot = plot,
      path = save_path,
      width = 10,
      height = 6,
      dpi = 300
    )
  }
  
  return(plot)
}

# Main Execution
main <- function() {
  # Path configuration
  data_dir <- "C:/Users/pmnha/my-new-project/22660348/Question3/Data"
  results_dir <- "C:/Users/pmnha/my-new-project/22660348/Question3/Results"
  
  # Data preparation
  movie_data <- prepare_movie_data(
    titles_path = file.path(data_dir, "titles.rds"),
    movies_path = file.path(data_dir, "netflix_movies.csv")
  )
  
  # Analysis
  runtime_stats <- calculate_runtime_stats(movie_data)
  optimal_runtime <- runtime_stats %>% slice_max(avg_rating, n = 1)
  age_stats <- calculate_age_stats(movie_data)
  
  # Visualization
  rating_plot <- create_rating_plot(movie_data, optimal_runtime, results_dir)
  engagement_plot <- create_engagement_plot(age_stats, results_dir)
  
  # Return results if needed
  list(
    movie_data = movie_data,
    runtime_stats = runtime_stats,
    age_stats = age_stats,
    plots = list(
      rating_plot = rating_plot,
      engagement_plot = engagement_plot
    )
  )
}

# Execute the analysis
results <- main()

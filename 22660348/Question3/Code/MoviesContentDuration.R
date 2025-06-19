run_netflix_visualizations <- function() {
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(
    tidyverse,
    lubridate,
    ggridges,
    patchwork,
    ggthemes
  )
  
  # Load and prepare data
  titles <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question3/Data/titles.rds")
  movies <- read_csv("Question3/Data/netflix_movies.csv")
  
  # Merge and clean data
  netflix_data <- titles %>%
    filter(type == "MOVIE") %>%
    inner_join(movies, by = "title") %>%
    select(title, genres, imdb_score, runtime, release_year = release_year.x) %>%
    mutate(
      primary_genre = str_extract(genres, "(?<=')[A-Za-z]+(?=')"),
      age = year(Sys.Date()) - release_year,
      runtime_bins = cut(runtime, breaks = seq(0, 240, by = 30))
    ) %>%
    filter(!is.na(primary_genre), !is.na(imdb_score), !is.na(runtime))
  
  # Analysis 1: IMDb Scores by Genre and Release Year
  genre_year_heatmap <- netflix_data %>%
    group_by(primary_genre, release_year) %>%
    summarise(
      avg_rating = mean(imdb_score),
      count = n(),
      .groups = "drop"
    ) %>%
    filter(count >= 5) %>% # Only include genre-years with sufficient data
    complete(primary_genre, release_year, fill = list(avg_rating = NA))
  
  # Heatmap visualization
  genrescore  <- ggplot(genre_year_heatmap, aes(x = release_year, y = reorder(primary_genre, avg_rating, na.rm = TRUE))) +
    geom_tile(aes(fill = avg_rating), color = "white") +
    scale_fill_gradient2(low = "#B81D24", mid = "#F5F5F1", high = "#221F1F", 
                         midpoint = median(netflix_data$imdb_score, na.rm = TRUE),
                         na.value = "grey90") +
    labs(title = "IMDb Scores by Genre and Release Year",
         subtitle = "Darker shades indicate higher average ratings",
         x = "Release Year", y = "Primary Genre", fill = "Avg Rating") +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold"),
          axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Save plot
  ggsave(
    filename = "genrescore.png",  # or use .pdf/.jpg etc.
    plot = genrescore,
    path = "C:/Users/pmnha/my-new-project/22660348/Question3/Results",
    width = 10,
    height = 6,
    dpi = 300
  )
  
  # Analysis 2: Optimal Movie Duration
  runtime_analysis <- netflix_data %>%
    group_by(runtime_bins) %>%
    summarise(
      avg_rating = mean(imdb_score),
      count = n(),
      .groups = "drop"
    ) %>%
    filter(count >= 10)
  
  opduration <- ggplot(runtime_analysis, aes(x = runtime_bins, y = avg_rating)) +
    geom_col(fill = "lightblue", width = 0.7) +
    geom_smooth(aes(group = 1), method = "loess", se = FALSE, color = "black", linetype = "dashed") +
    geom_text(aes(label = round(avg_rating, 1)), vjust = -0.5, size = 3, color = "black") +
    labs(
      title = "Movie Duration for Engagement",
      subtitle = "IMDb ratings improve for longer runtimes—peaking around 180–210 mins",
      x = "Runtime (minutes)", y = "Average IMDb Score"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 13),
      plot.subtitle = element_text(size = 10, color = "gray30"),
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid = element_blank()
    )
  
  # Save plot
  ggsave(
    filename = "opduration.png",  # or use .pdf/.jpg etc.
    plot = opduration,
    path = "C:/Users/pmnha/my-new-project/22660348/Question3/Results",
    width = 10,
    height = 6,
    dpi = 300
  )
  
  # Analysis 3: Content Age vs. Viewership (using imdb_score as proxy)
  age_analysis <- netflix_data %>%
    mutate(age_group = cut(age, breaks = c(0, 1, 3, 5, 10, 20, 50, 100))) %>%
    group_by(age_group) %>%
    summarise(
      avg_rating = mean(imdb_score),
      count = n(),
      .groups = "drop"
    )
  
  # Age vs. viewership visualization
  viewership <- ggplot(netflix_data, aes(x = age, y = imdb_score)) +
    geom_point(alpha = 0.3, color = "#E50914") +
    geom_smooth(method = "gam", color = "#221F1F") +
    labs(title = "Content Age vs. Audience Engagement",
         subtitle = "Relationship between movie age and IMDb ratings",
         x = "Age of Content (years)", y = "IMDb Score") +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold"))
  
  # Save plot
  ggsave(
    filename = "viewership.png",  #save png
    plot = viewership,
    path = "C:/Users/pmnha/my-new-project/22660348/Question3/Results",
    width = 10,
    height = 6,
    dpi = 300
  )
}

run_netflix_visualizations()

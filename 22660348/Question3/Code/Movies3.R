library(tidyverse)
library(countrycode)

# Load data (pure function with error handling)
load_netflix_data <- function() {
  tryCatch({
    titles <- read_rds("Precious Project/Exam/titles.rds")
    movies <- read_csv("Precious Project/Exam/netflix_movies.csv")
    
    titles %>%
      filter(type == "MOVIE") %>%
      inner_join(movies, by = "title") %>%
      select(title, genres, production_countries, imdb_score) %>%
      mutate(
        primary_country = map_chr(
          str_extract_all(production_countries, "(?<=')[A-Z]{2}(?=')"), 
          ~ ifelse(length(.x) > 0, .x[1], NA)
        ),
        country_name = countrycode(primary_country, "iso2c", "country.name"),
        primary_genre = map_chr(
          str_extract_all(genres, "(?<=')[A-Za-z]+(?=')"), 
          ~ ifelse(length(.x) > 0, .x[1], NA)
        )
      ) %>%
      filter(!is.na(country_name), !is.na(primary_genre))
  }, error = function(e) stop("Data loading failed: ", e$message))
}

netflix_data <- load_netflix_data()

# Calculate genre distribution per country (functional pipeline)
genre_distribution <- netflix_data %>%
  group_by(country_name, primary_genre) %>%
  summarise(
    count = n(),
    avg_rating = mean(imdb_score, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  group_by(country_name) %>%
  mutate(
    genre_pct = count / sum(count),
    genre_rank = rank(-count, ties.method = "first")
  ) %>%
  filter(genre_rank <= 5)  # Top 5 genres per country

# Filter countries with ≥50 movies for significance
significant_countries <- netflix_data %>%
  count(country_name) %>%
  filter(n >= 50) %>%
  pull(country_name)


ggplot(
  genre_distribution %>% filter(country_name %in% significant_countries),
  aes(x = reorder(country_name, genre_pct), y = genre_pct, fill = primary_genre)
) +
  geom_col(position = "stack") +
  scale_fill_brewer(palette = "Set2") +
  coord_flip() +
  labs(
    title = "Top 5 Movie Genres by Production Country",
    x = "", y = "Percentage of Country's Catalog",
    fill = "Genre"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))


genre_distribution %>%
  filter(country_name %in% significant_countries) %>%
  ggplot(aes(x = genre_pct, y = avg_rating, color = primary_genre)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~country_name, scales = "free_x") +
  labs(
    title = "Genre Popularity vs. IMDb Rating by Country",
    x = "Genre Share (%)", y = "Avg IMDb Rating"
  ) +
  theme_minimal()
library(tidyverse)
library(countrycode)
library(ggthemes)
library(scales)

# Load and prepare data
titles <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question3/Data/titles.rds")
movies <- read_csv("Question3/Data/netflix_movies.csv")

# Merge and clean data
netflix_data <- titles %>%
  filter(type == "MOVIE") %>%
  inner_join(movies, by = "title") %>%
  select(title, production_countries, imdb_score, runtime) %>%
  mutate(
    production_countries = str_extract(production_countries, "(?<=')[A-Z]{2}(?=')"), # Extract primary country
    country_name = countrycode(production_countries, "iso2c", "country.name")
  ) %>%
  filter(!is.na(country_name), !is.na(imdb_score))

# Analysis 1: Geographic distribution of content
content_distribution <- netflix_data %>%
  count(country_name, name = "content_count") %>%
  arrange(desc(content_count)) %>%
  mutate(
    pct_total = content_count / sum(content_count),
    cum_pct = cumsum(pct_total)
  )

# Top 20 countries plot
content_distribution <- content_distribution %>%
  mutate(
    color = ifelse(row_number() <= 2, "#E50914", "gray70")
  )

# Plot
top20creators <- ggplot(content_distribution %>% head(20), aes(x = reorder(country_name, content_count), y = content_count)) +
  geom_bar(stat = "identity", aes(fill = color)) +
  scale_fill_identity() +
  geom_text(aes(label = percent(pct_total, accuracy = 0.1)), hjust = -0.1, size = 3) +
  coord_flip() +
  labs(
    title = "Half the World's Netflix: India and USA Dominate Production",
    subtitle = "India and USA total 50% of all Netflix movies. The rest of the world fights for the other half.",
    x = NULL, y = "Number of Movies"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11)
  )

#save
ggsave(
  filename = "top20creators.png",  # or use .pdf/.jpg etc.
  plot = top20creators,
  path = "C:/Users/pmnha/my-new-project/22660348/Question3/Results",
  width = 10,
  height = 6,
  dpi = 300
)


# Analysis 2: Ratings by country (minimum 30 movies for statistical significance- Nlarge)
ratings_by_country <- netflix_data %>%
  group_by(country_name) %>%
  summarise(
    avg_rating = mean(imdb_score),
    rating_sd = sd(imdb_score),
    count = n(),
    .groups = "drop"
  ) %>%
  filter(count >= 30) %>%
  arrange(desc(avg_rating))

# Identify the top-rated country (Japan)
ratings_by_country <- ratings_by_country %>%
  mutate(color = ifelse(country_name == "Japan", "#E50914", "gray70"))

# Plot
countryrating <- ggplot(ratings_by_country, aes(x = reorder(country_name, avg_rating), y = avg_rating)) +
  geom_pointrange(aes(ymin = avg_rating - rating_sd, ymax = avg_rating + rating_sd, color = color), 
                  size = 0.8) +
  geom_text(aes(label = round(avg_rating, 1)), hjust = -0.4, size = 3.2, color = "black") +
  scale_color_identity() +
  coord_flip() +
  labs(
    title = "Japan Tops Netflix Quality Rankings",
    subtitle = "Despite fewer films, Japan leads in IMDb scores. India & US have scale, not standout ratings.\nCountries shown: ≥30 movies. Error bars = ±1 SD",
    x = "", y = "Average IMDb Rating"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 10, color = "gray30"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave(
  filename = "countryrating.png",  # or use .pdf/.jpg etc.
  plot = countryrating,
  path = "C:/Users/pmnha/my-new-project/22660348/Question3/Results",
  width = 10,
  height = 6,
  dpi = 300
)



# Analysis 3: Emerging markets analysis
emerging_markets <- c("South Korea", "India", "Brazil", "Mexico", "Turkey", "Nigeria")

emerging_market_performance <- netflix_data %>%
  filter(country_name %in% emerging_markets) %>%
  group_by(country_name) %>%
  summarise(
    avg_rating = mean(imdb_score),
    content_count = n(),
    .groups = "drop"
  ) %>%
  mutate(performance_ratio = avg_rating / (content_count / max(content_count)))

emerging_market_performance <- emerging_market_performance %>%
  mutate(
    highlight = ifelse(country_name %in% c("South Korea", "India"), TRUE, FALSE)
  )

emergers <- ggplot(emerging_market_performance, aes(x = content_count, y = avg_rating)) +
  geom_point(aes(size = performance_ratio, color = highlight), alpha = 0.9) +
  geom_text(aes(label = country_name), 
            vjust = -1, size = 3.2, fontface = "bold", color = "black") +
  scale_color_manual(values = c("TRUE" = "#E50914", "FALSE" = "gray95")) +
  scale_size_continuous(range = c(5, 12)) +
  labs(
    title = "South Korea & India: Punching Above Their Weight",
    subtitle = "Bubble size = performance ratio (rating / production volume)\nSouth Korea stands out in quality, India delivers both scale and strength",
    x = "Number of Movies", y = "Average IMDb Rating"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(size = 9.5),
    panel.grid = element_blank()
  )

#save
ggsave(
  filename = "emergers.png",  # or use .pdf/.jpg etc.
  plot = emergers,
  path = "C:/Users/pmnha/my-new-project/22660348/Question3/Results",
  width = 10,
  height = 6,
  dpi = 300
)


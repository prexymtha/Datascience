# Load necessary libraries
library(readr)
library(dplyr)
library(ggplot2)
library(scales)
library(lubridate)

# Read in the datasets
spotify <- read_rds("Precious Project/Exam/Broader_Spotify_Info.rds")
charts <- read_rds("Precious Project/Exam/charts.rds")
coldplay <- read_csv("Precious Project/Exam/Coldplay.csv")
metalica <- read_csv("Precious Project/Exam/metallica.csv")

# Filter Spotify data for Coldplay and Metallica
df <- spotify %>% 
  filter(artist %in% c("Coldplay", "Metallica"))

artist_debuts <- data.frame(
  artist = c("Coldplay", "Metallica"),
  debut_date = as.Date(c("1996-01-01", "1981-01-01"))
)

# 1. Filter for Coldplay and Metallica
charts_df <- charts %>%
  filter(artist %in% c("Coldplay", "Metallica")) %>%
  mutate(date = as.Date(date))

charts_df <- charts_df %>%
  mutate(date = as.Date(date)) %>%
  inner_join(artist_debuts, by = "artist")

# 3. Calculate weeks and years since debut
charts_df <- charts_df %>%
  group_by(artist, song) %>%
  summarize(
    first_chart_date = min(date),
    debut_date = first(debut_date),
    .groups = "drop"
  ) %>%
  mutate(
    weeks_since_debut = as.integer((first_chart_date - debut_date) / 7),
    years_since_debut = weeks_since_debut / 52.18  # More accurate year conversion
  ) %>%
  arrange(artist, years_since_debut) %>%
  group_by(artist) %>%
  mutate(cumulative_unique_songs = row_number()) %>%
  ungroup()


# 4. Plot cumulative unique songs vs. years since debut
# 1. Define color palette manually
artist_colors <- c("Coldplay" = "#1f77b4", "Metallica" = "gray60")  # Blue for Cold play, gray for Metallica

# 2. Plot with highlight
ggplot(charts_df, aes(x = years_since_debut, y = cumulative_unique_songs, group = artist)) +
  
  # Shaded rectangle for first 10 years
  annotate("rect", xmin = 0, xmax = 10, ymin = 0, ymax = Inf, fill = "lightblue", alpha = 0.15) +
  
  # Line and points
  geom_line(aes(color = artist), size = 1) +
  geom_point(aes(color = artist), size = 2) +
  
  # Manual colors
  scale_color_manual(values = artist_colors) +
  
  # Axes
  scale_x_continuous(breaks = seq(0, 45, 5), expand = expansion(mult = c(0, 0.05))) +
  scale_y_continuous(breaks = pretty_breaks()) +
  
  # Labels
  labs(
    title = "Cumulative Unique Songs Charted: Coldplay vs Metallica",
    subtitle = "First 10 years: Coldplay charted 5 songs, Metallica only 1 — Coldplay outpaced early.",
    x = "Years Since Debut",
    y = "Cumulative Unique Songs on Chart",
    color = "Artist"
  ) +
  
  # Theme styling
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 13, margin = margin(b = 10)),
    legend.position = "top",
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank()
  )

# ========================================================================================================
# Step 1: Filter for direct competition years (1996 onward)
charts_competition <- charts %>%
  filter(artist %in% c("Coldplay", "Metallica")) %>%
  mutate(date = as.Date(date)) %>%
  filter(year(date) >= 1996) %>%
  group_by(artist, song) %>%
  slice_min(date, n = 1) %>%  # First appearance of each song after 1996
  ungroup() %>%
  arrange(artist, date) %>%
  group_by(artist) %>%
  mutate(
    cumulative_songs = row_number(),
    years_since_1996 = year(date) - 1996
  ) %>%
  ungroup()

ggplot(charts_competition, aes(x = years_since_1996, y = cumulative_songs, color = artist)) +
  # Highlight Coldplay's first 10 years post-1996 (1996–2006)
  annotate("rect", xmin = 0, xmax = 10, ymin = 0, ymax = Inf,
           fill = "lightblue", alpha = 0.2) +
  
  geom_line(linewidth = 1.2) +
  geom_point(size = 2.5) +
  
  scale_color_manual(values = c("Coldplay" = "#1f77b4", "Metallica" = "gray50")) +
  
  labs(
    title = "Coldplay vs. Metallica: Songs Charted During Direct Competition (1996+)",
    subtitle = "Coldplay enters the scene and quickly builds momentum vs. veteran Metallica",
    x = "Years Since 1996",
    y = "Cumulative Unique Songs on Chart",
    color = "Artist"
  ) +
  
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12, color = "gray40"),
    legend.position = "top",
    panel.grid.minor = element_blank()
  ) +
  
  scale_x_continuous(breaks = seq(0, 30, 5), limits = c(0, NA)) +
  scale_y_continuous(breaks = pretty_breaks())

# ========================================================================================================
# Step 1: Calculate average popularity per album per band
top_albums <- band_audio_features %>%
  group_by(band, album) %>%
  summarise(avg_popularity = mean(popularity, na.rm = TRUE)) %>%
  arrange(band, desc(avg_popularity)) %>%
  group_by(band) %>%
  slice_head(n = 5) %>%  # top 5 albums per band
  ungroup()

# Step 2: Filter original data to keep only top albums
band_audio_top_albums <- band_audio_features %>%
  filter(album %in% top_albums$album & band %in% top_albums$band)

# Step 3: Plot boxplot
ggplot(band_audio_top_albums, aes(x = album, y = popularity, fill = band)) +
  geom_boxplot(alpha = 0.7, outlier.size = 1) +
  facet_wrap(~ band, scales = "free_x") +  # Separate plot panels by band
  labs(
    title = "Popularity Distribution by Top 5 Albums",
    subtitle = "Boxplot of Spotify popularity scores by album for Coldplay and Metallica",
    x = "Album",
    y = "Popularity",
    fill = "Band"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
    legend.position = "none",
    panel.grid.minor = element_blank()
  )



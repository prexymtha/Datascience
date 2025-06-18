# Load necessary libraries
library(readr)
library(dplyr)
library(ggplot2)
library(scales)
library(lubridate)
library(stringi)

# Read in the datasets
spotify <- read_rds("Precious Project/Exam/Broader_Spotify_Info.rds")
charts <- read_rds("Precious Project/Exam/charts.rds")

# Read Coldplay and Metallica data with explicit encoding
coldplay <- read_csv("Precious Project/Exam/Coldplay.csv", locale = locale(encoding = "UTF-8"))
metallica <- read_csv("Precious Project/Exam/metallica.csv", locale = locale(encoding = "UTF-8"))

# Clean Coldplay & Metallica: remove live or demo tracks
coldplay_clean <- coldplay %>%
  mutate(name = stri_enc_toutf8(name)) %>%  # Ensure UTF-8 encoding
  filter(!str_detect(tolower(name), "live|demo|concert|unplugged"))

metallica_clean <- metallica %>%
  mutate(name = iconv(name, to = "UTF-8", sub = "?")) %>%  # Replace invalid characters
  mutate(name = stri_enc_toutf8(name, validate = TRUE)) %>%  # Ensure UTF-8 encoding
  filter(!str_detect(tolower(name), "live|demo|concert|unplugged"))

# Filter Spotify data for Coldplay and Metallica
df <- spotify %>% 
  filter(artist %in% c("Coldplay", "Metallica")) %>%
  mutate(name = stri_enc_toutf8(name))  # Ensure UTF-8 encoding

coldplay_clean <- coldplay_clean %>%
  mutate(year = year(release_date), band = "Coldplay") %>%
  rename(album = album_name)

metallica_clean <- metallica_clean %>%
  mutate(year = year(release_date), band = "Metallica") %>%
  rename(duration = duration_ms)

band_audio_features <- bind_rows(coldplay_clean, metallica_clean)

# ===========================================================================================================
ggplot(band_audio_features, aes(x = year, y = tempo, color = band)) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(
    title = "Tempo Evolution: Coldplay vs Metallica (Studio Only)",
    x = "Release Year", y = "Tempo (BPM)", color = "Band"
  ) +
  theme_minimal()

# ==========================================================================================================
band_audio_features_long <- band_audio_features %>%
  select(year, band, danceability, acousticness, valence) %>%
  pivot_longer(cols = c(danceability, acousticness, valence), names_to = "feature")

# Pivot to long format all features you listed
features_to_plot <- c("danceability", "acousticness", "energy", "instrumentalness",
                      "liveness", "loudness", "speechiness", "tempo", "valence")

band_audio_features_long <- band_audio_features %>%
  select(year, band, all_of(features_to_plot)) %>%
  pivot_longer(cols = all_of(features_to_plot), names_to = "feature", values_to = "value")

ggplot(band_audio_features_long, aes(x = year, y = value, color = band)) +
  geom_smooth(se = FALSE, linewidth = 1.1) +
  facet_wrap(~ feature, scales = "free_y", ncol = 3) +
  labs(
    title = "Musical Audio Features Over Time by Band",
    subtitle = "Smoothed trends for key audio features from Spotify data",
    x = "Year",
    y = "Value",
    color = "Band"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top")

# =========================================================================================================
# =========================================================================================================
# Calculate annual metrics from Billboard Hot 100 data
charts_summary <- charts %>%
  # Extract year from date column
  mutate(year = year(date)) %>%
  
  # Group by year to calculate annual statistics
  group_by(year) %>%
  summarise(
    # Count of unique songs that charted each year (measures industry competitiveness)
    unique_songs = n_distinct(song),
    
    # Average peak position of songs (measures how high typical songs climb)
    avg_peak_rank = mean(`peak-rank`, na.rm = TRUE)
  ) %>%
  
  # Focus on modern era (1980 onward) for relevant comparison
  filter(year >= 1980) 

# =========================================================================================================
# VISUALIZATION: INDUSTRY TRENDS VS. ARTIST MILESTONES
# =========================================================================================================

# Create visualization with proper context
ggplot(charts_summary, aes(x = year, y = unique_songs)) +
  geom_line(linewidth = 1.2, color = "steelblue") +
  
  # Corrected artist milestones with exact values
  annotate("point", x = c(1986, 1991, 2014), 
           y = c(495, 472, 461),
           size = 4, shape = 21, fill = c("#ff7f0e", "#1f77b4", "#2ca02c")) +
  
  # Annotations with exact numbers
  annotate("text", x = c(1991, 2000, 2014), y = c(700, 700, 700),
           label = c(paste0("Metallica's Peak (1991)\n", 474, " songs/year"),
                     paste0("Coldplay Debut (2000)\n", 410, " songs/year"),
                     paste0("Joint Performance (2014)\n", 461, " songs/year")),
           hjust = -0.05, size = 3.5) +
  
  # Highlight streaming era
  annotate("rect", xmin = 2015, xmax = 2021, ymin = 0, ymax = 800,
           fill = "gray90", alpha = 0.3) +
  annotate("text", x = 2018, y = 100, 
           label = "Streaming Era\n(2015+)", size = 3.5) +
  
  # Labels and scales
  scale_x_continuous(breaks = seq(1980, 2020, 5)) +
  scale_y_continuous(limits = c(0, 800)) +
  labs(
    title = "Billboard Hot 100 Trends Show Two Distinct Industry Eras",
    subtitle = paste("Metallica peaked during the album era (low turnover), while Coldplay adapted",
                     "to increasing competition\nPost-2015 streaming explosion dramatically changed chart dynamics"),
    x = "Year", 
    y = "Unique Songs Charted Annually",
    caption = "Data shows total unique songs appearing on Hot 100 each year\nPoints mark key career moments for each artist"
  ) +
  
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, lineheight = 1.1),
    panel.grid.minor = element_blank()
  )


# ------------------------- LOAD LIBRARIES -------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  readr, dplyr, ggplot2, scales, lubridate, stringi, tidyr, stringr
)

# ------------------------- MODULE 1: Data Loading -------------------------
load_data <- function() {
  list(
    spotify   = readRDS("C:/Users/pmnha/my-new-project/22660348/Question2/Data/Broader_Spotify_Info.rds"),
    charts    = readRDS("C:/Users/pmnha/my-new-project/22660348/Question2/Data/charts.rds"),
    coldplay  = read_csv("Question2/Data/Coldplay.csv", locale = locale(encoding = "UTF-8")),
    metallica = read_csv("Question2/Data/metallica.csv", locale = locale(encoding = "UTF-8"))
  )
}

# ------------------------- MODULE 2: Data Cleaning -------------------------
clean_band_data <- function(df, band_name, name_col = "name", date_col = "release_date") {
  df %>%
    mutate(
      name = stri_enc_toutf8(iconv(.data[[name_col]], to = "UTF-8", sub = "?")),
      year = year(.data[[date_col]]),
      band = band_name
    ) %>%
    filter(!str_detect(tolower(name), "live|demo|concert|unplugged"))
}

# ------------------------- MODULE 3: Spotify Filter -------------------------
filter_spotify <- function(df) {
  df %>%
    filter(artist %in% c("Coldplay", "Metallica")) %>%
    mutate(name = stri_enc_toutf8(name))
}

# ------------------------- MODULE 4: Prepare Audio Features -------------------------
prepare_audio_features <- function(coldplay, metallica) {
  coldplay_clean <- coldplay %>% rename(album = album_name)
  metallica_clean <- metallica %>% rename(duration = duration_ms)
  
  bind_rows(coldplay_clean, metallica_clean)
}

# ------------------------- MODULE 5: Tempo Plot -------------------------
plot_tempo_evolution <- function(audio_features) {
  ggplot(audio_features, aes(x = year, y = tempo, color = band)) +
    geom_smooth(method = "loess", se = FALSE) +
    labs(
      title = "Tempo Evolution: Coldplay vs Metallica (Studio Only)",
      x = "Release Year", y = "Tempo (BPM)", color = "Band"
    ) +
    theme_minimal()
}

# ------------------------- MODULE 6: Feature Trends Plot -------------------------
plot_audio_features <- function(audio_features) {
  features <- c("danceability", "acousticness", "energy", "instrumentalness",
                "liveness", "loudness", "speechiness", "tempo", "valence")
  
  audio_features %>%
    select(year, band, all_of(features)) %>%
    pivot_longer(cols = all_of(features), names_to = "feature", values_to = "value") %>%
    ggplot(aes(x = year, y = value, color = band)) +
    geom_smooth(se = FALSE, linewidth = 1.1) +
    facet_wrap(~ feature, scales = "free_y", ncol = 3) +
    labs(
      title = "Musical Audio Features Over Time by Band",
      subtitle = "Smoothed trends for key audio features from Spotify data",
      x = "Year", y = "Value", color = "Band"
    ) +
    theme_minimal(base_size = 14) +
    theme(legend.position = "top")
}

# ------------------------- MODULE 7: Chart Summary -------------------------
summarize_charts <- function(charts) {
  charts %>%
    mutate(year = year(date)) %>%
    group_by(year) %>%
    summarise(
      unique_songs = n_distinct(song),
      avg_peak_rank = mean(`peak-rank`, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    filter(year >= 1980)
}

# ------------------------- MODULE 8: Industry Trends Plot -------------------------
plot_industry_trends <- function(chart_summary) {
  ggplot(chart_summary, aes(x = year, y = unique_songs)) +
    geom_line(linewidth = 1.2, color = "steelblue") +
    annotate("point", x = c(1986, 1991, 2014), y = c(495, 472, 461),
             size = 4, shape = 21, fill = c("#ff7f0e", "#1f77b4", "#2ca02c")) +
    annotate("text", x = c(1991, 2000, 2014), y = c(700, 700, 700),
             label = c(
               paste0("Metallica's Peak (1991)\n", 474, " songs/year"),
               paste0("Coldplay Debut (2000)\n", 410, " songs/year"),
               paste0("Joint Performance (2014)\n", 461, " songs/year")
             ),
             hjust = -0.05, size = 3.5) +
    annotate("rect", xmin = 2015, xmax = 2021, ymin = 0, ymax = 800,
             fill = "gray90", alpha = 0.3) +
    annotate("text", x = 2018, y = 100, label = "Streaming Era\n(2015+)", size = 3.5) +
    scale_x_continuous(breaks = seq(1980, 2020, 5)) +
    scale_y_continuous(limits = c(0, 800)) +
    labs(
      title = "Billboard Hot 100 Trends Show Two Distinct Industry Eras",
      subtitle = paste("Metallica peaked during the album era (low turnover), while Coldplay adapted",
                       "to increasing competition\nPost-2015 streaming explosion dramatically changed chart dynamics"),
      x = "Year", y = "Unique Songs Charted Annually",
      caption = "Data shows total unique songs appearing on Hot 100 each year\nPoints mark key career moments for each artist"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      plot.subtitle = element_text(size = 11, lineheight = 1.1),
      panel.grid.minor = element_blank()
    )
}

# ------------------------- MAIN FUNCTIONAL PIPELINE -------------------------
run_analysis <- function() {
  load_data() %>%
    (\(data) {
      coldplay <- clean_band_data(data$coldplay, "Coldplay")
      metallica <- clean_band_data(data$metallica, "Metallica")
      audio_features <- prepare_audio_features(coldplay, metallica)
      chart_summary <- summarize_charts(data$charts)
      
      list(
        tempo_plot    = plot_tempo_evolution(audio_features),
        features_plot = plot_audio_features(audio_features),
        trends_plot   = plot_industry_trends(chart_summary)
      )
    })()
}

# ------------------------- EXECUTE AND DISPLAY -------------------------
plots <- run_analysis()
print(plots$tempo_plot)
print(plots$features_plot)
print(plots$trends_plot)

# -------------------- FUNCTION 2 FOR MUSIC-------------------- #
# This function generates a full suite of visual analytics for Coldplay vs Metallica
# Includes cumulative charting, audio feature trends, top album popularity, and industry trends

run_artist_comparison_analysis <- function() {
  # Load required packages using pacman
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(readr, dplyr, ggplot2, scales, lubridate, stringi, tidyr, stringr)
  
  # Load data
  spotify <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question2/Data/Broader_Spotify_Info.rds")
  charts <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question2/Data/charts.rds")
  coldplay <- read_csv("Question2/Data/Coldplay.csv", locale = locale(encoding = "UTF-8"))
  metallica <- read_csv("Question2/Data/metallica.csv", locale = locale(encoding = "UTF-8"))
  
  # Clean and tag audio feature data
  clean_band_data <- function(df, band_name, date_col, name_col) {
    df %>%
      mutate(
        name = stri_enc_toutf8(iconv(.data[[name_col]], to = "UTF-8", sub = "?")),
        year = year(.data[[date_col]]),
        band = band_name
      ) %>%
      filter(!str_detect(tolower(name), "live|demo|concert|unplugged"))
  }
  
  coldplay_clean <- clean_band_data(coldplay, "Coldplay", "release_date", "name") %>%
    rename(album = album_name)
  metallica_clean <- clean_band_data(metallica, "Metallica", "release_date", "name") %>%
    rename(duration = duration_ms)
  
  band_audio_features <- bind_rows(coldplay_clean, metallica_clean)
  
  # ----------- Plot 1: Tempo Over Time ----------- #
  ggsave(
    filename = "audioeffects.png",
    plot = ggplot(band_audio_features, aes(x = year, y = tempo, color = band)) +
      geom_smooth(method = "loess", se = FALSE) +
      labs(
        title = "Tempo Evolution: Coldplay vs Metallica (Studio Only)",
        x = "Release Year", y = "Tempo (BPM)", color = "Band"
      ) +
      theme_minimal(),
    path = "C:/Users/pmnha/my-new-project/22660348/Question2/Results",
    width = 10, height = 6, dpi = 300
  )
  
  # ----------- Plot 2: Full Audio Feature Trends ----------- #
  features <- c("danceability", "acousticness", "energy", "instrumentalness",
                "liveness", "loudness", "speechiness", "tempo", "valence")
  
  band_audio_features_long <- band_audio_features %>%
    select(year, band, all_of(features)) %>%
    pivot_longer(cols = all_of(features), names_to = "feature", values_to = "value")
  
  ggsave(
    filename = "extraeffects.png",
    plot = ggplot(band_audio_features_long, aes(x = year, y = value, color = band)) +
      geom_smooth(se = FALSE, linewidth = 1.1) +
      facet_wrap(~ feature, scales = "free_y", ncol = 3) +
      labs(
        title = "Musical Audio Features Over Time by Band",
        subtitle = "Smoothed trends for key audio features from Spotify data",
        x = "Year", y = "Value", color = "Band"
      ) +
      theme_minimal(base_size = 14) +
      theme(legend.position = "top"),
    path = "C:/Users/pmnha/my-new-project/22660348/Question2/Results",
    width = 10, height = 6, dpi = 300
  )
  
  # ----------- Plot 3: Top Album Popularity Boxplot ----------- #
  top_albums <- band_audio_features %>%
    group_by(band, album) %>%
    summarise(avg_popularity = mean(popularity, na.rm = TRUE), .groups = "drop") %>%
    arrange(band, desc(avg_popularity)) %>%
    group_by(band) %>% slice_head(n = 5) %>% ungroup()
  
  band_audio_top <- band_audio_features %>%
    filter(album %in% top_albums$album & band %in% top_albums$band)
  
  ggsave(
    filename = "popalbums.png",
    plot = ggplot(band_audio_top, aes(x = album, y = popularity, fill = band)) +
      geom_boxplot(alpha = 0.7, outlier.size = 1) +
      facet_wrap(~ band, scales = "free_x") +
      labs(
        title = "Popularity Distribution by Top 5 Albums",
        subtitle = "Boxplot of Spotify popularity scores by album for Coldplay and Metallica",
        x = "Album", y = "Popularity", fill = "Band"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
        legend.position = "none",
        panel.grid.minor = element_blank()
      ),
    path = "C:/Users/pmnha/my-new-project/22660348/Question2/Results",
    width = 10, height = 6, dpi = 300
  )
  
  # ----------- Plot 4: Industry Trend and Milestones ----------- #
  charts_summary <- charts %>%
    mutate(year = year(date)) %>%
    group_by(year) %>%
    summarise(unique_songs = n_distinct(song), avg_peak_rank = mean(`peak-rank`, na.rm = TRUE), .groups = "drop") %>%
    filter(year >= 1980)
  
  ggsave(
    filename = "industrytrend.png",
    plot = ggplot(charts_summary, aes(x = year, y = unique_songs)) +
      geom_line(linewidth = 1.2, color = "steelblue") +
      annotate("point", x = c(1986, 1991, 2014), y = c(495, 472, 461),
               size = 4, shape = 21, fill = c("#ff7f0e", "#1f77b4", "#2ca02c")) +
      annotate("text", x = c(1991, 2000, 2014), y = c(700, 700, 700),
               label = c("Metallica's Peak (1991)\n474 songs/year",
                         "Coldplay Debut (2000)\n410 songs/year",
                         "Joint Performance (2014)\n461 songs/year"),
               hjust = -0.05, size = 3.5) +
      annotate("rect", xmin = 2015, xmax = 2021, ymin = 0, ymax = 800,
               fill = "gray90", alpha = 0.3) +
      annotate("text", x = 2018, y = 100, label = "Streaming Era\n(2015+)", size = 3.5) +
      scale_x_continuous(breaks = seq(1980, 2020, 5)) +
      scale_y_continuous(limits = c(0, 800)) +
      labs(
        title = "Billboard Hot 100 Trends Show Two Distinct Industry Eras",
        subtitle = "Coldplay adapted to streaming competition; Metallica thrived in album era",
        x = "Year", y = "Unique Songs Charted Annually",
        caption = "Data: Billboard Hot 100"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", size = 14),
        plot.subtitle = element_text(size = 11, lineheight = 1.1),
        panel.grid.minor = element_blank()
      ),
    path = "C:/Users/pmnha/my-new-project/22660348/Question2/Results",
    width = 10, height = 6, dpi = 300
  )
}

# Call the function to generate all outputs
run_artist_comparison_analysis()





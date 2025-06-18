library(dplyr)
library(stringr)
library(ggplot2)

# Step 1: Extract first names from artists and assign release year from chart date
artist_firstnames <- charts %>%
  mutate(
    firstname = str_extract(artist, "^[^ ]+"),  # First word of artist name
    release_year = lubridate::year(date)
  ) %>%
  distinct(song, firstname, release_year)  # Keep only unique song-name-year combos

# Step 2: Filter baby names and align naming
baby_names_filtered <- baby_names %>%
  filter(Count > 0) %>%
  select(Name, Year, Gender, Count) %>%
  rename(firstname = Name)

# Step 3: Join and calculate impact
music_impact <- artist_firstnames %>%
  inner_join(baby_names_filtered, by = "firstname", relationship = "many-to-many") %>%
  mutate(
    time_diff = Year - release_year,
    period = case_when(
      time_diff < 0 ~ "Pre-release",
      time_diff >= 0 & time_diff <= 5 ~ "Post-release",
      TRUE ~ "Beyond window"
    )
  ) %>%
  group_by(firstname, Gender, song, release_year) %>%
  summarise(
    pre_release = sum(Count[period == "Pre-release"]),
    post_release = sum(Count[period == "Post-release"]),
    impact_ratio = (post_release - pre_release) / (pre_release + 1),
    .groups = "drop"
  ) %>%
  filter(pre_release < 100, post_release > 100) %>%  # Only meaningful spikes
  arrange(desc(impact_ratio))

library(ggplot2)
library(ggtext)

# Prepare top 15 impactful names
top_artists <- music_impact %>%
  arrange(desc(impact_ratio)) %>%
  head(15) %>%
  mutate(
    name_label = ifelse(impact_ratio > 1000, 
                        paste0("<b>", firstname, "</b>"), 
                        firstname),
    tier = case_when(
      impact_ratio > 5000 ~ "Elite",
      impact_ratio > 1000 ~ "High",
      TRUE ~ "Notable"
    )
  )

# Create tiered visualization
ggplot(top_artists, aes(x = reorder(name_label, impact_ratio), 
                        y = impact_ratio, 
                        fill = tier)) +
  geom_col(width = 0.8, color = "white", linewidth = 0.3) +
  geom_text(aes(label = scales::comma(round(impact_ratio))),
            hjust = -0.1, size = 3.5, color = "gray30") +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2))) +
  scale_fill_manual(values = c("Elite" = "#E63946", 
                               "High" = "#457B9D", 
                               "Notable" = "#A8DADC")) +
  labs(
    title = "<span style='font-size:18pt'>**Elite Tier** Music Influencers on Baby Names</span>",
    subtitle = "Artist first names with highest post-release/pre-release name usage ratio",
    x = NULL,
    y = "Impact Ratio (Post/Pre Release)",
    caption = "Data: Billboard charts & US baby names | Analysis: Impact over 5-year window"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_markdown(margin = margin(b = 10)),
    plot.subtitle = element_text(color = "gray40", size = 11),
    axis.text.y = element_markdown(),
    legend.position = "none",
    panel.grid.major.y = element_blank(),
    plot.title.position = "plot",
    plot.caption = element_text(color = "gray60", size = 9)
  ) +
  # Add tier annotations
  annotate("text", x = 15, y = max(top_artists$impact_ratio)*0.85, 
           label = "ELITE TIER\n(5000+ impact)", 
           color = "#E63946", fontface = "bold", size = 4, hjust = 0) +
  annotate("text", x = 12, y = max(top_artists$impact_ratio)*0.6, 
           label = "HIGH TIER\n(1000-5000)", 
           color = "#457B9D", fontface = "bold", size = 3.5, hjust = 0) +
  annotate("curve", x = 14.5, xend = 13, y = max(top_artists$impact_ratio)*0.8, 
           yend = max(top_artists$impact_ratio)*0.7, curvature = -0.3,
           arrow = arrow(length = unit(2, "mm")), color = "#E63946")


# Coldplay vs. Metallica: Audio & Industry Analysis

This question compares the musical and industry impact of Coldplay and Metallica using Spotify audio features and Billboard Hot 100 data. It explores tempo trends, audio feature evolution, album popularity, and industry dynamics.

---

## Project Structure

├── Data/
│ ├── Broader_Spotify_Info.rds
│ ├── charts.rds
│ ├── Coldplay.csv
│ └── metallica.csv
├── Results/
│ ├── audioeffects.png
│ ├── extraeffects.png
│ ├── popalbums.png
│ └── industrytrend.png
├── analysis_script.R
└── README.md
load_data() - loads all the raw data 
clean_band_data - standardises UTF-8 encoding , removes live/demo tracks - we want to seek the ones recored in Studio as they are the ones that are ultimately produced and freely accessed by all customers .

filter_spotify - filters spotify for only Coldplay and Metallica 
prepare_audio_features () combines both bands into one cleaned dataset 
plot_tempo_evolution - visualises tempo by band 
plot_audio_features - show trends of 9 musical features 
summarise_charts - aggregates Hot 100 data by year 
plot_industry_trends_ visualises -wise competitiveness over time 

---

## Requirements

Before you running the project, I installed and loaded all required packages using **pacman**:

```{r}
if (!require("pacman")) install.packages("pacman")
pacman::p_load(readr, dplyr, ggplot2, scales, lubridate, stringi, tidyr, stringr)
```

```{r , error = FALSE}
source("C:/Users/pmnha/my-new-project/22660348/Question2/Code/MusicTaste.R")
run_analysis()
run_artist_comparison_analysis()

```


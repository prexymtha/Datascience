run_netflix_analysis <- function() {
  if (!require("pacman")) install.packages("pacman")
  
  pacman::p_load(
    tidyverse,    # includes ggplot2, dplyr, tidyr, readr, stringr, etc.
    tidytext,
    tm,
    textstem,
    topicmodels,
    SnowballC,
    wordcloud,
    textclean
  )
  
  # ===========================
  # Import data
  # ===========================
  titles <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question3/Data/titles.rds")
  credits <- readRDS("C:/Users/pmnha/my-new-project/22660348/Question3/Data/credits.rds")
  movies <- read_csv("Question3/Data/netflix_movies.csv")
  
  # ===========================
  # Merge and clean dataset
  # ===========================
  netflix_movies <- merge(title, movies, by = "title") %>%
    select(-id, -type.x, -type.y, -production_countries, -imdb_id, -release_year.y, -show_id) %>%
    rename(
      release_year = release_year.x, 
      imbd_description = description.x, 
      netflix_description = description.y
    )
  
  # ===========================
  # Clean movie descriptions
  # ===========================
  df_clean <- netflix_movies %>%
    mutate(
      full_description = netflix_description,
      full_description = replace_contraction(full_description),    # Expand contractions (e.g., don't → do not)
      full_description = str_to_lower(full_description),            # Convert to lowercase
      full_description = str_replace_all(full_description, "[^a-z\\s]", " "), # Remove punctuation and non-letters
      full_description = str_squish(full_description)               # Remove extra whitespace
    )
  
  # ===========================
  # Prepare list of actor names to remove from tokens
  # ===========================
  actors <- str_to_lower(credits$name) 
  
  # ===========================
  # Tokenize text and remove stopwords and actor names
  # ===========================
  # Enhanced tokenization pipeline
  tokens <- df_clean %>%
    # Step 1: Tokenization with custom handling
    unnest_tokens(
      word, 
      full_description,
      to_lower = TRUE,
      strip_punct = TRUE,
      strip_numeric = TRUE
    ) %>%
    
    # Step 2: Stopword removal (modular approach)
    anti_join(get_stopwords(source = "smart"), by = "word") %>%  # Comprehensive stopwords
    anti_join(tibble(word = c("film", "movie", "series", "story", "based")), by = "word") %>%
    
    # Step 3: Domain-specific filtering
    filter(
      !str_detect(word, "^\\d+$"),      # Remove standalone numbers
      !word %in% actors,                # Remove actor names
      nchar(word) > 2,                  # Remove short words
      !str_detect(word, "'s$")          # Remove possessives
    ) %>%
    
    # Step 4: Lemmatization (optional but recommended)
    mutate(word = textstem::lemmatize_words(word)) %>%
    
    # Step 5: Final frequency analysis
    count(word, sort = TRUE) %>%
    
    # Step 6: Term significance calculation
    mutate(
      total_words = sum(n),
      term_freq = n / total_words
    )
  
  # ===========================
  # Get word frequency and create wordcloud visualization
  # ===========================
  word_freq <- tokens %>%
    count(word, sort = TRUE) %>%
    filter(n > 30)
  
  wordcloud(words = word_freq$word, freq = word_freq$n, max.words = 100)
  
  # ===========================
  # Lemmatize tokens to unify word forms (run before DTM)
  # ===========================
  tokens <- tokens %>%
    mutate(word = lemmatize_words(word))
  
  # ===========================
  # Create Document-Term Matrix (DTM)
  # ===========================
  dtm <- tokens %>%
    count(word, word) %>%       # Count word frequency by movie title
    cast_dtm(word, word, n)     # Cast to DTM format required for LDA
  
  # ===========================
  # Run Latent Dirichlet Allocation (LDA) to extract 6 topics
  # ===========================
  lda_model <- LDA(dtm, k = 6, control = list(seed = 3452))
  
  # ===========================
  # Extract top terms per topic (beta matrix)
  # ===========================
  topics <- tidy(lda_model, matrix = "beta")
  
  # ===========================
  # Extract topic probabilities per document (gamma matrix)
  # ===========================
  movie_topics <- tidy(lda_model, matrix = "gamma") %>%
    group_by(document) %>%
    top_n(1, gamma)                # Select most likely topic per movie
  
  # ===========================
  # Join topic assignments back to the cleaned movie data
  # ===========================
  df_theme <- df_clean %>%
    mutate(title = as.character(word)) %>%
    left_join(movie_topics, by = c("title" = "document"))
  
  # ===========================
  # Define human-readable labels for topics
  # ===========================
  topic_labels <- c("Crime/Thriller", "Family Drama", "Sci-Fi", "War/Politics", "Romantic", "True Story")
  
  # ===========================
  # Map numeric topic to label in the dataframe
  # ===========================
  df_theme$theme_label <- topic_labels[df_theme$topic]
}

run_netflix_analysis()

This is  a Read me for my data science exam , compilation and analysis of all results are in the Essay Folder with all the relevant explanations and analysis .

**FINAL RESULTS AND ANALYSIS OF ALL REQUIRED PDF IS IN FOLDER ESSAY - AS EXAMALLQUESTIONS**

# Question 1 

For the babies dataset , we first eveluated did the sperman rank correlation , then we evaluated the names that have persisted by checking if they have lasted for 10 > years 
In the same analysis we had the 90 mark to see if names are still persisting as in the past
For the fads - we evaluated names that were only popular once in the top 25 most popular names 
Then we combined our dataset to see how music and media (HBO) has influenced name uptake in a decade/year 

Functions are as follows
baby_claims()
baby_length()
baby_media()
baby_music()




# Question 2
# Coldplay vs. Metallica: Audio & Industry Analysis
For Metallica and Coldplay we tested various analyses based on different features like danceability , acousticness e.t.c to see who has been the market favourite
We also the evaluated direct competitoon between the two , their most popular five albums as a starter , their indiviual unique songs 
Lastly we analysed how streaming music affected each's popularity 
We zoom in on studio effects as we believe they are the ones that lead to selling , and access by consumers 


#Functions 
run_analysis()
run_artist_comparison_analysis()

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



# Question 3 

Analysis of Netflix data 
We analysed audience engagement over the years , ratings by countries and emerging countries in the industries (those moving against expectations)
We also analysed genre ratings , genre score , IMDbratings and the optimal duration of a moving using runtime - we want to see what the audience prefer - short or longer movies 
We rated top 5 movies and top 20 movies creators (countries) , and how viewership has eveolved over time against the content age - to see if people like it old or if movies are very trendy 

#Functions are as below

```{r setup, include=FALSE}
# Set your working directory or use relative paths accordingly
code_folder <- "C:/Users/pmnha/my-new-project/22660348/Question3/Code"
# Source all scripts that define your functions
source(file.path(code_folder, "MoviesCleaning.R"))
source(file.path(code_folder, "MovieIMDbrating.R"))
source(file.path(code_folder, "MoviesContentDuration.R"))
source(file.path(code_folder, "MoviesCountryRatings.R"))
source(file.path(code_folder, "MoviesGenres.R"))
```

```{r run-analyses, echo=TRUE, message=FALSE, warning=FALSE}
# Data cleaning
run_netflix_analysis()

# IMDb Rating 
results <- main()

# Content duration analysis and visuals
run_netflix_visualizations()

# Country ratings analysis
run_netflix_country_analysis()

# Movie genre analysis by country
run_genre_country_analysis()
```


#Question 4 
For question one , we evaluated the sources of wealth of all the billionaires in the United States by their source of wealth .After which we did an analysis of top industries by market ( being either Developed , Emerging etc ) to see where the billionaires are concentrated in each region . We also analysed billionaired who inherited their wealth against those who didn't in all regions in comparison to the United States , we calculated the change in the growth of wealth and evalutated it by market type . Also did analysis of billionaired by age , gender and market type and a geospatial map to see where the concentration is at. The final report is included in the **ESSAY FOLDER** along other analysis

# Function for execution 
analyse_billionaires()


# Question 5: Health Data Analysis - Weight Change, Stress, Sleep, and Physical Activity

## Project Structure

├── Data/
│ └── HealthCare.csv
├── Results/
│ ├── Age_Distribution.png
│ ├── Age_Summary.csv
│ ├── Gender_Distribution.csv
│ ├── Weight_Change_Summary.csv
│ ├── Caloric_Activity_Summary.csv
│ ├── Sleep_Stress_Boxplot.png
│ ├── Sleep_Risk_Pivot.csv
│ ├── Stress_Risk_Pivot.csv
│ ├── Regression_Models.txt
│ └── OnAir.txt
├── health_analysis_script.R
└── README.md



### Phase 1: Understanding the Problem

  "1. Does high stress negate sleep benefits?",
  "2. Can inactivity cancel out good sleep?",
  "3. Which age groups are most vulnerable?",
  "4. How should we handle the weight change/duration relationship?"

**Initial Thoughts**:  
The Channel 1 host's anecdote about sleep > exercise resonated, but needed empirical validation. Key puzzles:
- How to quantify the sleep-stress interaction?
- Should physical activity be treated as moderator or confounder?
- What age brackets make biological sense for analysis?

### Phase 2: Data Exploration

**Discoveries**:  
1. **Age Distribution**:  
   - Clustering in 30-50 range (working professionals)  
   - Very few teens (n=6) - would need to flag as small sample  

2. **Measurement Quirks**:  
   - Sleep quality self-reported (potential bias)  
   - Weight change/duration showed extreme values that were above 2lbs in terms of absolute values 

### Phase 3: Modeling Strategy
**Decision Flow**:  
1. *Primary Relationship*:  
   - Sleep → Weight Change (baseline model)  
2. *Add Stress*:  
   - As interaction term (sleep × stress)  
3. *Control For*:  
   - Physical activity  
   - Age/gender  
   - Caloric balance  

### Phase 4: Critical Validations
**Sanity Checks**:  
1. **Teen Data**:  
   - Removed from main analysis (n=6 too small)  
   - Kept in exploratory visuals with disclaimer  
2. **Weight Change Rate**:  
   - Created `weight_change/week` metric  
   - Filtered unrealistic values (>2 lbs/week)  
   
##Notes 
Age groupings were categorised from teen , young adults , early career adults , pre and post pension (senior) to properly seperate effects during different stages of life .
 Age < 20 ~ "Teenagers (<20)",
      Age >= 20 & Age < 30 ~ "Adults (20-29)",
      Age >= 30 & Age < 40 ~ "Early Career (30-39)",
      Age >= 40 & Age < 50 ~ "Middle-aged (40-49)",
      Age >= 50 & Age < 65 ~ "Preretirement (50-64)",
      Age >= 65 ~ "Seniors (65+)",
      
Risk flagings were created to flag high stress , poor sleep and sedentary life style 
Pivot tables show stress / sleep impact across age groups 
We used regression models for examining weight changes 
Box and whisker of weight change across sleep-stress combinations 
And a summary of the on air script is provided.

## Requirements

Install and load the following packages using `pacman`:

```{r}
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, skimr, kableExtra, broom, GGally, readr, future, furrr, modelsummary)
```

```{r}
source("C:/Users/pmnha/my-new-project/22660348/Question5/Code/Health.R")
main_analysis("C:/Users/pmnha/my-new-project/22660348/Question5/Data/HealthCare.csv")
```

* **High Stress Risk**:
  Individuals with a `Stress Level` of **7 or higher** are classified as "Yes" for high stress risk, meaning they are considered to have high stress. Those with stress levels below 7 are classified as "No".

* **Poor Sleep Risk**:
  People whose `Sleep Quality` is either **"Poor"** or **"Fair"** are labeled as "Yes" for poor sleep risk. Those with better sleep quality (e.g., "Good" or "Excellent") are labeled "No".

* **Weight Change Risk**:
  This is a bit more complex:

  * If someone gained **more than 5 pounds** and their `Daily Caloric Surplus/Deficit` is **greater than 300 calories** (i.e., consistently eating more), they are considered "Yes" for weight change risk.
  * If someone lost **more than 5 pounds** and their caloric deficit is **less than -500 calories** (eating significantly less), they are also "Yes" for risk.
  * Otherwise, "No".

* **Sedentary Lifestyle**:
  Those who report their `Physical Activity Level` as exactly **"Sedentary"** are classified as "Yes" for sedentary lifestyle, otherwise "No".

* **Stress Group**:
  A simplified grouping where individuals with stress level ≥7 are tagged as **"High Stress"**, and the rest as **"Low Stress"**.

* **Sleep Group**:
  Similarly, people with "Poor" or "Fair" sleep are grouped as **"Poor Sleep"**, and others as **"Good Sleep"**.

* **Combined Group**:
  This is a combination label created by pasting together the sleep group and stress group, e.g., **"Poor Sleep + High Stress"**, **"Good Sleep + Low Stress"**, etc. This allows for analysis of combined sleep-stress categories.

* **Factors for Modeling**:
  Some variables are converted to factors (categorical variables) for modeling purposes:

  * `sleep_risk` (Poor Sleep / Good Sleep)
  * `stress_risk` (High Stress / Low Stress)
  * `physical_activity` (levels from the original physical activity data)
  * `age_group` (age categories created elsewhere)






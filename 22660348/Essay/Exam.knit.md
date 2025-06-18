---
title: "Data Science Exam"

author: 
  - name: "Precious Nhamo"

abstract: |
  This document comprises the responses to **Questions 1 to 5** of the 2025 Data Science examination,
  along with separate analyses (e.g., a PowerPoint presentation) completed in accordance with the exam
  instructions and organised within the designated folder.

bibliography: "r-references.bib"

floatsintext: yes
linenumbers: no
draft: no
mask: no

figurelist: no
tablelist: no
footnotelist: no

classoption: "man"
output: papaja::apa6_pdf
---





# Question 1 Baby Names 
\begin{figure}
\includegraphics[width=0.9\linewidth]{../Question1/Results/nametime} \caption{ }(\#fig:bubble-image-1)
\end{figure}
\begin{figure}
\includegraphics[width=0.9\linewidth]{../Question1/Results/yearonyear} \caption{ }(\#fig:bubble-image-2)
\end{figure}
\begin{figure}
\includegraphics[width=0.9\linewidth]{../Question1/Results/namepopularity} \caption{ }(\#fig:bubble-image-3)
\end{figure}
\begin{figure}
\includegraphics[width=0.9\linewidth]{../Question1/Results/fadsonewonders} \caption{ }(\#fig:bubble-image-4)
\end{figure}
\begin{figure}
\includegraphics[width=0.9\linewidth]{../Question1/Results/mediaimpact} \caption{ }(\#fig:bubble-image-5)
\end{figure}
\begin{figure}
\includegraphics[width=0.9\linewidth]{../Question1/Results/musicimpact} \caption{ }(\#fig:bubble-image-6)
\end{figure}
\begin{figure}
\includegraphics[width=0.9\linewidth]{../Question1/Results/bubble} \caption{ }(\#fig:bubble-image-7)
\end{figure}

### **Baby Naming Trends in the U.S.**
#### **Prepared for: New York-Based Kids’ Toy Design Agency**
#### **Date: June 18, 2025**

#### **Objective**
This report provides a strategic analysis of U.S. baby naming trends to inform character name selection for toy design. The analysis focuses on five key graphs, highlighting naming longevity, surges in popularity, gender-based stability, cultural influences, and the rise of disposable names.


### **Key Findings & Strategic Insights**

#### **1. Longevity of Baby Names in the Top 25**
- **Observation:** Certain names exhibit remarkable persistence in popularity, remaining in the top 25 for over a decade.
- **Strategic Insight:** Names with historical longevity (e.g., William, Elizabeth, James, Mary) signal cultural stability and trustworthiness, making them ideal for classic toy characters.

#### **2. Year-on-Year Surges in Popularity**
- **Observation:** Names experience sudden spikes due to external influences such as pop culture, politics, and media.
- **Example:** The name "Linda" surged by **89.1% in 1947**, likely influenced by Hit song “Linda” (1946)by Jack Lawrence.
- **Strategic Insight:** Leveraging trending names from movies, music, and social movements can enhance toy market relevance.

#### **3. Gender-Based Stability in Naming Trends**
- **Observation:** Boys' names exhibit **15-20% greater stability** in popularity compared to girls' names.
- **Strategic Insight:** Male character names  emphasize tradition and reliability, while female names can reflect evolving cultural trends.Or parents' likely conservatism with boys' names compared to girls' which are trend-sensitive

#### **4. Influence of HBO & Billboard Artists on Naming Trends**
- **Observation:** TV shows and music significantly impact baby name choices.
- **Example:** Names like "Whitney" surged in the 1980s due to Whitney Houston’s popularity.
- **Strategic Insight:** Incorporating names inspired by entertainment icons can enhance brand appeal.Integrating a real-time monitoring of children's media into product-development.

#### **5. The Rise of Disposable Baby Names**
- **Observation:** One-time top 25 names became **5x more common after 1960**, indicating a shift toward short-lived naming trends showing decadal patterns (confirming the suspicion).
- **Strategic Insight:** Short-lived trendy names may work well for limited-edition toy lines or shorter product cycles and name refresh strategies , but should must be  balanced with timeless names for long-term brand equity.


### **Recommendations**
1. **Blend Classic & Trendy Names:** Use a mix of historically persistent names and trending names to maximize appeal.Maybe , legacy lines using persistent names (> 100 ), trendy lines using current events and decade lines that envoke nostalgic names from specific era like Whitney.
2. **Leverage Pop Culture Data:** Monitor entertainment trends to predict future naming spikes.
3. **Gender-Based Strategy:** Design male characters with stable, traditional names and female characters with dynamic, evolving names.
4. **Optimise for Longevity:** Prioritise names with proven staying power for flagship toy lines.You never go with Elizabeth/William
5. **Monitor Disposable Name Trends:** Use short-lived names for seasonal or limited-edition products.

---

### **Additional Research & References**
To further refine the analysis, external research was conducted on baby naming trends, factors influencing names, and naming longevity:

- **General Trends in U.S. Baby Names:** [GitHub Analysis](https://github.com/brettc17/Baby-Name-Trends-Exploring-American-Naming-Patterns)
- **Political & Cultural Influences on Naming:** [Daily Trojan](https://dailytrojan.com/2025/06/18/parents-political-beliefs-shape-us-baby-names/)
- **Psychological & Sociological Factors in Naming:** [Life by Name](https://lifebyname.com/the-science/)
- **Historical Longevity of Baby Names:** [American Name Society](https://www.americannamesociety.org/long-term-sociolinguistics-trends-and-phonological-patterns-of-american-names/)








# Question 2 Music Taste

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question2/Results/popalbums} 

}

\caption{ }(\#fig:include-image-1)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question2/Results/uniquesongs} 

}

\caption{ }(\#fig:include-image-2)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question2/Results/audioeffects} 

}

\caption{ }(\#fig:include-image-3)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question2/Results/extraeffects} 

}

\caption{ }(\#fig:include-image-4)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question2/Results/directcompetition} 

}

\caption{ }(\#fig:include-image-5)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question2/Results/industrytrend} 

}

\caption{ }(\#fig:include-image-6)
\end{figure}


## Longevity and Musical Progression of Coldplay and Metallica

The data reveals distinct trajectories for Coldplay and Metallica in terms of popularity, musical evolution, and industry adaptation. Coldplay demonstrated early dominance, charting five songs in their first decade compared to Metallica’s one (Figure 2). Their popularity scores on Spotify also show broader appeal, with a higher median and narrower interquartile range than Metallica’s (Figure 1).

Musically, Coldplay’s tempo has remained stable (Figure 3), while their audio features, such as danceability and valence, trended positively over time (Figure 4). Metallica, conversely, maintained higher instrumentalness and energy, reflecting their heavier style.

Billboard data highlights their adaptation to industry shifts: Metallica peaked during the album era (1991), while Coldplay thrived post-2000, leveraging streaming’s rise (Figure 6). During direct competition (1996+), Coldplay’s momentum outpaced Metallica’s (Figure 5).

Coldplay’s consistent, accessible sound contrasts with Metallica’s enduring heavy metal identity. Both bands exemplify longevity but reflect divergent strategies in navigating musical trends



# Question 3 : Netflix Content Strategy Analysis 

In light of Netflix’s recent subscriber attrition and share price volatility, a strategic review was conducted to inform potential market entry for a new streaming venture. This review draws on IMDb ratings and global production data to assess what drives success in streaming content.

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question3/Results/audienceengage} 

}

\caption{ }(\#fig:audienceengage-1)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question3/Results/countryrating} 

}

\caption{ }(\#fig:audienceengage-2)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question3/Results/emergers} 

}

\caption{ }(\#fig:audienceengage-3)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question3/Results/genre_rating_plot} 

}

\caption{ }(\#fig:audienceengage-4)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question3/Results/genrescore} 

}

\caption{ }(\#fig:audienceengage-5)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question3/Results/IMDbratings} 

}

\caption{ }(\#fig:audienceengage-6)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question3/Results/top5movies} 

}

\caption{ }(\#fig:audienceengage-7)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question3/Results/viewership} 

}

\caption{ }(\#fig:audienceengage-8)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{../Question3/Results/top20creators} 

}

\caption{ }(\#fig:audienceengage-9)
\end{figure}
## Key Findings

### 1. Quality vs. Volume Trade-Off

Japanese titles, while constituting only 1.6% of Netflix’s catalogue, achieve superior average IMDb ratings (mean = 6.7, SD = ±0.3). By contrast, the United States and India collectively contribute over 50% of Netflix’s content but yield lower average ratings (mean = 6.1–6.3) (Figures 8, 15)
**Implication**: High-volume strategies may dilute perceived quality.

### 2. Genre Performance Differentials

Content genres vary markedly in audience reception. Documentaries (mean = 7.6) and dramas (mean = 7.0) lead on quality metrics, while action and comedy lag behind (mean = 6.2 and 6.5 respectively) (Figure 11). Crime and thriller categories also demonstrate strong viewer engagement.

**Implication**:Narrative depth and authenticity drive audience satisfaction.

### 3. Optimal Runtime Windows

Ratings peak for films with runtimes between 90–120 minutes (mean = 7.5). Shorter or longer formats tend to correlate with lower ratings (Figure 12).
**Implication**:Viewer engagement is maximised within a standardised runtime threshold.

### 4. Age and Longevity of Content

Older films (>20 years) sustain higher average ratings (mean = 8.5)(Figure 7) compared to recent productions (1–3 years; mean = 6.0)(Figure 14).
**Implication**:Legacy content benefits from curation and nostalgia; newer content faces saturation and discovery challenges.

## Strategic Recommendations for New Market Entrant

To position competitively against incumbent platforms:

### 1. Targeted Content Acquisition

Prioritise **high-quality, underrepresented niches**—such as Japanese documentaries and international dramas—to differentiate on quality and build a prestige brand image.

### 2. Genre Investment Strategy

Allocate production and licensing budgets towards **high-performing genres** (e.g., crime, thriller, drama). Avoid overserved categories like generic comedy unless uniquely positioned.

### 3. Runtime Standardisation

Anchor commissioned or licensed content within the 90–120 minute range to enhance user engagement and completion rates.

## Conclusion

A differentiated, quality-first strategy that leverages genre insights, runtime discipline, and curated international content provides a clear pathway for new entrants to gain market share and investor confidence—without replicating the scale-driven pitfalls observed in Netflix’s recent trajectory.






















#Question4 Billionaires


## Data analysis
We used R [Version 4.4.3\; @R-base] and the R-packages *dplyr* [Version 1.1.4\; @R-dplyr], *fastDummies* [Version 1.7.5\; @R-fastDummies], *forcats* [Version 1.0.0\; @R-forcats], *ggplot2* [Version 3.5.2\; @R-ggplot2], *ggrepel* [Version 0.9.6\; @R-ggrepel], *lubridate* [Version 1.9.4\; @R-lubridate], *papaja* [Version 0.1.3\; @R-papaja], *patchwork* [Version 1.3.0\; @R-patchwork], *purrr* [Version 1.0.4\; @R-purrr], *readr* [Version 2.1.5\; @R-readr], *stringr* [Version 1.5.1\; @R-stringr], *tibble* [Version 3.2.1\; @R-tibble], *tidyr* [Version 1.3.1\; @R-tidyr], *tidyverse* [Version 2.0.0\; @R-tidyverse], and *tinylabels* [Version 0.2.5\; @R-tinylabels] for all our analyses.
##Results

##Discussion








# Question 5 Health

## On Air Script
For the 9-to-5 gamer: 1 hour of extra sleep beats 1 hour on the treadmill. Data shows stress-free living is your real cheat code.

We've been told for years to 'exercise more'—but new data reveals the real game-changers: sleep and stress management. Here's the proof: Adults with poor sleep and high stress gained 7–10 pounds more than those with good sleep and low stress—based on regression analysis (p<0.01). The worst hit? Early-career professionals (ages 30–39), who saw up to 10 pounds more weight gain when stressed—even if they exercised. Why this matters: Gym memberships won't fix this. The solution? Protect your sleep: Aim for 7–9 hours, and keep a consistent schedule—it's your metabolic lifeline. Tame stress: Short walks, 5-minute breathing exercises, or setting work boundaries can slash health risks. Bottom line? Small changes to sleep and stress beat marathon workouts. Start tonight—your body will thank you.

\begin{figure}
\includegraphics[width=0.9\linewidth]{../Question5/Results/Sleep_Stress_Boxplot} \caption{ }(\#fig:sleep-stress-boxplot)
\end{figure}

\begin{table}

\caption{(\#tab:sleep-risk-pivot )Weight Change Summary}
\centering
\begin{tabular}[t]{l|l|r|r|r}
\hline
Gender & age\_group & mean\_weight\_change & median\_weight\_change & n\\
\hline
F & Adults (20-29) & -1.0181151 & -0.3680584 & 10\\
\hline
F & Early Career (30-39) & -2.4545587 & -1.3943583 & 11\\
\hline
F & Middle-aged (40-49) & -3.4805916 & 0.7000000 & 12\\
\hline
F & Preretirement (50-64) & -1.5639095 & 0.0000000 & 9\\
\hline
F & Teenagers (<20) & -1.7940640 & -1.7940640 & 1\\
\hline
M & Adults (20-29) & -2.3794779 & -0.1679132 & 14\\
\hline
M & Early Career (30-39) & -5.5847844 & 0.6000000 & 12\\
\hline
M & Middle-aged (40-49) & -3.7051828 & 0.4500000 & 12\\
\hline
M & Preretirement (50-64) & -0.8648233 & -0.3807078 & 14\\
\hline
M & Teenagers (<20) & -5.2528414 & -5.7184960 & 5\\
\hline
\end{tabular}
\end{table}

\begin{table}

\caption{(\#tab:sleep-risk-pivot )Sleep Risk Pivot Summary}
\centering
\begin{tabular}[t]{l|l|r|r}
\hline
Poor Sleep Risk & age\_group & Mean\_Weight\_Change & Count\\
\hline
No & Adults (20-29) & 0.2142665 & 9\\
\hline
No & Early Career (30-39) & 1.5777778 & 9\\
\hline
No & Middle-aged (40-49) & 2.9571429 & 7\\
\hline
No & Preretirement (50-64) & -0.0982816 & 11\\
\hline
No & Teenagers (<20) & 1.9500000 & 2\\
\hline
Yes & Adults (20-29) & -3.0281494 & 15\\
\hline
Yes & Early Career (30-39) & -7.7298256 & 14\\
\hline
Yes & Middle-aged (40-49) & -6.2899584 & 17\\
\hline
Yes & Preretirement (50-64) & -2.0918011 & 12\\
\hline
Yes & Teenagers (<20) & -7.9895678 & 4\\
\hline
\end{tabular}
\end{table}

\begin{table}

\caption{(\#tab:sleep-risk-pivot )Stress Risk Pivot Summary}
\centering
\begin{tabular}[t]{l|l|r|r}
\hline
Poor Sleep Risk & age\_group & Mean\_Weight\_Change & Count\\
\hline
No & Adults (20-29) & 0.2142665 & 9\\
\hline
No & Early Career (30-39) & 1.5777778 & 9\\
\hline
No & Middle-aged (40-49) & 2.9571429 & 7\\
\hline
No & Preretirement (50-64) & -0.0982816 & 11\\
\hline
No & Teenagers (<20) & 1.9500000 & 2\\
\hline
Yes & Adults (20-29) & -3.0281494 & 15\\
\hline
Yes & Early Career (30-39) & -7.7298256 & 14\\
\hline
Yes & Middle-aged (40-49) & -6.2899584 & 17\\
\hline
Yes & Preretirement (50-64) & -2.0918011 & 12\\
\hline
Yes & Teenagers (<20) & -7.9895678 & 4\\
\hline
\end{tabular}
\end{table}


\newpage

+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | Sleep-Stress Interaction | Stress-Age Interaction |
+=======================================================+==========================+========================+
| (Intercept)                                           | 1.758                    | -0.315                 |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (6.660)                  | (1.510)                |
+-------------------------------------------------------+--------------------------+------------------------+
| sleep_riskPoor Sleep                                  | -7.168***                |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (2.704)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| stress_riskLow Stress                                 | 5.800**                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (2.717)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| physical_activityModerately Active                    | -1.142                   |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (1.893)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| physical_activitySedentary                            | -0.539                   |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (1.982)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| physical_activityVery Active                          | -1.076                   |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (2.311)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| age_groupEarly Career (30-39)                         | -2.976                   | 0.653                  |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (1.875)                  | (2.135)                |
+-------------------------------------------------------+--------------------------+------------------------+
| age_groupMiddle-aged (40-49)                          | -2.226                   | 0.107                  |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (1.766)                  | (2.103)                |
+-------------------------------------------------------+--------------------------+------------------------+
| age_groupPreretirement (50-64)                        | -0.777                   | 0.164                  |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (1.891)                  | (2.135)                |
+-------------------------------------------------------+--------------------------+------------------------+
| age_groupTeenagers (<20)                              | -3.178                   | -1.867                 |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (2.861)                  | (3.094)                |
+-------------------------------------------------------+--------------------------+------------------------+
| GenderM                                               | -1.650                   |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (1.597)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| Daily Caloric Surplus/Deficit                         | 0.002                    |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (0.003)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| BMR (Calories)                                        | -0.001                   |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (0.002)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| Duration (weeks)                                      | -0.158                   |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (0.175)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| sleep_riskPoor Sleep × stress_riskLow Stress          | 2.980                    |                        |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       | (3.290)                  |                        |
+-------------------------------------------------------+--------------------------+------------------------+
| High Stress RiskYes                                   |                          | -4.493*                |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       |                          | (2.615)                |
+-------------------------------------------------------+--------------------------+------------------------+
| High Stress RiskYes × age_groupEarly Career (30-39)   |                          | -10.049***             |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       |                          | (3.785)                |
+-------------------------------------------------------+--------------------------+------------------------+
| High Stress RiskYes × age_groupMiddle-aged (40-49)    |                          | -7.112*                |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       |                          | (3.767)                |
+-------------------------------------------------------+--------------------------+------------------------+
| High Stress RiskYes × age_groupPreretirement (50-64) |                          | 1.248                  |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       |                          | (3.785)                |
+-------------------------------------------------------+--------------------------+------------------------+
| High Stress RiskYes × age_groupTeenagers (<20)        |                          | -10.476                |
+-------------------------------------------------------+--------------------------+------------------------+
|                                                       |                          | (7.112)                |
+-------------------------------------------------------+--------------------------+------------------------+
| Num.Obs.                                              | 100                      | 100                    |
+-------------------------------------------------------+--------------------------+------------------------+
| R2                                                    | 0.455                    | 0.402                  |
+-------------------------------------------------------+--------------------------+------------------------+
| R2 Adj.                                               | 0.366                    | 0.342                  |
+-------------------------------------------------------+--------------------------+------------------------+
| AIC                                                   | 655.5                    | 654.9                  |
+-------------------------------------------------------+--------------------------+------------------------+
| BIC                                                   | 697.2                    | 683.5                  |
+-------------------------------------------------------+--------------------------+------------------------+
| Log.Lik.                                              | -311.752                 | -316.433               |
+-------------------------------------------------------+--------------------------+------------------------+
| RMSE                                                  | 5.47                     | 5.73                   |
+=======================================================+==========================+========================+
| * p < 0.1, ** p < 0.05, *** p < 0.01                                                                      |
+=======================================================+==========================+========================+

### **Key Findings on Health Determinants**  
1. **Sleep Quality is Critical**:  
   - Poor sleep correlates with **-7.2 lbs** weight gain (*p<0.01*), surpassing the impact of physical activity (non-significant coefficients).  
   - Teens and early-career adults with poor sleep show the worst outcomes (**-7.7 to -8.0 lbs** mean weight change).Teens are abstracted from main analysis as their n is very small , n =5 .  

2. **Stress Drives Negative Outcomes**:  
   - High stress alone leads to **-4.5 lbs** weight gain (*p<0.1*).  
   - Stress combined with poor sleep exacerbates effects, especially in younger age groups (interaction terms up to **-10.0 lbs**, *p<0.01*).  

3. **Sedentary Lifestyle Modifies Risk**:  
   - Sedentary individuals (red dots, Figure 16) show higher weight variability, but sleep/stress dominate overall trends.  


### **Practical Recommendations**  
- **Prioritise Sleep Hygiene**: Consistent sleep schedules improve metabolic health more than moderate exercise.  
- **Stress Management**: Mindfulness or flexible work policies could mitigate high-stress impacts, particularly for younger adults.  
- **Targeted Interventions**: Early-career professionals need tailored programs addressing sleep and stress.  



 











\newpage

# References

::: {#refs custom-style="Bibliography"}
:::

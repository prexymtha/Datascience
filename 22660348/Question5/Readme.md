# Question5

This folder contains Code, Data, and Results for this question.

Edit this README to explain your logic and contributions.

```{r}
# Install pacman if not installed
if (!require("pacman")) install.packages("pacman")

# Load pacman and then load/install tidyverse
pacman::p_load(tidyverse)

# Load data assuming working directory is set correctly
Health <- read_csv("Data/HealthCare.csv")

head(Health)

```



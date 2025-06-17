# Define the bespoke function
Bespoke_Read_Function <- function(filepath) {
  data <- read_csv(filepath, col_types = cols(.default = "c"))
  # Custom cleaning: convert 'date' column to Date format
  data <- data %>% mutate(date = as.Date(date, format = "%d/%m/%Y"))
  return(data)
}

# Use the function to read the billionaires CSV file
Billionaires <- Bespoke_Read_Function("Question4/Data/billionaires.csv")
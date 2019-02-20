# Week 3: Data Cleaning 
library(tidyverse)
library(readr)

url <- paste0("https://raw.githubusercontent.com/", 
              "mhaber/AppliedDataScience/master/",
              "slides/week3/data/")

pew <- read_csv(paste0(url,"pew.csv"))
billboard <- read_csv(paste0(url,"billboard.csv")) 
weather <- read_tsv(paste0(url,"weather.txt"))

# Any function within tidyverse will work with a pipe but it may not work all the time esp. with base R
# E.g. pipe may not work with the lm() function 
# Piping means that we don't need to define the data object (usually identified first)

# Tidy data
# Objective: Calculate the rate of TB cases per country per year

# Steps:
# Extract number of TB cases per country per year 
# Extract the population per country per year 
# Divide the cases by population 
# Multiply by 10000

# Compute rate per 10,000
dataframe %>% 
  dplyr::mutate(newvar = var1/var2*10000)

# Compute cases per year 
dataframe %>% 
  dplyr::count(var1, wt = var2)

# gather() and spread()
# Builds on a key-value pair 
data(pew)
str(pew)
head(pew)
# Variables (religion) are in the rows but observations (values) are in the columns
# Goal is to transform it such that variables are in the columns and observations are in the rows

pewTidy <- pew %>% gather(key = income, value = frequency, -religion)
head(pewTidy)
# Value can also be stated as a range of columns [, 1:5] or a combination of columns through cbind
# Frequency, count, occurrence can also be used - easily recognised functions 

data(billboard)
str(billboard)
head(billboard)
# We should have one column for week; a column should also indicate the rank of the track in 
# respective weeks

billboardTidy <- billboard %>% 
  tidyr::gather(key = week, value = rank, wk1:wk76, na.rm = TRUE)
head(billboardTidy)
# sequential pipes: e.g. gather(df, key, value) %>% gather(., key, value)
# the . references the df in the first argument before the pipe since the first argument 
# transforms the original df - so you can't refer to the original df in the second argument after
# the pipe 

# Further cleaning: checking the formatting of each variable 
# Turning week into numeric variable and creating a proper date column 
billboardTidy2 <- billboardTidy %>% 
  dplyr::mutate(week = readr::parse_number(week),
                date = as.Date(date.entered) + 7 * (week - 1)) %>%
  dplyr::select(-date.entered) %>% 
  dplyr::arrange(artist, track, week)

# spread() - opposite of gather()
stocks <- tibble(
  year = c(2015, 2015, 2016, 2016), 
  half =c( 1, 2, 1, 2), 
  return = c(1.88, 0.59, 0.92, 0.17)
) 

stocks %>%
  tidyr::spread(year, return) %>% 
  tidyr::gather("year", "return", `2015`:`2016`)

# separate()
# tells R how to separate the value in a column 
# Better to specify the separator 
# R can separate a column into as many columns as there are separators

# unite()

# complete() makes missing values explicit 

# fill() allows you to fill in missing information 
# tribble() produces easier to read row-by-row layout of a tibble
# tidyr does not know how to handle merged cells, formatted cells etc. 



library(devtools)
library(tidyverse)
install.packages("nycflights13")
library(nycflights13)
library(readr)
library(haven)
library(readxl)
library(DBI)
library(httr)
library(jsonlite)
install.packages("RMySQL")
library(RMySQL)

pop1 <- read_excel("slides/week2/data/urbanpop.xlsx", sheet = 1) 
pop2 <- read_excel("slides/week2/data/urbanpop.xlsx", sheet = 2) 
pop3 <- read_excel("slides/week2/data/urbanpop.xlsx", sheet = 3)

host <- "courses.csrrinzqubik.us-east-1.rds.amazonaws.com" 
con <- dbConnect(RMySQL::MySQL(),
                 dbname = "tweater",
                 host = host,
                 port = 3306,
                 user = "student",
                 password = "datacamp")

tables <- dbListTables(con) 
tables

users <- dbReadTable(con, "users") 
users

comments <- dbReadTable(con, "comments")
comments

tweats <- dbReadTable(con, "tweats")
tweats

# User with user_id 5: Oliver posted the tweat "awesome! thanks!" 
dbDisconnect(con)

# Import files directly from the web 
#CSV
url <- paste0("https://raw.githubusercontent.com/", 
              "mhaber/AppliedDataScience/master/", 
              "slides/week2/data/potatoes.csv")
potatoes <- read_csv(url)

#Excel
url <- paste0("https://github.com/", 
              "mhaber/AppliedDataScience/blob/master/", 
              "slides/week2/data/urbanpop.xlsx?raw=true") 
download.file(url, "slides/week2/data/urbanpop.xlsx", mode = "wb") 
urbanpop <- read_excel("slides/week2/data/urbanpop.xlsx")

#httr
url <- "http://www.example.com/" 
resp <- GET(url)
content <- content(resp, as = "raw") 
head(content)

#Importing data from other statistical software 
sales <- read_sas("slides/week2/data/sales.sas7bdat") 
str(sales)

sugar <- read_dta("slides/week2/data/sugar.dta") 
sugar$Date <- as.Date(as_factor(sugar$Date))
head(sugar$Date)
View(sugar)

# Homework week 2:
# Q1
df <- read_csv("x,y,z\n1,2,'a,b'", quote="'")
df
# Answer: read_csv("x,y,z\n1,2,'a,b'", quote="'")

# Q2
url <- paste0("http://s3.amazonaws.com/assets.datacamp.com/",
              "production/course_1561/datasets/national_debt.csv")

debt <- read_csv(url, col_types = cols(V1 = col_date(format = "%m/%d/%y"), 
                                       V2 = col_number()))
str(debt)
summary(debt)
avg <- with(debt, mean(V2))
avg
format(avg, scientific=FALSE)
# Answer: "11024070595071"

# Solution: 
debt$V2 <- parse_number(debt$V2)
mean(debt$V2)

# Q3
url1 <- paste0("http://s3.amazonaws.com/assets.datacamp.com/",
               "production/course_1561/datasets/weather.csv")

weather <- read_csv(url1)
date <- parse_date(weather$date, format = "%m/%d/%Y")
date
View(weather$date)
# Answer: parse_date(weather$date, format = "%m/%d/%Y")

# Q4
View(mbta)
# Could not import the Excel file from url
# had to save Excel file manually in R project folder then ask R to import dataset

totals17 <- list(totals = mbta[12, 3:14])
totals17
totals <- as.numeric(unlist(totals17))
totals
avg <- mean(totals)
avg
# Answer: 1227.169

# Solution: 
# Can't read excel files directly into R - use the download.file() function
url <- #paste the url 
download.file(url, "mbta.xlsx")
mbta <- read_excel("mbta.xlsx", range = "C13:N13", col_names = FALSE)
mbta_t <- t(mbta)
mean(mbta_t)

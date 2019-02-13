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


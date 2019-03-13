library(tidyverse)
library(dbplyr)
library(DBI)
library(RSQLite)
library(nycflights13)
library(readr)

url <- paste0("https://raw.githubusercontent.com/mhaber/",
              "AppliedDataScience/",
              "master/slides/week5/data/")
films <- read_csv(paste0(url, "films.csv"))
people <- read_csv(paste0(url, "people.csv"),
                   col_types = "iccc")
reviews <- read_csv(paste0(url, "reviews.csv"))
roles <- read_csv(paste0(url, "roles.csv"))

# SQL syntax: 
# SELECT always followed by FROM (SELECT variable FROM table)
# To select multiple columns: 
# SELECT name, birthdate 
# FROM people 

# Select all columns: 
# SELECT * 
# FROM people 

# Limit number of rows returned: 
# SELECT * 
# FROM people 
# LIMIT 10 

# DISTINCT: selects unique values from a column 
# Similar to n_distinct() in R dplyr 
# SELECT DISTINCT language 
# FROM films 

# COUNT - similar to R 
# Also possible to nest commands
# SELECT COUNT(DISTINCT birthdate)
# FROM people 

# WHERE - acts like a filter 
# SELECT title 
# FROM films 
# WHERE title = 'Metropolis' 

# SELECT titles 
# FROM films 
# WHERE release_year > 1994 
# AND release_year < 2000

# WHERE also works with OR and BETWEEN

# IN 
# SELECT name 
# FROM kids 
# WHERE age IN (2, 4, 6, 8, 10)

# IS NULL for NA values; IS NOT NULL to filter out missing values 

# Aggregate functions 

# AS keyword - assign a temporary name to something 
# SELECT MAX(budget) AS max_budget 
# FROM films 

# ORDER BY is like the arrange function in dplyr 

# dbplyr - translates R code to SQL language (somewhat)


# First, connect to a database file 
# Syntax: con <- DBI::dbConnect(RSQLite::SQLite(), path = ":memory:")
# e.g.
con <- DBI::dbConnect(RMySQL::MySQL(),
                      host = "database.rstudio.com",
                      user = "hadley",
                      password = rstudioapi::askForPassword("Database password"))

# Creating your own database
con<-DBI::dbConnect(RSQLite::SQLite(),path = ":memory:")
dbWriteTable(con, "flights", nycflights13::flights)
dbListTables(con)

flights_db <- tbl(con, "flights")

# Generating queries
# using SQL syntax with dbGetQuery()
# or using dplyr

library(DBI)
con <- DBI::dbConnect(RSQLite::SQLite(), dbname = ":memory:")
# Or you can define an actual name/ path on hard drive: e.g. dbname = "films.sqlite"
dbWriteTable(con, "films", films)
dbWriteTable(con, "people", people)
dbWriteTable(con, "reviews", reviews)
dbWriteTable(con, "roles", roles)
dbListTables(con)

# Get title, release year, country for every film
results <- DBI::dbGetQuery(con, 
                           "SELECT title, release_year, country 
                           FROM films")

# Get all different type of film roles 
filmroles <- DBI::dbGetQuery(con,
                             "SELECT DISTINCT role
                             FROM roles")
filmroles
# Two roles - actor, director 

# Count number of unique languages 
lang <- DBI::dbGetQuery(con,
                             "SELECT COUNT(DISTINCT language)
                             FROM films
                             WHERE language IS NOT NULL")
lang
# 47 languages 

# Get number of films released before 2000
pre2000 <- DBI::dbGetQuery(con,
                           "SELECT COUNT(release_year)
                           FROM films
                           WHERE release_year < 2000")
pre2000
# 1337 

# Get the name and birth date of the person born on November 11th, 1974
nov11 <- DBI::dbGetQuery(con,
                         "SELECT name, birthdate
                         FROM people
                         WHERE birthdate = '1974-11-11'")
nov11
# Leonardo DiCaprio

# Get all information for Spanish language films released after 2000, but before 2010
release <- DBI::dbGetQuery(con,
                           "SELECT *
                           FROM films 
                           WHERE language = 'Spanish'
                           AND release_year > 2000
                           AND release_year > 2010")
release

# Get the names of people who are still alive 
alive <- DBI::dbGetQuery(con,
                         "SELECT name
                         FROM people
                         WHERE deathdate IS NULL")
alive

# Get the amount grossed by best performing film between 2000 and 2012 
best <- DBI::dbGetQuery(con,
                        "SELECT MAX(gross), release_year
                        FROM films
                        WHERE release_year >=2000 AND release_year <=2012
                        ORDER BY release_year")

best
#MAX(gross) release_year
#1  760505847         2009

# Get the avg duration in hours for all fims, aliased as avg_duration_hours
avgd <- DBI::dbGetQuery(con,
                        "SELECT AVG(duration/60.0) AS avg_duration_hours
                        FROM films")

avgd
#1.799132

# Get the IMDB score and count of film reviews grouped by IMDB score 
score <- DBI::dbGetQuery(con,
                         "SELECT imdb_score, COUNT(id) 
                         FROM reviews
                         GROUP BY imdb_score")
score

# Get the country, avg budget and avg gross take of countries that have made more than 10 films
# Order the result by country name, and limit the number of results displayed to 5 
# Alias the averages as avg_budget and avg_gross
order <- DBI::dbGetQuery(con,
                         "SELECT country, 
                         AVG(budget) AS avg_budget,
                         AVG(gross) AS avg_gross
                         FROM films
                         GROUP BY country
                         HAVING COUNT(title) > 10
                         LIMIT 5")

#> order
#country avg_budget avg_gross
#1 Australia   31172110  40205910
#2    Canada   14798459  22432067
#3     China   62219000  14143041
#4   Denmark   13922222   1418469
#5    France   30672035  16350594

dbDisconnect(con)



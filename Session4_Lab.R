library(tidyverse)
library(nycflights13)
data("flights", package = "nycflights13")
head(flights)
filter(flights, month==1, day==1)
jan1 <- filter(flights, month==1, day==1)

# Why does this not work? 
# filter(flights, month==11 | 12)
# Does not know how to evaluate this. 
# We want month to be equal to any of these values
# We should use: 
filter(flights, month==11 | month==12)
# or: 
filter(flights, month %in% c(11,12))

# filtering by comparing values between columns
filter(flights, dep_delay==arr_delay)
filter(flights, dep_delay>arr_delay)

# Using between()
filter(flights, between(dep_time, 0, 600))

# filter() and NA values 
# filter() skips NA values by default. To tell R to keep the NA values: 
# filter(df, is.na(x) | x > 1)

# filter() exercises 
# 1.1
filter1 <- flights %>% filter(dep_delay >= 120)
count(filter1)
# 1.2 
sum(is.na(flights$dep_delay))
# There are 8255 NA values in dep_delay
# The dep_delay should not be an NA value and must be <= 0 
filter2 <- flights %>% filter(!is.na(dep_delay), dep_delay<=0, arr_delay > 120)
count(filter2)
# 1.3
filter3 <- flights %>% filter(dest %in% c("IAH", "HOU"))
count(filter3)
# 1.4 
filter4 <- flights %>% filter(carrier %in% c("UA", "AA", "DL"))
count(filter4)
# 1.5 
filter5 <- flights %>% filter(between(month, 7, 9))
count(filter5)

# arrange()
# sorts values in ascending order  
arrange(flights, year, month, day)
# sort values in descending order 
arrange(flights, desc(dep_delay))

# Exercise 2

# select()
# subsets variables - state df, then name the columns you want to keep 
# overwrites the df - removes columns that are not specified in the original df
select1 <- select(flights, year, month, day)
select1

# Keep all columns except year column 
select2 <- select(flights, -year)
select2

# Select to rename variables 
tailnum <- select(flights, tail_num = tailnum)
tailnum
select(flights, tail_num = tailnum)
# or rename
rename(flights, tail_num = tailnum)

# Exercise 3
# 3.1
# select() 
# select() by exclusion (- name)
# indexing

#3.2 
# create a vector of names that you want to keep 
# select() based on whether it meets one of the names in the vector using one_of()

# mutate()
# Creates new columns or override existing columns 
flights %>% select(ends_with("delay"), distance, air_time) %>% 
  mutate(gain = arr_delay - dep_delay, 
         speed = distance/air_time*60)
# Can't use the pipe operator when using $ to define the variables 
# By default, mutate() creates a new column and keeps other columns

# use transmute() to only keep new variables 
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time/60,
          gain_per_hour = gain/hours)

# Exercise 4
# 4.1
flights1 <- flights %>% mutate(dep_time2 = dep_time %/% 100 * 60 + dep_time %% 100, 
                   sched_dep_time2 = sched_dep_time %/% 100 * 60 
                   + sched_dep_time %% 100) %>% 
  select(dep_time, dep_time2, sched_dep_time, sched_dep_time2)

# Assign this argument to an object to save the new column 

# summarize() or summarise()
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# Use summarise() with group_by() 
# calculate different summaries per group 
# group_by() can also be used in ggplot
# e.g. get average delay per date 
flights %>% group_by(year, month, day) %>% summarise(delay = mean(dep_delay, na.rm = TRUE))

# Calculates mean departure delay by carrier 
# Then sort this information in descending order 
# F9 is the carrier with the highest average departure delay
flights %>% group_by(carrier) %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE)) %>% 
  arrange(desc(delay))

# Working with strings 
library(tidyverse)
library(stringr)

# Length
str_length("Data Management with R")

# Combining strings
str_c("Data Management", "with R", sep = " ")

# Subset strings
x <- c("Apple", "Banana", "Pear")
# Select the first three letters of the string 
str_sub(x, 1, 3)
# x = list, positions 

# Or select the last three letters
str_sub(x, -3, -1)

# Functions for strings
# Changing case
str_to_upper(c("a", "b"))
str_to_lower(c("A", "B"))

# Regular expressions 
# To extract/ match text patterns 
# grep(..., value = FALSE), grepl(), stringr::str_detect()
# slide 3

# Pattern matching 
x <- c("apple", "banana", "pear")
str_view(x, "an")

# . matches any character (except a newline)
str_view(x, ".a.")
str_view(x, "a.")
str_view(x, ".") # highlights the whole string

# match the beginning of a string with ^ 
str_view(x, "^a")

# match the end of the string with $ 
str_view(x, "a$")

# Quantifiers: specify how often something should be matched 
# * matches at least 0 times 
# + matches at least 1 times
# ? matches at most 1 time
# {n} matches exactly n times 
# {n,} matches at least n times
# {n,m} matches between n and m times 

strings <- c("a", "ab", "acb", "accb", "acccb", "accccb")
grep("ac*b", strings, value = TRUE) # returns the whole string because of * - c doesn't have to appear
grep("ac+b", strings, value = TRUE)
grep("ac?b", strings, value = TRUE)
grep("ac{2}b", strings, value = TRUE)
grep("ac{2, }b", strings, value = TRUE)
grep("ac{2,3}b", strings, value = TRUE)

# \\ tells R to treat the metacharacters as string 

# Matching characters to a list of characters
# use [...]
# Match anything except for what is defined in the list - use [^...]
strings <- c("^ab", "ab", "abc", "abd", "abe", "ab 12")
grep("ab[c-e]", strings, value = TRUE)
grep("ab[^c]", strings, value = TRUE)

#gsub replaces string letters
gsub("(ab) 12", "\\1 34", strings)

# ignore.case = TRUE tells R to ignore differences between upper and lower case 

# Globbing vs. regular expression 
# globbing has a slightly different syntax 

# Detecting matches 
x <- c("apple", "banana", "pear")
str_detect(x, "e")

x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-") # similar to gsub
str_replace_all(x, "[aeiou]", "-") # replaces all the vowels with -
# Need to put the names in a vector before performing any function on them 

"a|b|c|d" %>%
  str_split("\\|")

words <- stringr::words
grep("^y", words, value = TRUE)
str_view(words, "^y")

grep("x$", words, value = TRUE)
str_view(words, "x$")

grep("^[aeiou]", words, value = TRUE)
str_view(words, "^[aeiou]", match = TRUE)

grep("^[^aeiou]+$", words, value = TRUE) # no consonants

grep("^ed$|[^e]ed$", words, value = TRUE) # not ending with eed

grep("ing|ise$", words, value = TRUE)

str_view(words, "^[^aeiou]{3}", match = TRUE)
str_view(words, "[aeiou]{3,}", match = TRUE)
str_view(words, "[aeiou][^aeiou]{2,}", match = TRUE)
str_view(words, "(..).*\\1", match = TRUE)

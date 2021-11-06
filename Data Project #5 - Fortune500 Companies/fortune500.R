library(tidyverse)

#In Excel converted '-' for empty values in 2015 to blanks

fortune500 <- read_csv("fortune500.csv")

#Question 1: What is the trend of average Revenue per year, by year?

ggplot(summarize(group1_by(fortune500,Year),avg_rev = mean(Revenue, na.rm = TRUE)), 
       aes(y = avg_rev,  x = Year))+geom_point()

#There is a steep jump at the year 1995 as confirmed here:

View(summarize(group_by(fortune500,Year),avg_rev = mean(Revenue, na.rm = TRUE)))

View(arrange())

#Question 2: What is the overall distribution of the past 10 companies, that held the highest rank, during the time they were in the fortune 500?

filter(arrange(mutate(group_by(fortune500,Name), highest_rank = min(Rank, na.rm = TRUE)),highest_rank)

ggplot(mutate(group_by(fortune500,Name), highest_rank = min(Rank, na.rm = TRUE)))+geom_point(aes(Year, Revenue))+facet_wrap(~Name)+theme_bw()

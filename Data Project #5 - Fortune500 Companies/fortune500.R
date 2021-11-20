library(tidyverse)

#In Excel converted '-' for empty values in 2015 to blanks

fortune500 <- read_csv("fortune500.csv")

#Question 1: What is the trend of average Revenue per year, by year?

ggplot(summarize(group_by(fortune500,Year),avg_rev = mean(Revenue, na.rm = TRUE)), 
       aes(y = avg_rev,  x = Year))+geom_point()

#There is a steep jump at the year 1995 as confirmed here:

View(summarize(group_by(fortune500,Year),avg_rev = mean(Revenue, na.rm = TRUE)))

#This is because the methodology of Forbes changed into including service companies as well into the mix

#Question 2: What is the overall distribution of the past 11 companies, that held the highest rank, during the time they were in the fortune 500?

mutate(group_by(fortune500,Name),highest_rank = min(Rank, na.rm = TRUE))

Question2 <- filter(arrange(mutate(group_by(fortune500,Name),highest_rank = min(Rank, na.rm = TRUE)),highest_rank),highest_rank < 4)
Question2 %>%
    ggplot()+
    geom_point(aes(Year, Revenue), colour = Question2$highest_rank)+facet_wrap(~Name)+theme_bw()
#Black = 1. Red = 2, Green = 3

#Question 3: Plot on one graph the distribution of each year's revenue

ggplot(data = fortune500, aes(Rank, Revenue))+geom_point(aes(colour = Year))+scale_color_gradientn(colours=c("purple","blue","green","yellow","orange","red"))

#Every colour represents a year with red = 2021 and purple = 1955
#The curve tends to always look like an exponential curve but the high outliers are higher in the later years than the earlier years
#Let's look at the points that are at this high range and see what company they belong to

ggplot(filter(fortune500, Revenue > 200000),aes(Year, Revenue)) + geom_point() + facet_wrap(~Name)

#



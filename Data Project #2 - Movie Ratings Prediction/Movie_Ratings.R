##Trying to find the correlation of Ratings by each Genre

#Step 1: Find which genres to do the separation on 

Movies <- read.csv("~/Shangeeth/Projects/Data_Analytics_Projects/Data Project #2 - Movie Ratings Prediction/IMDb movies.csv")
Ratings <- read.csv("~/Shangeeth/Projects/Data_Analytics_Projects/Data Project #2 - Movie Ratings Prediction/IMDb ratings.csv")

library(tidyverse)
library(sjmisc)

#Separate the genre column to understand the contents and create a boolean variable for each genre rather than a character variable
Genre <- Movies$genre

summary(is.na(Genre))

Genres <- unlist(strsplit(Genre,", ")) 

#Now we have 25 unique genres to summarize all 85k movies
sort(unique(Genres))

#To count the number of occurrences of each genre to see if any are too small to use

Genre_Count = data.frame()

for(i in unique(Genres)){
  Genre_Count[i,1] <- sum(lengths(regmatches(Genres,gregexpr(i,Genres))))
}

Genre_Count[,2] <- c(1:25)
a <- order(Genre_Count$V1,decreasing = TRUE)
Genre_Count2 <- Genre_Count[order(Genre_Count$V1,decreasing = TRUE),]
Genre_Count2
barplot(Genre_Count2$V1,names.arg = rownames(Genre_Count2))
#Include does with count >5% of number of movies or 0.05*85855 = 4292.75 or the first 9
#Move to MySQL to create a table that has binary variables for the top 9 genres individually
rownames(Genre_Count2)[1:9]

#Step 2: Create a table with the separated genres for examination
### My SQL code for creating table



###

#Now we import the new table and merge it with ratings

Genres <- read_csv("~/Shangeeth/Projects/Data_Analytics_Projects/Data Project #2 - Movie Ratings Prediction/Genre.csv")

Genres_and_Ratings <- Genres %>% left_join(Ratings)

Genres_and_Ratings %>% ggplot()+geom_boxplot(aes(Drama, mean_vote,group = Drama))+ggtitle("Drama")+theme(
  plot.title = element_text(size=20, face="bold",hjust = 0.5))
Genres_and_Ratings %>% ggplot()+geom_boxplot(aes(Comedy, mean_vote,group = Comedy))+ggtitle("Comedy")+theme(
  plot.title = element_text(size=20, face="bold",hjust = 0.5))
Genres_and_Ratings %>% ggplot()+geom_boxplot(aes(Romance, mean_vote,group = Romance))+ggtitle("Romance")+theme(
  plot.title = element_text(size=20, face="bold",hjust = 0.5))
Genres_and_Ratings %>% ggplot()+geom_boxplot(aes(Action1, mean_vote,group = Action1))+ggtitle("Action")+theme(
  plot.title = element_text(size=20, face="bold",hjust = 0.5))
Genres_and_Ratings %>% ggplot()+geom_boxplot(aes(Thriller, mean_vote,group = Thriller))+ggtitle("Thriller")+theme(
  plot.title = element_text(size=20, face="bold",hjust = 0.5))
Genres_and_Ratings %>% ggplot()+geom_boxplot(aes(Crime, mean_vote,group = Crime))+ggtitle("Crime")+theme(
  plot.title = element_text(size=20, face="bold",hjust = 0.5))
Genres_and_Ratings %>% ggplot()+geom_boxplot(aes(Horror, mean_vote,group = Horror))+ggtitle("Horror")+theme(
  plot.title = element_text(size=20, face="bold",hjust = 0.5))
Genres_and_Ratings %>% ggplot()+geom_boxplot(aes(Adventure, mean_vote,group = Adventure))+ggtitle("Adventure")+theme(
  plot.title = element_text(size=20, face="bold",hjust = 0.5))
Genres_and_Ratings %>% ggplot()+geom_boxplot(aes(Mystery, mean_vote,group = Mystery))+ggtitle("Mystery")+theme(
  plot.title = element_text(size=20, face="bold",hjust = 0.5))

#What we see is that Drama is slightly higher in rating than all other movies and 
#horror is very much lower in rating compared to all other movies

#Let's test the significance of this difference with a t test



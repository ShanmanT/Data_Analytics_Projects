##Trying to predict Ratings using Genre

#Step 1: Find which genres to do the separation on 

Movies <- read.csv("~/Shangeeth/Projects/Data Project #2 - Movie Ratings Prediction/IMDb movies.csv")

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

barplot(Genre_Count2$V1,names.arg = rownames(Genre_Count2))
#Include does with count >5% of number of movies or 0.05*85855 = 4292.75

Genre_Names <- rownames(Genre_Count2[which(Genre_Count2$V1>4000),])

for (i in Genre_Names) {
  grepl(i,Movies$genre[2])
}







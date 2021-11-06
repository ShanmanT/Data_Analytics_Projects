Movies <- read.csv("~/Shangeeth/Projects/Data_Analytics_Projects/Data Project #2 - Movie Ratings Prediction/IMDb movies.csv")
Ratings <- read.csv("~/Shangeeth/Projects/Data_Analytics_Projects/Data Project #2 - Movie Ratings Prediction/IMDb ratings.csv")
library(tidyverse)
Movies_Ratings <- inner_join(Movies, Ratings, by = c("imdb_title_id"))

for(i in c(1:ncol(Movies_Ratings))){
  print(colnames(Movies_Ratings)[i])
  print(nrow(unique(Movies_Ratings[i])))
}

View(Movies_Ratings[i])

ggplot(data = Movies_Ratings, aes(x = year, y = mean_vote))+geom_boxplot()+theme(axis.text.x = element_text(angle=90,vjust=0.5,hjust =1))

View(Movies_Ratings)

arrange(filter(select(Movies_Ratings, all_of(c("title","year","language","mean_vote","total_votes"))),language == "Tamil"),desc(mean_vote))
print(as.tibble(mtcars))
print(women)

library(tidyverse)
library(rPref)

candy <- read_csv("candy-data.csv")

#Goal, do EDA on the dataset to learn more about the set
#First I want to see the relkationship between winpct and pricepct, I would expect the relationship to be positive 

ggplot(candy, aes(winpercent, pricepercent)) + geom_point(size = 3) + 
  scale_x_continuous(expand = c(0,0),limits = c (0,100)) + 
  scale_y_continuous(expand = c(0,0),limits = c(0,1))

#tT looks like there is no relationship between price and winpct which is interesting because we can now look at the pareto frontier of min price and max winpct to see which candies are the best for their price and look into those
plot(x = candy$winpercent, y = candy$pricepercent)
plot_front(candy,high(winpercent) | low(pricepercent))

pareto_frontier <- psel(candy, high(winpercent) * low(pricepercent))
ggplot(candy, aes(winpercent, pricepercent)) + geom_point(size = 3) + 
  scale_x_continuous(expand = c(0,0),limits = c (0,100)) + 
  scale_y_continuous(expand = c(0,0),limits = c(0,1)) +
  geom_step(data = pareto_frontier)

colSums(pareto_frontier[,2:10])

#So we see that the "optimal" have a lot of chocolate, are pluribus, and are not caramel, nougat, crisped rice wafer, hard, or bar but not we should test if these results are statistically significant
#We should do a chi-square goodness of fit test on the average columns

x <- (pareto_frontier %>% summarise_if(is.numeric, mean))[1:10]
y <- (candy%>% summarise_if(is.numeric, mean))[1:10]
rbind(x,y)

#The difference in optimal candy to the average candy is not significant across the board, it's unsure what makes the candy optimal




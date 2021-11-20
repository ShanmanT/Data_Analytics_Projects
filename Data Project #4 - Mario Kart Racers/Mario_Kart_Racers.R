library (tidyverse)
library(rPref)

#Now that we have the combined data for the Mario Kart Racers, let's see what patterns we can find

Mario_Kart <- read_csv("combined.csv")

Mario_Kart %>% ggplot()+geom_point(aes(Speed,Mini_Turbo,colour = Acceleration, alpha = Traction),size = 3)+theme_bw()+facet_wrap(~Handling)

length(unique(Mario_Kart$Speed))
length(unique(Mario_Kart$Acceleration))
length(unique(Mario_Kart$Handling))
length(unique(Mario_Kart$Traction))
length(unique(Mario_Kart$Mini_Turbo))

#Hard to get all 5 Qualities labelled well on the graph, IF I could choose the top three most important it would be handling, acceleration, and speed all of which the higher is better

Mario_Kart %>% ggplot()+geom_point(aes(Speed,Handling,colour = Acceleration),size = 6)+scale_color_gradient(low = "red",high = "green")+theme_bw()

#Based on This data the karts with high handling and acceleration have low speed, and high speed has low acceleration
#We should find the 2 variables with the strongest negative correlation (Highest R^2 with a negative b1) to distinctly see the pareto optimal frontier

summary(lm(Speed~Acceleration, Mario_Kart))$coefficients[2,1]
summary(lm(Speed~Acceleration, Mario_Kart))$r.squared
summary(lm(Acceleration~Speed, Mario_Kart))$coefficients[2,1]
summary(lm(Acceleration~Speed, Mario_Kart))$r.squared

#When switching y and x the slope of the regression changes but the r.squared stays the same so I should check all permutations of R2 and then test the coefficient sequentially to find a negative b1, 
#I should also check the pairs for positive b1 because if two variables are positively correlated then the best kart will have both of those variables at their highest point conditioned on the other variables so I can exclude it from the calculation 
#However, it is not guaranteed that a positive R will result it a single point of pareto optima, consider this example:

summary(lm(Acceleration~Mini_Turbo, Mario_Kart))$r.squared #0.6896
Mario_Kart %>% ggplot()+geom_jitter(aes(x = Acceleration,y = Mini_Turbo),size = 6)+theme_bw()
#There are 2 pareto optimum points on this graph not just one which would need to be taken into account but for now we will ignore these points and exclude positive correlated variables

summary(lm(Speed~Acceleration, Mario_Kart))$coefficients[2,1] #-1.024
summary(lm(Speed~Acceleration, Mario_Kart))$r.squared #0.7
summary(lm(Speed~Handling, Mario_Kart))$coefficients[2,1] #-0.1209
summary(lm(Speed~Handling, Mario_Kart))$r.squared #0.008
summary(lm(Speed~Traction, Mario_Kart))$coefficients[2,1] #-0.7875
summary(lm(Speed~Traction, Mario_Kart))$r.squared #0.4448
summary(lm(Speed~Mini_Turbo, Mario_Kart))$coefficients[2,1] #-0.8444
summary(lm(Speed~Mini_Turbo, Mario_Kart))$r.squared #0.5766
summary(lm(Acceleration~Mini_Turbo, Mario_Kart))$coefficients[2,1] #0.7552106
summary(lm(Acceleration~Mini_Turbo, Mario_Kart))$r.squared #0.6896
summary(lm(Acceleration~Traction, Mario_Kart))$coefficients[2,1] #0.428366
summary(lm(Acceleration~Traction, Mario_Kart))$r.squared #0.1967749
summary(lm(Acceleration~Handling, Mario_Kart))$coefficients[2,1] #0.2945444
summary(lm(Acceleration~Handling, Mario_Kart))$r.squared #0.07511873
summary(lm(Traction~Handling, Mario_Kart))$coefficients[2,1] #-0.3110073
summary(lm(Traction~Handling, Mario_Kart))$r.squared #0.0780997
summary(lm(Mini_Turbo~Handling, Mario_Kart))$coefficients[2,1] #0.2252381
summary(lm(Mini_Turbo~Handling, Mario_Kart))$r.squared #0.036
summary(lm(Mini_Turbo~Traction, Mario_Kart))$coefficients[2,1]#0.3645
summary(lm(Mini_Turbo~Traction, Mario_Kart))$r.squared #0.1178

#If we plot some of these positive relationships we find that:
#We start to use geom_jitter because it shows all 3920 points even if some have the same value, giving us an idea of density

Mario_Kart %>% ggplot()+geom_jitter(aes(x = Acceleration,y = Mini_Turbo),size = 6)+theme_bw()

#Because both these variables have the same relationship with the other variables:

summary(lm(Mini_Turbo~Handling, Mario_Kart))$coefficients[2,1] #positive
summary(lm(Acceleration~Handling, Mario_Kart))$coefficients[2,1] #positive
summary(lm(Mini_Turbo~Traction, Mario_Kart))$coefficients[2,1] #positive
summary(lm(Acceleration~Traction, Mario_Kart))$coefficients[2,1] #positive
summary(lm(Speed~Mini_Turbo, Mario_Kart))$coefficients[2,1] #negative
summary(lm(Speed~Acceleration, Mario_Kart))$coefficients[2,1] #negative

#And the pareto optimal front only has 3-5 points, we will exclude mini_turbo from our calculations because acceleration covers all of that ground
#The idea is that any combination that finds the optimal mini_turbo will be found when finding the optimal acceleration
#We can find the pareto_optimal frontier using the step function

Mario_Kart %>% ggplot(aes(Mini_Turbo,Acceleration)) + geom_point(size = 6) + geom_step(direction="hv")

sky1 <- psel(Mario_Kart, high(Speed)*high(Acceleration))

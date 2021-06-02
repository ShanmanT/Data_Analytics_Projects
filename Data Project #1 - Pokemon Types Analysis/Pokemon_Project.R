Master <- read.csv("~/Shangeeth/Projects/Pokemon/pokemon.csv")
library(stringr)
library(tidyverse)
library(colorspace)

summary(Master) #Look for unusual values/patterns
summary(is.na(Master)) #Check the null values of the dataset to see if row should be deleted

#There are null values in Height, Weight, and %male which are not values we will use so they will just be ignored rather than delete the row or change the value

#Question 1, How many pokemon of each type?

Types <- Master[c("type1","type2")] #Reduce the large data set to the columns we care about

summary(as.factor(Types$type1))
summary(as.factor(Types$type2))
#summary(as.factor(Types$type1)) + summary(as.factor(Types$type2)) <- This doesn't work but is what we want

#Next I want to make a column for each type saying whether a pokemon has this type in column 1 or column 2
#For the for loop we need a list of types to iterate over
#We will use the unique function and double check that type1 and type2 have the same unique set of types
unique(Types$type1) 
unique(Types$type2) #There is an extra blank value in type2 which shouldn't matter for the merge

summary(is.na(Types))

for (i in c(unique(Types$type1))){
  List1 <- Types$type1 == i | Types$type2 == i #Here we say that type1 or type 2 is what we want than the pokemon has that type
  Types[,paste0(i)] <- as.numeric(List1) #Turn the logical values into numeric 0 & 1
}

Total_by_Type <- colSums(Types[,c(3:ncol(Types))]) #Creates a vector that has the total amount of pokemon as a number with each column titled by the type
sort(Total_by_Type,decreasing = TRUE) #Sorts it from largest to smallest

#Colours for the barplot that will show the sorted data as a graphical representation

PkmCol <- c("#6890F0","#A8A878","#A890F0",'#78C850',"#F85888","#A8B820","#F08030","#A040A0","#E0C068",
            "#B8A038","#C03028","#705848","#F8D030","#EE99AC","#B8B8D0","#7038F8","#705898","#98D8D8")

barplot(sort(Total_by_Type,decreasing = TRUE),ylab = "# of pokemon", xlab = "Types",col = PkmCol, main = "# of Pokemon by Type")

#######################################################################################################################################################
#Question 2, Is there a correlation between a Pokemon's type and it's Stats

summary(is.na(Master)) #No columns that we want to include have null values
Stats <- Master[c("type1","type2","attack","defense","speed","sp_attack","sp_defense","base_total")] #Reduce the large data set to the columns we care about

summary(is.na(Stats)) #double check
#Now we get the same Type Column to separate the data by type

for (i in c(unique(Stats$type1))){
  List1 <- Stats$type1 == i | Stats$type2 == i #Here we say that type1 or type 2 is what we want than the pokemon has that type
  for(j in c(1:801)){ #Across all rows, this for loop changes the True and False values to something for understandable when we plot the data
    if(List1[j] == TRUE){
    List1[j]<-paste("#",str_to_title(i),"Type")
    }
    else {
      List1[j]<-paste("Not",str_to_title(i),"Type")
    }
  }
  Stats[,paste(i)] <- List1 #Sets the vector as a column in our table
}

#Create a table of colours to apply it properly to each boxplot

PkmColTab <- data.frame(c("#6890F0","#A8A878","#A890F0",'#78C850',"#F85888","#A8B820","#F08030","#A040A0","#E0C068",
                          "#B8A038","#C03028","#705848","#F8D030","#EE99AC","#B8B8D0","#7038F8","#705898","#98D8D8"))

row.names(PkmColTab) <- c("water","normal","flying","grass","psychic","bug","fire","poison","ground","rock","fighting","dark","electric","fairy","steel","dragon","ghost","ice")

#Create boxplots comparing the associated Type to those not of the associated type
for (column in c(9:26)){
    plot(as.factor(Stats[,column]),Stats$base_total,
         xlab = paste(str_to_title(names(Stats[column])),"Type VS. Non -",str_to_title(names(Stats[column])),"Type"),
         ylab = "Base Stat Total",
         main = paste("Comparison of BST of Pokemon with the",str_to_title (names(Stats[column])),"type to Pokemon Without it"),
         col= c(PkmColTab[names(Stats[column]),1],"#FFFFFF"))
}
 
##########################################################################################################################################################
#Question 3. Can we quantify this correlation and see if it's statistically significant

table1 = data.frame(unique(Stats$type1)) #Create a table with just the type data 

#Then add the t-stat and p-value from the two-sample t-test to see if there is a statistical difference in means
for(i in c(1:18)){
  x = Stats[which(Stats[,i+8]==str_to_title(paste("#",table1[i,1],"Type"))),] #subsets the data based on the type we created in the previous section to be used as one of the samples
  table1[i,2] <- t.test(x$base_total,Stats$base_total)$p.value #Adds the p-value from the 2 sample t test for that type into that row
  table1[i,3] <- t.test(x$base_total,Stats$base_total)$statistic
  table1[i,4] <- mean(x$base_total)#Same has above except for the t stat
}

#Merges the colour table with table1 to have the p-values and the colour RGB code in the same row
colnames(table1) <- c("Types","P_Value","T_Stat","Mean")
row.names(table1) <- table1$Types
table2 <- merge(table1,PkmColTab,by = "row.names",all=TRUE)
colnames(table2) <- c("Types2","Types","P_Value","T_Stat","Mean_BST","Colours")

table2

t_stat_order <- order(-table2$T_Stat) #Create a vector of the order the T stat table from largest to smallest to see the outliers at the edges of the graphs (As we did a two-tailed t test)
P_Value_order <- order(table2$P_Value) #Same as a above but for the p-value

t_stat_Table <- table2[t_stat_order,] #Manually sort table2 by putting it in the order of the t_stat_order, a vector with numbers representing the row in table2
p_Value_Table <- table2[P_Value_order,] #Same as above for the P-Value



barplot(p_Value_Table$P_Value,names.arg = p_Value_Table$Types,col = p_Value_Table$Colours,xlab = 'Types' ,ylab = "P-Value as %", 
        main = "P-Value of 2 sample T test comparing the mean BST of \n the Individual Type of Pokemon with all Pokemon") #Plot showing the p-values of the t test against the types

barplot(t_stat_Table$Mean_BST,names.arg = t_stat_Table$Types,col = t_stat_Table$Colours, xlab = 'Types', ylab = "Base Total Stat",
        main = "Mean Base Stat Total for each Individual Type of Pokemon\nOrdered by Signed Value of T-Stat")

barplot(t_stat_Table$T_Stat,names.arg = t_stat_Table$Types,col = t_stat_Table$Colours,xlab = 'Types' ,ylab = "T-Stat", 
        main = "T-Stat of 2 sample T test comparing the mean BST of \n the Individual Type of Pokemon with all Pokemon") #Plot showing the t-stat of the t test against the types in largest to smallest order

barplot(p_Value_Table$T_Stat,names.arg = p_Value_Table$Types,col = p_Value_Table$Colours,xlab = 'Types' ,ylab = "T-Stat", 
        main = "T-Stat of 2 sample T test comparing the mean BST of the Individual Type of Pokemon \n with all Pokemon Ordered by Absolute Value of T-Stat") #Plot showing the t-stat in order of the absolute value of the t-stat so all the outliers are in one place 

qt(0.975,42) #95th percentile for a two-tailed distribution and 42 degrees of freedom is based on the smallest group size (40) with df for a 2 sample t test being n+2
#The smaller the df the larger the t-stat so we are being more conservative in our statistical test by lowering the df

#With a quantile of ~2, we are safe to say the Average BST for Steel, Dragon, Bug, Normal, Psychic, and Poison are statistically different from the total BST avaerage
#Steel, Dragon, Psychic have statistically larger BST and Bug, Normal, and Poison have statistically smaller mean BST
#Now let's see which stats for each type are statistically significant

###################################################################################################################################################################
#BONUS
#Question 4. Which stat (Attack, Defense...) for the 3 biggest outlying types are over/under performing

#double for loop for type and then for stat columns
for (column in c("steel","bug","dragon")){
  for (row in c(3:7)){
    plot(as.factor(Stats[,column]),Stats[,row],
         xlab = paste(str_to_title(names(Stats[column])),"Type VS. Non -",str_to_title(names(Stats[column])),"Type"),
         ylab = "Base Stat Total",
         main = paste("Comparison of",str_to_title(names(Stats[row])), "of Pokemon with the",str_to_title (names(Stats[column])),"type to Pokemon Without it"),
         col= c(PkmColTab[names(Stats[column]),1],"#FFFFFF"))
  }
}

#T test on the attack, defense, and so on to see if there is a significant difference

T_Stat_Table2 = data.frame()

for(i in c("steel","bug","dragon")){
  for(j in c("attack","defense","speed",'sp_attack',"sp_defense")){
    x = Stats[which(Stats[,i]==str_to_title(paste("#",i,"Type"))),]#subsets the data based on the type we created in the previous section to be used as one of the samples
    T_Stat_Table2[paste(i,"_",j),1] <- t.test(x = x[,j], y = Stats[,j])$p.value #Adds the p-value from the 2 sample t test for that type into that row
    T_Stat_Table2[paste(i,"_",j),2] <- t.test(x[,j],Stats[,j])$statistic #Same has above except for the t stat
  }
}

#Create barplot showing statistically significant stats for each type

colnames(T_Stat_Table2) <- c("P_Value","T_Stat")

Critical_T_Stat_order <- order(T_Stat_Table2$P_Value)
Critical_T_Stat_Table <- T_Stat_Table2[Critical_T_Stat_order,]

View(Critical_T_Stat_Table) #The first 8 are above the critical value of ~2 so we include only those in the graph

barplot(Critical_T_Stat_Table[1:8,1],names.arg = rownames(Critical_T_Stat_Table)[1:8],col = diverge_hcl(2,l = 100), 
        xlab = "Type and Stat Combination", ylab = "P-Value (%)", main = "Critical P-Values from T Test of\nIndividual Stat Values for Specific Types Compared to All Pokemon")
barplot(Critical_T_Stat_Table[1:8,2],names.arg = rownames(Critical_T_Stat_Table)[1:8],col = diverge_hcl(8), 
        xlab = "Type and Stat Combination", ylab = "T-Stat", main = "Critical T-Stat from T Test of\nIndividual Stat Values for Specific Types Compared to All Pokemon")

######################################################################################################################
#Question 5. Is Speed a statistically significant stat for any of the types? If so, which types?

#New Data Table with the mean speed, p-value, and t test for each corresponding type
Type_Speed = data.frame(unique(Stats$type1))

for(i in c(1:18)){
  x = Stats[which(Stats[,i+8]==str_to_title(paste("#",table1[i,1],"Type"))),] #subsets the data based on the type we created in the previous section to be used as one of the samples
  Type_Speed[i,2] <- mean(x$speed) #Adds the p-value from the 2 sample t test for that type into that row
  Type_Speed[i,3] <- t.test(x$speed,Stats$speed)$p.value #Adds the p-value from the 2 sample t test for that type into that row
  Type_Speed[i,4] <- t.test(x$speed,Stats$speed)$statistic
    }

colnames(Type_Speed) <- c("Types","Mean Speed","P_Value","T_Stat")
row.names(Type_Speed) <- Type_Speed$Types
Type_Speed <- merge(Type_Speed,PkmColTab,by = "row.names",all=TRUE)
colnames(Type_Speed) <- c("Types2","Types","Mean_Speed","P_Value","T_Stat","Colours")

#Create a vector of the order the T stat table from largest to smallest to see the outliers at the edges of the graphs (As we did a two-tailed t test)
t_stat_order2 <- order(Type_Speed$Mean_Speed) 

t_stat_order3 <- order(Type_Speed$P_Value) #Issue when running with a blank environment

Type_Speed <- Type_Speed[t_stat_order2,]

Type_Speed2 <- Type_Speed[t_stat_order3,]

Type_Speed2 #Should have 6 columns

barplot(Type_Speed$Mean_Speed,names.arg = Type_Speed$Types,col = Type_Speed$Colours,xlab = 'Types' ,ylab = "Speed Stat", 
        main = "Mean Speed Stat of Pokemon across the Types") #Plot showing the p-values of the t test against the types

barplot(Type_Speed2$T_Stat[1:7],names.arg = Type_Speed2$Types[1:7],col = Type_Speed2$Colours[1:7],xlab = 'Types' ,ylab = "T_Stat from two sample t-test", 
        main = "Critical T-Stat of 2 sample T test comparing the mean Speed of \n the Individual Type of Pokemon with all Pokemon") #Plot showing the p-values of the t test against the types

#barplot(Type_Speed2$P_Value[1:7],names.arg = Type_Speed2$Types[1:7],col = Type_Speed2$Colours[1:7],xlab = 'Types' ,ylab = "P-Value (%)", 
 #       main = "Critical P-Values of 2 sample T test comparing the mean Speed of \n the Individual Type of Pokemon with all Pokemon") #Plot showing the p-values of the t test against the types




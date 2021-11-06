#Goal is to find the 'best' character, body,  tie, glider combo
#First let's look at the data

SELECT *
FROM characters;

#We See that while there are 32 different characters, they tend to fall in the same groups, many light have the same characteristics with other lights
#I want to see the distinct groups of all the characteristics with the names taken out 

SELECT DISTINCT Class, Speed, `Speed (Water)`, `Speed (Air)`, `Speed (Ground)`, Acceleration, Weight, `Handling`, `Handling (Water)`, `Handling (Air)`, `Handling(Ground)`, Traction, `Mini Turbo`
FROM characters;

#Here we see the 32 Characters divy up into 7 unique categories of stats, which is what we will reduce them to 

CREATE TABLE characters_short SELECT distinct(CASE WHEN SPEED = 2.25 Then "Light-A"
WHEN SPEED = 2.75 THEN "Light-B"
WHEN SPEED = 3.25 THEN "Medium-A"
WHEN SPEED = 3.75 THEN "Medium-B"
WHEN SPEED = 4.25 AND Acceleration = 2.25 THEN 'Heavy-A'
WHEN SPEED = 4.25 AND Acceleration = 2 THEN 'Heavy-B'
WHEN SPEED = 4.75  THEN 'Heavy-C'
ELSE "Error" END) as Class_EXT, Speed, `Speed (Water)`, `Speed (Air)`, `Speed (Ground)`, Acceleration, Weight, `Handling`, `Handling (Water)`, `Handling (Air)`, `Handling(Ground)`, Traction, `Mini Turbo`
FROM characters;

SELECT *
FROM characters_short;
#Next we do the same to the other 3 tables:

SELECT *
from bodies;

SELECT distinct Speed, Acceleration, Weight, Handling, Traction, `Mini Turbo`
from bodies;

#Too many groups to split concisely for bodies, better to leave it as is

SELECT * 
FROM tires;

SELECT distinct Speed, `Speed (Water)`, `Speed (Air)`, `Speed (Ground)`, Acceleration, Weight, Handling, `Handling (Water)`, `Handling (Air)`, `Handling(Ground)`, Traction, `Mini Turbo`
FROM tires;

CREATE TABLE tires_short SELECT distinct(CASE WHEN Traction = -1 Then "Group-A"
WHEN Traction = -0.5 AND Weight = 0 Then "Group-B"
WHEN Traction = -0.5 AND Weight = -0.5 Then "Group-C"
WHEN Traction = -0.25 Then "Group-D"
WHEN Traction = 0 Then "Group-E"
WHEN Traction = 0.5 Then "Group-F"
WHEN Traction = 0.75 Then "Group-G"
ELSE "Error" END) as Class_EXT, Speed, `Speed (Water)`, `Speed (Air)`, `Speed (Ground)`, Acceleration, Weight, `Handling`, `Handling (Water)`, `Handling (Air)`, `Handling(Ground)`, Traction, `Mini Turbo`
FROM tires;

SELECT *
FROM tires_short;

SELECT *
FROM gliders;

SELECT DISTINCT Type, Speed, `Speed (Water)`, `Speed (Air)`, `Speed (Ground)`, Acceleration, Weight, `Handling`, `Handling (Water)`, `Handling (Air)`, `Handling(Ground)`, Traction, `Mini Turbo`
FROM gliders;

CREATE TABLE gliders_short SELECT DISTINCT Type, Speed, `Speed (Water)`, `Speed (Air)`, `Speed (Ground)`, Acceleration, Weight, `Handling`, `Handling (Water)`, `Handling (Air)`, `Handling(Ground)`, Traction, `Mini Turbo`
FROM gliders;

Select *
FROM gliders_short;

#Now we want to Cross Join all 4 tables so that we can see all the possibilities for drivers
# When we try to combine  More than 1 table without adjustments we run into an issue of duplicate column names, so we should combine the columns as we go 

CREATE table combined SELECT Characters, Vehicle, tires, Glider, A.Speed+B.Speed as Speed, A.Speed+ B.Speed_water as Speed_Water, 
			round(A.Speed+ B.Speed_Air, 2) as Speed_Air, round(A.Speed + B.Speed_Ground,2) as Speed_Ground, 
			A.Acceleration+B.Acceleration as Acceleration, A.Weight + B.Weight as Weight, A.Handling+B.Handling as Handling, 
			A.Handling + B.Handling_Water as Handling_Water, A.Handling + B.Handling_Air  as Handling_Air, 
			A.Handling+B.Handling_Ground as Handling_Ground, A.Traction + B.Traction as Traction, A.`Mini Turbo` + B.Mini_Turbo as Mini_Turbo
FROM(
		SELECT Characters, Glider, Class_EXT as Tires, A.Speed+B.Speed as Speed, A.`Speed (Water)`+ B.Speed_water as Speed_Water, 
			round(A.`Speed (Air)`+ B.Speed_Air, 2) as Speed_Air, round(A.`Speed (Ground)` + B.Speed_Ground,2) as Speed_Ground, 
			A.Acceleration+B.Acceleration as Acceleration, A.Weight + B.Weight as Weight, A.Handling+B.Handling as Handling, 
			A.`Handling (Water)` + B.Handling_Water as Handling_Water, A.`Handling (Air)` + B.Handling_Air  as Handling_Air, 
			A.`Handling(Ground)`+B.Handling_Ground as Handling_Ground, A.Traction + B.Traction as Traction, A.`Mini Turbo` + B.Mini_Turbo as Mini_Turbo
		FROM(
			SELECT Class_EXT as Characters, B.Type as Glider, A.Speed+B.Speed as Speed, A.`Speed (Water)`+ B.`Speed (water)` as Speed_Water, 
				A.`Speed (Air)`+ B.`Speed (Air)` as Speed_Air, A.`Speed (Ground)` + B.`Speed (Ground)` as Speed_Ground, 
				A.Acceleration+B.Acceleration as Acceleration, A.Weight + B.Weight as Weight, A.Handling+B.Handling as Handling, 
				A.`Handling (Water)` + B.`Handling (Water)` as Handling_Water, A.`Handling (Air)` + B.`Handling (Air)`  as Handling_Air, 
				A.`Handling(Ground)`+B.`Handling(Ground)` as Handling_Ground, A.Traction + B.Traction as Traction, A.`Mini Turbo` + B.`Mini Turbo` as Mini_Turbo
			FROM characters_short AS A
			CROSS JOIN gliders_short AS B) as B
		CROSS JOIN tires_short AS A) as B
CROSS JOIN bodies AS A;

SELECT *
from combined;

#Now we have a combined table of all combinations ready at our disposal, Now it's time to find the best kart

ALTER TABLE combined
ADD ID VARCHAR (255);

UPDATE combined
SET ID = concat(Characters,"-", Vehicle, "-", tires, "-", Glider);

ALTER TABLE combined Modify COlumn ID varchar(255) AFTER Glider;

SELECT *
FROM combined;

CREATE table combined_reduct AS
SELECT *
FROM combined;

ALTER TABLE combined_reduct
DROP Column Glider,
DROP Column Vehicle,
DROP Column Characters, 
DROP Column Tires;

SELECT *
FROM combined_reduct
ORDER BY SPEED DESC
LIMIT 10;

SELECT *
FROM combined_reduct
ORDER BY SPEED DESC
LIMIT 10;

SELECT *
FROM combined_reduct
ORDER BY Acceleration DESC
LIMIT 10;

#Those with high speed have low acceleration, and those with high accelereation have low speed, time to take this to R to see what the pareto frontier would look like
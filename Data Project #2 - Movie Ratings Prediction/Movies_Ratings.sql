LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IMDb movies.csv'
INTO TABLE movies
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*)
FROM movies
WHERE genre LIKE "%Sport%";
# Matches Genre_count numbers

ALTER TABLE movies
ADD column Drama binary;

# Create 9 variables that are binary with true being whether the column genre contains the following words "Drama"     "Comedy"    "Romance"   "Action"    "Thriller" "Crime"     "Horror"    "Adventure" "Mystery"  

CREATE TABLE Genres_Table SELECT imdb_title_id, genre, 
(CASE WHEN genre like "%Drama%" Then 1 ELSE "0" END) as Drama, 
(CASE WHEN genre like "%Comedy%" Then 1 ELSE "0" END) as Comedy, 
(CASE WHEN genre like "%Romance%" Then 1 ELSE "0" END) as Romance, 
(CASE WHEN genre like "%Action%" Then 1 ELSE "0" END) as Action1, 
(CASE WHEN genre like "%Thriller%" Then 1 ELSE "0" END) as Thriller, 
(CASE WHEN genre like "%Crime%" Then 1 ELSE "0" END) as Crime, 
(CASE WHEN genre like "%Horror%" Then 1 ELSE "0" END) as Horror, 
(CASE WHEN genre like "%Adventure%" Then 1 ELSE "0" END) as Adventure,
(CASE WHEN genre like "%Mystery%" Then 1 ELSE "0" END) as Mystery
FROM movies;

DROP TABLE Genres_Table;

Select SUM(Drama), SUM(Comedy),SUM(Romance),SUM(Action1),SUM(Thriller),SUM(Crime),SUM(Horror),SUM(Adventure),SUM(Mystery)
From Genres_Table;

#This should match the numbers we got in R which they do
#For example to find a movie with drama and comedy and some other genre that is specified the query is:

SELECT imdb_title_id, genre
FROM Genres_Table
WHERE Drama = 1 AND Comedy = 1
ORDER BY Romance, Action1, Thriller, Crime, Horror, Adventure, Mystery;

#And then for the first 5 titles of the query use the movies table

SELECT imdb_title_id, title, language
FROM movies
WHERE imdb_title_id IN ('tt2437648','tt6343058','tt2447934','tt2448912','tt2451550');

#Now we export this table back into R to do multiple regression



----------------------------------------------------------------------------------
-- Exploratory Data Analysis of fortune500.csv
------------------------------------------------------------------------------
CREATE TABLE fortune500(YEAR INTEGER);

WbImport  - file = C:/fortune500.csv
          - table = fortune500;
-- Question #1 - What is the Avg Revenue per year for these companies

SELECT year, AVG(Revenue) as avg_rev, count(year)
FROM 

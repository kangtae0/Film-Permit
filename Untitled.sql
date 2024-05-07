SELECT * 
FROM film.film_permits;

ALTER TABLE film_permits
DROP COLUMN `ZipCode(s)`;

ALTER TABLE film_permits
DROP COLUMN `CommunityBoard(s)`;

ALTER TABLE film_permits
DROP COLUMN `PolicePrecinct(s)`;

SET SQL_SAFE_UPDATES = 0;

SELECT DISTINCT Country, COUNT(*)
FROM film.film_permits
GROUP BY Country;

SELECT *
FROM film.film_permits
WHERE Country='Netherlands';
#There is only 3 countries 

#Since it is all USA
ALTER TABLE film_permits
DROP COLUMN `Country`;

SELECT DISTINCT EventAgency, COUNT(*)
FROM film.film_permits
GROUP BY EventAgency;
#Since every Event Agency is Mayor's Office of Film, Theatre & Broadcasting erase it

ALTER TABLE film_permits
DROP COLUMN `EventAgency`;

SELECT STR_TO_DATE(StartDateTime, '%m/%d/%Y') FROM film.film_permits;
SELECT STR_TO_DATE(EndDateTime, '%m/%d/%Y') FROM film.film_permits;
SELECT STR_TO_DATE(EnteredOn, '%m/%d/%Y') FROM film.film_permits;


SELECT SUBSTRING(StartDateTime, 1, 10) AS StartDate
FROM film.film_permits;

SELECT SUBSTRING(EndDateTime, 1, 10) AS EndDate
FROM film.film_permits;

SELECT SUBSTRING(EnteredOn, 1, 10) AS EnteredOn
FROM film.film_permits;

UPDATE film.film_permits
SET StartDateTime=(SELECT SUBSTRING(StartDateTime, 1, 10));
ALTER TABLE film.film_permits CHANGE StartDateTime StartDate VARCHAR(10);

UPDATE film.film_permits
SET EndDateTime=(SELECT SUBSTRING(EndDateTime, 1, 10));
ALTER TABLE film.film_permits CHANGE EndDateTime EndDate VARCHAR(10);

UPDATE film.film_permits
SET EnteredOn=(SELECT SUBSTRING(EnteredOn, 1, 10));

UPDATE film.film_permits
SET StartDate= STR_TO_DATE(StartDate, '%m/%d/%Y');

UPDATE film.film_permits
SET EndDate= STR_TO_DATE(EndDate, '%Y-%m-%d');

UPDATE film.film_permits
SET EnteredOn = STR_TO_DATE(EnteredOn, '%Y-%m-%d');


#Ordering and changing the Event ID By the order of EnteredOn
SELECT *, ROW_NUMBER() OVER(ORDER BY EnteredOn)
FROM film.film_permits;

WITH NumberedRows AS (
    SELECT EventID, ROW_NUMBER() OVER(ORDER BY EnteredOn) AS RowNum
    FROM film.film_permits
)
UPDATE film.film_permits
INNER JOIN NumberedRows 
ON film.film_permits.EventID = NumberedRows.EventID
SET film.film_permits.EventID = NumberedRows.RowNum;


SELECT *
FROM film.film_permits
ORDER BY EventID;

SELECT DISTINCT(EnteredOn), COUNT(*)
FROM film.film_permits
GROUP BY EnteredOn;

SELECT DISTINCT(SUBSTRING(EnteredOn,1,2)) AS Month, COUNT(*) AS Number_Of_Films
FROM film.film_permits
GROUP BY SUBSTRING(EnteredOn,1,2)
ORDER BY Month;


SELECT EventType,COUNT(*)
FROM film.film_permits
GROUP BY EventType;

SELECT Borough,Category,COUNT(*) AS Count_By_category
FROM film.film_permits
GROUP BY Borough, Category;

SELECT Borough,Category, SubCategoryName, COUNT(*) AS Count_By_category
FROM film.film_permits
GROUP BY Borough, Category, SubCategoryName;

SELECT EventType,Category, SubCategoryName, COUNT(*)
FROM film.film_permits
GROUP BY EventType,Category, SubCategoryName;

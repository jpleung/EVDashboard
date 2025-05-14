-- Use the proper schema
USE EVPopulation;

-- Change column names to use "_" instead of " "
ALTER TABLE evpopulation
RENAME COLUMN `VIN (1-10)` TO VIN;

ALTER TABLE evpopulation
RENAME COLUMN `Postal Code` TO Postal_Code;

ALTER TABLE evpopulation
RENAME COLUMN `Model Year` TO Model_Year;

ALTER TABLE evpopulation
RENAME COLUMN `Electric Vehicle Type` TO EV_Type;

ALTER TABLE evpopulation
RENAME COLUMN `Clean Alternative Fuel Vehicle (CAFV) Eligibility` TO CAFV_Eligibility;

ALTER TABLE evpopulation
RENAME COLUMN `Electric Range` TO Electric_Range;

ALTER TABLE evpopulation
RENAME COLUMN `Base MSRP` TO Base_MSRP;

ALTER TABLE evpopulation
RENAME COLUMN `Legislative District` TO Legislative_District;

ALTER TABLE evpopulation
RENAME COLUMN `DOL Vehicle ID` TO DOL_Vehicle_ID;

ALTER TABLE evpopulation
RENAME COLUMN `Vehicle Location` TO Vehicle_Location;

ALTER TABLE evpopulation
RENAME COLUMN `Electric Utility` TO Electric_Utility;

ALTER TABLE evpopulation
RENAME COLUMN `2020 Census Tract` TO 2020_Census_Tract;

-- Add a location column to have city state and postal code information in one column
ALTER TABLE evpopulation
ADD COLUMN Location_Full text;
UPDATE evpopulation
SET location_full = CONCAT(city, ' ', state, ' ', postal_code);

-- We will use this dataset to answer "How has the adoption of electric veheicles changed over time?"
SELECT *
FROM evpopulation;

SELECT make, COUNT(*)
FROM evpopulation
GROUP BY make
ORDER BY 2 DESC;

SELECT cafv_eligibility, COUNT(*) / (SELECT COUNT(*) FROM evpopulation)
FROM evpopulation
GROUP BY 1
ORDER BY 2 DESC;

SELECT electric_range, COUNT(*)
FROM evpopulation
GROUP BY 1
ORDER BY 2 DESC;

SELECT ev_type, COUNT(*)
FROM evpopulation
GROUP BY 1;

SELECT state, COUNT(*)
FROM evpopulation
GROUP BY 1
ORDER BY 2 DESC;

SELECT model_year, COUNT(*)
FROM evpopulation
GROUP BY model_year
ORDER BY model_year;

SELECT ev_type, cafv_eligibility, COUNT(*)
FROM evpopulation
GROUP BY 1, 2
ORDER BY 1;

SELECT cafv_eligibility, avg(electric_range)
FROM evpopulation
GROUP BY 1;

SELECT ev_type, avg(electric_range)
FROM evpopulation
GROUP BY 1;

SELECT model_year, ev_type, avg(electric_range)
FROM evpopulation
WHERE cafv_eligibility = 'Clean Alternative Fuel Vehicle Eligible' AND electric_range != 0
GROUP BY 1, 2
ORDER BY 1;

SELECT base_msrp, COUNT(*)
FROM evpopulation
GROUP BY 1 
ORDER BY 2 DESC;

SELECT ev_type, avg(base_msrp), max(base_msrp), min(base_msrp)
FROM evpopulation
WHERE base_msrp != 0
GROUP BY 1;

SELECT *
FROM evpopulation
HAVING base_msrp = 845000;

SELECT county, COUNT(*)
FROM evpopulation
GROUP BY county;

SELECT location_full, COUNT(*)
FROM evpopulation
GROUP BY location_full;

SELECT model_year, AVG(electric_range)
FROM evpopulation
WHERE electric_range != 0
GROUP BY model_year
ORDER BY model_year;

SELECT model_year, ev_type, AVG(electric_range)
FROM evpopulation
WHERE electric_range != 0
GROUP BY model_year, ev_type
ORDER BY model_year;

SELECT model_year, make, ev_type, COUNT(*)
FROM evpopulation
GROUP BY model_year, make, ev_type
ORDER BY model_year;

SELECT model_year, ev_type, cafv_eligibility, COUNT(*)
FROM evpopulation
GROUP BY 1, 2, 3
ORDER BY 1;

SELECT model_year, ev_type, cafv_eligibility, COUNT(*)
FROM evpopulation
WHERE cafv_eligibility != 'Eligibility unknown as battery range has not been researched'
GROUP BY 1, 2, 3
ORDER BY 1;

SELECT model_year, ev_type, location_full, COUNT(*)
FROM evpopulation
GROUP BY 1, 2, 3
ORDER BY 1;

SELECT model_year, ev_type, AVG(base_msrp)
FROM evpopulation
WHERE base_msrp != 0
GROUP BY model_year, ev_type
ORDER BY model_year;

-- Create views for visualisations
CREATE VIEW ev_count_year AS (
SELECT model_year, make, ev_type, COUNT(*) AS number_of_cars
FROM evpopulation
GROUP BY model_year, make, ev_type
ORDER BY model_year);

CREATE VIEW ev_location AS (
SELECT model_year, ev_type, location_full, COUNT(*) AS number_of_cars
FROM evpopulation
GROUP BY 1, 2, 3
ORDER BY 1);

CREATE VIEW ev_avg_range AS (
SELECT model_year, ev_type, AVG(electric_range) AS average_range
FROM evpopulation
WHERE electric_range != 0
GROUP BY model_year, ev_type
ORDER BY model_year);

CREATE VIEW ev_msrp AS (
SELECT model_year, ev_type, AVG(base_msrp) AS base_msrp_average
FROM evpopulation
WHERE base_msrp != 0
GROUP BY model_year, ev_type
ORDER BY model_year);

CREATE VIEW ev_eligibility AS (
SELECT model_year, ev_type, cafv_eligibility, COUNT(*) AS eligible_cars
FROM evpopulation
GROUP BY 1, 2, 3
ORDER BY 1);

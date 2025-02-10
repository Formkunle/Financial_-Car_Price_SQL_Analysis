SELECT COUNT(*) AS Total
FROM car_price

--1. Data Cleaning & Preparation

-- Checking and Removing Rows with Missing Essential Data
  SELECT COUNT(*) AS empty_row_count
FROM car_price
WHERE ("Salesdate" IS NULL);

SELECT COUNT(*) AS empty_row_count
FROM car_price
WHERE (mmr IS NULL);

SELECT COUNT(*) AS empty_row_count
FROM car_price
WHERE (make IS NULL);

SELECT COUNT(*) AS empty_row_count
FROM car_price
WHERE (model IS NULL);

DELETE FROM car_price
WHERE ("Salesdate" IS NULL);

DELETE FROM car_price
WHERE (color IS NULL);

SELECT COUNT(*) AS empty_row_count
FROM car_price
WHERE (sellingprice IS NULL);

--Checking and Removing of Duplicate 

SELECT vin, make, model, COUNT(*) AS duplicate_count
FROM car_price
GROUP BY vin, make, model
HAVING COUNT(*) > 1;

CREATE TABLE car_price_deduplicated AS
SELECT DISTINCT ON (vin) * FROM car_price
ORDER BY vin;

ALTER TABLE car_price_cleaned
RENAME COLUMN "Salesdate" TO saledate;

-- Change and saving the table name after cleaning as csv
DROP TABLE car_price;
ALTER TABLE car_price_deduplicated RENAME TO car_price_cleaned;

COPY car_price_cleaned TO 'C:\tmp\car_price_cleaned.csv' WITH CSV HEADER;


-- 2. Sales and Market Trends Analysis
--Total Number of car sold
SELECT COUNT(*) AS Total_sale
FROM car_price_cleaned;

--Total Sales Per Year
SELECT EXTRACT(YEAR FROM saledate) AS year, COUNT(*) AS Total_sales_per_Year
FROM car_price_cleaned
GROUP BY EXTRACT(YEAR FROM saledate)
ORDER BY year;

--Most Profitable Year
SELECT EXTRACT(YEAR FROM saledate) AS year, ROUND(AVG(sellingprice), 2) AS Average_Sellingprice
FROM car_price_cleaned
GROUP BY EXTRACT(YEAR FROM saledate)
ORDER BY year DESC;

-- Most Sold Car Brands
SELECT make, COUNT(*) AS most_sold_brands
FROM car_price_cleaned
GROUP BY make
ORDER BY most_sold_brands DESC
LIMIT 10;

--Most Profitable Car Brands
SELECT make, ROUND(AVG(sellingprice), 2) AS most_profitable_car_brands
FROM car_price_cleaned
GROUP BY make
ORDER BY most_profitable_car_brands DESC
LIMIT 10;


-- Most Sold Car Model
SELECT model, COUNT(*) AS most_sold_model
FROM car_price_cleaned
GROUP BY model
ORDER BY most_sold_model DESC
LIMIT 10;

--Most Profitable Car Models
SELECT model, ROUND(AVG(sellingprice), 2) AS most_profitable_car_model
FROM car_price_cleaned
GROUP BY model
ORDER BY most_profitable_car_model DESC
LIMIT 10;

-- 3. Pricing & Valuation Insights

-- Average Selling Price by Car Condition
SELECT condition, ROUND(AVG(sellingprice), 2) AS Average_Sellinprice
FROM car_price_cleaned
GROUP BY condition
ORDER BY condition DESC
LIMIT 10;

-- Check for the Impact of Mileage on Price
SELECT
	CASE
		WHEN odometer < 20000 THEN '0 - 20k miles'
		WHEN odometer BETWEEN 20000 AND 50000 THEN '20k - 50k miles'
		WHEN odometer BETWEEN 50000 AND 100000 THEN '50k - 100k miles'
		ELSE '100k+ miles'
		END AS mileage_range, ROUND(AVG(sellingprice), 2) AS Average_price
FROM car_price_cleaned
GROUP BY mileage_range
ORDER BY Average_price DESC;

-- Comparing Selling Price vs. MMR (Market Value)
SELECT make,model, ROUND(AVG(sellingprice),2) AS Average_Sellingprice, ROUND(AVG(mmr),2) AS Average_marketvalue,
ROUND(AVG(sellingprice) - AVG(mmr),2) AS price_difference
FROM car_price_cleaned
GROUP BY make,model
ORDER BY price_difference DESC
LIMIT 10;

-- 4. Regional & Dealer Performance
-- Top 5 States with Highest Sales
SELECT state, COUNT(*) AS total_sales
FROM car_price_cleaned
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;

-- Top Selling Dealers
SELECT seller, COUNT(*) AS total_sales, ROUND(AVG(sellingprice), 2) AS Average_sellingprice
FROM car_price_cleaned
GROUP BY seller
ORDER BY total_sales DESC
LIMIT 10;

-- 5. Time Series & Seasonal Trends
-- Sales Trend Over Time
SELECT EXTRACT(MONTH FROM saledate::DATE) AS month, COUNT(*) AS sales_count
FROM car_price_cleaned
GROUP BY EXTRACT(MONTH FROM saledate::DATE)
ORDER BY month;

--THANKS--


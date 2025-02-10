# Financial_-Car_Price_SQL_Analysis
# Introduction
The automotive industry relies heavily on data to track vehicle sales, pricing trends, and market demand. This project aims to analyze a dataset containing vehicle sales information, including details such as the year, make, model, trim, body type, transmission, VIN, state, condition, odometer reading, color, interior features, seller, market value (MMR), selling price, and sales date. By leveraging this data, we seek to uncover insights that can assist in pricing strategy, demand forecasting, and market trends analysis.
# Exploration of the Dataset
The dataset contains vehicle-related information, including details about their specifications, conditions, and sales transactions. The dataset comprises the following key columns:
1.	Year – The manufacturing year of the vehicle.
2.	Make – The brand or manufacturer of the vehicle (e.g., Toyota, Honda).
3.	Model – The specific model of the vehicle (e.g., Camry, Civic).
4.	Trim – The version or sub-model of the vehicle with different features.
5.	Body – The body type of the vehicle (e.g., Sedan, SUV, Truck).
6.	Transmission – The type of transmission system (e.g., Automatic, Manual).
7.	VIN (Vehicle Identification Number) – A unique identifier assigned to each vehicle.
8.	State – The location where the vehicle was sold or registered.
9.	Condition – The state of the vehicle at the time of sale (e.g., new, used, damaged).
10.	Odometer – The mileage of the vehicle, indicating how much it has been driven.
11.	Color – The exterior color of the vehicle.
12.	Interior – The color or material of the vehicle’s interior.
13.	Seller – The individual or organization that sold the vehicle.
14.	MMR (Manheim Market Report) – A market value estimate for the vehicle based on auction data.
15.	Selling Price – The final price at which the vehicle was sold.
16.	Sales Date – The date when the vehicle transaction took place.
# Initial Observations
•	The dataset provides insights into vehicle sales patterns, pricing trends, and vehicle conditions.
•	Some columns, such as VIN and seller, may contain unique values, making them useful for tracking individual transactions.
•	The sales date column enables time-series analysis, allowing us to examine trends in vehicle sales over time.
•	The odometer and condition fields help determine how mileage and vehicle condition influence pricing.
•	The MMR and selling price fields can be used to compare expected market value vs. actual selling price.
# Objectives
The primary objectives of this project include:
1.	Data Cleaning & Preparation: Ensure the dataset is structured, complete, and free from inconsistencies.
2.	Price Analysis: Determine how various factors influence car prices and market values.
3.	Demand Insights: Identify the most popular car makes, models, and trims based on sales trends.
4.	Condition vs. Pricing: Assess the impact of car condition and mileage on pricing.
5.	Market Trends: Analyze regional sales patterns to understand geographic demand variations.
6.	Predictive Modeling (Optional): Use statistical models or machine learning to predict car prices based on historical data.

SELECT COUNT(*) AS Total
FROM car_price

#1. Data Cleaning & Preparation
-	Checking and Removing Rows with Missing Essential Data
  ```
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

-	Checking and Removing of Duplicate 
```
SELECT vin, make, model, COUNT(*) AS duplicate_count
FROM car_price
GROUP BY vin, make, model
HAVING COUNT(*) > 1;

CREATE TABLE car_price_deduplicated AS
SELECT DISTINCT ON (vin) * FROM car_price
ORDER BY vin;

ALTER TABLE car_price_cleaned
RENAME COLUMN "Salesdate" TO saledate;

-	 Change and saving the table name after cleaning as csv
DROP TABLE car_price;
ALTER TABLE car_price_deduplicated RENAME TO car_price_cleaned;

COPY car_price_cleaned TO 'C:\tmp\car_price_cleaned.csv' WITH CSV HEADER;

## Sales and Market Trends Analysis
-	Total Number of car sold
```
SELECT COUNT(*) AS Total_sale
FROM car_price_cleaned;
```
"total_sale"
    331347
## Interpretation of "Total Sale: 331,347"
-	This means that 331,347 vehicles were sold based on the available data.

# Total Sales Per Year
```
SELECT EXTRACT(YEAR FROM saledate) AS year, COUNT(*) AS Total_sales_per_Year
FROM car_price_cleaned
GROUP BY EXTRACT(YEAR FROM saledate)
ORDER BY year;

"year"	"total_sales_per_year"
2014	36253
2015	295094
```
# Interpretation of Total Sales Per Year
Your dataset shows the total number of vehicle sales recorded for each year:
-	2014 → 36,253 vehicles sold
-	2015 → 295,094 vehicles sold
# Key Insights:
1.	Significant Growth (2014 to 2015):
-	Sales increased from 36,253 in 2014 to 295,094 in 2015.
-	This is an increase of +258,841 sales, which is about 714% growth.
2.	Possible Reasons for the Growth:
-	More vehicles entered the market.
-	Higher demand for used or new cars.

# Most Profitable Year
```
SELECT EXTRACT(YEAR FROM saledate) AS year, AVG(sellingprice) AS Average_Sellingprice
FROM car_price_cleaned
GROUP BY EXTRACT(YEAR FROM saledate)
ORDER BY year DESC;
"year"	"average_sellingprice"
2015	13826.21
2014	12706.11
```
This data represents the average selling price of a product for the years 2014 and 2015. 
-	Price Increase: The average selling price increased from ₦12,706.11 in 2014 to ₦13,826.21 in 2015.
# Most Sold Car Brands
```
SELECT make, COUNT(*) AS most_sold_brands
FROM car_price_cleaned
GROUP BY make
ORDER BY most_sold_brands DESC
LIMIT 10;
"make"		"most_sold_brands"
"Ford"		56321
"Chevrolet"	37861
"Nissan"	30154
"Toyota"	24512
"Dodge"	18821
"Honda"	18116
"Hyundai"	13087
"BMW"		12740
"Kia"		11381
"Chrysler"	10378
```
# Interpretation
1.	Ford is the most sold brand with 56,321 units, indicating it has a strong market presence.
2.	Chevrolet follows with 37,861 units, showing it is also a popular choice.
3.	Nissan, Toyota, and Dodge round out the top five, reflecting their strong consumer demand.
4.	Honda and Hyundai, known for affordability and reliability, are in the mid-range.
5.	Luxury brands like BMW still make the top 10 but have fewer sales compared to mass-market brands.
6.	Chrysler, at 10,378 units, closes the top 10 list, suggesting a smaller but still significant market share.
# Possible Insights & Business Implications
-	Ford and Chevrolet dominate the used car market, possibly due to affordability and availability.
-	Toyota and Honda, known for reliability, continue to have strong sales, likely maintaining good resale value.
-	Luxury brands like BMW rank lower, as they cater to a more niche audience.
-	If you're in the car-selling business, focusing on these top brands might lead to higher sales and profits.

# Most Profitable Car Brands
```
SELECT make, ROUND(AVG(sellingprice), 2) AS most_profitable_car_brands
FROM car_price_cleaned
GROUP BY make
ORDER BY most_profitable_car_brands DESC
LIMIT 10;
"make"		"most_profitable_car_brands"
"Rolls-Royce"	155253.85
"Ferrari"	131250.00
"Lamborghini"	111500.00
"Bentley"	73412.79
"Tesla"		69200.00
"Aston Martin"	56823.53
"Fisker"		45900.00
"Maserati"	45043.21
"Lotus"		40800.00
"Porsche"	38618.50
```
# Interpretation
1.	Luxury cars are the most expensive.
-	Rolls-Royce is the most profitable, with each car selling for an average of $155,253.85.
-	Other high-end brands like Ferrari, Lamborghini, and Bentley also sell at very high prices.
2.	Tesla is the only electric car brand in the top 5.
-	Tesla cars sell for an average of $69,200, showing that electric vehicles are expensive but profitable.
3.	Luxury brands don’t sell as many cars as brands like Ford or Toyota, but they make more money per sale.
# Business Insight:
-	Expensive cars bring in more profit per sale, but fewer people buy them.
-	Regular brands (like Ford or Toyota) sell more cars, but at lower prices.
-	If you want to make money in the car business, you can sell many affordable cars or focus on a few high-end ones.

# Most Sold Car Model
```
SELECT model, COUNT(*) AS most_sold_model
FROM car_price_cleaned
GROUP BY model
ORDER BY most_sold_model DESC
LIMIT 10;
"model"	"most_sold_model"
"Altima"	11009
"Fusion"	8508
"F-150"		8260
"Camry"	7746
"Escape"	7440
"Focus"		6634
"Accord"	6259
"Impala"	5244
"3 Series"	5185
"Civic"		5154
```
# Interpretation
1.	Nissan Altima is the most sold model with 11,009 units, meaning it's a very popular choice.
2.	Ford Fusion, F-150, and Toyota Camry are also among the top-selling models.
3.	Sedans like Altima, Camry, Accord, and Civic are very popular, likely because they are reliable and fuel-efficient.
4.	The Ford F-150 (a truck) ranks high, showing that pickup trucks are also in demand.
5.	Luxury cars like the BMW 3 Series made it to the list, but they sell in lower numbers compared to mass-market brands.
# Business Insight:
-	People prefer affordable, fuel-efficient, and reliable cars like the Altima, Camry, and Accord.
-	Pickup trucks like the F-150 are also in demand, possibly for business and personal use.
-	Luxury cars (BMW 3 Series) sell well, but not as much as everyday sedans.

# Most Profitable Car Models
SELECT model, ROUND(AVG(sellingprice), 2) AS most_profitable_car_model
FROM car_price_cleaned
GROUP BY model
ORDER BY most_profitable_car_model DESC
LIMIT 10;
```
"model"			"most_profitable_car_model"
"458 Italia"			183000.00
"SLS AMG GT"			156500.00
"i8"				156187.50
"Ghost"				155253.85
"California"			134363.64
"SLS AMG"			  116016.67
"Gallardo"			111500.00
"Continental GTC Speed"	111000.00
"Continental Flying Spur Speed"	105750.00
"RS 7"				102142.86
```
# Introduction
1.	Ferrari 458 Italia is the most profitable, selling for an average of $183,000 per car.
2.	Luxury and sports cars dominate the list, including models from Ferrari, Rolls-Royce, Bentley, and Lamborghini.
3.	The Rolls-Royce Ghost sells for $155,253.85, showing how high-end luxury cars generate massive revenue.
4.	BMW i8, Audi RS 7, and Mercedes-Benz SLS AMG GT are also among the most expensive models.
5.	These cars are rare and expensive, meaning they don’t sell in high numbers, but each sale brings in huge profit.
# Business Insight:
-	Luxury and sports cars bring in the most money per sale, but they don’t sell as many units as regular cars.
-	People are willing to pay premium prices for performance and luxury.
-	If you sell high-end cars, even a few sales can generate big profits.

#  3. Pricing & Valuation Insights
# Average Selling Price by Car Condition
```
SELECT condition, ROUND(AVG(sellingprice), 2) AS Average_Sellinprice
FROM car_price_cleaned
GROUP BY condition
ORDER BY condition DESC
LIMIT 10;
"condition"	"average_sellinprice"
49		22763.46
48		21438.80
47		21147.47
46		20533.14
45		20010.21
44		19231.30
43		18473.63
42		17924.69
41		17275.83
39		15925.48
```
# Interpretation
1.	Cars in better condition sell for higher prices.
-	A car with condition 49 sells for an average of $22,763.46, while a car with condition 39 sells for only $15,925.48.
2.	Prices gradually decrease as the condition drops.
-	This suggests that buyers are willing to pay more for cars in top condition and less for older or more worn-out cars.
3.	The price difference between condition 49 and 39 is about $7,000, showing that condition has a big impact on value.
# Business Insight:
-	Better-conditioned cars sell for more money.
-	If you’re selling cars, keeping them in top shape (repairs, detailing) can increase selling prices.
-	Buyers looking for budget-friendly options might go for lower-condition cars.

# Check for the Impact of Mileage on Price
```
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
"mileage_range"	"average_price"
"0 - 20k miles"		21479.31
"20k - 50k miles"	17736.93
"50k - 100k miles"	11712.75
"100k+ miles"		5094.63
```
# Introduction
1.	Lower mileage = Higher price
-	Cars with 0 - 20k miles sell for the highest average price ($21,479.31).
-	Cars with 100k+ miles are the cheapest, averaging only $5,094.63.
2.	Big price drop as mileage increases
-	A car with 50k - 100k miles is worth about $11,712.75, which is nearly half the price of a car with 20k - 50k miles.
-	100k+ mile cars lose value fast, dropping to less than $5,100.
3.	Why does this happen?
-	Higher mileage cars have more wear and tear, so they are less valuable.
-	Buyers prefer lower-mileage cars because they last longer and require fewer repairs.
# Business Insight:
-	If you’re selling a car, lower mileage will get you a much better price.
-	Buyers looking for affordability may choose higher-mileage cars, but they might need more repairs.
-	Investing in lower-mileage used cars might be more profitable for resale.

# Comparing Selling Price vs. MMR (Market Value)
```
SELECT make,model, ROUND(AVG(sellingprice),2) AS Average_Sellingprice, ROUND(AVG(mmr),2) AS Average_marketvalue,
ROUND(AVG(sellingprice) - AVG(mmr),2) AS price_difference
FROM car_price_cleaned
GROUP BY make,model
ORDER BY price_difference DESC
LIMIT 10;
"make"		"model"	"average_sellingprice"	"average_marketvalue"	"price_difference"
"Aston Martin"	"Rapide"			98750.00	90500.00	8250.00
"Cadillac"	"CTS-V Wagon"			50500.00	42300.00	8200.00
"Mercury"	"Marauder"			9900.00	6441.67	3458.33
"Maserati"	"Spyder"			17800.00	14500.00	3300.00
"BMW"		"ActiveHybrid 7"		41790.91	38527.27	3263.64
"HUMMER"	"H3T"				20337.50	17362.50	2975.00
"BMW"		"ActiveHybrid 5"		27625.00	24800.00	2825.00
"Aston Martin"	"DB9"				47800.00	45140.00	2660.00
"HUMMER"	"H1"				45750.00	43400.00	2350.00
"Bentley"	"Continental GTC Speed"	111000.00	109000.00	2000.00
```
# Interpretation
1.	Some cars sell for much more than their market value.
-	Aston Martin Rapide has the highest price difference ($8,250), meaning sellers are getting more than expected.
-	Cadillac CTS-V Wagon also sells for $8,200 above market value.
2.	Luxury and rare models hold their value well.
-	Brands like Aston Martin, Maserati, BMW, and Bentley have smaller price gaps, meaning they sell close to market value.
-	Bentley Continental GTC Speed has only a $2,000 difference, showing it’s priced very close to its actual worth.
3.	Some cars have a surprisingly high resale value.
-	Mercury Marauder sells for $3,458.33 above market value, despite being an older model.
-	Hummer H3T and H1 also sell for more than market value, showing strong demand for rugged vehicles.
# Business Insight:
-	Luxury and rare cars can sell above market value, making them good investments.
-	Certain cars (like the Aston Martin Rapide and Cadillac CTS-V Wagon) bring in the most extra profit.
-	If you’re buying, knowing the market value helps avoid overpaying.
-	If you’re selling, targeting high-demand models can get you a better price.

# 4. Regional & Dealer Performance
# Top 5 States with Highest Sales
```
SELECT state, COUNT(*) AS total_sales
FROM car_price_cleaned
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;
"state"	"total_sales"
"fl"	49547
"ca"	48534
"tx"	29057
"ga"	21091
"pa"	16846
"nj"	16012
"il"	15476
"oh"	14418
"tn"	14107
"nc"	11438
```
# Interpretation
1.	Florida (FL) has the highest car sales with 49,547 units sold, followed closely by California (CA) with 48,534.
2.	Texas (TX) is third with 29,057 sales, showing a strong market but lower than FL and CA.
3.	Georgia (GA), Pennsylvania (PA), and New Jersey (NJ) follow, indicating that car sales are also strong in these states.
4.	North Carolina (NC) has the lowest sales in this top 10 list with 11,438 units.
# Business Insight:
-	Florida and California are the biggest car markets, meaning they have the highest demand.
-	Texas is also a strong market, likely due to its large population and preference for trucks and SUVs.
-	If you’re selling cars, targeting states with high sales can bring more business opportunities.
-	States with lower sales (like NC and TN) might have less competition, offering a different kind of opportunity.

# Top Selling Dealers
```
SELECT seller, COUNT(*) AS total_sales, ROUND(AVG(sellingprice), 2) AS Average_sellingprice
FROM car_price_cleaned
GROUP BY seller
ORDER BY total_sales DESC
LIMIT 10;
"seller"					"total_sales"	"average_sellingprice"
"ford motor credit company llc"		12665		17637.49
"the hertz corporation"			10962		13763.48
"nissan-infiniti lt"			10277		13652.79
"santander consumer"			9798		7967.56
"avis corporation"			8011		15970.74
"nissan infiniti lt"			6870		21719.76
"wells fargo dealer services"		5882		8927.67
"ge fleet services for itself/servicer"	4286		11372.78
"tdaf remarketing"			4234		15569.41
"ahfc/honda lease trust/hvt  inc. eot"	4210		14090.77
```
# Interpretation
1.	Ford Motor Credit Company LLC is the top seller with 12,665 cars sold at an average price of $17,637.49.
2.	Rental car companies like Hertz and Avis are major sellers.
-	Hertz sold 10,962 cars at an average of $13,763.48.
-	Avis sold 8,011 cars at a higher average price of $15,970.74.
3.	Financial institutions and leasing companies also play a big role.
-	Santander Consumer sold 9,798 cars at a lower average price of $7,967.56.
-	Wells Fargo Dealer Services sold 5,882 cars at an average price of $8,927.67.
4.	Nissan Infiniti LT appears twice, with different average prices.
-	One entry has 6,870 cars at $21,719.76 (higher-end vehicles).
-	Another entry has 10,277 cars at $13,652.79 (likely standard models).
# Business Insight:
-	Major automakers and rental car companies dominate used car sales.
-	Leasing and financial institutions sell cars at lower average prices, likely from repossessions or end-of-lease sales.
-	If you're looking to buy a used car, rental companies (like Hertz & Avis) often sell at lower prices.
-	Higher-end models from Nissan Infiniti LT and TDAF Remarketing sell for more.

# 5. Time Series & Seasonal Trends
# Sales Trend Over Time
```
SELECT EXTRACT(MONTH FROM saledate::DATE) AS month, COUNT(*) AS sales_count
FROM car_price_cleaned
GROUP BY EXTRACT(MONTH FROM saledate::DATE)
ORDER BY month;

"month"	"sales_count"
1		94827
2		106213
3		6547
4		934
5		42797
6		43792
7		13
12		36224
```
# Observations:
1.	February has the highest sales (106,213), followed by January (94,827).
-	These two months account for a large portion of total sales.
2.	March (6,547), April (934), and July (13) have very low sales.
-	March and April see a sharp drop, which is unusual.
-	July has almost no sales (only 13), which might indicate missing or incorrect data.
3.	Sales pick up again in May (42,797) and June (43,792), then drop in December (36,224).
4.	No data for months 8, 9, 10, and 11.
-	This could be due to missing records or data filtering issues.
Possible Explanations:
-	End-of-year and new-year promotions could explain high sales in January and February.
-	March and April's drop could be seasonal trends or data issues.
-	July’s near-zero sales may be an error in data collection.
-	Missing months (August to November) might need further investigation.
Simple Business Insight:
-	Car sales peak at the beginning of the year, possibly due to new models, tax refunds, and promotions.
-	Data inconsistencies (like July’s 13 sales) need verification.

## You can reach me via
Email:- adekunletimothy92@gmail.com
Linkedin:- www.linkedin.com/in/timothyadekunle1992


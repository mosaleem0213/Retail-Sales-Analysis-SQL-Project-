--  CREATE DATABASE FOR ANALYST --

CREATE DATABASE Retail_Sales_Analyst;

-- CREATE TABLE FOR INSERTING THE CSV DATA --

Create Table RetailSales (

transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(10),
age INT,
category VARCHAR(15),
quantiy	INT ,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

-- CHECKING IMPORTING CSV DTA --

SELECT * FROM RetailSales;
 
-- CHECKING TOTAL ENTRIES IMPORTED --

SELECT COUNT(*) FROM RetailSales;

         --  DATA Cleaning --

-- CHECKING NULL VALUES IN THE IMPORTING CSV DATA --

SELECT  * FROM RetailSales 
	Where
		transactions_id IS NULL
		OR sale_date IS NULL
		OR sale_time IS NULL
		OR customer_id IS NULL
		OR gender IS NULL
		OR category IS NULL
		OR quantiy IS NULL
;

--  Removing NULL Values from the data --  


DELETE FROM RetailSales 
	Where
		transactions_id IS NULL
		OR sale_date IS NULL
		OR sale_time IS NULL
		OR customer_id IS NULL
		OR gender IS NULL
		OR category IS NULL
		OR quantiy IS NULL

;
--  Bussiness Lavel Queries  --

-- How Many Sales We Have Till Now ? 

SELECT COUNT(*) FROM RetailSales;

-- How Many Umique Customers We Have Till Now ?

Select Count(Distinct customer_id) from RetailSales;

-- How Many Umique Category We Have Till Now ?

Select Distinct category from RetailSales;

-- Write a SQL Query to retrieve all columns for sales made on 2022-11-05 ?

SELECT *
FROM RetailSales 
WHERE sale_date = '2022-11-05';

-- Write a SQL Query to retrieve all transictions where the category is Clothing and the quentity sold more then is 2 in the month of NOV-2022 ?

SELECT *
FROM RetailSales
WHERE category='Clothing'
AND
quantiy>3 
AND
TO_CHAR(sale_date,'yyyy-mm')='2022-11';

-- Write a SQL Query to calculate the total sales and totsl orders for each category ?

SELECT category,
SUM(total_sale)  as Net_Sales,
COUNT(*) as Total_Orders
FROM RetailSales 
GROUP BY category
ORDER BY Net_Sales DESC;

-- Write a SQL Query to find the average age of customers who purchased item for the Beauty category ?

SELECT category,
ROUND(AVG(age),2) as avg_age
FROM RetailSales
Where category='Beauty'
GROUP BY category;

-- Write a SQL Query to find all transactions where the total_sale is greater than 1000 ?

SELECT * 
FROM RetailSales
WHERE total_sale > 1000;

-- Write a SQL Query to find number of transactions made by each gender and category

Select gender,
category ,
count(transactions_id) as total_transaction
FROM RetailSales
GROUP BY gender,category
order by category;

-- Write a SQL Query to calculate the average sale for each month. Find out best selling month in each year ?
SELECT year,
month,
avg_sale
FROM
(
	SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	-- YEAR(sale_date),MONTH(sale_date) if we are using MSSQL AND MYSQL
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) as rank
	from RetailSales 
	GROUP BY year,month
) as rank_table
WHERE rank='1';
 
-- Write SQL Query to find the top 5 customers based on the highest total sales ?

SELECT 
DISTINCT(customer_id) as unique_customer,
SUM(total_sale) as total_sales
FROM RetailSales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Write a SQL Query to find the number of unique customers who purchased items from each category ?

SELECT 
category,
COUNT(DISTINCT(customer_id)) as total_unique_customer
FROM RetailSales
GROUP BY category;

--  Write a SQL Query to create each shift and number of orders (Example Morning<12, Afternoon Between 12 & 17, Evening >17) ?

WITH shift_wise_sale
AS
(
	Select *,
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
	from RetailSales
)
SELECT shift,
	COUNT(*) as total_orders
FROM shift_wise_sale
GROUP BY shift
ORDER BY total_orders DESC;



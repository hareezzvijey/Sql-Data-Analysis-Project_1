--SQL Retail Sales Analysis
CREATE DATABASE sql_project1

--Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),	
		quantiy	INT,
		price_per_unit INT,	
		cogs FLOAT,
		total_sale FLOAT
	);
SELECT * FORM retaile_sales	
SELECT COUNT(*) FROM retail_sales


--
SELECT * FROM retail_sales rs
WHERE 
	transactions_id is NULL
	or
	sale_date is NULL	
	or
	sale_time is NULL	
	or
	customer_id is NULL	
	or
	gender is NULL 
	or
	age	is NULL
	or
	category is NULL	
	or
	quantiy	is NULL
	or
	price_per_unit is NULL	
	or
	cogs is NULL	
	or
	total_sale is NULL;



--
DELETE FROM retail_sales
WHERE
	transactions_id is NULL
	or
	sale_date is NULL	
	or
	sale_time is NULL	
	or
	customer_id is NULL	
	or
	gender is NULL 
	or
	age	is NULL
	or
	category is NULL	
	or
	quantiy	is NULL
	or
	price_per_unit is NULL	
	or
	cogs is NULL	
	or
	total_sale is NULL;


-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sales FROM retail_sales


-- How many customers we have?
SELECT COUNT(DISTINCT customer_id) as Unique_customers FROM retail_sales

--Types of Category
SELECT DISTINCT category as Unique_category FROM retail_sales


-- Data Analysis & Buisness key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity is greater than 2 for the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE 
	sale_date = '2022-11-05'

--  Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity is greater than 2 for the month of Nov-2022

SELECT * 
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	quantiy > 2
	AND 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'

	

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	DISTINCT category as category,
	SUM(total_sale) as net_sales
FROM retail_sales
GROUP BY
	category
	
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	ROUND(AVG(age),0) as Avg_age
FROM retail_sales
WHERE 
	category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE 
	total_sale>1000
ORDER BY 
	total_sale DESC
	

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT
	category,
	gender,
	COUNT(DISTINCT transactions_id) as Transactions
FROM retail_sales
GROUP BY 
	gender,
	category
	

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.

SELECT * FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as total_sale,
		RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY
		1,2
) as t1
WHERE rank = 1



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
	customer_id,
	SUM(total_sale)
FROM retail_sales
GROUP BY
	customer_id
LIMIT 5
	
	


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(Distinct customer_id) as Customers_count
FROM retail_sales
GROUP BY 
	category

-- Q.10 Write a SQL query to create each shift and number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH 
Hourly_sale AS
(
	SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		--WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 'EVENING'
		ELSE 'EVENING'
	END as shift
	FROM retail_sales
)
SELECT 
	shift,
	COUNT(*)
FROM Hourly_sale
GROUP BY shift

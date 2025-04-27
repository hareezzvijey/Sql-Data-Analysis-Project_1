# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project1`

# Retail Sales Data Analysis with PostgreSQL

This project demonstrates how to analyze retail sales data using PostgreSQL, leveraging its powerful querying capabilities to derive meaningful insights. By working with a sample retail dataset, the project covers various aspects of data analysis, including:

## Key Aspects

### Data Exploration
- Extracting key details from the dataset, such as sales trends, customer demographics, and product categories.

### Performance Metrics
- Calculating metrics like total sales, average transaction value, and category-wise revenue contributions.

### Sales Trends
- Analyzing sales patterns across time periods to identify peak sales months, seasonal effects, and growth trends.

### Customer Behavior
- Investigating customer purchase preferences, transaction frequencies, and average spending.

### Data-Driven Insights
- Using SQL queries to generate actionable insights that can drive decisions, such as identifying top-selling products or underperforming categories.

## How to Use
1. Set up a PostgreSQL database and load the sample retail dataset.
2. Execute the SQL scripts provided in the repository to perform the analysis.
3. (Optional) Use the insights derived to create visualizations or reports using your preferred tools.
---
- This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.
---
## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project1;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
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

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * 
FROM retail_sales
WHERE 
	sale_date = '2022-11-05'
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022**:
```sql
SELECT * 
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	quantiy > 2
	AND 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
	DISTINCT category as category,
	SUM(total_sale) as net_sales
FROM retail_sales
GROUP BY
	1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
	ROUND(AVG(age),0) as Avg_age
FROM retail_sales
WHERE 
	category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE 
	total_sale>1000
ORDER BY 
	total_sale DESC;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT
	category,
	gender,
	COUNT(DISTINCT transactions_id) as Transactions
FROM retail_sales
GROUP BY 
	gender,
	category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT * FROM
	(
		SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as total_sale,
		RANK() OVER (PARTITION BY 
					 	EXTRACT(YEAR FROM sale_date) 
					 	ORDER BY 
					 	AVG(total_sale) DESC) as rank
						FROM retail_sales
						GROUP BY 1,2
	) AS t1
WHERE rank = 1;

```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
	customer_id,
	SUM(total_sale)
FROM retail_sales
GROUP BY
	customer_id
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
	category,
	COUNT(Distinct customer_id) as Customers_count
FROM retail_sales
GROUP BY 
	category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
GROUP BY shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

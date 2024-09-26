USE walmart_sales;
CREATE TABLE IF NOT EXISTS wmsales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
	branch VARCHAR(5) NOT NULL,
	city VARCHAR (30) NOT NULL,
	customer_type VARCHAR(30) NOT NULL,
	gender VARCHAR(10) NOT NULL, 
	product_line VARCHAR(100) NOT NULL,
	unit_price DECIMAL(10,2) NOT NULL,
	quantity INT NOT NULL,
	VAT FLOAT NOT NULL,
	total DECIMAL(12,4) NOT NULL,
	sale_date DATETIME NOT NULL,
	sale_time TIME NOT NULL,
	payment_method VARCHAR(15) NOT NULL,
	cogs DECIMAL (10,2) NOT NULL,
	gross_margin_pct FLOAT,
	gross_income DECIMAL(12,4) NOT NULL,
	rating FLOAT
);

SELECT sale_time
FROM wmsales;

SELECT 
	sale_time, (CASE 
				WHEN sale_time BETWEEN "00:00:00" AND '12:00:00' THEN 'Morning'
				WHEN sale_time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
				ELSE 'Evening'
			END) AS time_of_day
FROM wmsales;
ALTER TABLE wmsales
ADD COLUMN time_of_day VARCHAR(30);

UPDATE wmsales 
SET time_of_day = (
	CASE 
		WHEN sale_time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN sale_time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
	ELSE 'Evening'
	END
	
);

-- ADD a New Column Day Name 

SELECT 
	DATE_FORMAT(sale_date, '%m/%d/%Y') AS sale_date,
	DAYNAME(sale_date) AS day_name
FROM wmsales;

ALTER TABLE wmsales 
ADD COlUMN day_name VARCHAR(10);

UPDATE wmsales 
SET day_name = DAYNAME(sale_date);

-- Adding a new column month_name that contains the extracted months of the year
SELECT 
	sale_date,
    MONTHNAME(sale_date) As sale_date
FROM wmsales;

ALTER TABLE wmsales
ADD Column month_name VARCHAR(15);

UPDATE wmsales
SET month_name = MONTHNAME(sale_date);

SELECT *
FROM wmsales;

-- Business Question To Answer 
-- How many unique cities does the data have?
SELECT DISTINCT city
FROM wmsales;

-- In Which city is each branch
SELECT 
	DISTINCT city,
    Branch
FROM wmsales;

-- How many unique product lines does the data have
SELECT 
-- DISTINCT product_line,
COUNT(DISTINCT product_line)
FROM wmsales;

-- What is the most common payment method
SELECT 
	payment_method,
    COUNT(payment_method) AS cnt
FROM wmsales
GROUP BY payment_method
ORDER BY cnt DESC ;

-- What is the most selling product line
SELECT 
	product_line,
    COUNT(product_line) AS spl
FROM wmsales 
GROUP BY product_line
ORDER BY spl DESC;

-- What is the total revenue by month
SELECT 
	month_name AS Month,
    SUM(total) AS Total_Revenue
FROM wmsales
GROUP BY month_name 
ORDER BY Total_Revenue DESC;

-- What Month had the largest COGS?
SELECT 
	month_name As Month, 
	SUM(cogs) AS mlcog
FROM wmsales
GROUP BY month_name 
ORDER BY mlcog DESC;

-- What product line had the largest revenue?
SELECT
	product_line,
    SUM(total) AS plr
FROM wmsales 
GROUP BY product_line
ORDER BY plr DESC;

-- What is the city with the largest revenue?
SELECT 
	city,
    SUM(total) AS city_revenue
FROM wmsales
GROUP BY city 
ORDER BY city_revenue DESC;

-- What product line had the largest vat?

SELECT 
	product_line,
    SUM(VAT) AS pvat
FROM wmsales
GROUP BY product_line
ORDER BY pvat DESC;

-- Which branch sold more products than average product sold?
SELECT 
	branch,
    SUM(quantity) AS branch_avg_product
FROM wmsales
GROUP BY branch
HAVING SUM(quantity)>(SELECT AVG(quantity) FROM wmsales);

-- What is the most common product line by gender?

SELECT 
	gender,
	product_line,
    COUNT(gender) AS mcp_by_gender
FROM wmsales
GROUP BY gender, product_line
ORDER BY mcp_by_gender DESC;
-- What is the avarage rating of each product?

SELECT 
	rating,
    product_line,
    round(AVG(rating), 2) AS avg_rating
FROM wmsales
GROUP BY rating, product_line
ORDER BY avg_rating DESC;

-- SALES ANALYSIS 
-- Number of Sales made in each time of the day per weekday
SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM wmsales
WHERE day_name = "Sunday"
GROUP BY time_of_day
ORDER BY total_sales DESC;
-- Which of the customer types bring the most revenu? 
SELECT 
	customer_type,
    SUM(total) AS total_revenue
FROM wmsales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent/VAT (**Value Added Tax"**)
SELECT 
	city,
    AVG(VAT) AS city_vat
FROM wmsales
GROUP BY city
ORDER BY city_vat DESC;
-- Which customer type pays the most in VAT?
SELECT 
	customer_type,
    AVG(VAT) as customer_type_vat
FROM wmsales
GROUP BY customer_type
ORDER BY customer_type_vat DESC;

-- CUSTOMER ANALYSIS 
-- How many unique customer types does the data have?
SELECT 
	DISTINCT (customer_type) 
FROM wmsales;

-- How many Unique payment methods does the data have?
SELECT 
	DISTINCT payment_method
FROM wmsales;

-- What is the most common customer types?
SELECT 
	customer_type,
    COUNT(*) AS total_counts
FROM wmsales
GROUP BY customer_type
ORDER BY total_counts DESC;

-- WHich customer Types Buys the Most 
SELECT 
	customer_type,
    COUNT(*) as total_count
FROM wmsales
GROUP BY customer_type
ORDER BY total_count DESC;

-- WHat is the gender of most customer 
SELECT 
	gender,
    count(*) as gender_count
FROM wmsales
GROUP BY gender 
ORDER BY gender_count DESC;

-- What is the gender distribution per branch 
SELECT 
	gender,
    count(*) AS gender_count
FROM wmsales 
WHERE branch ="C"
GROUP BY gender 
ORDER BY gender_count DESC;

-- WHich time of the day do customers give most rating? 

SELECT 
	time_of_day,
    AVG(rating) AS rating_avg
FROM wmsales
GROUP BY time_of_day
ORDER BY rating_avg DESC;

-- Which time of the day do customers give most ratings per branch

SELECT 
	time_of_day,
    branch,
    AVG(rating) AS avg_rating
FROM wmsales 
GROUP BY time_of_day,branch
ORDER BY avg_rating DESC;

-- Which day for the week has the best avg ratings?

SELECT 
	day_name,
    AVG(rating) AS avg_rating
FROM wmsales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average rating per branch?
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM wmsales 
WHERE branch = "A"
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Revenue and Profit Calculations 
-- $ Total(gross sales)
SELECT 
	SUM(VAT+cogs) as total_sales
FROM wmsales;

-- gross profit 
SELECT 
	(SUM(VAT+cogs)-cogs) AS gross_profit
FROM wmsales;
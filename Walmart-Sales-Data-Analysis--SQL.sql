create database WalmartSales ;

use  WalmartSales ;

-- 1. Time_of_day

SELECT time,
(CASE 
	WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening" 
END) AS time_of_day
FROM walmasaledata;

ALTER TABLE walmasaledata ADD COLUMN time_of_day VARCHAR(20);


UPDATE walmasaledata
SET time_of_day = (
	CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END
);
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

UPDATE walmasaledata
SET time_of_day = (
	CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END
);
-- 2.Day_name

SELECT date,
DAYNAME(date) AS day_name
FROM walmasaledata;

ALTER TABLE walmasaledata ADD COLUMN day_name VARCHAR(10);

UPDATE walmasaledata
SET day_name = DAYNAME(date);

-- 3.Momth_name

SELECT date,
MONTHNAME(date) AS month_name
FROM walmasaledata;

ALTER TABLE walmasaledata ADD COLUMN month_name VARCHAR(10);

UPDATE walmasaledata
SET month_name = MONTHNAME(date);



-- Generic Questions
--  1,How many distinct cities are present in the dataset?



select distinct city  AS Distinct_City from walmasaledata ;

-- 2,In which city is each branch situated?

select City ,Branch from walmasaledata
group by  City , Branch ;

-- Product Analysis

-- 1,How many distinct product lines are there in the dataset?

select count(distinct Product_line) AS Distinct_product_lines from walmasaledata ;

-- 2, What is the most common payment method?

select payment , count(Payment) AS count_Payment
from walmasaledata 
group by payment 
order by count_Payment desc ;

-- 3, What is the most selling product line?

select  Product_line , count(product_line) As Most_selling_product_line
from walmasaledata 
group by Product_line 
order by Most_selling_product_line desc ;

-- 4, What is the total revenue by month?

select month_name , sum(Total) AS total_revenue_by_month
from walmasaledata 
group by month_name 
order by total_revenue_by_month desc;

-- 5, Which month recorded the highest Cost of Goods Sold (COGS)?

select month_name , count(cogs) AS  highest_Cost_of_Goods_Sold_COGS from walmasaledata 
group by month_name
order by highest_Cost_of_Goods_Sold_COGS desc limit 1;

-- 6, Which product line generated the highest revenue?

select Product_line , sum(total) AS product_line_generated_the_highest_revenue
from walmasaledata 
group by  Product_line
order by product_line_generated_the_highest_revenue desc limit 1;

-- 7, Which city has the highest revenue?

select city , sum(Total)  AS Highest_Revenue
from walmasaledata
group by  city
order by  Highest_Revenue desc limit 1 ;

-- -- 9.Retrieve each product line and add a column product_category, indicating
--  'Good' or 'Bad,'based on whether its sales are above the average.

ALTER TABLE walmasaledata ADD COLUMN product_category VARCHAR(20);

UPDATE walmasaledata
JOIN (
    SELECT AVG(total) AS avg_total
    FROM walmasaledata
) AS avg_sales
ON 1=1
SET walmasaledata.product_category = (
    CASE
        WHEN walmasaledata.total >= avg_sales.avg_total THEN 'Good'
        ELSE 'Bad'
    END
);
-- 10 Which branch sold more products than the average product sold?



select Branch , sum(Quantity) AS  Quantity from walmasaledata
group by Branch 
HAVING SUM(quantity) > AVG(quantity) ORDER BY quantity DESC LIMIT 1;

-- 11, Most Common Product Line by Gender:

select Gender , Product_line , count(*) Total_count
from walmasaledata 
group by Gender , Product_line
order by Total_count desc ;

-- 12,Average Rating of Each Product Line:

SELECT Product_line, ROUND(AVG(Rating), 2) AS AvgRating
FROM walmasaledata
GROUP BY Product_line
ORDER BY AvgRating DESC;

-- Sales Analysis


-- 1, Number of Sales Made in Each Time of the Day per Weekday

SELECT day_name, time_of_day, COUNT(invoice_id) AS total_sales
FROM walmasaledata
WHERE day_name NOT IN ('Sunday', 'Saturday')
GROUP BY day_name, time_of_day;

-- 2, Identify the Customer Type that Generates the Highest Revenue

select  Customer_type , sum(Total) As Highest_Revenue
from walmasaledata 
group by Customer_type
order by Highest_Revenue desc limit 1;



-- 3, Which City Has the Largest Tax Percent/VAT?

SELECT City, SUM(`Tax5%`) AS HighestTAX
FROM walmasaledata
GROUP BY City
ORDER BY HighestTAX DESC
LIMIT 1;

-- 4, Which Customer Type Pays the Most in VAT?

select Customer_type , sum(`Tax5%`) MOSTTAX
from walmasaledata
group by Customer_type
order by MOSTTAX desc limit 1 ;

-- Customer Analysis

-- 1, How Many Unique Customer Types Does the Data Have?

select count(distinct Customer_type) AS Distinct_Customers
from walmasaledata  ;

-- 2, How Many Unique Payment Methods Does the Data Have?

select count(distinct Payment) AS Unique_Payment_Methods
from walmasaledata ;

-- 3,Which is the Most Common Customer Type?

select Customer_type , count(Customer_type) AS Most_Common_Type
from walmasaledata
group by Customer_type 
order by Most_Common_Type desc limit 1 ;

-- 4, Which Customer Type Buys the Most?

select Customer_type , sum(total) As Total_Sales
from walmasaledata
group by Customer_type
order by Total_Sales desc limit 1 ;

-- 5, What is the Gender of Most of the Customers?

 
 select Gender , count(*) AS All_Gender
 from  walmasaledata 
 group by Gender
 order by All_Gender Desc limit 1   ;
 
-- 6 , What is the Gender Distribution per Branch?


select Branch , Gender , count(Gender) AS Distribution_of_Gender
from walmasaledata 
group by Branch , Gender
order by Distribution_of_Gender ;

--  7, Which Time of the Day Do Customers Give Most Ratings?

select  time_of_day , avg(Rating) AS Avg_Ratings
from walmasaledata
group by time_of_day
order by Avg_Ratings desc ;

-- 8, Which Time of the Day Do Customers Give Most Ratings Per Branch?
select * from walmasaledata ;
select time_of_day , Branch , avg(Rating) AS avg_Rating
from walmasaledata
group by   time_of_day , Branch 
order by avg_Rating desc limit 5;

--  9, Which Day of the Week Has the Best Average Ratings?
select * from walmasaledata ;

select day_name , avg(Rating) AS AvgRating
from walmasaledata
group by day_name 
order by AvgRating desc limit 1 ;

-- 10, Which Day of the Week Has the Best Average Ratings Per Branch?

SELECT branch, day_name, AVG(rating) AS average_rating
FROM sales
GROUP BY branch, day_name
ORDER BY average_rating DESC;


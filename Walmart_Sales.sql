Create database walmart;
Create table if not exists sales(
	invoice_id varchar(30) NOT NULL Primary Key,
    branch varchar(5) NOT NULL,
    city varchar(30) NOT NULL,
    customer_type varchar (30) NOT NULL,
    gender varchar(10) NOT NULL,
    product_line varchar(100) NOT NULL,
    unit_price decimal(10,2) NOT NULL,
    quantity int NOT NULL,
    VAT float(6,4) NOT NULL,
    total decimal(10,2) NOT NULL,
    date Datetime NOT NULL,
    time Time NOT NULL,
    payment_method varchar(15) NOT NULL,
    cogs decimal(10,2) NOT NULL,
    gross_margin_pct float(11, 9) NOT NULL,
    gross_income decimal(12, 4) NOT NULL,
    rating float(2, 1) NOT NULL    
);
select * from sales;

-- ----------------------------------------------------------------------
-- -------------------------Feature Engineering--------------------------

-- time_of-day--
Select 
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		Else "Evening"
        END
    ) As time_of_day
From sales;

Alter table sales ADD COLUMN time_of_day varchar(20); 
Update sales
set time_of_day = (
		CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		Else "Evening"
        END
    );
    
    -- day_name--
Select 
	date,
    dayname(date)
from sales;

Alter table sales ADD COLUMN day_name varchar(20);

UPDATE sales
SET day_name = (
				dayname(date)
);

-- month_name--
Select 
	date,
    monthname(date)
from sales;

Alter table sales ADD COLUMN month_name varchar(20);

UPDATE sales
SET month_name = monthname(date);

-- ----------------------End of Feature Engineering------------------------------
-- ------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------
-- ----------------------------------Generic Questions---------------------------

-- How many unique cities does the data have?
Select distinct city from sales;
Select count(distinct city) from sales;

-- In which city is each branch?
Select distinct branch from sales;
Select distinct city,branch from sales;
-- ------------------------------------------------------------------------------
-- ------------------------------Product Questions-------------------------------

-- How many unique product lines does the data have?
Select distinct product_line from sales;
Select count(distinct product_line) from sales;

-- What is the most common payment method?
Select payment_method,count(payment_method)as payment_method_cnt
from sales
group by payment_method
order by payment_method_cnt desc;

-- What is the most selling product line?
Select 
	product_line,
    count(product_line)as product_line_cnt
from sales
group by product_line
order by product_line_cnt desc;

-- What is the total revenue by month?
Select 
	month_name as Month, sum(total) as Total_Revenue
From sales
group by month
order by Total_Revenue DESC;

-- What month had the largest COGS?
Select 
	month_name as month, 
    sum(cogs)
from sales
group by month_name
order by sum(cogs) desc;

-- What product line had the largest revenue?
Select 
	product_line,
    sum(total) as Total_Revenue
from sales
group by product_line
order by Total_Revenue desc;

-- What is the city with the largest revenue?
Select 
	city,
    sum(Total) As Max_Revenue
from sales
group by City
order by Max_revenue desc;

-- What product line had the largest VAT?
Select 
	product_line,
    Avg(VAT) as Avg_Tax
from sales
group by product_line
order by Avg_Tax desc;

-- Which branch sold more products than average product sold?
Select 
	branch,
    Sum(quantity) As qty
from sales
group by branch
having Sum(quantity) > (Select Avg(quantity) from sales);

-- What is the most common product line by gender?
Select 
	product_line,
    gender,
    Count(gender) As Total_cnt
from sales
group by product_line,gender
order by Total_cnt desc;

-- What is the average rating of each product line?
Select 
	product_line,
    Round(Avg(rating),2) as rate
from sales
group by product_line
order by rate desc ;

-- ------------------------------------------------------------------------------
-- -------------------------------Sales Based Questions--------------------------

-- Number of sales made in each time of the day per weekday
Select 
	time_of_day,
    count(*) As Total_Sales
from sales
where day_name = "Monday"
group by time_of_day
order by Total_Sales;

-- Which of the customer types brings the most revenue?
Select 
	customer_type,
    SUM(Total) As Total_Revenue
from sales
group by customer_type
order by Total_Revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
Select 
	city,
    AVG(VAT) As VAT
from sales
group by city
order by VAT Desc;

-- Which customer type pays the most in VAT?
Select 
	customer_type,
    AVG(VAT) As VAT
from sales
group by customer_type
order by VAT Desc;

-- ------------------------------------------------------------------------------
-- ---------------------------------Customers Questions---------------------------

-- How many unique customer types does the data have?
Select 
	distinct customer_type
from sales;

-- How many unique payment methods does the data have?
Select 
	distinct payment_method
from sales;

-- What is the most common customer type?
Select
	Customer_type,
    count(*) AS Customer_Count
from sales
group by customer_type;

-- Which customer type buys the most?
Select
	Customer_type,
    count(*) AS Customer_Count
from sales
group by customer_type;

-- What is the gender of most of the customers?
Select 
	Gender,
    count(*) As Gender_Count
from sales
group by Gender;

-- What is the gender distribution per branch?
Select 
	Gender,
    count(*) As Gender_Count
from sales
Where Branch = "A"
group by Gender;

-- Distribution of Each Branch
Select
	branch,
    count(gender) As Gender_Cnt
from sales
group by branch;

-- Which time of the day do customers give most ratings?
Select 
	time_of_day,
    round(Avg(rating),2) As Avg_Ratings
from sales
group by time_of_day
order by Avg_Ratings DESC;

-- Which time of the day do customers give most ratings per branch?
Select 
	time_of_day,
    round(Avg(rating),2) As Avg_Ratings
from sales
Where Branch = "C"
group by time_of_day
order by Avg_Ratings desc;

-- Which day fo the week has the best avg ratings?
Select
	day_name,
    Round(Avg(rating),2) As Avg_Ratings
from sales
group by day_name
order by Avg_Ratings Desc;

-- Which day of the week has the best average ratings per branch?
Select
	day_name,
    Round(Avg(rating),2) As Avg_Ratings
from sales
Where Branch = "B"
group by day_name
order by Avg_Ratings Desc;

-- -----------------------End of Project-----------------------------
-- ------------------------------------------------------------------




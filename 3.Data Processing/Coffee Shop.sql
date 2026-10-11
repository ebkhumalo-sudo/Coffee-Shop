--What is the first and last transaction date and time

SELECT
    MIN(CAST(transaction_date AS TIMESTAMP) +
        (transaction_time - CAST(transaction_time AS DATE))) AS first_transaction_datetime,

    MAX(CAST(transaction_date AS TIMESTAMP) +
        (transaction_time - CAST(transaction_time AS DATE))) AS last_transaction_datetime

FROM coffee.coffee_shop.coffee_shop_sales_dataset;

--How many rows are there in total

SELECT COUNT(*) AS total_rows
FROM coffee.coffee_shop.coffee_shop_sales_dataset;

--Are ther any missing transaction IDs?

SELECT COUNT(*) AS missing_transaction_id
FROM coffee.coffee_shop.coffee_shop_sales_dataset
WHERE transaction_id IS NULL;

--Checking for duplicate IDs

SELECT
    transaction_id,
    COUNT(*) AS number_of_records
FROM coffee.coffee_shop.coffee_shop_sales_dataset
GROUP BY transaction_id
HAVING COUNT(*) > 1;

--Big code
   SELECT 
    transaction_id,--From original table
    transaction_date,--From original table
    DATE_FORMAT(transaction_time, 'HH:mm:ss') AS transaction_time,--Format to help DataBricks read the time
    
    --Non aggregated functions
    store_location, 
    product_category, 
    product_type, 
    product_detail, 
    
    DAYNAME(transaction_date) AS Day_name,--DAYNAME gives the name of a specific table. This will be a new column

    MONTHNAME(transaction_date) AS Month_name,--Gives the name of the month. This will be a new column

    COUNT(transaction_id) AS number_of_sales,--Counts all the transaction ids
 
    SUM(transaction_qty) AS units_sold, --Adds up all the transaction quantities

    COUNT(DISTINCT product_id) AS unique_products,--Counts all the unique product ids
 
    COUNT(store_id) AS number_of_stores,--Counts all the store ids
 
    SUM(  transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(36,16)) ) AS revenue, --CAST REPLACE code is to tell Data Bricks how to read full stops and commas

    --CASE statement: Always creates buckets for enhanced analysis

    --This CASE statement is classifying the day of the week as either a weekend or weekday
    CASE 
        WHEN DAYNAME(transaction_date) IN ('Sat', 'Sun') THEN 'Weekend' 
 
        WHEN DAYNAME(transaction_date) IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri') THEN 'Weekday' 
    END AS day_classification, 

    --This CASE statement is classifying the time of the day as either morning,afternoon or evening
    CASE  
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning' 
 
        WHEN HOUR(transaction_time) BETWEEN 12 AND 17 THEN 'Afternoon' 
 
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN 'Evening' 
        ELSE 'Night' 
    END AS time_of_day 
 
FROM coffee.coffee_shop.coffee_shop_sales_dataset 
 
GROUP BY --Unagrregated functions
    transaction_id,
    transaction_date, 
    transaction_time,
    store_location, 
    product_category, 
    product_type, 
    product_detail, 
 
    CASE 
        WHEN DAYNAME(transaction_date) IN ('Sat', 'Sun') THEN 'Weekend' 
 
        WHEN DAYNAME(transaction_date) IN 
            ('Mon', 'Tue', 'Wed', 'Thu', 'Fri') THEN 'Weekday' 
    END, 
    
    CASE  
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11  THEN 'Morning' 
 
        WHEN HOUR(transaction_time) BETWEEN 12 AND 17  THEN 'Afternoon' 
 
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20  THEN 'Evening' 
 
        ELSE 'Night' 
    END;

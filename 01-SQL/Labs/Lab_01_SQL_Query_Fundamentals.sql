-- --------------------------------------------------------------------------------------
-- Course: DS2-2002 - Data Science Systems | Author: Jon Tupitza
-- Lab 1: SQL Query Fundamentals | 5 Points
-- --------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------
-- 1). First, How Many Rows (Products) are in the Products Table?			| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT COUNT(*) FROM northwind.products;

-- --------------------------------------------------------------------------------------
-- 2). Fetch Each Product Name and its Quantity per Unit					| 0.2.pt
-- --------------------------------------------------------------------------------------
SELECT product_name as "Product Name"
	, quantity_per_unit as "Quantity per Unit" FROM northwind.products;

-- --------------------------------------------------------------------------------------
-- 3). Fetch the Product ID and Name of Currently Available Products		| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT id as "Product ID"
	, product_name as "Name" 
FROM northwind.products 
WHERE quantity_per_unit IS NOT NULL;

-- --------------------------------------------------------------------------------------
-- 4). Fetch the Product ID, Name & List Price Costing Less Than $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT id as "Product ID"
	, product_name as "Name"
    , list_price as "List Price" 
FROM northwind.products
WHERE list_price < 20
ORDER BY list_price DESC;

-- --------------------------------------------------------------------------------------
-- 5). Fetch the Product ID, Name & List Price Costing Between $15 and $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT id as product_id
	, product_name
    , list_price
FROM northwind.products
WHERE list_price BETWEEN 15.00 AND 20.00
ORDER BY list_price DESC;

-- Older (Equivalent) Syntax -----
SELECT id as product_id
	, product_name
    , list_price
FROM northwind.products
WHERE list_price >= 15.00 
AND list_price <= 20.00
ORDER BY list_price DESC;

-- --------------------------------------------------------------------------------------
-- 6). Fetch the Product Name & List Price of the 10 Most Expensive Products 
--     Sort the results with the most expensive Products first.				| 0.33 pt
-- --------------------------------------------------------------------------------------
SELECT product_name as "Product Name"
	, list_price as "List Price" 
FROM northwind.products
ORDER BY list_price DESC
LIMIT 10;

-- --------------------------------------------------------------------------------------
-- 7). Fetch the Name & List Price of the Most & Least Expensive Products	| 0.33 pt.
-- --------------------------------------------------------------------------------------
SELECT product_name
	, list_price 
FROM northwind.products
WHERE list_price = (SELECT MAX(list_price) FROM northwind.products)
OR list_price = (SELECT MIN(list_price) FROM northwind.products);

-- --------------------------------------------------------------------------------------
-- 8). Fetch the Product Name & List Price Costing Above Average List Price
--     Sort the results with the most expensive Products first.				| 0.33 pt.
-- --------------------------------------------------------------------------------------
SELECT product_name as "Product Name"
	, list_price as "List Price"
FROM northwind.products
WHERE list_price > (SELECT AVG(list_price) FROM northwind.products)
ORDER BY list_price DESC;

-- --------------------------------------------------------------------------------------
-- 9). Fetch & Label the Count of Current and Discontinued Products using
-- 	   the "CASE... WHEN" syntax to create a column named "availablity"
--     that contains the values "discontinued" and "current". 				| 0.33 pt
-- --------------------------------------------------------------------------------------
UPDATE northwind.products SET discontinued = 1 WHERE id IN (95, 96, 97);

ALTER TABLE northwind.products
ADD availability varchar(12);

UPDATE northwind.products
SET availability =
    CASE 
        WHEN discontinued = 0 THEN 'discontinued'
        WHEN discontinued = 1 THEN 'current'
    END
WHERE product_code IS NOT NULL;


SELECT id, availability FROM northwind.products;


UPDATE northwind.products SET discontinued = 0 WHERE id in (95, 96, 97);

-- --------------------------------------------------------------------------------------
-- 10). Fetch Product Name, Reorder Level, Target Level and "Reorder Threshold"
-- 	    Where Reorder Level is Less Than or Equal to 20% of Target Level	| 0.33 pt.
-- --------------------------------------------------------------------------------------
SELECT product_name AS "Product Name",
       reorder_level AS "Reorder Level",
       target_level AS "Target Level",
       target_level * 0.20 AS "Reorder Threshold"
FROM northwind.products
WHERE reorder_level <= (target_level * 0.20);

-- --------------------------------------------------------------------------------------
-- 11). Fetch the Number of Products per Category Priced Less Than $20.00	| 0.33 pt
-- --------------------------------------------------------------------------------------
SELECT p.category,
       COUNT(p.product_name) AS "Number of Products"
FROM northwind.products AS p
WHERE p.list_price < 20.00
GROUP BY p.category;

-- --------------------------------------------------------------------------------------
-- 12). Fetch the Number of Products per Category With Less Than 5 Units In Stock	| 0.5 pt
-- Fetch the Number of Products per Category to Include Categories Having Fewer that 5 Products
-- --------------------------------------------------------------------------------------
SELECT p.category,
	COUNT(p.product_name) AS "Number of Products"
FROM northwind.products AS p
GROUP BY p.category
HAVING COUNT(p.product_name) < 5;

-- --------------------------------------------------------------------------------------
-- 13). Fetch Products along with their Supplier Company & Address Info		| 0.5 pt
-- --------------------------------------------------------------------------------------
SELECT p.product_code
	, product_name
    , s.company
    , s.address
FROM northwind.products AS p
INNER JOIN northwind.suppliers AS s
ON s.id = p.supplier_ids;

-- --------------------------------------------------------------------------------------
-- 14). Fetch the Customer ID and Full Name for All Customers along with
-- 		the Order ID and Order Date for Any Orders they may have			| 0.5 pt
-- --------------------------------------------------------------------------------------
# join, outer keyword is optional
SELECT c.id 
	, o.order_date as "Order Date"
	, CONCAT (c.first_name, " ", c.last_name) AS full_name
FROM northwind.customers AS c
LEFT OUTER JOIN northwind.orders AS o
ON c.id = o.customer_id;

-- --------------------------------------------------------------------------------------
-- 15). Fetch the Order ID and Order Date for All Orders along with
--   	the Customr ID and Full Name for Any Associated Customers			| 0.5 pt
-- --------------------------------------------------------------------------------------
SELECT c.id 
	, o.order_date as "Order Date"
	, CONCAT (c.first_name, " ", c.last_name) AS full_name
FROM northwind.customers AS c
RIGHT OUTER JOIN northwind.orders AS o
ON c.id = o.customer_id;



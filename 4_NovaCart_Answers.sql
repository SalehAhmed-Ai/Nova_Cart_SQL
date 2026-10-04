/*
============================================================
                    NovaCart SQL Lab
                  SQL Questions Worksheet
============================================================

Student Name : Saleh Ahmed Hammad
Section      : Instant Ai-ON-SW#29
ID           : __________________________________

Platform: Microsoft SQL Server / SSMS

Instructions:
1. Complete the database design and implementation before solving
   these questions.
2. Do not modify the database structure just to make a question easier.
3. Write your SQL solution directly below each question.
4. Use meaningful aliases and readable formatting.
5. All queries must execute successfully on your completed NovaCartDB.
6. Use the separate Hints PDF only when you are genuinely stuck.
7. Do not hard-code results that should be calculated from the data.

Database:
    NovaCartDB

============================================================
*/

USE NovaCartDB;
GO


/*============================================================
                MISSION 1 — CUSTOMER & PRODUCT OVERVIEW
============================================================*/

-- M1-Q1
-- Display all customers.

-- Your query:
SELECT * FROM dbo.Customers;


------------------------------------------------------------

-- M1-Q2
-- Display the product name, category, and current price
-- for every product.

-- Your query:
SELECT p.name AS ProductName,
c.category_name AS Category,
p.price AS CurrentPrice 
FROM dbo.Products AS p
JOIN dbo.Categories AS c ON p.category_id = c.category_id;

   


------------------------------------------------------------

-- M1-Q3
-- Display products whose current price is greater than 5000.

-- Your query:
SELECT * FROM dbo.Products
WHERE price > 5000;


------------------------------------------------------------

-- M1-Q4
-- Display all customers ordered by join date, newest first.

-- Your query:
SELECT * 
FROM dbo.Customers
WHERE join_date IS NOT NULL
ORDER BY join_date DESC;

------------------------------------------------------------

-- M1-Q5
-- Display the total number of customers.

-- Your query:
SELECT COUNT(*) AS TotalCustomers FROM dbo.Customers;


/*============================================================
             MISSION 2 — AGGREGATION & BUSINESS TOTALS
============================================================*/

-- M2-Q1
-- Calculate the average current product price.

-- Your query:
SELECT AVG(price) AS AverageCurrentProductPrice FROM dbo.Products;


------------------------------------------------------------

-- M2-Q2
-- Display the highest and lowest current product prices 
-- Your query:
SELECT MAX(price) AS HighestCurrentProductPrice,
       MIN(price) AS LowestCurrentProductPrice
FROM dbo.Products;

------------------------------------------------------------

-- M2-Q3
-- Calculate the total available stock quantity.

-- Your query:
SELECT SUM(stock_quantity) AS TotalAvailableStockQuantity
FROM dbo.Products
WHERE stock_quantity IS NOT NULL;


------------------------------------------------------------

-- M2-Q4
-- Calculate the total amount recorded in Payments.

-- Your query:
SELECT SUM(amount) AS TotalPaymentsAmount FROM dbo.Payments;


------------------------------------------------------------

-- M2-Q5
-- Display the number of orders for each order status.

-- Your query:
SELECT status AS OrderStatus, COUNT(*) AS NumberOfOrders
FROM dbo.Orders
WHERE status IS NOT NULL 
GROUP BY status ;


------------------------------------------------------------

-- M2-Q6
-- Display the total payment amount for each payment method.

-- Your query:
SELECT method AS PaymentMethod, SUM(amount) AS TotalPaymentAmount
FROM dbo.Payments
GROUP BY method;


/*============================================================
               MISSION 3 — ORDER & SALES ANALYSIS
============================================================*/

-- M3-Q1
-- Calculate the total sales amount for each order.
-- Use quantity multiplied by the historical unit price.

-- Your query:
SELECT od.order_id,
    SUM(od.quantity * od.unit_price) AS TotalSalesAmount
FROM dbo.OrderDetails AS od
GROUP BY od.order_id;


------------------------------------------------------------

-- M3-Q2
-- Display only orders whose total sales exceed 5000.

-- Your query:
SELECT 
    od.order_id,
    SUM(od.quantity * od.unit_price) AS TotalSalesAmount
FROM dbo.OrderDetails AS od
GROUP BY od.order_id
HAVING SUM(od.quantity * od.unit_price) > 5000;

------------------------------------------------------------

-- M3-Q3
-- Display each order together with:
-- customer name, order date, and order status.

-- Your query:
SELECT o.order_id,
       c.full_name AS CustomerName,
       o.order_date AS OrderDate,
       o.status AS OrderStatus
 FROM dbo.Orders AS o
 JOIN dbo.Customers AS c ON o.customer_id = c.customer_id;


------------------------------------------------------------

-- M3-Q4
-- Display each order with:
-- product name, purchased quantity, and historical unit price.

-- Your query:
SELECT 
    o.order_id,
    p.name AS ProductName,
    od.quantity AS PurchasedQuantity,
    od.unit_price AS HistoricalUnitPrice
FROM dbo.Orders AS o
JOIN dbo.OrderDetails AS od 
    ON o.order_id = od.order_id
JOIN dbo.Products AS p 
    ON od.product_id = p.product_id;


------------------------------------------------------------

-- M3-Q5
-- Display the total amount spent by each customer.

-- Your query:
SELECT c.customer_id,
       c.full_name AS CustomerName,
       SUM(p.amount) AS TotalAmountSpent
FROM dbo.Customers AS c
JOIN dbo.Orders AS o
    ON c.customer_id = o.customer_id
JOIN dbo.Payments AS p
    ON o.order_id = p.order_id
GROUP BY c.customer_id,
         c.full_name;

/*============================================================
              MISSION 4 — REVIEWS & RELATIONSHIPS
============================================================*/

-- M4-Q1
-- Display the number of reviews received by each product,
-- including products with no reviews.

-- Your query:
SELECT 
    p.product_id,
    p.name AS ProductName,
    COUNT(r.review_id) AS NumberOfReviews
FROM dbo.Products AS p
LEFT JOIN dbo.Reviews AS r 
    ON p.product_id = r.product_id
GROUP BY 
    p.product_id,
    p.name;


------------------------------------------------------------

-- M4-Q2
-- Display all reviews together with:
-- customer name and product name.

-- Your query:
SELECT
    r.review_id,
    c.full_name AS CustomerName,
    p.name AS ProductName
FROM dbo.Reviews AS r
JOIN dbo.Customers AS c
    ON r.customer_id = c.customer_id
JOIN dbo.Products AS p
    ON r.product_id = p.product_id;

------------------------------------------------------------

-- M4-Q3
-- Display customers who have placed at least one order.

-- Your query:
SELECT c.customer_id,
    c.full_name AS CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1
    FROM dbo.Orders AS o
    WHERE o.customer_id = c.customer_id
);


------------------------------------------------------------

-- M4-Q4
-- Display products that have never been ordered.

-- Your query:
SELECT p.product_id,
       p.name AS ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderDetails AS od
    WHERE od.product_id = p.product_id
);


------------------------------------------------------------

-- M4-Q5
-- Display products that have never received a review.

-- Your query:
SELECT p.product_id,
       p.name AS ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Reviews AS r
    WHERE r.product_id = p.product_id
);



------------------------------------------------------------

-- M4-Q6
-- Display all customers and their number of orders,
-- including customers who have never placed an order.

-- Your query:
SELECT 
    c.customer_id,
    c.full_name AS CustomerName,
    COUNT(o.order_id) AS NumberOfOrders
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.full_name;


/*============================================================
                       MISSION 5 — SUBQUERIES
============================================================*/

-- M5-Q1
-- Display customers who placed more orders than the average
-- number of orders among customers who placed at least one order.

-- Your query:
SELECT c.customer_id,
       c.full_name AS CustomerName
FROM dbo.Customers AS c
WHERE (
    SELECT COUNT(o.order_id)
    FROM dbo.Orders AS o
    WHERE o.customer_id = c.customer_id
) > (
    SELECT AVG(CAST(order_count AS DECIMAL(10,2)))
    FROM (
        SELECT COUNT(o2.order_id) AS order_count
        FROM dbo.Orders AS o2
        GROUP BY o2.customer_id
    ) AS subquery
);


------------------------------------------------------------

-- M5-Q2
-- Display products whose current price is above the average
-- current product price.

-- Your query:
SELECT p.product_id, p.name AS ProductName, p.price AS CurrentPrice
FROM dbo.Products AS p
WHERE p.price > (
    SELECT AVG(price)
    FROM dbo.Products
);


------------------------------------------------------------

-- M5-Q3
-- Display customers whose total spending is greater than
-- the average total spending among customers who have made
-- at least one payment.

-- Your query:
SELECT c.customer_id, c.full_name AS CustomerName
FROM dbo.Customers AS c
WHERE (
    SELECT SUM(p.amount)
    FROM dbo.Orders AS o
    JOIN dbo.Payments AS p ON o.order_id = p.order_id
    WHERE o.customer_id = c.customer_id
) > (
    SELECT AVG(total_spending)
    FROM (
        SELECT SUM(p2.amount) AS total_spending
        FROM dbo.Orders AS o2
        JOIN dbo.Payments AS p2 ON o2.order_id = p2.order_id
        GROUP BY o2.customer_id
    ) AS subquery
);


/*============================================================
                MISSION 6 — COMMON TABLE EXPRESSIONS
============================================================*/

-- M6-Q1
-- Using a CTE, calculate total revenue by month.

-- Your query:
WITH RevenueByMonth AS (
    SELECT 
        YEAR(p.payment_date) AS PaymentYear,
        MONTH(p.payment_date) AS PaymentMonth,
        SUM(p.amount) AS TotalRevenue
    FROM dbo.Payments AS p
    GROUP BY 
        YEAR(p.payment_date),
        MONTH(p.payment_date)
)
SELECT *
FROM RevenueByMonth
ORDER BY PaymentYear, PaymentMonth;


------------------------------------------------------------

-- M6-Q2
-- Using a CTE, calculate total spending by customer.
-- Return only customers whose total spending exceeds 10000.

-- Your query:
WITH TotalSpendingByCustomer AS (
    SELECT 
        c.customer_id,
        c.full_name AS CustomerName,
        SUM(p.amount) AS TotalSpending
    FROM dbo.Customers AS c
    JOIN dbo.Orders AS o 
        ON c.customer_id = o.customer_id
    JOIN dbo.Payments AS p 
        ON o.order_id = p.order_id
    GROUP BY 
        c.customer_id,
        c.full_name
)
SELECT 
    customer_id,
    CustomerName,
    TotalSpending
FROM TotalSpendingByCustomer
WHERE TotalSpending > 10000;


/*============================================================
                  MISSION 7 — WINDOW FUNCTIONS
============================================================*/

-- M7-Q1
-- Rank customers by total spending using RANK(),
-- with the highest spending ranked first.

-- Your query:
SELECT 
    c.customer_id,
    c.full_name AS CustomerName,
    SUM(p.amount) AS TotalSpending,
    RANK() OVER (
        ORDER BY SUM(p.amount) DESC
    ) AS SpendingRank
FROM dbo.Customers AS c
JOIN dbo.Orders AS o
    ON c.customer_id = o.customer_id
JOIN dbo.Payments AS p
    ON o.order_id = p.order_id
GROUP BY 
    c.customer_id,
    c.full_name
ORDER BY SpendingRank;


------------------------------------------------------------

-- M7-Q2
-- Rank products by total quantity sold using DENSE_RANK(),
-- with the highest quantity ranked first.

-- Your query:
SELECT 
    p.product_id,
    p.name AS ProductName,
    SUM(od.quantity) AS TotalQuantitySold,
    DENSE_RANK() OVER (
        ORDER BY SUM(od.quantity) DESC
    ) AS QuantityRank
FROM dbo.Products AS p
JOIN dbo.OrderDetails AS od
    ON p.product_id = od.product_id
GROUP BY 
    p.product_id,
    p.name
ORDER BY QuantityRank, p.product_id;


------------------------------------------------------------

-- M7-Q3
-- Display each payment together with the previous payment amount
-- using LAG().
-- Order the sequence by payment date and payment ID.

-- Your query:

SELECT 
    p.payment_id,
    p.payment_date,
    p.amount AS PaymentAmount,
    LAG(p.amount) OVER (
        ORDER BY p.payment_date, p.payment_id
    ) AS PreviousPaymentAmount
FROM dbo.Payments AS p;

------------------------------------------------------------

-- M7-Q4
-- Display a running total of payment amounts.
-- Order the sequence by payment date and payment ID.

-- Your query:
SELECT 
    p.payment_id,
    p.payment_date,
    p.amount AS PaymentAmount,
    SUM(p.amount) OVER (
        ORDER BY p.payment_date, p.payment_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM dbo.Payments AS p;


/*============================================================
                         MISSION 8 — VIEWS
============================================================*/

-- M8-Q1
-- Create a view named vw_revenue_by_month
-- that displays monthly revenue.

-- Your query:
CREATE VIEW dbo.vw_revenue_by_month
AS
SELECT 
    YEAR(p.payment_date) AS PaymentYear,
    MONTH(p.payment_date) AS PaymentMonth,
    SUM(p.amount) AS TotalRevenue
FROM dbo.Payments AS p
GROUP BY 
    YEAR(p.payment_date),
    MONTH(p.payment_date);

SELECT *
FROM dbo.vw_revenue_by_month
ORDER BY PaymentYear, PaymentMonth;
------------------------------------------------------------

-- M8-Q2
-- Create a view named vw_best_selling_products
-- that displays:
--   Product Name
--   Total Quantity Sold
--   Total Revenue

-- Your query:
CREATE VIEW dbo.vw_best_selling_products
AS
SELECT 
    p.name AS ProductName,
    SUM(od.quantity) AS TotalQuantitySold,
    SUM(od.quantity * od.unit_price) AS TotalRevenue
FROM dbo.Products AS p
JOIN dbo.OrderDetails AS od
    ON p.product_id = od.product_id
GROUP BY 
    p.product_id,
    p.name;

SELECT *
FROM dbo.vw_best_selling_products
ORDER BY TotalQuantitySold DESC;


------------------------------------------------------------

-- M8-Q3
-- Create a view named vw_customer_summary
-- that displays:
--   Customer Name
--   Number of Orders
--   Total Amount Spent

-- Your query:
CREATE VIEW dbo.vw_customer_summary
AS
SELECT c.full_name AS CustomerName,
       COUNT(DISTINCT o.order_id) AS NumberOfOrders,
       COALESCE(SUM(p.amount), 0) AS TotalAmountSpent
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN dbo.Payments AS p
    ON o.order_id = p.order_id
GROUP BY c.customer_id,
         c.full_name;

SELECT *
FROM dbo.vw_customer_summary;



/*============================================================
                           END
============================================================*/

/*
PART A - DESIGN REASONING

1. Why is an intermediate table needed between Orders and Products?
   One order can have many products, and one product can be in many orders
   (many-to-many). A table can't store a list in one cell, so OrderDetails
   is used to link them. Each row is one product in one order.

2. Why is quantity stored for an order-product combination, not in Products?
   Quantity depends on both the order and the product. The same product can be
   bought in different quantities in different orders. Products only stores
   the stock available in the store.

3. Why store unit_price in OrderDetails instead of using Products.price?
   Product prices change over time. Saving unit_price keeps the price the
   customer paid at that time, so old orders don't change when the price changes.

4. Why restrict order status to four values?
   The business only uses Pending, Shipped, Delivered and Cancelled.
   A CHECK constraint prevents wrong or misspelled values and keeps the
   data clean.

5. Why is order_id unique in Payments?
   A foreign key alone allows many payments for one order. UNIQUE allows only
   one payment per order, so the relationship becomes one-to-one.

6. Which rules need constraints, and which review rule needs extra logic?
   Constraints handle: primary keys, foreign keys, unique email, NOT NULL,
   and CHECK for status, payment method, rating (1-5) and quantity > 0.
   The rule "a customer can review a product only after buying it" needs
   extra logic (a trigger or application code), because a CHECK can't look
   at other tables.


PART B - SQL REASONING

1. Which queries need GROUP BY? Why?
   Queries that use SUM, COUNT or AVG per group, like orders per status,
   payments per method, and total spending per customer. GROUP BY gives one
   result row for each group.

2. Which queries need HAVING instead of WHERE?
   Queries that filter on an aggregate, like orders with total sales over 5000.
   WHERE filters rows before grouping, so it can't use SUM(). HAVING filters
   after grouping.

3. Which questions need a LEFT JOIN?
   Products with no reviews and customers with no orders. LEFT JOIN keeps
   rows that have no match, and INNER JOIN would remove them.

4. Where can a join create duplicate rows, and how did you avoid wrong totals?
   When an order is joined with OrderDetails, the order (and its payment)
   repeats once per product line, so SUM(amount) becomes too big. I avoid it
   by aggregating OrderDetails first in a subquery/CTE, or by not joining
   OrderDetails when I only need payment totals.

5. Why use OrderDetails.unit_price for revenue?
   It is the price the customer actually paid. Products.price is the current
   price and may be different now.

6. What is the difference between RANK() and DENSE_RANK() with ties?
   Both give tied rows the same rank. RANK() skips the next numbers
   (1, 1, 3), while DENSE_RANK() doesn't skip (1, 1, 2).
*/

-- PART C - DDL
USE master;
GO
IF DB_ID(N'NovaCartDB') IS NOT NULL
BEGIN
    ALTER DATABASE NovaCartDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE NovaCartDB;
END
GO

CREATE DATABASE NovaCartDB;
GO

USE NovaCartDB;
GO

-- 1) Categories

CREATE TABLE Categories (
    category_id   INT IDENTITY(1,1) NOT NULL,
    category_name NVARCHAR(100)     NOT NULL,
    CONSTRAINT PK_Categories      PRIMARY KEY (category_id),
    CONSTRAINT UQ_Categories_name UNIQUE (category_name)
);


-- 2) Customers

CREATE TABLE Customers (
    customer_id  INT IDENTITY(1,1) NOT NULL,
    full_name    NVARCHAR(150)     NOT NULL,
    email        NVARCHAR(255)     NOT NULL,
    phone        NVARCHAR(20)      NOT NULL,
    home_address NVARCHAR(255)     NOT NULL,
    join_date    DATE              NOT NULL,
    CONSTRAINT PK_Customers       PRIMARY KEY (customer_id),
    CONSTRAINT UQ_Customers_email UNIQUE (email)
);


-- 3) Products

CREATE TABLE Products (
    product_id     INT IDENTITY(1,1) NOT NULL,
    name           NVARCHAR(150)     NOT NULL,
    category_id    INT               NOT NULL,
    price          DECIMAL(10,2)     NOT NULL,
    stock_quantity INT               NOT NULL,
    CONSTRAINT PK_Products            PRIMARY KEY (product_id),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (category_id)
        REFERENCES Categories (category_id),
    CONSTRAINT CK_Products_price      CHECK (price >= 0),
    CONSTRAINT CK_Products_stock      CHECK (stock_quantity >= 0)
);

-- 4) Orders

CREATE TABLE Orders (
    order_id    INT IDENTITY(1,1) NOT NULL,
    customer_id INT               NOT NULL,
    order_date  DATE              NOT NULL,
    status      VARCHAR(20)       NOT NULL CONSTRAINT DF_Orders_status DEFAULT 'Pending',
    CONSTRAINT PK_Orders           PRIMARY KEY (order_id),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id)
        REFERENCES Customers (customer_id),
    CONSTRAINT CK_Orders_status    CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);


-- 5) OrderDetails (junction table: Orders <-> Products)
--    Composite primary key: one row per product per order
CREATE TABLE OrderDetails (
    order_id   INT           NOT NULL,
    product_id INT           NOT NULL,
    quantity   INT           NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,   -- price at the time of purchase
    CONSTRAINT PK_OrderDetails          PRIMARY KEY (order_id, product_id),
    CONSTRAINT FK_OrderDetails_Orders   FOREIGN KEY (order_id)
        REFERENCES Orders (order_id),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (product_id)
        REFERENCES Products (product_id),
    CONSTRAINT CK_OrderDetails_quantity CHECK (quantity > 0),
    CONSTRAINT CK_OrderDetails_price    CHECK (unit_price >= 0)
);
GO

-- 6) Payments

CREATE TABLE Payments (
    payment_id   INT IDENTITY(1,1) NOT NULL,
    order_id     INT               NOT NULL,
    payment_date DATE              NOT NULL,
    amount       DECIMAL(10,2)     NOT NULL,
    method       VARCHAR(30)       NOT NULL,
    CONSTRAINT PK_Payments        PRIMARY KEY (payment_id),
    CONSTRAINT UQ_Payments_order  UNIQUE (order_id),          -- 1:1 with Orders
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (order_id)
        REFERENCES Orders (order_id),
    CONSTRAINT CK_Payments_amount CHECK (amount >= 0),
    CONSTRAINT CK_Payments_method CHECK (method IN ('Credit Card', 'PayPal', 'COD'))
);
GO

-- 7) Reviews

CREATE TABLE Reviews (
    review_id   INT IDENTITY(1,1) NOT NULL,
    customer_id INT               NOT NULL,
    product_id  INT               NOT NULL,
    rating      INT               NOT NULL,
    comment     NVARCHAR(1000)    NULL,      -- optional
    review_date DATE              NOT NULL,
    CONSTRAINT PK_Reviews           PRIMARY KEY (review_id),
    CONSTRAINT FK_Reviews_Customers FOREIGN KEY (customer_id)
        REFERENCES Customers (customer_id),
    CONSTRAINT FK_Reviews_Products  FOREIGN KEY (product_id)
        REFERENCES Products (product_id),
    CONSTRAINT CK_Reviews_rating    CHECK (rating BETWEEN 1 AND 5)
);
GO

-- Quick check: all 7 tables should be listed
SELECT name AS table_name FROM sys.tables ORDER BY name;
GO


USE NovaCartDB;
GO


-- 1) Categories (10)

INSERT INTO Categories (category_name) VALUES
(N'Smartphones'),            -- 1
(N'Laptops & Computers'),    -- 2
(N'Audio & Headphones'),     -- 3
(N'Men''s Fashion'),         -- 4
(N'Women''s Fashion'),       -- 5
(N'Home Appliances'),        -- 6
(N'Kitchen'),                -- 7
(N'Books'),                  -- 8
(N'Accessories'),            -- 9
(N'Gaming');                 -- 10
GO


-- 2) Customers (12)

INSERT INTO Customers (full_name, email, phone, home_address, join_date) VALUES
(N'Ahmed Hassan',  N'ahmed.hassan@example.com',    N'01012345678', N'15 Mostafa El-Nahas St, Nasr City, Cairo',        '2025-11-05'), -- 1
(N'Mona Ibrahim',  N'mona.ibrahim@example.com',    N'01123456789', N'8 Gamal Abdel Nasser St, Mansoura, Dakahlia',      '2025-12-18'), -- 2
(N'Omar Khaled',   N'omar.khaled@example.com',     N'01234567890', N'22 El-Horreya Rd, Alexandria',                     '2026-01-10'), -- 3
(N'Sara Mahmoud',  N'sara.mahmoud@example.com',    N'01098765432', N'5 El-Galaa St, Tanta, Gharbia',                    '2026-02-01'), -- 4
(N'Youssef Adel',  N'youssef.adel@example.com',    N'01156781234', N'31 Faisal St, Giza',                               '2026-02-14'), -- 5
(N'Nour El-Din',   N'nour.eldin@example.com',      N'01287654321', N'9 El-Gamaa St, Zagazig, Sharqia',                  '2026-03-09'), -- 6
(N'Hala Samir',    N'hala.samir@example.com',      N'01011223344', N'27 Corniche El-Nil, Maadi, Cairo',                 '2026-05-20'), -- 7
(N'Karim Fathy',   N'karim.fathy@example.com',     N'01122334455', N'3 Port Said St, Damietta',                         '2026-06-15'), -- 8
(N'Mariam Tarek',  N'mariam.tarek@example.com',    N'01233445566', N'18 El-Mahalla Rd, El-Mahalla El-Kubra, Gharbia',   '2026-08-22'), -- 9
(N'Mostafa Reda',  N'mostafa.reda@example.com',    N'01544556677', N'40 Sheikh Zayed Rd, 6th of October City, Giza',    '2026-09-03'), -- 10
(N'Dina Ashraf',   N'dina.ashraf@example.com',     N'01055667788', N'6 Abbas El-Akkad St, Nasr City, Cairo',            '2026-09-18'), -- 11
(N'Mona Ibrahim',  N'mona.ibrahim92@example.com',  N'01166778899', N'11 Salah Salem St, Ismailia',                      '2026-09-25'); -- 12 same name as customer 2, different person
GO


-- 3) Products (16)   columns: name, category_id, price, stock_quantity

INSERT INTO Products (name, category_id, price, stock_quantity) VALUES
(N'Samsung Galaxy A55 128GB',           1, 14500.00,  40), -- 1
(N'iPhone 15 128GB',                    1, 38000.00,  15), -- 2
(N'Lenovo IdeaPad 3 15.6"',             2, 21500.00,  22), -- 3
(N'HP Pavilion 14',                     2, 29900.00,  12), -- 4  never ordered
(N'Sony WH-CH520 Wireless Headphones',  3,  2400.00,  60), -- 5
(N'JBL Flip 6 Bluetooth Speaker',       3,  4200.00,  35), -- 6
(N'Men''s Cotton Polo Shirt',           4,   450.00, 120), -- 7
(N'Men''s Slim Fit Jeans',              4,   799.00,  90), -- 8
(N'Women''s Summer Dress',              5,   650.00,  75), -- 9
(N'Women''s Leather Handbag',           5,  1250.00,  30), -- 10 never ordered (same price as product 15)
(N'Fresh Front Load Washing Machine 8kg', 6, 12500.00,  10), -- 11
(N'Tornado Air Fryer 5L',               7,  3100.00,  45), -- 12 ordered, never reviewed
(N'Atomic Habits (Book)',               8,   320.00, 200), -- 13
(N'Clean Code (Book)',                  8,   750.00,  55), -- 14
(N'Anker Power Bank 20000mAh',          9,  1250.00,  80), -- 15
(N'DualSense Wireless Controller',     10,  2900.00,  28); -- 16
GO


-- 4) Orders (14)   columns: customer_id, order_date, status

INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2026-01-12', 'Delivered'),  -- 1
(2, '2026-01-25', 'Delivered'),  -- 2
(1, '2026-02-08', 'Delivered'),  -- 3
(3, '2026-02-19', 'Delivered'),  -- 4
(4, '2026-03-03', 'Delivered'),  -- 5
(5, '2026-03-21', 'Cancelled'),  -- 6
(2, '2026-04-10', 'Delivered'),  -- 7
(6, '2026-04-10', 'Delivered'),  -- 8  same date as order 7
(1, '2026-05-14', 'Delivered'),  -- 9
(7, '2026-06-02', 'Delivered'),  -- 10
(8, '2026-07-18', 'Delivered'),  -- 11
(3, '2026-08-05', 'Delivered'),  -- 12
(9, '2026-09-14', 'Shipped'),    -- 13
(6, '2026-09-28', 'Pending');    -- 14
GO


-- 5) OrderDetails (26)   columns: order_id, product_id, quantity, unit_price
--    unit_price = price at the time of purchase

INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
-- Order 1 (total 17,200)
(1,  1, 1, 15000.00),
(1, 15, 2,  1100.00),
-- Order 2 (total 1,300)
(2, 13, 2,   300.00),
(2, 14, 1,   700.00),
-- Order 3 (total 22,500)
(3,  3, 1, 22500.00),
-- Order 4 (total 2,948)
(4,  7, 3,   450.00),
(4,  8, 2,   799.00),
-- Order 5 (total 40,750)
(5,  2, 1, 39500.00),
(5, 15, 1,  1250.00),
-- Order 6 - cancelled (total 4,200)
(6,  6, 1,  4200.00),
-- Order 7 (total 5,800)
(7, 12, 1,  3300.00),
(7,  5, 1,  2500.00),
-- Order 8 (total 1,750)
(8,  9, 2,   650.00),
(8,  7, 1,   450.00),
-- Order 9 (total 18,800)
(9, 11, 1, 13000.00),
(9, 16, 2,  2900.00),
-- Order 10 (total 14,820)
(10,  1, 1, 14500.00),
(10, 13, 1,   320.00),
-- Order 11 (total 7,100)
(11, 16, 1,  2900.00),
(11,  6, 1,  4200.00),
-- Order 12 (total 6,050)
(12,  5, 2,  2400.00),
(12, 15, 1,  1250.00),
-- Order 13 (total 22,250)
(13,  3, 1, 21500.00),
(13, 14, 1,   750.00),
-- Order 14 (total 1,699)
(14,  8, 1,   799.00),
(14,  7, 2,   450.00);
GO


-- 6) Payments (14, one per order)
--    columns: order_id, payment_date, amount, method
--    COD payments are dated on delivery, a few days after the order
--    (payments 7 and 8 share the same payment_date on purpose)

INSERT INTO Payments (order_id, payment_date, amount, method) VALUES
(1,  '2026-01-12', 17200.00, 'Credit Card'),  -- 1
(2,  '2026-01-27',  1300.00, 'COD'),          -- 2
(3,  '2026-02-08', 22500.00, 'PayPal'),       -- 3
(4,  '2026-02-22',  2948.00, 'COD'),          -- 4
(5,  '2026-03-03', 40750.00, 'Credit Card'),  -- 5
(6,  '2026-03-21',  4200.00, 'PayPal'),       -- 6
(7,  '2026-04-10',  5800.00, 'Credit Card'),  -- 7
(8,  '2026-04-10',  1750.00, 'PayPal'),       -- 8  same date as payment 7
(9,  '2026-05-14', 18800.00, 'PayPal'),       -- 9
(10, '2026-06-02', 14820.00, 'Credit Card'),  -- 10
(11, '2026-07-22',  7100.00, 'COD'),          -- 11
(12, '2026-08-05',  6050.00, 'PayPal'),       -- 12
(13, '2026-09-14', 22250.00, 'PayPal'),       -- 13
(14, '2026-09-28',  1699.00, 'Credit Card');  -- 14
GO


-- 7) Reviews (16)   columns: customer_id, product_id, rating, comment, review_date
--    comment is optional (NULL allowed)

INSERT INTO Reviews (customer_id, product_id, rating, comment, review_date) VALUES
(1,  1, 5, N'Great phone, fast delivery and the camera is excellent.',          '2026-01-20'),
(2, 13, 5, N'Practical and easy to read. Highly recommended.',                  '2026-02-05'),
(2, 14, 4, NULL,                                                                '2026-02-06'),
(1,  3, 4, N'Solid laptop for study and office work. The fan is a bit loud.',   '2026-02-18'),
(3,  7, 3, N'Fabric is fine but the size runs small.',                          '2026-03-01'),
(3,  8, 2, N'Faded after two washes. Not worth the price.',                     '2026-03-02'),
(4,  2, 5, N'Exactly as described. Original and sealed.',                       '2026-03-12'),
(4, 15, 1, N'Stopped charging after one week.',                                 '2026-03-20'),
(2,  5, 4, NULL,                                                                '2026-04-22'),
(6,  9, 5, N'Beautiful fabric and the colour matches the photos.',              '2026-05-08'),
(1, 11, 3, N'Works well but installation took a week to schedule.',             '2026-05-30'),
(1, 16, 5, NULL,                                                                '2026-05-30'),
(7, 13, 4, N'Great read for beginners.',                                        '2026-06-15'),
(7,  1, 4, NULL,                                                                '2026-06-20'),
(8,  6, 5, N'Loud and clear sound, great for the balcony.',                     '2026-08-01'),
(3,  5, 2, N'Sound is okay but the ear cups hurt after an hour.',               '2026-08-20');
GO


-- Sanity checks

-- Row count per table (each must be at least 10)
SELECT 'Categories'   AS table_name, COUNT(*) AS row_count FROM Categories   UNION ALL
SELECT 'Customers',                  COUNT(*)              FROM Customers    UNION ALL
SELECT 'Products',                   COUNT(*)              FROM Products     UNION ALL
SELECT 'Orders',                     COUNT(*)              FROM Orders       UNION ALL
SELECT 'OrderDetails',               COUNT(*)              FROM OrderDetails UNION ALL
SELECT 'Payments',                   COUNT(*)              FROM Payments     UNION ALL
SELECT 'Reviews',                    COUNT(*)              FROM Reviews;
GO

-- Payment amount must equal the order total: expected result = 0 rows
SELECT p.order_id, p.amount AS paid, t.order_total
FROM Payments AS p
JOIN (
    SELECT order_id, SUM(quantity * unit_price) AS order_total
    FROM OrderDetails
    GROUP BY order_id
) AS t ON t.order_id = p.order_id
WHERE p.amount <> t.order_total;
GO
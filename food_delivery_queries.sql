-- ==============================================================================
-- SQL Queries For Demonstration
-- ==============================================================================

USE food_delivery_db;

-- ---------------------------------------------------------
-- BASIC QUERIES (SELECT, WHERE, ORDER BY, DISTINCT, LIKE)
-- ---------------------------------------------------------

-- List all restaurants sorted by rating in descending order.
SELECT name, address, rating_avg 
FROM Restaurant 
ORDER BY rating_avg DESC;

-- List all available food items.
SELECT name, price 
FROM Food_Item 
WHERE is_available = TRUE;

-- Find food items priced between 100 and 300.
SELECT name, price 
FROM Food_Item 
WHERE price BETWEEN 100 AND 300;

-- ---------------------------------------------------------
-- AGGREGATE QUERIES (COUNT, SUM, AVG, MIN, MAX, GROUP BY)
-- ---------------------------------------------------------

-- Find the cheapest and most expensive food items.
SELECT MIN(price) AS cheapest_item, MAX(price) AS expensive_item 
FROM Food_Item;

-- Calculate the total revenue generated from all delivered orders.
SELECT SUM(total_amount) AS total_revenue 
FROM Orders 
WHERE order_status = 'Delivered';

-- Find the average order value across all orders.
SELECT AVG(total_amount) AS avg_order_value 
FROM Orders;

-- ---------------------------------------------------------
-- JOIN QUERIES (INNER, LEFT, MULTIPLE TABLES)
-- ---------------------------------------------------------

-- Find all food items belonging to a particular category (e.g., 'Main Course').
SELECT f.name, f.price, c.name AS category 
FROM Food_Item f
INNER JOIN Category c ON f.category_id = c.category_id
WHERE c.name = 'Main Course';

-- Find all orders placed by a specific customer (e.g., 'Alice Smith').
SELECT o.order_id, o.order_date, o.total_amount 
FROM Orders o
INNER JOIN Customer c ON o.customer_id = c.customer_id
WHERE c.name = 'Alice Smith';

-- Generate a complete order invoice (Multiple Table JOIN).
SELECT o.order_id, c.name AS customer, r.name AS restaurant, 
       f.name AS item, oi.quantity, oi.subtotal, o.total_amount
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Restaurant r ON o.restaurant_id = r.restaurant_id
JOIN Order_Item oi ON o.order_id = oi.order_id
JOIN Food_Item f ON oi.item_id = f.item_id
WHERE o.order_id = 1;

-- ==============================================================================
-- Online Food Ordering & Delivery System - Complete MySQL Database Script
-- ==============================================================================

-- 1. Database Creation
DROP DATABASE IF EXISTS food_delivery_db;
CREATE DATABASE food_delivery_db;
USE food_delivery_db;

-- ==============================================================================
-- ============================ Table Creation ==================================
-- ==============================================================================

CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Restaurant (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    rating_avg DECIMAL(3,2) DEFAULT 0.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE Food_Item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE RESTRICT
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    order_status ENUM('Pending', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id) ON DELETE RESTRICT
);

CREATE TABLE Order_Item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Food_Item(item_id) ON DELETE RESTRICT
);

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Credit Card', 'Debit Card', 'UPI', 'Cash on Delivery') NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Delivery_Partner (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    vehicle_details VARCHAR(50),
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE Delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    partner_id INT NOT NULL,
    delivery_status ENUM('Assigned', 'Picked Up', 'Delivered') DEFAULT 'Assigned',
    assigned_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    delivered_time DATETIME NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (partner_id) REFERENCES Delivery_Partner(partner_id) ON DELETE RESTRICT
);

CREATE TABLE Review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id) ON DELETE CASCADE,
    UNIQUE (customer_id, restaurant_id) -- A customer can only leave one review per restaurant
);

-- ==============================================================================
-- ============================== Index Creation ================================
-- ==============================================================================

CREATE INDEX idx_customer_email ON Customer(email);
CREATE INDEX idx_food_restaurant ON Food_Item(restaurant_id);
CREATE INDEX idx_food_category ON Food_Item(category_id);
CREATE INDEX idx_order_customer ON Orders(customer_id);
CREATE INDEX idx_order_restaurant ON Orders(restaurant_id);
CREATE INDEX idx_order_date ON Orders(order_date);
CREATE INDEX idx_order_status ON Orders(order_status);
CREATE INDEX idx_delivery_partner ON Delivery(partner_id);

-- ==============================================================================
-- ============================== Sample Data Insertion =========================
-- ==============================================================================

-- Insert Customers
INSERT INTO Customer (name, email, phone, address) VALUES 
('Alice Smith', 'alice@example.com', '9876543210', '123 Main St, Springfield'),
('Bob Johnson', 'bob@example.com', '9876543211', '456 Elm St, Springfield'),
('Charlie Brown', 'charlie@example.com', '9876543212', '789 Oak St, Springfield'),
('Diana Prince', 'diana@example.com', '9876543213', '101 Pine St, Springfield'),
('Evan Wright', 'evan@example.com', '9876543214', '202 Maple St, Springfield'),
('Fiona Gallagher', 'fiona@example.com', '9876543215', '303 Cedar St, Springfield'),
('George Miller', 'george@example.com', '9876543216', '404 Birch St, Springfield'),
('Hannah Abbott', 'hannah@example.com', '9876543217', '505 Spruce St, Springfield'),
('Ian Somerhalder', 'ian@example.com', '9876543218', '606 Walnut St, Springfield'),
('Jane Doe', 'jane@example.com', '9876543219', '707 Ash St, Springfield');

-- Insert Restaurants
INSERT INTO Restaurant (name, email, phone, address, rating_avg) VALUES 
('Spicy Corner', 'contact@spicycorner.com', '1112223330', '10 Downtown, Springfield', 4.5),
('Burger Hub', 'hello@burgerhub.com', '1112223331', '20 Uptown, Springfield', 4.2),
('Vegan Delight', 'info@vegandelight.com', '1112223332', '30 Midtown, Springfield', 4.8),
('Pasta Palace', 'ciao@pastapalace.com', '1112223333', '40 Westside, Springfield', 4.0),
('Sushi Zen', 'sushi@zen.com', '1112223334', '50 Eastside, Springfield', 4.7);

-- Insert Categories
INSERT INTO Category (name, description) VALUES 
('Starters', 'Appetizers and quick bites'),
('Main Course', 'Heavy meals and entrees'),
('Desserts', 'Sweet treats and cakes'),
('Beverages', 'Cold and hot drinks'),
('Vegan', '100% plant-based items'),
('Fast Food', 'Burgers, fries, and quick meals');

-- Insert Food Items
INSERT INTO Food_Item (restaurant_id, category_id, name, description, price, is_available) VALUES 
(1, 1, 'Paneer Tikka', 'Grilled cottage cheese cubes', 250.00, TRUE),
(1, 2, 'Chicken Curry', 'Spicy traditional chicken curry', 350.00, TRUE),
(1, 4, 'Mango Lassi', 'Sweet mango yogurt drink', 100.00, TRUE),
(2, 6, 'Cheese Burger', 'Classic beef burger with cheese', 150.00, TRUE),
(2, 6, 'French Fries', 'Crispy salted fries', 80.00, TRUE),
(2, 4, 'Cola', 'Chilled soft drink', 50.00, TRUE),
(3, 5, 'Quinoa Salad', 'Healthy bowl of quinoa and veggies', 200.00, TRUE),
(3, 5, 'Vegan Wrap', 'Soy protein in a whole wheat wrap', 180.00, TRUE),
(4, 2, 'Alfredo Pasta', 'Creamy white sauce pasta', 280.00, TRUE),
(4, 1, 'Garlic Bread', 'Toasted bread with garlic butter', 120.00, TRUE),
(4, 3, 'Tiramisu', 'Italian coffee-flavored dessert', 220.00, TRUE),
(5, 2, 'Salmon Sushi', 'Fresh salmon rolls', 400.00, TRUE),
(5, 1, 'Miso Soup', 'Traditional Japanese soup', 150.00, TRUE),
(1, 2, 'Mutton Biryani', 'Aromatic rice with tender mutton', 450.00, TRUE),
(2, 6, 'Chicken Wings', 'Spicy fried wings', 250.00, TRUE);

-- Insert Orders (Total Amount initially set to 0, will be updated via triggers or manually for sample)
INSERT INTO Orders (customer_id, restaurant_id, order_date, order_status, total_amount) VALUES 
(1, 1, '2023-10-01 12:30:00', 'Delivered', 700.00),
(2, 2, '2023-10-02 14:15:00', 'Delivered', 280.00),
(3, 3, '2023-10-02 19:45:00', 'Delivered', 380.00),
(4, 4, '2023-10-03 20:00:00', 'Out for Delivery', 400.00),
(5, 5, '2023-10-04 13:00:00', 'Pending', 550.00),
(1, 2, '2023-10-05 18:30:00', 'Cancelled', 150.00),
(6, 1, '2023-10-06 21:00:00', 'Delivered', 350.00),
(7, 4, '2023-10-07 13:30:00', 'Preparing', 620.00);

-- Insert Order Items
INSERT INTO Order_Item (order_id, item_id, quantity, unit_price) VALUES 
(1, 1, 1, 250.00),
(1, 14, 1, 450.00),
(2, 4, 1, 150.00),
(2, 5, 1, 80.00),
(2, 6, 1, 50.00),
(3, 7, 1, 200.00),
(3, 8, 1, 180.00),
(4, 9, 1, 280.00),
(4, 10, 1, 120.00),
(5, 12, 1, 400.00),
(5, 13, 1, 150.00),
(6, 4, 1, 150.00),
(7, 2, 1, 350.00),
(8, 9, 2, 280.00),
(8, 6, 1, 60.00);

-- Insert Payments
INSERT INTO Payment (order_id, amount, payment_method, payment_status, payment_date) VALUES 
(1, 700.00, 'UPI', 'Completed', '2023-10-01 12:35:00'),
(2, 280.00, 'Credit Card', 'Completed', '2023-10-02 14:17:00'),
(3, 380.00, 'Debit Card', 'Completed', '2023-10-02 19:47:00'),
(4, 400.00, 'Cash on Delivery', 'Pending', '2023-10-03 20:00:00'),
(5, 550.00, 'UPI', 'Completed', '2023-10-04 13:02:00'),
(6, 150.00, 'Credit Card', 'Refunded', '2023-10-05 18:35:00'),
(7, 350.00, 'UPI', 'Completed', '2023-10-06 21:05:00'),
(8, 620.00, 'Credit Card', 'Completed', '2023-10-07 13:32:00');

-- Insert Delivery Partners
INSERT INTO Delivery_Partner (name, phone, vehicle_details, is_available) VALUES 
('Ramesh Kumar', '9988776655', 'Bike - MH12AB1234', TRUE),
('Suresh Singh', '9988776656', 'Scooter - MH12CD5678', FALSE),
('John Doe', '9988776657', 'Bike - MH12EF9012', TRUE);

-- ==============================================================================
-- ============================= Views Creation =================================
-- ==============================================================================

-- View 1: Order Summary
CREATE OR REPLACE VIEW View_Order_Summary AS
SELECT 
    o.order_id,
    c.name AS customer_name,
    r.name AS restaurant_name,
    o.order_date,
    o.total_amount,
    o.order_status
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Restaurant r ON o.restaurant_id = r.restaurant_id;


-- View 2: Restaurant Sales Summary
CREATE OR REPLACE VIEW View_Restaurant_Sales AS
SELECT 
    r.restaurant_id,
    r.name AS restaurant_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value
FROM Restaurant r
LEFT JOIN Orders o ON r.restaurant_id = o.restaurant_id AND o.order_status != 'Cancelled'
GROUP BY r.restaurant_id, r.name;

-- View 3: Food Item Popularity
CREATE OR REPLACE VIEW View_Food_Popularity AS
SELECT 
    f.item_id,
    f.name AS food_item,
    r.name AS restaurant_name,
    SUM(oi.quantity) AS total_quantity_sold,
    COUNT(DISTINCT oi.order_id) AS number_of_orders
FROM Food_Item f
JOIN Restaurant r ON f.restaurant_id = r.restaurant_id
LEFT JOIN Order_Item oi ON f.item_id = oi.item_id
GROUP BY f.item_id, f.name, r.name
ORDER BY total_quantity_sold DESC;


-- ==============================================================================
-- ============================== Stored Procedures =============================
-- ==============================================================================

DELIMITER //



DELIMITER;


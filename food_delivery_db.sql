--customers info 
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
--restaurants info 
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

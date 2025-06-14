INSERT INTO Customers (FirstName, LastName, Email, PasswordHash, PhoneNumber, Address) VALUES
('Aarav', 'Sharma', 'aarav.sharma@gmail.com', 'hashed_password_1', '9876543210', '123 MG Road, Bangalore, Karnataka'),
('Vivaan', 'Patel', 'vivaan.patel@gmail.com', 'hashed_password_2', '9876543211', '456 1st Main, Mumbai, Maharashtra'),
('Aditya', 'Singh', 'aditya.singh@gmail.com', 'hashed_password_3', '9876543212', '789 2nd Cross, Delhi, Delhi'),
('Vihaan', 'Kumar', 'vihaan.kumar@gmail.com', 'hashed_password_4', '9876543213', '101 3rd Floor, Chennai, Tamil Nadu'),
('Reyansh', 'Iyer', 'reyansh.iyer@gmail.com', 'hashed_password_5', '9876543214', '202 4th Street, Hyderabad, Telangana'),
('Krishna', 'Nair', 'krishna.nair@gmail.com', 'hashed_password_6', '9876543215', '303 5th Avenue, Pune, Maharashtra'),
('Sai', 'Reddy', 'sai.reddy@gmail.com', 'hashed_password_7', '9876543216', '404 6th Lane, Ahmedabad, Gujarat'),
('Anaya', 'Desai', 'anaya.desai@gmail.com', 'hashed_password_8', '9876543217', '505 7th Block, Kolkata, West Bengal'),
('Tanish', 'Yadav', 'tanish.yadav@gmail.com', 'hashed_password_9', '9876543218', '606 8th Sector, Jaipur, Rajasthan'),
('Diya', 'Mehta', 'diya.mehta@gmail.com', 'hashed_password_10', '9876543219', '707 9th Road, Surat, Gujarat');

INSERT INTO Sellers (CompanyName, ContactName, Email, PhoneNumber, Address) VALUES
('Shree Ganesh Traders', 'Amit Kumar', 'amit.kumar@gmail.com', '9876543215', '100 Old City Road, Bangalore, Karnataka'),
('Krishna Enterprises', 'Ravi Sharma', 'ravi.sharma@gmail.com', '9876543216', '200 New Market, Mumbai, Maharashtra'),
('Tech World', 'Neha Gupta', 'neha.gupta@gmail.com', '9876543217', '300 Electronics Market, Delhi'),
('Fresh Organic Farms', 'Sanjay Singh', 'sanjay.singh@gmail.com', '9876543218', '400 Green Valley, Chennai, Tamil Nadu'),
('Gadget Store', 'Priya Iyer', 'priya.iyer@gmail.com', '9876543219', '500 High Street, Hyderabad, Telangana'),
('Fashion Hub', 'Snehal Reddy', 'snehal.reddy@gmail.com', '9876543200', '600 Fashion Street, Pune, Maharashtra'),
('Home Essentials', 'Vikram Patel', 'vikram.patel@gmail.com', '9876543201', '700 Main Bazaar, Ahmedabad, Gujarat'),
('Books and More', 'Anjali Desai', 'anjali.desai@gmail.com', '9876543202', '800 Book Lane, Kolkata, West Bengal'),
('Gadgets and Gizmos', 'Rahul Yadav', 'rahul.yadav@gmail.com', '9876543203', '900 2nd Avenue, Jaipur, Rajasthan'),
('Toys Factory', 'Ritesh Mehta', 'ritesh.mehta@gmail.com', '9876543204', '1000 3rd Block, Surat, Gujarat');

INSERT INTO Products (SellerID, ProductName, Price, Stock, CategoryName) VALUES
(1, 'Widget A', 599.99, 100, 'Widgets'),
(1, 'Widget B', 899.99, 150, 'Widgets'),
(2, 'Organic Apples', 120.00, 200, 'Groceries'),
(2, 'Organic Bananas', 60.00, 150, 'Groceries'),
(3, 'Smartphone X', 69999.00, 50, 'Electronics'),
(3, 'Smartphone Y', 29999.00, 100, 'Electronics'),
(4, 'Kitchen Blender', 3999.99, 75, 'Appliances'),
(4, 'Coffee Maker', 5999.99, 60, 'Appliances'),
(5, 'Casual Sneakers', 2999.99, 120, 'Footwear'),
(5, 'Formal Shoes', 3999.99, 80, 'Footwear'),
(6, 'Men\'s T-Shirt', 799.99, 200, 'Clothing'),
(6, 'Women\'s Dress', 2999.99, 50, 'Clothing'),
(7, 'Camping Tent', 14999.99, 20, 'Outdoor Gear'),
(7, 'Sleeping Bag', 1999.99, 40, 'Outdoor Gear'),
(8, 'Fiction Novel', 499.99, 300, 'Books'),
(8, 'Cookbook', 799.99, 100, 'Books');

INSERT INTO Orders (CustomerID, OrderDate, Status, ShippingAddress, TrackingNumber, ProductID, Quantity, Price, Discount) VALUES
(1, '2024-11-01 10:00:00', 'Shipped', '123 MG Road, Bangalore, Karnataka', 'TRACK123', 1, 2, 1199.98, 0),
(1, '2024-11-02 11:00:00', 'Pending', '123 MG Road, Bangalore, Karnataka', 'TRACK124', 3, 1, 69999.00, 0),
(2, '2024-11-03 12:30:00', 'Delivered', '456 1st Main, Mumbai, Maharashtra', 'TRACK125', 2, 5, 300.00, 0),
(3, '2024-11-04 14:15:00', 'Shipped', '789 2nd Cross, Delhi', 'TRACK126', 4, 3, 11999.97, 5.00),
(4, '2024-11-05 16:45:00', 'Delivered', '101 3rd Floor, Chennai, Tamil Nadu', 'TRACK127', 5, 1, 5999.99, 0),
(5, '2024-11-06 09:30:00', 'Pending', '202 4th Street, Hyderabad, Telangana', 'TRACK128', 6, 2, 1599.98, 0),
(1, '2024-11-07 11:00:00', 'Shipped', '123 MG Road, Bangalore, Karnataka', 'TRACK129', 8, 3, 1499.97, 0),
(2, '2024-11-08 12:00:00', 'Delivered', '456 1st Main, Mumbai, Maharashtra', 'TRACK130', 7, 1, 3999.99, 0),
(3, '2024-11-09 13:15:00', 'Pending', '789 2nd Cross, Delhi', 'TRACK131', 5, 2, 1599.98, 0),
(4, '2024-11-10 14:30:00', 'Shipped', '101 3rd Floor, Chennai, Tamil Nadu', 'TRACK132', 9, 1, 499.99, 0),
(5, '2024-11-11 15:45:00', 'Delivered', '202 4th Street, Hyderabad, Telangana', 'TRACK133', 2, 4, 800.00, 0),
(6, '2024-11-12 10:00:00', 'Pending', '78 Green Road, Pune, Maharashtra', 'TRACK134', 10, 1, 2500.00, 0),
(7, '2024-11-13 11:30:00', 'Shipped', '45 Blue Street, Kolkata, West Bengal', 'TRACK135', 11, 2, 1500.00, 0),
(8, '2024-11-14 12:00:00', 'Delivered', '89 Yellow Lane, Jaipur, Rajasthan', 'TRACK136', 12, 1, 3000.00, 0),
(9, '2024-11-15 13:00:00', 'Shipped', '67 Red Avenue, Surat, Gujarat', 'TRACK137', 13, 3, 1800.00, 0),
(10, '2024-11-16 14:00:00', 'Pending', '34 Purple Boulevard, Ahmedabad, Gujarat', 'TRACK138', 14, 2, 750.00, 0);

INSERT INTO Payments (OrderID, Amount, PaymentMethod, PaymentDate) VALUES
(1, 1199.98, 'Credit Card', '2024-11-01 10:05:00'),
(2, 69999.00, 'Debit Card', '2024-11-02 11:05:00'),
(3, 300.00, 'PayPal', '2024-11-03 12:35:00'),
(4, 11999.97, 'Net Banking', '2024-11-04 14:20:00'),
(5, 5999.99, 'Credit Card', '2024-11-05 16:50:00'),
(6, 1599.98, 'Cash on Delivery', '2024-11-06 09:35:00'),
(7, 1499.97, 'Credit Card', '2024-11-07 11:05:00'),
(8, 3999.99, 'Debit Card', '2024-11-08 12:05:00'),
(9, 1599.98, 'PayPal', '2024-11-09 13:20:00'),
(10, 499.99, 'Net Banking', '2024-11-10 14:35:00');

INSERT INTO Cart (CustomerID, ProductID, Quantity, Price, Discount, AddedDate) VALUES
(1, 1, 2, 1199.98, 0, '2024-11-01 09:00:00'),
(1, 3, 1, 69999.00, 0, '2024-11-02 10:00:00'),
(2, 2, 5, 600.00, 0, '2024-11-03 11:00:00'),
(3, 4, 3, 11999.97, 5.00, '2024-11-04 12:00:00'),
(4, 5, 1, 5999.99, 0, '2024-11-05 13:00:00'),
(5, 6, 2, 1599.98, 0, '2024-11-06 14:00:00'),
(1, 8, 3, 1499.97, 0, '2024-11-07 15:00:00'),
(2, 7, 1, 3999.99, 0, '2024-11-08 16:00:00'),
(3, 10, 1, 499.99, 0, '2024-11-09 17:00:00'),
(4, 9, 1, 2999.99, 0, '2024-11-10 18:00:00');


INSERT INTO Customers (FirstName, LastName, Email, PasswordHash, PhoneNumber, Address) VALUES('Rakesh','Ramya','rrr@gmail.com','rrr','1234567890','123 Colony Hyderabad');
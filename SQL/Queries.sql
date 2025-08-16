-- 1. Login check (fixed)
SELECT CustomerID, PasswordHash 
FROM Customers 
WHERE Email = %s;

-- 2. Get customer details
SELECT * 
FROM Customers 
WHERE CustomerID = %s;

-- 3. Recent orders (last 5) with totals and discounts
SELECT 
    p.ProductName, 
    o.OrderDate, 
    o.Quantity, 
    SUM(o.Price * o.Quantity) AS TotalPrice,
    SUM(o.Price * o.Quantity - o.Discount) AS DiscountedPrice
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
JOIN Products p ON p.ProductID = o.ProductID
WHERE o.CustomerID = %s
GROUP BY p.ProductName, o.OrderDate, o.Quantity
ORDER BY o.OrderDate DESC
LIMIT 5;

-- 4. Items in customer’s cart
SELECT p.ProductName, c.Quantity, c.Price
FROM Cart c
JOIN Products p ON c.ProductID = p.ProductID
WHERE c.CustomerID = %s;

-- 5. Seller’s orders
SELECT 
    p.ProductName,
    o.Quantity,
    o.ShippingAddress
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE p.SellerID = %s;

-- 6. Seller’s product catalog
SELECT ProductName, Description, Price, Stock, CategoryName 
FROM Products 
WHERE SellerID = %s;

SELECT CustomerID, PasswordHash FROM Customers WHERE Email = ;

SELECT * FROM Customers WHERE CustomerID = %s;

SELECT 
    p.ProductName, 
    o.OrderDate, 
    o.Quantity, 
        SUM(o.Price * o.Quantity) AS TotalPrice,
        SUM(o.Price * o.Quantity - o.Discount) AS DiscountedPrice
    FROM 
        Orders o
    JOIN 
        Customers c ON c.CustomerID = o.CustomerID
    JOIN 
        Products p ON p.ProductID = o.ProductID
    WHERE 
        o.CustomerID = %s
    GROUP BY 
        p.ProductName, o.OrderDate, o.Quantity
    ORDER BY 
        o.OrderDate DESC
    LIMIT 5;
   
   
   SELECT p.ProductName, c.Quantity, c.Price
        FROM Cart c
        JOIN Products p ON c.ProductID = p.ProductID
        WHERE c.CustomerID = %s
        
        
 SELECT 
        p.ProductName,
        o.Quantity,
        o.ShippingAddress
    FROM 
        Orders o
    JOIN 
        Products p ON o.ProductID = p.ProductID
    WHERE 
        p.SellerID = %s
        
        
 SELECT ProductName, Description, Price, Stock, CategoryName 
        FROM Products 
        WHERE SellerID = %s
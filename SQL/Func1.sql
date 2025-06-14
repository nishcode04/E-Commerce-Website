
DELIMITER $$

CREATE FUNCTION GetCustomerOrderCount(input_customerID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE order_count INT;

    -- Count the number of orders placed by the customer with Status = 'Delivered'
    SELECT COUNT(*) INTO order_count
    FROM Orders
    WHERE CustomerID = input_customerID;

    RETURN order_count;
END $$

DELIMITER ;


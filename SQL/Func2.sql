DELIMITER $$

CREATE FUNCTION GetTotalCustomerSpending(customerID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE totalSpending DECIMAL(10,2);

    -- Calculate total spending by the customer across all orders
SELECT 
    SUM(p.Amount)
INTO totalSpending FROM
    Payments p
        JOIN
    Orders o ON p.OrderID = o.OrderID
WHERE
    o.CustomerID = customerID;

    RETURN totalSpending;
END $$

DELIMITER ;

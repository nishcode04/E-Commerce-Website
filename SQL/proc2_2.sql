	
DELIMITER $$
CREATE PROCEDURE Place_order(
    IN p_CustomerID INT,
    IN p_ProductID INT,
    IN p_Quantity INT
)
BEGIN
    DECLARE v_Price DECIMAL(10, 2);
    DECLARE v_TotalAmount DECIMAL(10, 2);
    DECLARE v_Stock INT;
    DECLARE v_ShippingAddress TEXT;
    DECLARE v_Discount DECIMAL(10, 2);
    
    -- Fetch Customer Address
    SELECT Address INTO v_ShippingAddress
    FROM Customers
    WHERE CustomerID = p_CustomerID;

    -- Fetch Product Stock, Price, and Discount
    SELECT Stock, Price INTO v_Stock, v_Price
    FROM Products
    WHERE ProductID = p_ProductID;
	
    select Discount into v_Discount from Cart where CustomerID = p_CustomerID; 
    IF v_Stock < p_Quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for the selected product.';
    ELSE
        -- Calculate Total Amount
        SET v_TotalAmount = (v_Price * p_Quantity) - v_Discount;

        -- Insert into Orders
        INSERT INTO Orders (CustomerID, ProductID, Quantity, Price, Discount, Status, ShippingAddress)
        VALUES (p_CustomerID, p_ProductID, p_Quantity, v_Price, v_Discount, 'Pending', v_ShippingAddress);

        -- Retrieve Order ID
        SELECT LAST_INSERT_ID() INTO @OrderID;

        -- Insert Payment Details (Assuming Cash on Delivery)
        INSERT INTO Payments (OrderID, Amount, PaymentMethod)
        VALUES (@OrderID, v_TotalAmount, 'Cash on Delivery');
    END IF;
    COMMIT;
END$$
DELIMITER ;

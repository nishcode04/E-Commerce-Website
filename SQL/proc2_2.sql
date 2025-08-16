DELIMITER $$

CREATE PROCEDURE Place_order(
    IN p_CustomerID INT,
    IN p_ProductID INT,
    IN p_Quantity INT
)
BEGIN
    DECLARE v_Price DECIMAL(10,2);
    DECLARE v_TotalAmount DECIMAL(10,2);
    DECLARE v_Stock INT;
    DECLARE v_ShippingAddress TEXT;
    DECLARE v_Discount DECIMAL(10,2) DEFAULT 0.00; -- default to 0 if no discount
    DECLARE v_OrderID INT;

    -- Fetch Customer Address
    SELECT Address INTO v_ShippingAddress
    FROM Customers
    WHERE CustomerID = p_CustomerID;

    -- Fetch Product Stock and Price
    SELECT Stock, Price INTO v_Stock, v_Price
    FROM Products
    WHERE ProductID = p_ProductID;

    -- Fetch Discount (if exists)
    SELECT COALESCE(Discount,0) INTO v_Discount
    FROM Cart
    WHERE CustomerID = p_CustomerID
    LIMIT 1;

    -- Check Stock Availability
    IF v_Stock < p_Quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for the selected product.';
    ELSE
        -- Calculate Total Amount
        SET v_TotalAmount = (v_Price * p_Quantity) - v_Discount;

        -- Insert into Orders
        INSERT INTO Orders (CustomerID, ProductID, Quantity, Price, Discount, Status, ShippingAddress)
        VALUES (p_CustomerID, p_ProductID, p_Quantity, v_Price, v_Discount, 'Pending', v_ShippingAddress);

        -- Get the new OrderID
        SET v_OrderID = LAST_INSERT_ID();

        -- Insert Payment Details
        INSERT INTO Payments (OrderID, Amount, PaymentMethod)
        VALUES (v_OrderID, v_TotalAmount, 'Cash on Delivery');
    END IF;
END$$

DELIMITER ;

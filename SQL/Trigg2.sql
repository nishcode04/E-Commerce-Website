DELIMITER //

CREATE TRIGGER UpdateStockAfterOrder
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    -- Retrieve the current stock for the product being ordered
    SELECT Stock INTO current_stock
    FROM Products
    WHERE ProductID = NEW.ProductID;

    -- Check if the stock is sufficient before updating (optional, to prevent negative stock)
    IF current_stock >= NEW.Quantity THEN
        -- Update the stock in the Products table by reducing the quantity ordered
        UPDATE Products
        SET Stock = Stock - NEW.Quantity
        WHERE ProductID = NEW.ProductID;
    ELSE
        -- If there's not enough stock, raise an error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock available for this product';
    END IF;
END;
//

DELIMITER ;

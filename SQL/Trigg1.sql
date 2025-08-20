DELIMITER $$

CREATE TRIGGER ApplyDiscountBasedOnOrderValue
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE total_order_value DECIMAL(10,2);

    -- Calculate the total value of the order (Quantity * Price)
    SET total_order_value = NEW.Quantity * NEW.Price;

    -- Check if the total order value exceeds $1000
    IF total_order_value > 1000 THEN
        -- Apply a 10% discount to the order
        SET NEW.Discount = 10;  -- 10% discount
    ELSE
        -- No discount if the order value is less than $1000
        SET NEW.Discount = 0;
    END IF;
END $$

DELIMITER ;

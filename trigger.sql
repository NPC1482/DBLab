DELIMITER //

CREATE TRIGGER trg_update_order_total
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET TotalAmount = (
        SELECT COALESCE(SUM(Quantity * UnitPrice), 0)
        FROM OrderDetails
        WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
END //

DELIMITER ;

DELIMITER //

DROP TRIGGER IF EXISTS trg_reduce_book_stock;
CREATE TRIGGER trg_reduce_book_stock
BEFORE INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE cur_stock INT DEFAULT 0;
    
    -- Lấy tồn kho hiện tại
    SELECT Stock INTO cur_stock FROM Books WHERE BookID = NEW.BookID;
    
    -- Kiểm tra sách có tồn tại không
    IF cur_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = CONCAT('Sách ', NEW.BookID, ' không tồn tại');
    END IF;
    
    -- Kiểm tra đủ hàng không
    IF cur_stock < NEW.Quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = CONCAT('Không đủ tồn kho cho sách ', NEW.BookID,
                                   ' (còn ', cur_stock, ', cần ', NEW.Quantity, ')');
    END IF;
    
    -- Trừ tồn kho
    UPDATE Books SET Stock = Stock - NEW.Quantity WHERE BookID = NEW.BookID;
    
END //

DELIMITER ;

DELIMITER //

DROP TRIGGER IF EXISTS trg_restore_book_stock;
CREATE TRIGGER trg_restore_book_stock
AFTER DELETE ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Books
    SET Stock = Stock + OLD.Quantity
    WHERE BookID = OLD.BookID;
END //

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS book_revenue;
CREATE FUNCTION book_revenue(p_book_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(12,2) DEFAULT 0;
    
    SELECT COALESCE(SUM(Quantity * UnitPrice), 0) INTO total
    FROM OrderDetails
    WHERE BookID = p_book_id;
    
    RETURN total;
END //

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS count_employee_orders;
CREATE FUNCTION count_employee_orders(p_emp_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE cnt INT DEFAULT 0;
    
    SELECT COUNT(*) INTO cnt
    FROM Orders
    WHERE EmployeeID = p_emp_id;
    
    RETURN cnt;
END //

DELIMITER ;
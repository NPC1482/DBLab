CREATE INDEX idx_book_title       ON Books (Title); 
CREATE INDEX idx_orderdetail_book ON OrderDetails (BookID); 
CREATE INDEX idx_order_customer   ON Orders (CustomerID); 
CREATE INDEX idx_order_employee   ON Orders (EmployeeID); 
CREATE INDEX idx_customer_name    ON Customers (Name); 
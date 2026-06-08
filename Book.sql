-- Chèn sách
INSERT INTO Books (Title, Author, Price, Stock) VALUES
('Dế Mèn Phiêu Lưu Ký', 'Tô Hoài', 75000, 20),
('Số Đỏ', 'Vũ Trọng Phụng', 85000, 15),
('Tắt Đèn', 'Ngô Tất Tố', 65000, 30),
('Chiếc Lá Cuối Cùng', 'O. Henry', 55000, 10),
('Nhà Giả Kim', 'Paulo Coelho', 90000, 25),
('Truyện Kiều', 'Nguyễn Du', 120000, 5),
('Bố Già', 'Mario Puzo', 110000, 8);
 
-- Chèn khách hàng
INSERT INTO Customers (Name, Phone, Email) VALUES 
('Nguyễn Văn A', '0901234567', 'a@gmail.com'), 
('Trần Thị B', '0912345678', 'b@gmail.com'), 
('Lê Văn C', '0987654321', 'c@gmail.com'), 
('Phạm Thị D', '0971234567', 'd@gmail.com'), 
('Hoàng Văn E', '0909876543', 'e@gmail.com'); 
 
-- Chèn nhân viên
INSERT INTO Employees (Name, Position, HireDate) VALUES 
('Nguyễn Thị Hoa', 'Nhân viên bán hàng', '2023-06-01'), 
('Trần Văn Hùng', 'Nhân viên bán hàng', '2024-01-15'), 
('Lê Thị Mai', 'Quản lý', '2022-03-10'), 
('Phạm Văn Nam', 'Nhân viên kho', '2024-09-01'); 
 
-- Chèn đơn hàng
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, TotalAmount) VALUES
(1, 1, '2026-01-15 10:30:00', 375000),
(2, 2, '2026-02-20 14:15:00', 375000),
(3, 1, '2026-03-05 09:45:00', 235000),
(1, 3, '2026-04-10 16:20:00', 40000),
(4, 2, '2026-05-01 11:00:00', 130000);
 
-- Chèn chi tiết đơn hàng
INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice) VALUES
(1,1,2,75000), (1,3,1,65000),
(2,4,1,55000), (2,5,2,90000),
(3,2,3,85000), (3,6,1,120000),
(4,5,1,90000), (4,7,1,110000),
(5,3,2,65000);
 
-- Cập nhật tổng tiền đơn hàng
UPDATE Orders o SET TotalAmount = (
    SELECT COALESCE(SUM(Quantity*UnitPrice),0)
    FROM OrderDetails od
    WHERE od.OrderID = o.OrderID
);
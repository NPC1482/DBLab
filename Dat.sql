-- Liệt kê toàn bộ sách, sắp xếp theo tên A→Z
SELECT BookID, Title, Author, Price, Stock
FROM Books
ORDER BY Title ASC;

--Tìm các cuốn sách có giá từ 80.000đ trở lên
SELECT Title, Author, Price
FROM Books
WHERE Price >= 80000
ORDER BY Price DESC;
 
-- Tìm khách hàng theo số điện thoại
SELECT CustomerID, Name, Phone, Email
FROM Customers
WHERE Phone = '0901234567';
 
-- Liệt kê nhân viên được tuyển dụng sau năm 2023
SELECT EmployeeID, Name, Position, HireDate
FROM Employees
WHERE HireDate > '2023-12-31'
ORDER BY HireDate ASC;
 
-- Liệt kê tất cả đơn hàng kèm tên khách hàng và tên nhân viên xử lý
SELECT 
    o.OrderID,
    c.Name      AS KhachHang,
    e.Name      AS NhanVien,
    o.OrderDate,
    o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
ORDER BY o.OrderDate ASC;

-- Liệt kê chi tiết từng đơn hàng kèm tên sách
SELECT 
    o.OrderID,
    c.Name          AS KhachHang,
    b.Title         AS TenSach,
    od.Quantity     AS SoLuong,
    od.UnitPrice    AS DonGia,
    od.Quantity * od.UnitPrice AS ThanhTien
FROM Orders o
JOIN Customers c    ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID  = od.OrderID
JOIN Books b        ON od.BookID   = b.BookID
ORDER BY o.OrderID, b.Title;

-- Tìm khách hàng chưa từng mua hàng (dùng LEFT JOIN)
SELECT c.CustomerID, c.Name, c.Phone, c.Email
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Tìm nhân viên chưa xử lý đơn hàng nào (dùng LEFT JOIN)
SELECT e.EmployeeID, e.Name, e.Position
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE o.OrderID IS NULL;
 
-- Thống kê doanh thu theo từng đầu sách
SELECT 
    b.Title,
    b.Author,
    COALESCE(SUM(od.Quantity), 0)               AS TongSoBan,
    COALESCE(SUM(od.Quantity * od.UnitPrice), 0) AS DoanhThu
FROM Books b
LEFT JOIN OrderDetails od ON b.BookID = od.BookID
GROUP BY b.BookID, b.Title, b.Author
ORDER BY DoanhThu DESC;

--. Thống kê doanh số theo từng nhân viên 
SELECT 
    e.EmployeeID,
    e.Name,
    e.Position,
    COUNT(o.OrderID)                AS SoDonXuLy,
    COALESCE(SUM(o.TotalAmount), 0) AS TongDoanhSo
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.Name, e.Position
ORDER BY TongDoanhSo DESC;
 
-- Khách hàng chi tiêu nhiều nhất
SELECT 
    c.CustomerID,
    c.Name,
    COUNT(DISTINCT o.OrderID)       AS SoDonHang,
    SUM(od.Quantity)                AS TongSachDaMua,
    SUM(od.Quantity * od.UnitPrice) AS TongChiTieu
FROM Customers c
JOIN Orders o       ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID  = od.OrderID
GROUP BY c.CustomerID, c.Name
ORDER BY TongChiTieu DESC;

-- Sách bán chạy nhất theo số lượng đã bán
SELECT 
    b.Title,
    b.Author,
    COALESCE(SUM(od.Quantity), 0) AS TongSoBan
FROM Books b
LEFT JOIN OrderDetails od ON b.BookID = od.BookID
GROUP BY b.BookID, b.Title, b.Author
ORDER BY TongSoBan DESC;
 
-- Tổng doanh thu toàn cửa hàng theo từng tháng
SELECT 
    YEAR(o.OrderDate)   AS Nam,
    MONTH(o.OrderDate)  AS Thang,
    COUNT(o.OrderID)    AS SoDon,
    SUM(o.TotalAmount)  AS DoanhThu
FROM Orders o
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY Nam, Thang;
 
-- Tìm sách có giá cao hơn giá trung bình của toàn bộ sách
SELECT Title, Author, Price
FROM Books
WHERE Price > (
    SELECT AVG(Price) FROM Books
)
ORDER BY Price DESC;

-- Tìm khách hàng có tổng chi tiêu cao hơn mức chi tiêu trung bình
SELECT c.Name, SUM(o.TotalAmount) AS TongChiTieu
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
HAVING SUM(o.TotalAmount) > (
    SELECT AVG(TongMoi)
    FROM (
        SELECT SUM(TotalAmount) AS TongMoi
        FROM Orders
        GROUP BY CustomerID
    ) AS Sub
)
ORDER BY TongChiTieu DESC;
 
-- Tìm sách chưa từng được bán
SELECT BookID, Title, Author, Stock
FROM Books
WHERE BookID NOT IN (
    SELECT DISTINCT BookID FROM OrderDetails
);

-- Tìm đơn hàng có tổng tiền cao nhất
SELECT 
    o.OrderID,
    c.Name      AS KhachHang,
    e.Name      AS NhanVien,
    o.OrderDate,
    o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE o.TotalAmount = (
    SELECT MAX(TotalAmount) FROM Orders
);
 
-- Cảnh báo sách tồn kho thấp (Stock ≤ 10)
SELECT 
    BookID,
    Title,
    Author,
    Price,
    Stock,
    CASE 
        WHEN Stock = 0        THEN 'Hết hàng'
        WHEN Stock <= 5       THEN 'Sắp hết — nhập ngay'
        WHEN Stock <= 10      THEN 'Tồn kho thấp'
    END AS TrangThai
FROM Books
WHERE Stock <= 10
ORDER BY Stock ASC;

-- Khách hàng mua từ 2 đơn trở lên và chi tiêu hơn 300.000đ
SELECT 
    c.CustomerID,
    c.Name,
    c.Phone,
    COUNT(DISTINCT o.OrderID)       AS SoDonHang,
    SUM(o.TotalAmount)              AS TongChiTieu
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name, c.Phone
HAVING COUNT(DISTINCT o.OrderID) >= 2
   AND SUM(o.TotalAmount) > 300000
ORDER BY TongChiTieu DESC;
 
-- Báo cáo tổng hợp toàn cửa hàng
SELECT 
    (SELECT COUNT(*) FROM Books)                        AS TongDauSach,
    (SELECT COUNT(*) FROM Customers)                    AS TongKhachHang,
    (SELECT COUNT(*) FROM Employees)                    AS TongNhanVien,
    (SELECT COUNT(*) FROM Orders)                       AS TongDonHang,
    (SELECT COALESCE(SUM(TotalAmount), 0) FROM Orders)  AS TongDoanhThu,
    (SELECT MAX(TotalAmount) FROM Orders)               AS DonLonNhat,
    (SELECT MIN(TotalAmount) FROM Orders)               AS DonNhoNhat,
    (SELECT AVG(TotalAmount) FROM Orders)               AS DoanhThuTrungBinh;

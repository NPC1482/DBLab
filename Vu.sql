--Câu 1: Liệt kê tất cả các cuốn sách có giá bán lớn hơn hoặc bằng 80000 và sắp xếp theo thứ tự giảm dần theo giá 

SELECT * 
FROM Books 
WHERE Price >= 80000 
ORDER BY Price DESC; 
  

--Câu 2: Tìm tất cả các cuốn sách của tác giả 'Tô Hoài' hoặc 'Nguyễn Du'   

SELECT * 
FROM Books 
WHERE Author IN ('Tô Hoài', 'Nguyễn Du'); 
   

--Câu 3: Tìm những cuốn sách mà tên sách có chứa chữ 'Tìm' hoặc chữ 'Kiếm'   

SELECT * 
FROM Books 
WHERE Title LIKE '%Tìm%'  
OR Title LIKE '%Kiếm%'; 
  

--Câu 4: Hiển thị tất cả cuốn sách có số lượng tồn kho nằm trong khoảng từ 10 đến 25 

SELECT * 
FROM Books 
WHERE Stock BETWEEN 10 AND 25; 

  
--Câu 5: Tìm cuốn sách có giá bán rẻ thứ nhì trong nhà sách   

SELECT * 
FROM Books 
ORDER BY Price ASC 
LIMIT 1 OFFSET 1;   
   

--Câu 6: Đếm xem mỗi tác giả có bao nhiêu đầu sách trong hệ thống và có tổng số lượng tồn kho của tác giả đó là bao nhiêu  

SELECT Author, COUNT(BookID) AS TotalTitles, SUM(Stock) AS TotalStock 
FROM Books 
GROUP BY Author; 
  

--Câu 7: Tìm những tác giả có từ 2 đầu sách trở lên trong cửa hàng   

SELECT Author, COUNT(BookID) AS TotalTitles 
FROM Books 
GROUP BY Author 
HAVING COUNT(BookID) >= 2; 
  

--Câu 8: Tính giá bán trung bình của các cuốn sách theo từng tác giả, nhưng chỉ hiển thị các tác giả có mức giá trung bình lớn hơn 70000 

SELECT Author, AVG(Price) AS AveragePrice 
FROM Books 
GROUP BY Author 
HAVING AVG(Price) > 70000; 

   
--Câu 9: Liệt kê danh sách các cuốn sách kèm theo tổng số lượng đã bán được của từng cuốn (kể cả những cuốn chưa bán được bản nào) 

SELECT b.BookID, b.Title, COALESCE(SUM(od.Quantity), 0) AS TotalSold 
FROM Books b 
LEFT JOIN OrderDetails od ON b.BookID = od.BookID 
GROUP BY b.BookID, b.Title 
ORDER BY TotalSold DESC; 

  
--Câu 10: Tìm những cuốn sách mang lại doanh thu cao nhất cho nhà sách 

SELECT b.BookID, b.Title, SUM(od.Quantity * od.UnitPrice) AS TotalRevenue 
FROM Books b 
JOIN OrderDetails od ON b.BookID = od.BookID 
GROUP BY b.BookID, b.Title 
ORDER BY TotalRevenue DESC; 

  
--Câu 11: Tìm những cuốn sách đã từng được mua bởi khách hàng 'Nguyễn Văn A' 

SELECT DISTINCT b.BookID, b.Title 
FROM Books b 
JOIN OrderDetails od ON b.BookID = od.BookID 
JOIN Orders o ON od.OrderID = o.OrderID 
JOIN Customers c ON o.CustomerID = c.CustomerID 
WHERE c.Name = 'Nguyễn Văn A'; 


--Câu 12: Tìm những cuốn sách được bán ra trong tháng 05 năm 2026 

SELECT DISTONCT b.BookID, b.Title, b.Author 
FROM Books b 
JOIN OrderDetails od ON o.BookID = od.BookID 
JOIN Orders o ON od.OrderID = o.OrderID 
WHERE MONTH(o.OrderDate) = 5 AND YEAR(o.OrderDate) = 2026; 

   
--Câu 13: Tìm tất cả các cuốn sách có giá bán cao hơn giá trung bình của tất cả sách trong cửa hàng 

SELECT * 
FROM Books 
WHERE Price > (SELECT AVG(Price) FROM Books);

  
--Câu 14: Lập danh sách các cuốn sách chưa từng có ai mua 

SELECT * 
FROM Books 
WHERE BookID NOT IN (SELECT DISTINCT BookID FROM OrderDetails); 

  
--Câu 15: Tìm những cuốn sách có số lượng tồn kho thấp hơn số lượng tồn kho của tất cả các cuốn sách do tác giả 'Nguyễn Du' sáng tác 

SELECT * 
FROM Books 
WHERE Stock < ALL ( 
    SELECT Stock 
    FROM Books 
    WHERE Author = 'Nguyễn Du');  

  
--Câu 16: Tìm những cuốn sách có giá bán bằng với giá bán của ít nhất một cuốn sách thực thể loại/tác giá của 'O.Henry' 

SELECT * 
FROM Books 
WHERE Price = ANY ( 
    SELECT Price 
    FROM Books 
    WHERE Author = 'O.Henry') 
AND Author <> O.Henry; 

   
--Câu 17: Với mỗi tác giả, hãy tìm cuốn sách có số lượng tồn kho lớn nhất của tác giả đó 

SELECT b1.BookID, b1.Title, b1.Author, b1.Stock 
FROM Books b1 
WHERE b1.Stock = ( 
    SELECT MAX(b2.Stock) 
    FROM Books b2 
    WHERE b2.Author = b1.Author 
); 

  
--Câu 18: Lập danh sách các cuốn sách có giá bán cao hơn giá bán trung bình của các cuốn sách thuộc cùng tác giả 

SELECT b1.BookID, b1.Title, b1.Author, b1.Price 
FROM Books b1 
WHERE b1.Price > ( 
    SELECT AVG(b2.Price) 
    FROM Books b2 
    WHERE b2.Author = b1.Author 
); 

  
--Câu 19: Sử dụng NOT EXISTS để tìm những cuốn sách chưa từng được bán ra  

SELECT b.BookID, b.Title, b.Author 
FROM Books b 
WHERE NOT EXISTS ( 
    SELECT 1 FROM OrderDetails od  
    WHERE b.BookID = od.BookID 
); 

  
--Câu 20: Tìm những cuốn sách xuất hiện trong mọi hóa đơn trong ngày '2026-05-01' 

SELECT b.BookID, b.Title 
FROM Books b 
JOIN OrderDetals od ON b.BookID = od.BookID 
JOIN Orders o ON od.OrderID = o.OrderID 
WHERE DATE(o.OrderDate) = '2026-05-01' 
GROUP BY b.BookID, b.Title 
HAVING COUNT(DISTINCT o.OrderID) = ( 
    SELECT COUNT(OrderID)  
    FROM Orders  
    WHERE DATE(OrderDate) = '2026-05-01' 
); 

--lab ในชั้นเรียนวันที่ 19 ส.ค. 2569

--ต้องการข้อมูล เลขที่ใบสั่งซื้อ และยอดเงินจำหน่ายสินค้าในใบสั่งซื้อนั้น
select orderID ,ProductID, UnitPrice, Quantity, discount,
		UnitPrice*Quantity*(1-discount) as Totalprice
from [Order Details]

--ต้องการ รหัส ชื่อเต็มพนักงาน(คำนำหน้า ชื่อ นามสกุล) ตำแหน่ง โทร ของพนักงาน
select EmployeeID,titleOfCourtesy+FirstName+space(2)+LastName as EmpName,Title,HomePhone
from Employees

--ต้องการ รหัสสินค้า ราคา จำนวนที่ขายได้ ยอดเงินที่ขายได้ เรีนวตามลำดับรหัสสินค้า
select ProductID, sum(quantity) as จำนวนที่ขายได้
		, sum(unitprice*quantity*(1-discount))  as ยอดเงินที่ขายได้
from [Order Details]
group by productid
order by sum(unitprice*quantity*(1-discount)) desc

--cast (25.65 AS int)) 
--ต้องการชื่อพนักงานและปีที่เข้าทำงาน
select titleOfCourtesy+FirstName+space(2)+LastName as EmpName, year(hiredate)+543 [ปีที่ พ.ศ. เข้าทำงาน]
from Employees

--รหัสสินค้า ชื่อสินค้า ราคา และ ช่วงราคา(สูง ปานกลาง ต่ำ)
select productid, productname, unitprice,
		case when unitprice >= 75 then 'High' 
			 when UnitPrice >= 35 then 'Medium'
			 else 'Low'
			end as pricelevel
from products

--การ join ตาราง ที่มีความสัมพันธ์กัน
--Join 2 ตาราง
--ต้องการชื่อสินค้าทั้งหมด และชื่อหมวดหมู่ของสินค้า
select products.productname, Categorier.CategoryName
from products as join Categorier as 
on products.CategoryID = Categorier.Categoryid

--หรือเขียนย่อ
select products.productname, Categorier.CategoryName
from products as join Categorier as 
on p.CategoryID = C.Categoryid

select p.productname, s.companyname as supplier
from products as p join Suppliers as s
on p.SupplierID = s.SupplierID

--Order แต่ละรายการเป็นของลูกค้ารายใด
select orderid, convert(varchar,orderdate,6) as [order date], companyname
from orders as o join customers as c
on o.customerid = c.CustomerID
order by 3 asc

--convert(varchar,6)

-- 1. ต้องการชื่อบริษัทขนส่ง และจำนวนใบสั่งซื้อที่เกี่ยวข้อง
SELECT s.CompanyName AS ShipperName,
       COUNT(o.OrderID) AS TotalOrders
FROM Orders AS o
JOIN Shippers AS s
    ON o.ShipVia = s.ShipperID
GROUP BY s.CompanyName;


-- 2.1 ต้องการชื่อเต็มพนักงาน และจำนวนใบสั่งซื้อที่เกี่ยวข้อง
SELECT e.EmployeeID,
       e.TitleOfCourtesy + e.FirstName + SPACE(2) + e.LastName AS EmpName,
       COUNT(o.OrderID) AS [จำนวนใบสั่งซื้อ]
FROM Employees AS e
JOIN Orders AS o
    ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID,
         e.TitleOfCourtesy,
         e.FirstName,
         e.LastName;


-- 2.2 ชื่อบริษัทลูกค้า ประเภทลูกค้า และจำนวนใบสั่งซื้อที่เกี่ยวข้อง
SELECT c.CompanyName AS [ชื่อบริษัทลูกค้า],
       c.ContactTitle AS [ประเภทลูกค้า],
       COUNT(o.OrderID) AS [จำนวนใบสั่งซื้อ]
FROM Customers AS c
JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName,
         c.ContactTitle;


-- 3.1 หมายเลขใบสั่งซื้อ และชื่อบริษัทขนส่ง
SELECT o.OrderID,
       s.CompanyName AS Shipper
FROM Orders AS o
JOIN Shippers AS s
    ON o.ShipVia = s.ShipperID;


-- 3.2 รหัสสินค้า ชื่อสินค้า และชื่อบริษัทผู้จำหน่าย (Supplier)
SELECT p.ProductID AS [รหัสสินค้า],
       p.ProductName AS [ชื่อสินค้า],
       s.CompanyName AS [ชื่อบริษัท]
FROM Products AS p
JOIN Suppliers AS s
    ON p.SupplierID = s.SupplierID;


-- 4. รหัสหมวดหมู่ ชื่อหมวดหมู่สินค้า และจำนวนชนิดสินค้าในแต่ละหมวดหมู่
SELECT c.CategoryID AS [รหัสหมวดหมู่],
       c.CategoryName AS [ชื่อหมวดหมู่สินค้า],
       COUNT(p.ProductID) AS [จำนวนชนิดสินค้า]
FROM Categories AS c
JOIN Products AS p
    ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID,
         c.CategoryName;


--การ join 3 ตารางขึ้นไป
--ต้องการหมายเลขใบสั่งซื้อ วันที่สั่งซื้อ บริษัทลูกค้า ชื่อสกุลพนักงานผู้ขาย
SELECT o.OrderID,
       CONVERT(VARCHAR, o.OrderDate, 6) AS [Order Date],c.CompanyName,
       e.FirstName + SPACE(2) + e.LastName AS EmpName
FROM Orders AS o
JOIN Customers AS c ON o.CustomerID = c.CustomerID
JOIN Employees AS e ON o.EmployeeID = e.EmployeeID;

--ต้องการรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย ชื่อหมวดหมู่ ชื่อบริษัทจำหน่าย
select productid, productname, unitprice, categoryname, companyname
from products p join categories c on p.CategoryID = c.CategoryID
                join Suppliers s on p.SupplierID = s.SupplierID

--ต้องการ รหัสหมวดหมู่ ชื่อหมวดหมู่ ยอดขายทั้งหมดในหมวดหมู่ แสดงเฉพาะยอดขายสูงสุด 3 อันดับแรก
select top 3
       c.CategoryID  ,
       c.CategoryName  ,
       sum(od.UnitPrice * od.Quantity * (1 - od.Discount))  
from Categories c JOIN Products  p on c.CategoryID = p.CategoryID
                  JOIN [Order Details]  od on p.ProductID = od.ProductID
group by c.CategoryID, c.CategoryName
order by 3 DESC;

--(4 ตาราง ) ในแต่ละรายการสั่งซื้อ มีบริษัทลูกค้าใดซื้อสินค้า ชื่ออะไร จำนวน และมียอดขายเท่าไร
select o.OrderID ,
       c.CompanyName ,
       p.ProductName ,
       od.Quantity  ,
       od.UnitPrice * od.Quantity * (1 - od.Discount) AS [ยอดขาย]
from Orders AS o JOIN Customers  c          on o.CustomerID = c.CustomerID
                 JOIN [Order Details]  od   on o.OrderID = od.OrderID
                 JOIN Products  p           on od.ProductID = p.ProductID;

--ลูกค้าบริษัทใด มีการซื้อค้าที่มาจากประเทศ USA บ้าง (5ตาราง)
SELECT DISTINCT
       c.CompanyName 
FROM Customers AS c JOIN Orders AS o  ON c.CustomerID = o.CustomerID
                    JOIN [Order Details] AS od ON o.OrderID = od.OrderID
                    JOIN Products AS p ON od.ProductID = p.ProductID
                    JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
WHERE s.Country = 'USA';


select * from [Order Details]

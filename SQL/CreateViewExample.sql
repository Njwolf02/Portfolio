CREATE TABLE Category
(
Category VARCHAR(30),
LOW INT NOT NULL,
HIGH INT NOT NULL
)

INSERT
INTO	A8_Category(Category, LOW, HIGH)
VALUES	('WEAK', 0, 200)

INSERT
INTO	A8_Category (Category, LOW, HIGH)
VALUES	('GOOD', 200, 800)

INSERT 
INTO	A8_Category (Category, LOW, HIGH)
VALUES	('BEST', 800, 10000)


CREATE VIEW Customer_Rankings AS
SELECT	C.CustomerID, C.LastName, C.FirstName, SUM(SI.SalePrice) as MercTotal, SUM(SA.SalePrice) as AnimalTotal, SUM( SI.SalePrice)+SUM( SA.SalePrice) AS Grandtotal
FROM	Customer C INNER JOIN Sale S
		ON C.CustomerID = S.CustomerID
		INNER JOIN SaleItem SI
		ON S.SaleID = SI.SaleID
		INNER JOIN SaleAnimal SA
		ON SA.SaleID = S.SaleID
GROUP BY C.CustomerID, C.LastName, C.FirstName

SELECT distinct	CustomerID, LastName, FirstName, Grandtotal, Category
FROM	Customer_Rankings, A8_Category
WHERE	A8_Category.HIGH > Customer_Rankings.Grandtotal and Customer_Rankings.Grandtotal > A8_Category.LOW 
ORDER BY	Grandtotal DESC

--12

Select	S.SupplierID, 'Animal' As Category
from	Supplier S inner join AnimalOrder AO
		ON S.SupplierID = AO.SupplierID
where	MONTH(ao.OrderDate) IN (6)
UNION ALL
Select	S.SupplierID, 'Merchandise' As Category
from	Supplier S inner join MerchandiseOrder MO
		ON S.SupplierID = MO.SupplierID
WHERE	MONTH(MO.OrderDate) IN (6)

CREATE TABLE Sale_Ordertype
(
Category VARCHAR(30),
IsNull	int
)

Drop	table	Sale_Ordertype

INSERT 
INTO	Sale_Ordertype(Category, ISNull)
VALUES	('Animal', 0 )

INSERT 
INTO	Sale_Ordertype(Category)
VALUES	('Merchandise')

Select * from   Sale_Ordertype

CREATE view [SUPPLIER_Order]	AS
SELECT	Supplier.Name AS SupplierName, AnimalOrder.SupplierID AS SupplierID
FROM	AnimalOrder FULL OUTER JOIN Supplier
		ON Supplier.SupplierID = AnimalOrder.SupplierID

select	*
from	SUPPLIER_Order

select *
from	SUPPLIER_Order, Sale_Ordertype
where	SUPPLIER_Order.SupplierID  > Sale_Ordertype.ISNULL
		and SUPPLIER_Order.SupplierID IS not Null
	
select * from Sale_Ordertype

DROP View SUPPLIER_ORDERTYPE

SELECT	Supplier.Name, AnimalOrder.SupplierID, Supplier.SupplierID AS ORDERTYPE
INTO	SUPPLIER_ORDERTYPE
FROM	AnimalOrder FULL OUTER JOIN Supplier
		ON Supplier.SupplierID = AnimalOrder.SupplierID

ALTER TABLE	SUPPLIER_ORDERTYPE
ALTER COLUMN	OrderType VARCHAR(20) NULL

UPDATE	SUPPLIER_ORDERTYPE
SET		OrderType = 'Animal'
where	SupplierID is NOT null

UPDATE	SUPPLIER_ORDERTYPE
SET		OrderType = 'Merchandise'
where	SupplierID is null

SELECT	Name, ORDERTYPE
FROM	SUPPLIER_ORDERTYPE 

--13
update A8_Category
set HIGH = 400
where Category = 'WEAK'

--14

DROP TABLE A8_Category

--15
DELETE TOP (1)
FROM A8_Category

--16
SELECT *
INTO EMPLOYEE_COPY
FROM Employee

DELETE
FROM EMPLOYEE_COPY

INSERT
INTO	EMPLOYEE_COPY
SELECT	* FROM Employee
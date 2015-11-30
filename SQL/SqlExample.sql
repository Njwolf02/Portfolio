--1.	List the products with a list price greater than the average list price of all products.

SELECT	ItemID, Description, ListPrice
FROM	Merchandise
WHERE	ListPrice > 
					(SELECT	AVG(ListPrice)
					 FROM	Merchandise
					)

--2.	Which merchandise items have an average sale price more than 50 percent higher than their average purchase cost?

SELECT	OI.ItemID, AVG(OI.Cost) AS AverageCost, AVG(s.SalePrice) AS AverageSalePrice
FROM	OrderItem OI INNER JOIN Merchandise M
		ON OI.ItemID = M.ItemID
		INNER JOIN SaleItem S
		ON M.ItemID = S.ItemID
WHERE	S.SalePrice > (
						SELECT	1.5* AVG(OI.Cost)
						FROM	OrderItem OI
						)
group by OI.ItemID

--3.	List the employees and their total merchandise sales expressed as a percentage of total merchandise sales for all employees.

SELECT	E.EmployeeID, E.LastName, SUM(SI.SALEPRICE) AS TotalSales, SUM(SI.SalePrice) / (SELECT SUM(SaleItem.SalePrice)
																						FROM SaleItem
																						)  AS PctSales
FROM	Employee E INNER JOIN Sale S
		ON E.EmployeeID = S.EmployeeID
		INNER JOIN SaleItem SI
		ON S.SaleID = SI.SaleID
GROUP BY	E.EmployeeID, E.LastName


--4. On average, which supplier charges the highest shipping cost as a percent of the merchandise order total?

SELECT TOP 1 S.SupplierID, S.Name, AVG(MO.ShippingCost / (O.Cost * O.Quantity)) AS PctShipCost
FROM	Supplier S INNER JOIN MerchandiseOrder MO
		ON S.SupplierID = MO.SupplierID
		INNER JOIN OrderItem O
		ON O.PONumber = MO.PONumber
GROUP BY S.SupplierID, S.Name
ORDER BY PctShipCost DESC

--5. Which customer has given us the most total money for animals and merchandise? 

SELECT	C.CustomerID, C.LastName, C.FirstName, SUM(SI.SalePrice) as MercTotal, SUM(SA.SalePrice) as AnimalTotal, SUM( SI.SalePrice)+SUM( SA.SalePrice) AS Grandtotal
FROM	Customer C INNER JOIN Sale S
		ON C.CustomerID = S.CustomerID
		INNER JOIN SaleItem SI
		ON S.SaleID = SI.SaleID
		INNER JOIN SaleAnimal SA
		ON SA.SaleID = S.SaleID
GROUP BY C.CustomerID, C.LastName, C.FirstName
HAVING	(SUM( SI.SalePrice)+SUM( SA.SalePrice)) = (SELECT TOP 1 (SUM( SI.SalePrice)+SUM( SA.SalePrice)) AS Grandtotal
														FROM	Customer C INNER JOIN Sale S
																ON C.CustomerID = S.CustomerID
																INNER JOIN SaleItem SI
																ON S.SaleID = SI.SaleID
																INNER JOIN SaleAnimal SA
																ON SA.SaleID = S.SaleID
													GROUP BY C.CustomerID, C.LastName, C.FirstName
													ORDER BY	SUM( SI.SalePrice)+SUM( SA.SalePrice) Desc
																)

--6. Which customers who bought more than $100 in merchandise in May also spent more than $50 on merchandise in October?

SELECT	C.CustomerID, C.LastName, C.FirstName, SUM(SI.SalePrice*SI.Quantity) AS MAYTOTAL
FROM	Customer C INNER JOIN Sale S
		ON C.CustomerID = S.CustomerID
		INNER JOIN SaleItem SI
		ON SI.SaleID = S.SaleID
WHERE	C.CustomerID IN (SELECT	C.CustomerID
						 FROM	Customer C INNER JOIN Sale S
								ON C.CustomerID = S.CustomerID
								INNER JOIN SaleItem SI
								ON SI.SaleID = S.SaleID
						 WHERE	C.CustomerID = S.CustomerID AND S.SaleDate BETWEEN '1-OCT-2004' AND '31-OCT-2004'
						 GROUP BY	C.CustomerID, C.LastName, C.FirstName, SaleDate
						 HAVING	50 < SUM( SI.SalePrice*SI.Quantity)
						 )
AND
SaleDate BETWEEN '1-MAY-2004' AND '30-MAY-2004'															
GROUP BY	C.CustomerID, C.LastName, C.FirstName
HAVING 100 < SUM(SalePrice*Quantity)

--7. What was the net change in quantity on hand for premium canned dog food between January 1 and July 1?

SELECT M.Description, M.ItemID, SUM( OI.Quantity) AS Purchased, SUM(SI.Quantity) as Sold,SUM(OI.QUANTITY) - SUM(SI.QUANTITY) as NetIncrease
FROM	Sale S INNER JOIN SaleItem SI
		ON S.SaleID = SI.SaleID
		INNER JOIN Merchandise M
		ON M.ItemID = SI.ItemID
		INNER JOIN OrderItem OI
		ON OI.ItemID = M.ItemID
WHERE	S.SaleDate BETWEEN '1-JAN-2004' AND '1-JUL-2004'AND
		OI.ItemID = 16
GROUP BY	M.Description, M.ItemID

--8. Which merchandise items with a list price of more than $50 had no sales July?

SELECT	M.ItemID, M.Description, M.ListPrice
FROM	Merchandise M INNER JOIN SaleItem SI
		ON M.ItemID = SI.ItemID
		INNER JOIN Sale S
		ON S.SaleID = SI.SaleID
WHERE	M.ListPrice > 50 AND  EXISTS		( SELECT *
												FROM	SALE
												WHERE S.SaleID = SI.SaleID AND NOT MONTH(S.SaleDate) IN (7)
											)
GROUP BY M.ItemID, M.Description, M.ListPrice

--9. Which merchandise items with more than 100 units on hand have not been ordered in 2004? Use an outer join to answer the question.

SELECT	M.ItemID, M.Description, M.QuantityOnHand, O.ItemID
FROM	Merchandise M FULL OUTER JOIN OrderItem O
		ON M.ItemID = O.ItemID
		FULL OUTER JOIN MerchandiseOrder MO
		ON O.PONumber = MO.PONumber
WHERE	M.QuantityOnHand > 100 AND MO.OrderDate IS NULL

--10	10.	Which merchandise items with more than 100 units on hand have not been ordered in 2004? Use a subquery to answer the question.
SELECT	ItemID, Description, QuantityOnHand, ItemID
FROM	Merchandise
WHERE	QuantityOnHand > 100 AND NOT EXISTS (SELECT *
											 FROM OrderItem
											 WHERE Merchandise.ItemID = OrderItem.ItemID
											 AND NOT EXISTS (SELECT *
															 FROM	MerchandiseOrder
															 WHERE	OrderItem.PONumber = MerchandiseOrder.PONumber AND MerchandiseOrder.OrderDate IS NULL))
											

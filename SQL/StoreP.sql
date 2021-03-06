USE [DATABASE_X]
GO
/****** Object:  StoredProcedure [dbo].[A11]    Script Date: 12/10/2014 8:22:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[A11]

AS
BEGIN

	SET NOCOUNT ON;

	--drop foreign key
	Alter table	Fact
	Drop constraint	FK_FACT_CUSTOMERDIM

	Alter table Fact
	Drop constraint	FK_FACT_PARTDIM

	Alter table Fact
	Drop constraint	FK_FACT_TIMEDIM

	--drop primary key
	Alter table	Fact
	Drop constraint	PK_FACT

	alter table	Customerdim
	drop constraint	PK_CUSTOMERDIM

	alter table timedim
	drop constraint	PK_TIMEDIM

	Alter table PartDim
	Drop constraint PK_PARTID

	--truncate tables
	truncate table	CustomerDim
	truncate table	PartDim
	truncate table	TimeDim
	truncate table	Fact
	truncate table	Staging

	--Add Primary Key
	Alter table	CustomerDim
	ADD constraint	PK_CUSTOMERDIM Primary Key (CustomerID)

	Alter table	PartDim
	ADD constraint	PK_PARTID Primary Key (PARTID)

	Alter table	TimeDim
	ADD constraint	PK_TIMEDIM Primary Key (TIMEID)

	Alter table	Fact
	ADD constraint	PK_FACT Primary Key (CUSTOMERID, PARTID, TIMEID)

	--add foreign
	Alter table Fact
	Add constraint FK_FACT_CUSTOMERDIM	Foreign Key (CustomerID)
	References	CUSTOMERDIM (CUSTOMERID)

	Alter table Fact
	Add constraint FK_FACT_PARTDIM	Foreign Key (PartID)
	References	PARTDIM (PartID)

	Alter table Fact
	Add constraint FK_FACT_TIMEDIM	Foreign Key (TimeID)
	References	TIMEDIM (TimeID)

	--pop Dim

	Insert INTO CustomerDim
	select	*
	from	CUSTOMER

	Insert into	PartDim
	select	PART_NUM, DESCRIPTION, CLASS, WAREHOUSE
	From	PART

	Insert into	timeDim
	select	ORDER_DATE, DATENAME(YEAR, order_date) As YEAR, DATENAME( MONTH, ORDER_DATE) AS MONTH
	from	ORDERS

	--pop the stage
	INSERT INTO Staging
		(Quoted_Price, Price, Customer_Num, Part_Num, Order_Date)
	SELECT	OI.QUOTED_PRICE, P.PRICE, C.CUSTOMER_NUM, P.PART_NUM, O.ORDER_DATE
	FROM	CUSTOMER C INNER JOIN ORDERS O
		ON C.CUSTOMER_NUM = O.CUSTOMER_NUM
		INNER JOIN ORDER_LINE OI
		ON O.ORDER_NUM = OI.ORDER_NUM
		INNER JOIN PART P
		ON P.PART_NUM = OI.PART_NUM
	
	UPDATE	Staging
	SET		CustomerID = C.CUSTOMERID
	FROM	Staging S INNER JOIN CustomerDim C
			ON S.Customer_Num = C.CUSTOMER_NUM

	UPDATE	Staging
	SET		PartID = P.PARTID
	FROM	Staging S INNER JOIN PartDim P
			ON S.Part_Num = P.PART_NUM

	UPDATE	Staging
	SET		TimeID = T.TIMEID
	FROM	Staging S INNER JOIN timeDim T
			ON S.Order_Date = T.ORDER_DATE

	Insert	into	FACT
	select	CustomerID, PartID, TimeID, Quoted_Price, Price
	From	Staging

END

	select	CustomerID, PartID, TimeID, Quoted_Price, Price
	From	Staging

END

USE [DATABASE_X]
GO
/****** Object:  Trigger [dbo].[A10]    Script Date: 11/29/2014 9:08:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[A10]
   ON  [dbo].[OrderItem]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
    DECLARE    @ITEM_ID VARCHAR(4)
    DECLARE @TOTAL INT

    --INSERT CASE
    IF(EXISTS (SELECT * FROM INSERTED) AND
       NOT EXISTS (SELECT * FROM DELETED))
    BEGIN
        DECLARE    INSERT_CURSOR CURSOR FOR
        SELECT    ItemID, SUM(Quantity) AS TOTAL
        FROM    INSERTED
        GROUP BY ItemID

        OPEN    INSERT_CURSOR
        FETCH NEXT FROM INSERT_CURSOR INTO @ITEM_ID, @TOTAL
        WHILE(@@FETCH_STATUS = 0)
        BEGIN
            UPDATE    Merchandise
            SET        QuantityOnHand = QuantityOnHand - @TOTAL
            WHERE    ItemID = @ITEM_ID
            FETCH NEXT FROM INSERT_CURSOR INTO @ITEM_ID, @TOTAL
        END
        CLOSE INSERT_CURSOR
        DEALLOCATE INSERT_CURSOR
    END
    --DELETE CASE
    IF(EXISTS (SELECT * FROM DELETED) AND
       NOT EXISTS (SELECT * FROM INSERTED))
    BEGIN
        DECLARE    DELETE_CURSOR CURSOR FOR
        SELECT    ItemID, SUM(Quantity) AS TOTAL
        FROM    DELETED
        GROUP BY ItemID

        OPEN    DELETE_CURSOR
        FETCH NEXT FROM DELETE_CURSOR INTO @ITEM_ID, @TOTAL
        WHILE(@@FETCH_STATUS = 0)
        BEGIN
            UPDATE    Merchandise
            SET        QuantityOnHand = QuantityOnHand + @TOTAL
            WHERE    ItemID = @ITEM_ID
            FETCH NEXT FROM DELETE_CURSOR INTO @ITEM_ID, @TOTAL
        END
        CLOSE DELETE_CURSOR
        DEALLOCATE DELETE_CURSOR
    END
    IF(EXISTS (SELECT * FROM DELETED) AND
       EXISTS (SELECT * FROM INSERTED))
    BEGIN
        DECLARE    UPDATE_CURSOR CURSOR FOR
        SELECT    I.ItemID, SUM(I.Quantity-D.Quantity) AS TOTAL
        FROM    DELETED D INNER JOIN INSERTED I
                ON D.ItemID = I.ItemID AND D.Quantity = I.Quantity
        GROUP BY I.ItemID

        OPEN    UPDATE_CURSOR
        FETCH NEXT FROM UPDATE_CURSOR INTO @ITEM_ID, @TOTAL
        WHILE(@@FETCH_STATUS = 0)
        BEGIN
            UPDATE    Merchandise
            SET        QuantityOnHand = QuantityOnHand - @TOTAL
            WHERE    ItemID = @ITEM_ID
            FETCH NEXT FROM UPDATE_CURSOR INTO @ITEM_ID, @TOTAL
        END
        CLOSE UPDATE_CURSOR
        DEALLOCATE UPDATE_CURSOR
    END

END
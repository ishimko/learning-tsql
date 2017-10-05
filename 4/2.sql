USE AdventureWorks2012;
GO

IF OBJECT_ID('[Production].[View_LocationProduct]') IS NOT NULL
  DROP VIEW [Production].[View_LocationProduct];
GO

IF OBJECT_ID('[Production].[Trigger_View_LocationProduct_Insert]') IS NOT NULL
  DROP TRIGGER [Production].[Trigger_View_LocationProduct_Insert];
GO

IF OBJECT_ID('[Production].[Trigger_View_LocationProduct_Update]') IS NOT NULL
  DROP TRIGGER [Production].[Trigger_View_LocationProduct_Update];
GO

IF OBJECT_ID('[Production].[Trigger_View_LocationProduct_Delete]') IS NOT NULL
  DROP TRIGGER [Production].[Trigger_View_LocationProduct_Delete];
GO


-- a
CREATE VIEW [Production].[View_LocationProduct] (
    [LocationID],
    [Name],
    [CostRate],
    [Availability],
    [LocationModifiedDate],
    [ProductID],
    [Shelf],
    [Bin],
    [Quantity],
    [ProductInventoryModifiedDate],
    [ProductName]
)
  WITH ENCRYPTION, SCHEMABINDING AS
  SELECT
    [l].[LocationID],
    [l].[Name],
    [l].[CostRate],
    [l].[Availability],
    [l].[ModifiedDate],
    [pi].[ProductID],
    [pi].[Shelf],
    [pi].[Bin],
    [pi].[Quantity],
    [pi].[ModifiedDate],
    [p].[Name]
  FROM [Production].[Location] AS [l]
    JOIN [Production].[ProductInventory] AS [pi] ON [l].[LocationID] = [pi].[LocationID]
    JOIN [Production].[Product] AS [p] ON [p].[ProductID] = [pi].[ProductID];
GO


CREATE UNIQUE CLUSTERED INDEX [AK_View_LocationProduct_LocationID_ProductID]
  ON [Production].[View_LocationProduct] ([LocationID], [ProductID]);
GO


-- b
CREATE TRIGGER [Production].[Trigger_View_LocationProduct_Insert]
  ON [Production].[View_LocationProduct]
INSTEAD OF INSERT AS
  BEGIN
    INSERT INTO [Production].[Location] (
      [Name],
      [CostRate],
      [Availability],
      [ModifiedDate])
      SELECT
        [Name],
        [CostRate],
        [Availability],
        [LocationModifiedDate]
      FROM inserted;
    INSERT INTO [Production].[ProductInventory] (
      [LocationID],
      [ProductID],
      [Shelf],
      [Bin],
      [Quantity],
      [ModifiedDate])
      SELECT
        SCOPE_IDENTITY(),
        [ProductID],
        [Shelf],
        [Bin],
        [Quantity],
        [ProductInventoryModifiedDate]
      FROM inserted
  END;
GO

CREATE TRIGGER [Production].[Trigger_View_LocationProduct_Update]
  ON [Production].[View_LocationProduct]
INSTEAD OF UPDATE AS
  BEGIN
    UPDATE [Production].[Location]
    SET
      [Location].[Name]         = inserted.[Name],
      [Location].[CostRate]     = inserted.[CostRate],
      [Location].[Availability] = inserted.[Availability],
      [Location].[ModifiedDate] = inserted.[LocationModifiedDate]
    FROM [Production].[Location]
      JOIN inserted
        ON [Location].[LocationID] = inserted.[LocationID];

    UPDATE [Production].[ProductInventory]
    SET
      [ProductInventory].[Shelf]        = inserted.[Shelf],
      [ProductInventory].[Bin]          = inserted.[Bin],
      [ProductInventory].[Quantity]     = inserted.[Quantity],
      [ProductInventory].[ModifiedDate] = inserted.[ProductInventoryModifiedDate]
    FROM [Production].[ProductInventory]
      JOIN inserted
        ON [ProductInventory].[ProductID] = inserted.[ProductID]
           AND [ProductInventory].[LocationID] = inserted.[LocationID];
  END;
GO

CREATE TRIGGER [Production].[Trigger_View_LocationProduct_Delete]
  ON [Production].[View_LocationProduct]
INSTEAD OF DELETE AS
  BEGIN
    DELETE [Production].[ProductInventory]
    FROM [Production].[ProductInventory]
      JOIN deleted
        ON [ProductInventory].[ProductID] = deleted.[ProductID]
           AND [ProductInventory].[LocationID] = deleted.[LocationID];

    DELETE [Production].[Location]
    FROM [Production].[Location]
      JOIN deleted
        ON [Location].[LocationID] = deleted.[LocationID];
  END;
GO

-- c

INSERT INTO [Production].[View_LocationProduct] ([Name],
                                                 [CostRate],
                                                 [Availability],
                                                 [LocationModifiedDate],
                                                 [Shelf],
                                                 [Bin],
                                                 [Quantity],
                                                 [ProductInventoryModifiedDate],
                                                 [ProductID],
                                                 [ProductName])
VALUES ('Final Assembly1', 15.2500, 121.00, '2005-06-01 00:00:00.000',
        'A', 4, 372, '2008-09-09 00:00:00.000', 1, 'Adjustable Race');

DECLARE @LocationID [SMALLINT] = (SELECT MAX([LocationID]) FROM [Production].[Location]);

SELECT * FROM [Production].[Location] WHERE LocationID = @LocationID;
SELECT * FROM [Production].[ProductInventory] WHERE LocationID = @LocationID;

UPDATE [Production].[View_LocationProduct]
SET
  [Name] = 'Final Assembly2'
WHERE [LocationID] = @LocationID;

SELECT * FROM [Production].[Location] WHERE LocationID = @LocationID;
SELECT * FROM [Production].[ProductInventory] WHERE LocationID = @LocationID;

DELETE FROM [Production].[View_LocationProduct]
WHERE [LocationID] = @LocationID;

SELECT * FROM [Production].[Location] WHERE LocationID = @LocationID;
SELECT * FROM [Production].[ProductInventory] WHERE LocationID = @LocationID;

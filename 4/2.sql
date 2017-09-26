USE AdventureWorks2012;
GO

DROP VIEW [Production].[View_LocationProduct];
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
) WITH ENCRYPTION, SCHEMABINDING AS SELECT
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

CREATE UNIQUE CLUSTERED INDEX [AK_View_LocationProduct_LocationID_ProductID] ON [Production].[View_LocationProduct] ([LocationID], [ProductID]);
GO


-- b
CREATE TRIGGER [Production].[Trigger_View_LocationProduct] ON [Production].[View_LocationProduct]
INSTEAD OF INSERT AS
BEGIN
	INSERT INTO [Production].[Location] (
		[LocationID],
		[Name],
		[CostRate],
		[Availability],
		[ModifiedDate])
	SELECT  
		[LocationID],
		[Name],
		[CostRate],
		[Availability],
		[LocationModifiedDate]
	FROM inserted;
	INSERT INTO [Production].[ProductInventory] (
		[ProductID],
		[Shelf],
		[Bin],
		[Quantity],
		[ModifiedDate])		
	SELECT
		[ProductID],
		[Shelf],
		[Bin],
		[Quantity],
		[ProductInventoryModifiedDate]
	FROM inserted
END;
GO
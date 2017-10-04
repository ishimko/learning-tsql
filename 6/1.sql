USE AdventureWorks2012;
GO

IF OBJECT_ID('[dbo].[SubCategoriesByColor]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[SubCategoriesByColor];
GO

CREATE PROCEDURE [dbo].[SubCategoriesByColor]
    @productColor NVARCHAR(4000)
AS
  SET NOCOUNT ON;
  DECLARE @sql NVARCHAR(4000);
  SET @sql = 'SELECT * FROM (SELECT [Production].[ProductSubcategory].[Name], [Production].[Product].[Color], [Production].[Product].[Weight] FROM [Production].[Product]
		JOIN  [Production].[ProductSubcategory]
			ON [Production].[Product].[ProductSubcategoryID] = [Production].[ProductSubcategory].[ProductSubcategoryID]
	) [t]
	PIVOT(
		MAX([t].Weight)
		FOR [t].[Color] IN (' + @productColor + ')
	) [p]'
  EXEC sp_executesql @sql
GO

EXECUTE dbo.SubCategoriesByColor '[Black],[Silver],[Yellow]'
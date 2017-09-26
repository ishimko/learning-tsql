USE AdventureWorks2012;
GO

-- 2

SELECT [DepartmentID],
		[Name]
FROM [HumanResources].[Department]
ORDER BY [Name] DESC
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY;


SELECT DISTINCT [JobTitle]
FROM [HumanResources].[Employee]
WHERE [OrganizationLevel] = 1;


SELECT [BusinessEntityID],
       [JobTitle],
       [Gender],
       [BirthDate],
       [HireDate]
FROM [HumanResources].[Employee]
WHERE DATEDIFF(YEAR, [BirthDate], [HireDate]) = 18;

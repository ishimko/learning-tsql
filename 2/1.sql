USE [AdventureWorks2012];
GO

-- 2

SELECT [e].[BusinessEntityID],
       [e].[JobTitle],
	   [d].[Name],
	   [edh].[StartDate],
	   [edh].[EndDate]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] AS [d] ON [edh].[DepartmentID] = [d].[DepartmentID]
WHERE [e].[JobTitle] = 'Purchasing Manager';


SELECT [e].[BusinessEntityID],
       [e].[JobTitle],
	   COUNT([e].[BusinessEntityID]) AS [RateCount]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [e].[BusinessEntityID] = [eph].[BusinessEntityID]
GROUP BY [e].[BusinessEntityID],
         [e].[JobTitle]
HAVING COUNT([e].[BusinessEntityID]) > 1;


SELECT [d].[DepartmentID],
       [d].[Name],
	   MAX([eph].[Rate]) AS [MaxRate]
FROM [HumanResources].[Department] AS [d]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [d].[DepartmentID] = [edh].[DepartmentID]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [edh].[BusinessEntityID] = [eph].[BusinessEntityID]
WHERE [edh].[EndDate] IS NULL
GROUP BY [d].[DepartmentID],
         [d].[Name];

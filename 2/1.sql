USE [AdventureWorks2012];
GO

SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],	   
	   MAX([ph].[Rate]) as [MaxRate]
FROM [HumanResources].[Employee] AS[e]
JOIN [HumanResources].[EmployeePayHistory] AS [ph] ON [e].[BusinessEntityID] = [ph].[BusinessEntityID]
GROUP BY [e].[BusinessEntityID],
		 [e].[JobTitle];


SELECT [e].[BusinessEntityId],
	   [e].[JobTitle],
	   [ph].[Rate],
	   DENSE_RANK() OVER (ORDER BY [ph].[Rate]) as RankRate
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeePayHistory] AS [ph] ON [e].[BusinessEntityID] = [ph].[BusinessEntityID]
GROUP BY [e].[BusinessEntityID],
		 [e].[JobTitle],
		 [ph].[Rate];


SELECT [d].[Name] AS [DepName],
       [e].[BusinessEntityID],
       [e].[JobTitle],
       [edh].[ShiftID]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] AS [d] ON [edh].[DepartmentID] = [d].[DepartmentID]
WHERE [edh].[EndDate] IS NULL
ORDER BY [d].[Name],
         CASE [d].[Name]
             WHEN 'Document Control' THEN [edh].[ShiftID]
             ELSE [e].[BusinessEntityID]
         END;


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

-- 3

SELECT [e].[BusinessEntityID],
       [e].[JobTitle],
	   [d].[DepartmentID],
       [d].[Name]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] AS [d] ON [edh].[DepartmentID] = [d].[DepartmentID]
WHERE [edh].[EndDate] IS NULL
GROUP BY [e].[BusinessEntityID],
         [e].[JobTitle],
		 [d].[DepartmentID],
		 [d].[Name];


SELECT [d].[DepartmentID],
       [d].[Name],
	   COUNT([edh].[BusinessEntityID]) AS [EmpCount]
FROM [HumanResources].[Department] AS [d]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [d].[DepartmentID] = [edh].[DepartmentID]
WHERE [edh].[EndDate] IS NULL
GROUP BY [d].[DepartmentID],
         [d].[Name];


SELECT [e].[JobTitle],
	   [eph].[Rate],
	   [eph].[ModifiedDate] AS [RateChangeDate],
	   FORMATMESSAGE('The rate for %s was set to %s at %s', [e].[JobTitle], CAST([eph].[Rate] AS nvarchar), FORMAT([eph].[ModifiedDate], 'dd MMM yyyy')) AS Report
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [e].[BusinessEntityID] = [eph].[BusinessEntityID];


-- 4


SELECT DISTINCT [d].[Name], 
	   [e].[JobTitle],
	   COUNT([edh].[BusinessEntityID]) OVER (PARTITION BY edh.DepartmentID)
FROM [HumanResources].[Employee] as [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] as [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] as [d] ON [d].[DepartmentID] = [edh].[DepartmentID]
WHERE [edh].[EndDate] is NULL
ORDER BY [d].[Name]


SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],
	   [s].[Name],
	   [s].[StartTime],
	   [s].[EndTime]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] as [edh] ON [edh].[BusinessEntityID] = [e].[BusinessEntityID]
JOIN [HumanResources].[Shift] as [s] ON [edh].[ShiftID] = [s].[ShiftID]
WHERE [s].[Name] = 'Night'


SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],
	   [eph].[Rate],
	   COALESCE([eph_prev].[Rate], 0) AS [PrevRate],
	   [eph].[Rate] -  COALESCE([eph_prev].[Rate], 0) as [Increased]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [e].[BusinessEntityID] = [eph].[BusinessEntityID]
LEFT JOIN [HumanResources].[EmployeePayHistory] AS [eph_prev] ON [eph_prev].[BusinessEntityID] = [eph].[BusinessEntityID] AND [eph_prev].[RateChangeDate] < [eph].[RateChangeDate]


-- 5

SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],
	   [s].[Name],
	   [s].[StartTime],
	   [s].[EndTime]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] as [edh] ON [edh].[BusinessEntityID] = [e].[BusinessEntityID]
JOIN [HumanResources].[Shift] as [s] ON [edh].[ShiftID] = [s].[ShiftID]
WHERE [edh].[EndDate] is NULL


SELECT [d].[GroupName],
	   COUNT([edh].[BusinessEntityID]) AS [EmpCount]
FROM [HumanResources].[EmployeeDepartmentHistory] AS [edh]
JOIN [HumanResources].[Department] as [d] ON [edh].[DepartmentID] = [d].DepartmentID
WHERE [edh].[EndDate] is NULL
GROUP BY [d].[GroupName]
	

SELECT [d].[Name],
	   [e].[BusinessEntityID],
	   [eph].[Rate],
	   MAX([eph].[Rate]) OVER (PARTITION BY [edh].[DepartmentID]) as [MaxInDepartment],
	   DENSE_RANK() OVER(PARTITION BY [edh].[DepartmentID] ORDER BY [eph].[Rate]) as [RateGroup]
FROM [HumanResources].[Employee] as [e]
JOIN [HumanResources].[EmployeePayHistory] as [eph] ON [eph].[BusinessEntityID] = [e].[BusinessEntityID]
JOIN [HumanResources].[EmployeeDepartmentHistory] as [edh] ON [edh].[BusinessEntityID] = [e].[BusinessEntityID]
JOIN [HumanResources].[Department] as [d] ON [edh].[DepartmentID] = [d].[DepartmentID]
WHERE [edh].[EndDate] is NULL
ORDER BY [d].[Name]


-- 6


SELECT [d].[Name],
	   MIN([edh].[StartDate])
FROM [HumanResources].[Department] AS [d]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [edh].[DepartmentID] = [d].[DepartmentID]
GROUP BY
	[d].[Name],
	[d].[DepartmentID]


SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],
	   CASE [s].[Name]
			WHEN 'Day' THEN 1
			WHEN 'Evening' THEN 2
			WHEN 'Night' THEN 3
	   END AS [ShiftName]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] as [edh] ON [edh].[BusinessEntityID] = [e].[BusinessEntityID]
JOIN [HumanResources].[Shift] AS [s] ON [edh].[ShiftID] = [s].[ShiftID]
WHERE [e].[JobTitle] = 'Stocker'


SELECT [e].[BusinessEntityID],
	   REPLACE([e].[JobTitle], 'and', '&') AS [Job Title],
	   [d].[Name] as [DepName]
FROM [HumanResources].[Employee] as [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] as [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] as [d] ON [d].[DepartmentID] = [edh].[DepartmentID]
WHERE [edh].[EndDate] IS NULL


-- 7

SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],	   
	   MAX([eph].[RateChangeDate])
FROM [HumanResources].[Employee] as [e]
JOIN [HumanResources].[EmployeePayHistory] as [eph] ON [eph].[BusinessEntityID] = [e].[BusinessEntityID]
GROUP BY [e].[BusinessEntityID],
		 [e].[JobTitle]


SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],
	   [d].[Name] as [DepName],
	   [edh].[StartDate],
	   [edh].[EndDate],
	   DATEDIFF(year, [edh].[StartDate], COALESCE([edh].[EndDate], GETDATE()))
FROM [HumanResources].[Employee] as [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] as [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] as [d] ON [d].[DepartmentID] = [edh].[DepartmentID]


SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],
	   [d].[Name],
	   [d].[GroupName],
	   CASE CHARINDEX(' ', [d].[GroupName])
		   WHEN 0 THEN [d].[GroupName]
           ELSE SUBSTRING([d].[GroupName], 1, CHARINDEX(' ', [d].[GroupName]) - 1)
       END AS [FirstWord]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] AS [d] ON [d].[DepartmentID] = [edh].[DepartmentID]
WHERE [edh].[EndDate] IS NULL


-- 8


SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],
	   [e].[OrganizationLevel],
	   [jc].[JobCandidateID],
	   [jc].[Resume]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[JobCandidate] AS [jc] ON [e].[BusinessEntityID] = [jc].[BusinessEntityID]


SELECT [d].[DepartmentID],
	   [d].[Name],
	   COUNT([edh].[BusinessEntityID]) AS [EmpCount]
FROM [HumanResources].[Department] AS [d]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [d].[DepartmentID] = [edh].[DepartmentID]
WHERE [edh].[EndDate] IS NULL
GROUP BY [d].[DepartmentID],
	     [d].[Name]
HAVING COUNT([edh].[BusinessEntityID]) > 10


SELECT [d].[Name],
  [e].[HireDate],
  [e].[SickLeaveHours],
  SUM([e].[SickLeaveHours]) OVER (PARTITION BY [d].[DepartmentID] ORDER BY [e].[HireDate]) AS AccumulativeSum
FROM [HumanResources].[Department] AS [d]
  JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [edh].[DepartmentID] = [d].[DepartmentID]
  JOIN [HumanResources].[Employee] AS [e] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
GROUP BY
  [d].[Name],
  [e].[HireDate],
  [e].[SickLeaveHours],
  [e].[BusinessEntityID],
  [d].[DepartmentID]
ORDER BY [d].[Name], [e].[HireDate];


-- 9

SELECT [e].[BusinessEntityID],
       [e].[JobTitle],
	   AVG([eph].[Rate]) AS [AverageRate]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [e].[BusinessEntityID] = [eph].[BusinessEntityID]
GROUP BY [e].[BusinessEntityID],
		 [e].[JobTitle]


SELECT [e].[BusinessEntityID],
	   [e].[JobTitle],
	   [eph].[Rate],
	   CASE
			WHEN [eph].[Rate] <= 50 THEN 'less or equal 50'
			WHEN [eph].[Rate] BETWEEN 50 AND 100 THEN 'more than 50 but less or equal 100'
			WHEN [eph].[Rate] > 100 THEN 'more than 100'
	   END AS [RateRepor]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [e].[BusinessEntityID] = [eph].[BusinessEntityID]


SELECT [d].[Name],
	   MAX([eph].[Rate]) AS [MaxRate]
FROM [HumanResources].[Department] AS [d]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [d].[DepartmentID] = [edh].[DepartmentID]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [eph].[BusinessEntityID] = [edh].[BusinessEntityID]
WHERE [edh].[EndDate] IS NULL
GROUP BY [d].[DepartmentID],
		 [d].[Name]
HAVING MAX([eph].[Rate]) > 60
ORDER BY [MaxRate]


-- 10

SELECT [e].[BusinessEntityID],
       [e].[JobTitle],
	   ROUND([eph].[Rate], 0) AS [RoundRate],
	   [eph].[Rate]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [eph].[BusinessEntityID] = [e].BusinessEntityID


SELECT [e].[BusinessEntityID],
       [e].[JobTitle],
	   [eph].[Rate],
	   ROW_NUMBER() OVER(PARTITION BY [e].[BusinessEntityID] ORDER BY [eph].[RateChangeDate])
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [eph].[BusinessEntityID] = [e].BusinessEntityID


SELECT [d].[Name],
	   [e].[JobTitle],
	   [e].[HireDate],
	   [e].[BirthDate]
FROM [HumanResources].[Employee] AS [e]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] AS [d] ON [d].[DepartmentID] = [edh].[DepartmentID]
ORDER BY
	[e].[JobTitle],
	CASE LEN([e].[JobTitle]) - LEN(REPLACE([e].[JobTitle], ' ', ''))
		WHEN 0 THEN [e].[HireDate]
		ELSE [e].[BirthDate]
	END DESC
		

USE AdventureWorks2012;
GO

-- 1

SELECT	[BusinessEntityId],
		[JobTitle],
		[Gender],
		[HireDate]
FROM [HumanResources].[Employee]
WHERE [JobTitle] IN 
	('Accounts Manager',
	'Benefits Specialist',
	'Engineering Manager',
	'Finance Manager',
	'Maintenance Supervisor',
	'Master Scheduler',
	'Network Manager');


SELECT COUNT([BusinessEntityId]) AS [EmpCount]
FROM [HumanResources].[Employee]
WHERE YEAR([HireDate]) >= 2004


SELECT TOP 5 [BusinessEntityId],
		[JobTitle],
		[MaritalStatus],
		[Gender],
		[BirthDate]
		[HireDate]
FROM [HumanResources].[Employee]
WHERE	[MaritalStatus] = 'M'
		AND YEAR([HireDate]) = 2004
ORDER BY [BirthDate] DESC;


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


-- 3


SELECT [DepartmentID],
       [Name]
FROM [HumanResources].[Department]
WHERE [Name] LIKE 'P%';


SELECT [BusinessEntityID],
       [JobTitle],
       [Gender],
       [VacationHours],
       [SickLeaveHours]
FROM [HumanResources].[Employee]
WHERE [VacationHours] BETWEEN 10 AND 13;


SELECT [BusinessEntityID],
       [JobTitle],
       [Gender],
       [BirthDate],
       [HireDate]
FROM [HumanResources].[Employee]
WHERE DAY([HireDate]) = 1
	  AND MONTH([HireDate]) = 7
ORDER BY [BusinessEntityID]
OFFSET 3 ROWS FETCH NEXT 5 ROWS ONLY;


-- 4


SELECT [Name],
       [GroupName]
FROM [HumanResources].[Department]
WHERE [GroupName] = 'Executive General and Administration';


SELECT MAX([VacationHours]) AS [MaxVacationHours]
FROM [HumanResources].[Employee];


SELECT [BusinessEntityID],
       [JobTitle],
       [Gender],
       [BirthDate],
       [HireDate]
FROM [HumanResources].[Employee]
WHERE [JobTitle] LIKE '%Engineer%';


-- 5


SELECT [Name],
       [GroupName]
FROM [HumanResources].[Department]
WHERE [GroupName] = 'Research and Development'
ORDER BY [Name];


SELECT MIN([SickLeaveHours]) AS [MinSickLeaveHours]
FROM [HumanResources].[Employee];


SELECT DISTINCT TOP 10 [JobTitle],
                    CASE CHARINDEX(' ',[JobTitle])
                        WHEN 0 THEN [JobTitle]
                        ELSE SUBSTRING([JobTitle], 1, CHARINDEX(' ', [JobTitle]) - 1)
                    END AS [FirstWord]
FROM [HumanResources].[Employee]
ORDER BY [JobTitle];


-- 6


SELECT [DepartmentID],
       [Name]
FROM [HumanResources].[Department]
WHERE [Name] LIKE 'F%'
  AND [Name] LIKE '%e';


SELECT AVG([VacationHours]) AS [AvgVacationHours],
       AVG([SickLeaveHours]) AS [AvgSickLeaveHours]
FROM [HumanResources].[Employee];


SELECT [BusinessEntityID],
       [JobTitle],
       [Gender],
       DATEDIFF(YEAR, [HireDate], GETDATE()) AS [YearsWorked]
FROM [HumanResources].[Employee]
WHERE DATEDIFF(YEAR, [BirthDate], GETDATE()) > 65;


-- 7


SELECT COUNT([DepartmentID]) AS [DepartmentCount]
FROM [HumanResources].[Department]
WHERE [GroupName] = 'Executive General and Administration';


SELECT TOP 5 [BusinessEntityID],
           [JobTitle],
           [Gender],
           [BirthDate]
FROM [HumanResources].[Employee]
ORDER BY [BirthDate] DESC;


SELECT [BusinessEntityID],
       [JobTitle],
       [Gender],
       [HireDate],
       REPLACE([LoginID], 'adventure-works', 'adventure-works2012') AS [LoginID]
FROM [HumanResources].[Employee]
WHERE [Gender] = 'F'
  AND DATENAME(weekday, [HireDate]) = 'Tuesday';


-- 8


SELECT [BusinessEntityID],
       [BirthDate],
       [MaritalStatus],
       [Gender],
       [HireDate]
FROM [HumanResources].[Employee]
WHERE [MaritalStatus] = 'S'
  AND YEAR([BirthDate]) <= 1960;


SELECT [BusinessEntityID],
       [JobTitle],
       [BirthDate],
       [Gender],
       [HireDate]
FROM [HumanResources].[Employee]
WHERE [JobTitle] = 'Design Engineer'
ORDER BY [HireDate] DESC;


SELECT [BusinessEntityID],
       [DepartmentID],
       [StartDate],
       [EndDate],
	   DATEDIFF(YEAR, [StartDate], COALESCE([EndDate], GETDATE())) AS [YearsWorked]
FROM [HumanResources].[EmployeeDepartmentHistory]
WHERE [DepartmentID] = 1;


-- 9


SELECT [BusinessEntityID],
       [JobTitle],
       [BirthDate],
       [HireDate]
FROM [HumanResources].[Employee]
WHERE YEAR([BirthDate]) > 1980
  AND [HireDate] > '2003-04-01';


SELECT SUM([VacationHours]) AS [SumVacationHours],
       SUM([SickLeaveHours]) AS [SumSickLeaveHours]
FROM [HumanResources].[Employee];


SELECT TOP 3 [BusinessEntityID],
           [JobTitle],
           [BirthDate],
           [Gender],
           [MaritalStatus],
           [HireDate]
FROM [HumanResources].[Employee]
ORDER BY [HireDate];


-- 10


SELECT COUNT([BusinessEntityID])
FROM [HumanResources].[Employee]
WHERE [OrganizationLevel] = 3;


SELECT DISTINCT [GroupName]
FROM [HumanResources].[Department];


SELECT DISTINCT TOP 10 [JobTitle],
                    CASE CHARINDEX(' ',[JobTitle])
                        WHEN 0 THEN [JobTitle]
                        ELSE SUBSTRING([JobTitle], LEN([JobTitle]) - CHARINDEX(' ', REVERSE([JobTitle])) + 2, LEN([JobTitle]))
                    END AS [FirstWord]
FROM [HumanResources].[Employee]
ORDER BY [JobTitle];


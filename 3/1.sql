USE AdventureWorks2012
GO

-- 2

-- a
ALTER TABLE [dbo].[PersonPhone] ADD [HireDate] date;
GO

-- b
DECLARE @PersonPhoneVar TABLE (
	[BusinessEntityID] [int] NOT NULL,
	[PhoneNumber] [dbo].[Phone] NOT NULL,
	[PhoneNumberTypeID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[HireDate] [date] NOT NULL);


INSERT INTO @PersonPhoneVar
           ([BusinessEntityID]
           ,[PhoneNumber]
           ,[PhoneNumberTypeID]
           ,[ModifiedDate]
		   ,[HireDate])
SELECT [ph].[BusinessEntityID]
      ,[ph].[PhoneNumber]
      ,[ph].[PhoneNumberTypeID]
      ,[ph].[ModifiedDate]
	  ,(SELECT [HireDate] FROM [HumanResources].[Employee] AS [e] WHERE [e].[BusinessEntityID] = [ph].[BusinessEntityID])
FROM [dbo].[PersonPhone] AS [ph]


-- c
UPDATE [dbo].[PersonPhone] SET
	[PersonPhone].[HireDate] = DATEADD(day, 1, [ph].[HireDate])
FROM @PersonPhoneVar AS [ph]


-- d
DELETE [dbo].[PersonPhone] 
FROM [dbo].[PersonPhone] AS [ph]
JOIN [HumanResources].[EmployeePayHistory] AS [eph] ON [ph].[BusinessEntityID] = [eph].[BusinessEntityID]
WHERE [eph].[Rate] > 50


-- e
DECLARE @sql NVARCHAR(MAX) = N'';

DECLARE @schema NVARCHAR(MAX) = 'dbo';
DECLARE @table NVARCHAR(MAX) = 'PersonPhone';

SELECT @sql += N'
ALTER TABLE ' + QUOTENAME([ctu].[TABLE_SCHEMA])
    + '.' + QUOTENAME([ctu].[TABLE_NAME]) + 
    ' DROP CONSTRAINT ' + QUOTENAME([ctu].[CONSTRAINT_NAME]) + ';'
FROM [AdventureWorks2012].[INFORMATION_SCHEMA].[CONSTRAINT_TABLE_USAGE] AS [ctu]
WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @table;

SELECT @sql += N'
ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM [AdventureWorks2012].[sys].[default_constraints]  AS [dc]
WHERE SCHEMA_NAME(schema_id) = @schema and OBJECT_NAME(parent_object_id) = @table

EXEC sp_executesql @sql;

ALTER TABLE [dbo].[PersonPhone] DROP COLUMN [ID];


-- f
DROP TABLE [dbo].[PersonPhone];
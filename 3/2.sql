USE [AdventureWorks2012];
GO

DROP TABLE [dbo].[#PersonPhone];

-- a
ALTER TABLE [dbo].[PersonPhone] ADD 
	[JobTitle] NVARCHAR(50),
	[BirthDate] DATE,
	[HireDate] DATE,
	[HireAge] AS (DATEDIFF(year, [BirthDate], [HireDate]));
GO

-- b
CREATE TABLE [dbo].[#PersonPhone](
	[BusinessEntityID] [int] NOT NULL,
	[PhoneNumber] NVARCHAR(50) NOT NULL,
	[PhoneNumberTypeID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[JobTitle] NVARCHAR(50),
	[BirthDate] DATE,
	[HireDate] DATE,
	PRIMARY KEY([BusinessEntityID]))
GO


-- ñ
WITH PERSON_PHONES AS (
	SELECT	[ph].[BusinessEntityID]
			,[ph].[PhoneNumber]
			,[ph].[PhoneNumberTypeID]
			,[ph].[ModifiedDate]
			,[e].[JobTitle]
			,[e].[BirthDate]
			,[e].[HireDate]
	FROM [dbo].[PersonPhone] AS [ph]
	JOIN [HumanResources].[Employee] AS [e] ON [ph].[BusinessEntityID] = [e].[BusinessEntityID]
	WHERE [e].[JobTitle] = 'Sales Representative')
INSERT INTO [dbo].[#PersonPhone](
           [BusinessEntityID]
           ,[PhoneNumber]
           ,[PhoneNumberTypeID]
           ,[ModifiedDate]
		   ,[JobTitle]
		   ,[BirthDate]
		   ,[HireDate])
SELECT * FROM PERSON_PHONES;


-- d
DELETE FROM [dbo].[PersonPhone]
WHERE [BusinessEntityID] = 275


-- e
MERGE INTO [dbo].[PersonPhone] AS target
USING [dbo].[#PersonPhone] AS source
ON target.[BusinessEntityID] = source.[BusinessEntityID]
WHEN MATCHED THEN UPDATE SET
    [JobTitle] = Target.[JobTitle],
	[BirthDate] = Target.[BirthDate],
	[HireDate] = Target.[HireDate]    
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
			[BusinessEntityID]
           ,[PhoneNumber]
           ,[PhoneNumberTypeID]
           ,[ModifiedDate]
		   ,[JobTitle]
		   ,[BirthDate]
		   ,[HireDate]
    ) VALUES (
			source.[BusinessEntityID]
           ,source.[PhoneNumber]
           ,source.[PhoneNumberTypeID]
           ,source.[ModifiedDate]
		   ,source.[JobTitle]
		   ,source.[BirthDate]
		   ,source.[HireDate]
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
GO
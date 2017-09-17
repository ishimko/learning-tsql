USE [AdventureWorks2012];
GO

-- 1

DROP TABLE [dbo].[Person];
GO

CREATE TABLE [dbo].[Person](
	[BusinessEntityID] [int] NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] [dbo].[NameStyle] NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [dbo].[Name] NOT NULL,
	[MiddleName] [dbo].[Name] NULL,
	[LastName] [dbo].[Name] NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL);

ALTER TABLE [dbo].[Person] ADD ID BIGINT IDENTITY(10, 10);
ALTER TABLE [dbo].[Person] ADD CONSTRAINT PK_ID PRIMARY KEY CLUSTERED (ID);

ALTER TABLE [dbo].[Person] ADD CONSTRAINT check_title CHECK ([Title] IN ('Mr.', 'Ms.'));

ALTER TABLE [dbo].[Person] ADD CONSTRAINT default_suffix DEFAULT 'N/A' FOR [Suffix];

INSERT INTO [dbo].[Person]
           ([BusinessEntityID]
           ,[PersonType]
           ,[NameStyle]
           ,[Title]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[EmailPromotion]
           ,[ModifiedDate])
SELECT [p].[BusinessEntityID]
           ,[PersonType]
           ,[NameStyle]
           ,[Title]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[EmailPromotion]
           ,[p].[ModifiedDate]
FROM [Person].[Person] AS [p]
JOIN [HumanResources].[Employee] AS [e] ON [p].[BusinessEntityID] = [e].[BusinessEntityID]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] AS [d] ON [edh].[DepartmentID] = [d].[DepartmentID]
WHERE [d].[Name] != 'Executive' AND [edh].[EndDate] IS NULL

ALTER TABLE [dbo].[Person] ALTER COLUMN [Suffix] nvarchar(5)
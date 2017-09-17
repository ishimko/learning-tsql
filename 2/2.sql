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

ALTER TABLE [dbo].[Person] ADD ID BIGINT IDENTITY(10, 10) PRIMARY KEY;

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
SELECT [e].[BusinessEntityID]
           ,[PersonType]
           ,[NameStyle]
           ,[Title]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[EmailPromotion]
           ,[e].[ModifiedDate]
FROM [Person].[Person] AS [p]
JOIN [HumanResources].[Employee] AS [e] ON [p].[BusinessEntityID] = [e].[BusinessEntityID]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
JOIN [HumanResources].[Department] AS [d] ON [edh].[DepartmentID] = [d].[DepartmentID]
WHERE [d].[Name] != 'Executive' AND [edh].[EndDate] IS NULL

ALTER TABLE [dbo].[Person] ALTER COLUMN [Suffix] nvarchar(5)


-- 2


DROP TABLE [dbo].[PersonPhone]


CREATE TABLE [dbo].[PersonPhone](
	[BusinessEntityID] [int] NOT NULL,
	[PhoneNumber] [dbo].[Phone] NOT NULL,
	[PhoneNumberTypeID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL)

ALTER TABLE [dbo].[PersonPhone] ADD ID BIGINT IDENTITY(2, 2) UNIQUE;

ALTER TABLE [dbo].[PersonPhone] ADD CONSTRAINT phone_only_numbers CHECK ([PhoneNumber] NOT LIKE '%[a-zA-Z]%')

ALTER TABLE [dbo].[PersonPhone] ADD CONSTRAINT default_type_id DEFAULT 1 FOR [PhoneNumberTypeID];


INSERT INTO [dbo].[PersonPhone]
           ([BusinessEntityID]
           ,[PhoneNumber]
           ,[PhoneNumberTypeID]
           ,[ModifiedDate])
SELECT [e].[BusinessEntityID]
      ,[PhoneNumber]
      ,[PhoneNumberTypeID]
      ,[e].[ModifiedDate]
FROM [Person].[PersonPhone] AS [ph]
JOIN [HumanResources].[Employee] AS [e] ON [ph].[BusinessEntityID] = [e].[BusinessEntityID]
JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [edh].[BusinessEntityID] = [e].[BusinessEntityID]

WHERE [ph].[PhoneNumber] NOT LIKE '%[()]%'
	  AND [edh].[EndDate] IS NULL
	  AND [e].[HireDate] = [edh].[StartDate];

ALTER TABLE [dbo].[PersonPhone] ALTER COLUMN [PhoneNumber] [dbo].[Phone] NULL;


-- 3


DROP TABLE [dbo].[Address];

CREATE TABLE [dbo].[Address](
	[AddressID] [int],
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL)

ALTER TABLE [dbo].[Address] ADD PRIMARY KEY ([StateProvinceID], [PostalCode]);

ALTER TABLE [dbo].[Address] ADD CONSTRAINT postal_only_numbers CHECK ([PostalCode] LIKE '%[0-9]%')

ALTER TABLE [dbo].[Address] ADD CONSTRAINT default_modified_date DEFAULT GETDATE() FOR [ModifiedDate];

INSERT INTO [dbo].[Address]
           ([AddressID]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[StateProvinceID]
           ,[PostalCode]
           ,[ModifiedDate])
SELECT MAX([a].[AddressID]) OVER (PARTITION BY [a].[StateProvinceID], [a].[PostalCode]) AS [AddressID]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[City]
      ,[a].[StateProvinceID]
      ,[PostalCode]      
      ,[a].[ModifiedDate]
FROM [Person].[Address] as [a]
JOIN [Person].[StateProvince] as [sp] ON [sp].[StateProvinceID] = [a].[StateProvinceID]
WHERE [sp].[CountryRegionCode] = 'US'
	  AND [a].[PostalCode] LIKE '%[0-9]%'


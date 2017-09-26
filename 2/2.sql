USE [AdventureWorks2012];
GO


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

USE [AdventureWorks2012]
GO

-- 1


IF OBJECT_ID('[tempdb].[dbo].[#EmployeeTemporary]', 'U') IS NOT NULL
  DROP TABLE [dbo].[#EmployeeTemporary];
GO

SELECT
	[BusinessEntityID] AS '@ID',
	[NationalIDNumber],
	[JobTitle]
FROM [HumanResources].[Employee]
FOR XML PATH ('Employee'), ROOT ('Employees')

CREATE TABLE [dbo].[#EmployeeTemporary]
(
  [BusinessEntityID] INT,
  [NationalIDNumber] NVARCHAR(15),
  [JobTitle]         NVARCHAR(50)
);

DECLARE @xml_var_Employee XML =
(
  SELECT
    [BusinessEntityID] AS '@ID',
    [NationalIDNumber],
    [JobTitle]
  FROM [HumanResources].[Employee]
  FOR XML PATH ('Employee'), ROOT ('Employees')
);


INSERT INTO [dbo].[#EmployeeTemporary] ([BusinessEntityID], [NationalIDNumber], [JobTitle])
	SELECT
		xc.value('@ID', 'int'),
		xc.value('NationalIDNumber[1]', 'nvarchar(15)'),
		xc.value('JobTitle[1]', 'nvarchar(50)')
	FROM @xml_var_Employee.nodes('//Employee') AS XmlData(xc);

SELECT * FROM [dbo].[#EmployeeTemporary];


-- 2


SELECT
  [ProductID] AS '@ID',
  [Name],
  [ProductNumber]
FROM [Production].[Product]
FOR XML PATH ('Product'), ROOT ('Products');


IF OBJECT_ID('[dbo].[GetProductsFromXml]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[GetProductsFromXml];
GO

CREATE PROCEDURE [dbo].[GetProductsFromXml]
    @xml_var_P XML
AS
BEGIN
	SELECT
		xc.value('@ID', 'int')                        AS ID,
		xc.value('Name[1]', 'nvarchar(50)')           AS NAME,
		xc.value('ProductNumber[1]', 'nvarchar(25)')  AS ProductNumber
	FROM @xml_var_P.nodes('//Product') AS XmlData(xc)
END;
GO

DECLARE @xml_var_Product XML =
(
  SELECT
    [ProductID] AS '@ID',
    [Name],
    [ProductNumber]
  FROM [Production].[Product]
  FOR XML PATH ('Product'), ROOT ('Products')
);

EXECUTE [dbo].[GetProductsFromXml] @xml_var_Product;


-- 3


SELECT
  [BusinessEntityID] AS 'ID',
  [FirstName],
  [LastName]
FROM [Person].[Person]
FOR XML PATH ('Person'), ROOT ('Persons');


IF OBJECT_ID('[tempdb].[dbo].[#PersonTemporary]', 'U') IS NOT NULL
  DROP TABLE [dbo].[#PersonTemporary];
GO

CREATE TABLE [dbo].[#PersonTemporary]
(
  [BusinessEntityID] INT,
  [FirstName]       NVARCHAR(50),
  [LastName]         NVARCHAR(50)
);

DECLARE @xml_var_Person XML =
(
  SELECT
    [BusinessEntityID] AS 'ID',
    [FirstName],
    [LastName]
  FROM [Person].[Person]
  FOR XML PATH ('Person'), ROOT ('Persons')
);

INSERT INTO [dbo].[#PersonTemporary] ([BusinessEntityID], [FirstName], [LastName])
	SELECT
		xc.value('ID[1]', 'int'),
		xc.value('FirstName[1]', 'nvarchar(50)'),
		xc.value('LastName[1]', 'nvarchar(50)')
	FROM @xml_var_Person.nodes('//Person') AS XmlData(xc);

SELECT * FROM [dbo].[#PersonTemporary];


-- 4


SELECT
	[BusinessEntityID] AS 'ID',
	[Name],
	[AccountNumber]
FROM [Purchasing].[Vendor]
FOR XML PATH ('Vendor'), ROOT ('Vendors')

IF OBJECT_ID('[dbo].[GetVendorsFromXml]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[GetVendorsFromXml];
GO

CREATE PROCEDURE [dbo].[GetVendorsFromXml]
    @xml_var_V XML
AS
BEGIN	
	SELECT
		xc.value('ID[1]', 'int')						AS ID,
		xc.value('Name[1]', 'nvarchar(50)')			    AS Name,
		xc.value('AccountNumber[1]', 'nvarchar(15)')	AS AccountNumber
	FROM @xml_var_V.nodes('//Vendor') AS XmlData(xc)
END;
GO

DECLARE @xml_var_Vendor XML =
(
  SELECT
    [BusinessEntityID] AS 'ID',
    [Name],
    [AccountNumber]
  FROM [Purchasing].[Vendor]
  FOR XML PATH ('Vendor'), ROOT ('Vendors')
);

EXECUTE [GetVendorsFromXml] @xml_var_Vendor;


-- 5

SELECT
	[LocationID] AS '@ID',
	[Name]       AS '@Name',
	[CostRate]   AS '@Cost'
FROM [Production].[Location]
FOR XML PATH ('Location'), ROOT ('Locations')

IF OBJECT_ID('[tempdb].[dbo].[#LocationTmp]', 'U') IS NOT NULL
	DROP TABLE [dbo].[#LocationTmp]
GO

DECLARE @xml_var_Location XML =
(
  SELECT
    [LocationID] AS '@ID',
    [Name]       AS '@Name',
    [CostRate]   AS '@Cost'
  FROM [Production].[Location]
  FOR XML PATH ('Location'), ROOT ('Locations')
);

CREATE TABLE #LocationTmp
(
  [LocationID] INT,
  [Name]       NVARCHAR(50),
  [CostRate]   SMALLMONEY
);

INSERT INTO [dbo].[#LocationTmp] ([LocationID], [Name], [CostRate])
  SELECT
    xc.value('@ID', 'int'),
    xc.value('@Name', 'nvarchar(100)'),
    xc.value('@Cost', 'smallmoney')
  FROM @xml_var_Location.nodes('//Location') AS XmlData(xc);

SELECT * FROM [dbo].[#LocationTmp];


-- 6

IF OBJECT_ID('[dbo].[GetCreditCardsFromXml]', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[GetCreditCardsFromXml];
GO

CREATE PROCEDURE [dbo].[GetCreditCardsFromXml]
    @xml_var_CC XML
AS
BEGIN
	SELECT
		xc.value('@ID', 'int')               AS ID,
		xc.value('@Type', 'nvarchar(100)')   AS CardType,
		xc.value('@Number', 'nvarchar(100)') AS CardNumber
	FROM @xml_var_CC.nodes('//Card') XmlData(xc)
END;
GO

DECLARE @xml_var_CreditCard XML =
(
  SELECT
    [CreditCardID] AS '@ID',
    [CardType]     AS '@Type',
    [CardNumber]   AS '@Number'
  FROM [Sales].[CreditCard]
  FOR XML PATH ('Card'), ROOT ('CreditCards')
);

EXECUTE [dbo].[GetCreditCardsFromXml] @xml_var_CreditCard;


-- 7


SELECT
	[p].[ProductID]      AS '@ID',
	[p].[Name]           AS 'Name',
	[p].[ProductModelID] AS 'Model/@ID',
	[pm].[Name]          AS 'Model/Name'
FROM [Production].[Product] AS [p]
JOIN [Production].[ProductModel] AS [pm]
    ON P.[ProductModelID] = PM.[ProductModelID]
FOR XML PATH ('Product'), ROOT ('Products')

IF OBJECT_ID('[tempdb].[dbo].[#ProductTmp]', 'U') IS NOT NULL
	DROP TABLE [dbo].[#ProductTmp]
GO

CREATE TABLE [dbo].[#ProductTmp]
(
  [ProductID]        INT,
  [ProductName]      NVARCHAR(50),
  [ProductModelID]   INT,
  [ProductModelName] NVARCHAR(50)
);

DECLARE @xml_var_Product XML =
(
  SELECT
    [p].[ProductID]      AS '@ID',
    [p].[Name]           AS 'Name',
    [p].[ProductModelID] AS 'Model/@ID',
    [pm].[Name]          AS 'Model/Name'
  FROM [Production].[Product] AS [p]
    JOIN [Production].[ProductModel] AS [pm]
      ON P.[ProductModelID] = PM.[ProductModelID]
  FOR XML PATH ('Product'), ROOT ('Products')
);

INSERT INTO [dbo].[#ProductTmp] ([ProductID], [ProductName], [ProductModelID], [ProductModelName])
  SELECT
    xc.value('@ID', 'int'),
    xc.value('Name[1]', 'nvarchar(50)'),
    xc.value('Model[1]/@ID', 'int'),
    xc.value('Model[1]/Name[1]', 'nvarchar(50)')
  FROM @xml_var_Product.nodes('//Product') XmlData(xc);

SELECT * FROM [dbo].[#ProductTmp];


-- 8


SELECT
	[a].[AddressID]          AS '@ID',
	[a].[City]               AS 'City',
	[sp].[StateProvinceID]   AS 'Province/@ID',
	[sp].[CountryRegionCode] AS 'Province/Region'
FROM [Person].[Address] AS [a]
JOIN [Person].[StateProvince] AS [sp]
    ON [a].[StateProvinceID] = [sp].[StateProvinceID]
FOR XML PATH ('Address'), ROOT ('Addresses')

IF OBJECT_ID('[dbo].[GetAddressesFromXml]', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[GetAddressesFromXml];
GO

CREATE PROCEDURE [dbo].[GetAddressesFromXml]
    @xml_var_A XML
AS
BEGIN
	SELECT
		xc.value('@ID', 'int')                             AS [AddressID],
		xc.value('City[1]', 'nvarchar(100)')               AS [AddressCity],
		xc.value('Province[1]/@ID', 'int')                 AS [ProvinceID],
		xc.value('Province[1]/Region[1]', 'nvarchar(100)') AS [ProvinceRegion]
	FROM @xml_var_A.nodes('//Address') XmlData(xc)
END;
GO

DECLARE @xml_var_Address XML =
(
  SELECT
    [a].[AddressID]          AS '@ID',
    [a].[City]               AS 'City',
    [sp].[StateProvinceID]   AS 'Province/@ID',
    [sp].[CountryRegionCode] AS 'Province/Region'
  FROM [Person].[Address] AS [a]
    JOIN [Person].[StateProvince] AS [sp]
      ON [a].[StateProvinceID] = [sp].[StateProvinceID]
  FOR XML PATH ('Address'), ROOT ('Addresses')
);

EXECUTE [dbo].[GetAddressesFromXml] @xml_var_Address;


-- 9


IF OBJECT_ID('[tempdb].[dbo].[#DepartmentTmp]', 'U') IS NOT NULL
	DROP TABLE [dbo].[#DepartmentTmp]
GO

DECLARE @xml_var_Transaction XML = 
(
  SELECT
    [edh].[StartDate] AS 'Start',
    [edh].[EndDate]   AS 'End',
    [d].[GroupName]   AS 'Department/Group',
    [d].[Name]        AS 'Department/Name'
  FROM [HumanResources].[EmployeeDepartmentHistory] AS [edh]
    JOIN [HumanResources].[Department] AS [d]
      ON [edh].[DepartmentID] = [d].[DepartmentID]
  FOR XML PATH ('Transaction'), ROOT ('History')
);

CREATE TABLE [dbo].[#DepartmentTmp]
(
  [DepartmentXml] XML
);

INSERT INTO [dbo].[#DepartmentTmp] ([DepartmentXml])
  SELECT xc.query('Department')
  FROM @xml_var_Transaction.nodes('//Transaction') XmlData(xc);

SELECT * FROM [dbo].[#DepartmentTmp]


-- 10


SELECT TOP 100
    [per].[FirstName],
    [per].[LastName],
    [pas].[ModifiedDate]     AS 'Password/Date',
    [pas].[BusinessEntityID] AS 'Password/ID'
FROM [Person].[Person] AS [per]
JOIN [Person].[Password] AS [pas]
    ON [per].[BusinessEntityID] = [pas].[BusinessEntityID]
FOR XML PATH ('Person'), ROOT ('Persons')

IF OBJECT_ID('[dbo].[GetPersonsFromXml]', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[GetPersonsFromXml];
GO

CREATE PROCEDURE [dbo].[GetPersonsFromXml]
    @xml_var_P XML
AS
  BEGIN
    SELECT xc.query('Password') AS 'xml'
    FROM @xml_var_P.nodes('//Person') XmlData(xc)
  END;
GO

DECLARE @xml_var_Person XML =
(
  SELECT TOP 100
    [per].[FirstName],
    [per].[LastName],
    [pas].[ModifiedDate]     AS 'Password/Date',
    [pas].[BusinessEntityID] AS 'Password/ID'
  FROM [Person].[Person] AS [per]
    JOIN [Person].[Password] AS [pas]
      ON [per].[BusinessEntityID] = [pas].[BusinessEntityID]
  FOR XML PATH ('Person'), ROOT ('Persons')
);

EXECUTE [dbo].[GetPersonsFromXml] @xml_var_Person;

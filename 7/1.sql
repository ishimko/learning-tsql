USE [AdventureWorks2012]
GO

-- 1
SELECT
  [BusinessEntityID] AS '@ID',
  [NationalIDNumber],
  [JobTitle]
FROM [HumanResources].[Employee]
FOR XML PATH ('Employee'), ROOT ('Employees');


IF OBJECT_ID('[dbo].[#EmployeeTemporary]', 'T') IS NOT NULL
  DROP TABLE [dbo].[#EmployeeTemporary];
GO

CREATE TABLE [dbo].[#EmployeeTemporary]
(
  BusinessEntityID INT,
  NationalIDNumber NVARCHAR(100),
  JobTitle         NVARCHAR(100)
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
    xc.value('NationalIDNumber[1]', 'nvarchar(100)'),
    xc.value('JobTitle[1]', 'nvarchar(100)')
  FROM @xml_var_Employee.nodes('//Employee') XmlData(xc);

SELECT *
FROM [dbo].[#EmployeeTemporary];

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
      xc.value('Name[1]', 'nvarchar(100)')          AS NAME,
      xc.value('ProductNumber[1]', 'nvarchar(100)') AS ProductNumber
    FROM @xml_var_P.nodes('//Product') XmlData(xc)
  END;

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


IF OBJECT_ID('[dbo].[#PersonTemporary]', 'T') IS NOT NULL
  DROP TABLE [dbo].[#PersonTemporary];
GO

CREATE TABLE [dbo].[#PersonTemporary]
(
  BusinessEntityID INT,
  FirstName        NVARCHAR(100),
  LastName         NVARCHAR(100)
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
    xc.value('FirstName[1]', 'nvarchar(100)'),
    xc.value('LastName[1]', 'nvarchar(100)')
  FROM @xml_var_Person.nodes('//Person') XmlData(xc);

SELECT *
FROM [dbo].[#PersonTemporary];

-- 4 !
DECLARE @xml_var_Vendor XML
SET @xml_var_Vendor =
(
  SELECT
    [BusinessEntityID] AS 'ID',
    [Name],
    [AccountNumber]
  FROM [Purchasing].[Vendor]
  FOR XML PATH ('Vendor'), ROOT ('Vendors')
);

CREATE PROCEDURE ShowVendorXml
    @xml_var_V XML
AS
  BEGIN
    SELECT
      xc.value('ID[1]', 'int')                      AS ID,
      xc.value('Name[1]', 'nvarchar(100)')          AS NAME,
      xc.value('AccountNumber[1]', 'nvarchar(100)') AS AccountNumber
    FROM @xml_var_V.nodes('//Vendor') XmlData(xc)
  END;

EXECUTE [ShowVendorXml] @xml_var_Vendor;

DROP PROCEDURE ShowVendorXml;

-------------
--lab_7_option_5

DECLARE @xml_var_Location XML
SET @xml_var_Location =
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
  LocationID INT,
  Name       NVARCHAR(100),
  CostRate   SMALLMONEY
);

INSERT INTO #LocationTmp ([LocationID], [Name], [CostRate])
  SELECT
    xc.value('@ID', 'int'),
    xc.value('@Name', 'nvarchar(100)'),
    xc.value('@Cost', 'smallmoney')
  FROM @xml_var_Location.nodes('//Location') XmlData(xc);

DROP TABLE #LocationTmp;

-------------
--lab_7_option_6

DECLARE @xml_var_CreditCard XML
SET @xml_var_CreditCard =
(
  SELECT
    [CreditCardID] AS '@ID',
    [CardType]     AS '@Type',
    [CardNumber]   AS '@Number'
  FROM [Sales].[CreditCard]
  FOR XML PATH ('Card'), ROOT ('CreditCards')
);

CREATE PROCEDURE ShowCreditCardXml
    @xml_var_CC XML
AS
  BEGIN
    SELECT
      xc.value('@ID', 'int')               AS ID,
      xc.value('@Type', 'nvarchar(100)')   AS CardType,
      xc.value('@Number', 'nvarchar(100)') AS CardNumber
    FROM @xml_var_CC.nodes('//Card') XmlData(xc)
  END;

EXECUTE [ShowCreditCardXml] @xml_var_CreditCard;

DROP PROCEDURE ShowCreditCardXml;

-------------
--lab_7_option_7

DECLARE @xml_var_Product XML
SET @xml_var_Product =
(
  SELECT
    P.[ProductID]      AS '@ID',
    P.[Name]           AS 'Name',
    P.[ProductModelID] AS 'Model/@ID',
    PM.[Name]          AS 'Model/Name'
  FROM [Production].[Product] AS P
    JOIN [Production].[ProductModel] AS PM
      ON P.[ProductModelID] = PM.[ProductModelID]
  FOR XML PATH ('Product'), ROOT ('Products')
);

CREATE TABLE #ProductTmp
(
  ProductID        INT,
  ProductName      NVARCHAR(100),
  ProductModelID   INT,
  ProductModelName NVARCHAR(100)
);

INSERT INTO #ProductTmp ([ProductID], [ProductName], [ProductModelID], [ProductModelName])
  SELECT
    xc.value('@ID', 'int'),
    xc.value('Name[1]', 'nvarchar(100)'),
    xc.value('Model[1]/@ID', 'int'),
    xc.value('Model[1]/Name[1]', 'nvarchar(100)')
  FROM @xml_var_Product.nodes('//Product') XmlData(xc);

DROP TABLE #ProductTmp;

-------------
--lab_7_option_8

DECLARE @xml_var_Address XML
SET @xml_var_Address =
(
  SELECT
    A.[AddressID]          AS '@ID',
    A.[City]               AS 'City',
    SP.[StateProvinceID]   AS 'Province/@ID',
    SP.[CountryRegionCode] AS 'Province/Region'
  FROM [Person].[Address] AS A
    JOIN [Person].[StateProvince] AS SP
      ON A.[StateProvinceID] = SP.[StateProvinceID]
  FOR XML PATH ('Address'), ROOT ('Addresses')
);

CREATE PROCEDURE ShowAddressXml
    @xml_var_A XML
AS
  BEGIN
    SELECT
      xc.value('@ID', 'int')                             AS AddressID,
      xc.value('City[1]', 'nvarchar(100)')               AS AddressCity,
      xc.value('Province[1]/@ID', 'int')                 AS ProvinceID,
      xc.value('Province[1]/Region[1]', 'nvarchar(100)') AS ProvinceRegion
    FROM @xml_var_A.nodes('//Address') XmlData(xc)
  END;

EXECUTE [ShowAddressXml] @xml_var_Address;

DROP PROCEDURE ShowAddressXml;

-------------
--lab_7_option_9

DECLARE @xml_var_Transaction XML
SET @xml_var_Transaction =
(
  SELECT
    EDH.[StartDate] AS 'Start',
    EDH.[EndDate]   AS 'End',
    D.[GroupName]   AS 'Department/Group',
    D.[Name]        AS 'Department/Name'
  FROM [HumanResources].[EmployeeDepartmentHistory] AS EDH
    JOIN [HumanResources].[Department] AS D
      ON EDH.[DepartmentID] = D.[DepartmentID]
  FOR XML PATH ('Transaction'), ROOT ('History')
);

CREATE TABLE #TransactionTmp
(
  DepartmentSql XML
);

INSERT INTO #TransactionTmp ([DepartmentSql])
  SELECT xc.query('Department')
  FROM @xml_var_Transaction.nodes('//Transaction') XmlData(xc);

DROP TABLE #TransactionTmp;

-------------
--lab_7_option_10

DECLARE @xml_var_Person XML
SET @xml_var_Person =
(
  SELECT TOP 100
    Per.[FirstName],
    Per.[LastName],
    Pas.[ModifiedDate]     AS 'Password/Date',
    Pas.[BusinessEntityID] AS 'Password/ID'
  FROM [Person].[Person] AS Per
    JOIN [Person].[Password] AS Pas
      ON Per.[BusinessEntityID] = Pas.[BusinessEntityID]
  FOR XML PATH ('Person'), ROOT ('Persons')
);

CREATE PROCEDURE ShowPersonXml
    @xml_var_P XML
AS
  BEGIN
    SELECT xc.query('Password') AS 'sql'
    FROM @xml_var_P.nodes('//Person') XmlData(xc)
  END;

EXECUTE [ShowPersonXml] @xml_var_Person;

DROP PROCEDURE ShowPersonXml;

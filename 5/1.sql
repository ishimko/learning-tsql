USE AdventureWorks2012;
GO

IF OBJECT_ID('[dbo].[ufnGetDepartmentHumanCount]') IS NOT NULL
  DROP FUNCTION [dbo].[ufnGetDepartmentHumanCount];
GO


CREATE FUNCTION [dbo].[ufnGetDepartmentHumanCount](@DepartmentID SMALLINT)
  RETURNS INT
AS
  BEGIN
    DECLARE @ret INT;
    SELECT @ret = COUNT([edh].[BusinessEntityID])
    FROM [HumanResources].[EmployeeDepartmentHistory] AS [edh]
    WHERE [edh].[DepartmentID] = @DepartmentID
          AND [edh].[EndDate] IS NULL;
    IF (@ret IS NULL)
      SET @ret = 0;
    RETURN @ret;
  END;
GO


SELECT [dbo].[ufnGetDepartmentHumanCount](1);

IF OBJECT_ID('[dbo].[ufnGetHumansWhoWorksOver11Years]') IS NOT NULL
  DROP FUNCTION [dbo].[ufnGetHumansWhoWorksOver11Years];
GO

CREATE FUNCTION [dbo].[ufnGetHumansWhoWorksOver11Years](@DepartmentID SMALLINT)
  RETURNS TABLE
  AS
  RETURN
  (
  SELECT
    [e].[BusinessEntityID],
    [e].[NationalIDNumber],
    [e].[LoginID],
    [e].[OrganizationNode],
    [e].[OrganizationLevel],
    [e].[JobTitle],
    [e].[BirthDate],
    [e].[MaritalStatus],
    [e].[Gender],
    [e].[HireDate],
    [e].[SalariedFlag],
    [e].[VacationHours],
    [e].[SickLeaveHours],
    [e].[CurrentFlag],
    [e].[rowguid],
    [e].[ModifiedDate]
  FROM [HumanResources].[Employee] AS [e]
    JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [edh].[BusinessEntityID] = [e].[BusinessEntityID]
  WHERE [edh].[DepartmentID] = @DepartmentID
        AND [edh].[EndDate] IS NULL
        AND DATEDIFF(YEAR, [StartDate], GETDATE()) > 11
  );
GO

SELECT *
FROM [dbo].[ufnGetHumansWhoWorksOver11Years](1);

SELECT
  [d].[DepartmentID],
  [e].[BusinessEntityID],
  [e].[NationalIDNumber],
  [e].[LoginID],
  [e].[OrganizationNode],
  [e].[OrganizationLevel],
  [e].[JobTitle],
  [e].[BirthDate],
  [e].[MaritalStatus],
  [e].[Gender],
  [e].[HireDate],
  [e].[SalariedFlag],
  [e].[VacationHours],
  [e].[SickLeaveHours],
  [e].[CurrentFlag],
  [e].[rowguid],
  [e].[ModifiedDate]
FROM [HumanResources].[Department] AS [d]
  CROSS APPLY [dbo].[ufnGetHumansWhoWorksOver11Years]([d].[DepartmentID]) AS [e];

SELECT
  [d].[DepartmentID],
  [e].[BusinessEntityID],
  [e].[NationalIDNumber],
  [e].[LoginID],
  [e].[OrganizationNode],
  [e].[OrganizationLevel],
  [e].[JobTitle],
  [e].[BirthDate],
  [e].[MaritalStatus],
  [e].[Gender],
  [e].[HireDate],
  [e].[SalariedFlag],
  [e].[VacationHours],
  [e].[SickLeaveHours],
  [e].[CurrentFlag],
  [e].[rowguid],
  [e].[ModifiedDate]
FROM [HumanResources].[Department] AS [d]
  OUTER APPLY [dbo].[ufnGetHumansWhoWorksOver11Years]([d].[DepartmentID]) AS [e];

IF OBJECT_ID('[dbo].[ufnMGetHumansWhoWorksOver11Years]') IS NOT NULL
  DROP FUNCTION [dbo].[ufnMGetHumansWhoWorksOver11Years];
GO

CREATE FUNCTION [dbo].[ufnMGetHumansWhoWorksOver11Years](@DepartmentID SMALLINT)
  RETURNS @FunctionResultTableVariable TABLE(	[BusinessEntityID] [int] NOT NULL,
	[NationalIDNumber] [nvarchar](15) NOT NULL,
	[LoginID] [nvarchar](256) NOT NULL,
	[OrganizationNode] [hierarchyid] NULL,
	[JobTitle] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[MaritalStatus] [nchar](1) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[HireDate] [date] NOT NULL,
	[SalariedFlag] [dbo].[Flag] NOT NULL,
	[VacationHours] [smallint] NOT NULL,
	[SickLeaveHours] [smallint] NOT NULL,
	[CurrentFlag] [dbo].[Flag] NOT NULL,
	[rowguid] [uniqueidentifier] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL)
AS
  BEGIN
    INSERT INTO @FunctionResultTableVariable ([BusinessEntityID],
                                              [NationalIDNumber],
                                              [LoginID],
                                              [OrganizationNode],
                                              [JobTitle],
                                              [BirthDate],
                                              [MaritalStatus],
                                              [Gender],
                                              [HireDate],
											  [SalariedFlag],
                                              [VacationHours],
                                              [SickLeaveHours],
											  [CurrentFlag],
                                              [rowguid],
                                              [ModifiedDate])
      SELECT
        [e].[BusinessEntityID],
        [e].[NationalIDNumber],
        [e].[LoginID],
        [e].[OrganizationNode],
        [e].[JobTitle],
        [e].[BirthDate],
        [e].[MaritalStatus],
        [e].[Gender],
        [e].[HireDate],
		[e].[SalariedFlag],
        [e].[VacationHours],
        [e].[SickLeaveHours],
		[e].[CurrentFlag],
        [e].[rowguid],
        [e].[ModifiedDate]
      FROM [HumanResources].[Employee] AS [e]
        JOIN [HumanResources].[EmployeeDepartmentHistory] AS [edh] ON [edh].[BusinessEntityID] = [e].[BusinessEntityID]
      WHERE [edh].[DepartmentID] = @DepartmentID
            AND [edh].[EndDate] IS NULL
            AND DATEDIFF(YEAR, [StartDate], GETDATE()) > 11
    RETURN;
  END
GO


SELECT *
FROM [dbo].[ufnMGetHumansWhoWorksOver11Years](1);

SELECT
  [d].[DepartmentID],
  [e].[BusinessEntityID],
  [e].[NationalIDNumber],
  [e].[LoginID],
  [e].[OrganizationNode],
  [e].[JobTitle],
  [e].[BirthDate],
  [e].[MaritalStatus],
  [e].[Gender],
  [e].[HireDate],
  [e].[VacationHours],
  [e].[SickLeaveHours],
  [e].[rowguid],
  [e].[ModifiedDate]
FROM [HumanResources].[Department] AS [d]
  CROSS APPLY [dbo].[ufnMGetHumansWhoWorksOver11Years]([d].[DepartmentID]) AS [e];

SELECT
  [d].[DepartmentID],
  [e].[BusinessEntityID],
  [e].[NationalIDNumber],
  [e].[LoginID],
  [e].[OrganizationNode],
  [e].[JobTitle],
  [e].[BirthDate],
  [e].[MaritalStatus],
  [e].[Gender],
  [e].[HireDate],
  [e].[VacationHours],
  [e].[SickLeaveHours],
  [e].[rowguid],
  [e].[ModifiedDate]
FROM [HumanResources].[Department] AS [d]
  OUTER APPLY [dbo].[ufnMGetHumansWhoWorksOver11Years]([d].[DepartmentID]) AS [e];
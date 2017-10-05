USE AdventureWorks2012;
GO

IF OBJECT_ID('[Production].[LocationHost]') IS NOT NULL
  DROP TABLE [Production].[LocationHost];
GO

IF OBJECT_ID('[Production].[Trigger_Location_After]') IS NOT NULL
  DROP TRIGGER [Production].[Trigger_Location_After];
GO

IF OBJECT_ID('[Production].[View_Location]') IS NOT NULL
  DROP VIEW [Production].[View_Location];
GO


-- a
CREATE TABLE [Production].[LocationHost] (
  ID           INT IDENTITY (1, 1) PRIMARY KEY,
  Action       CHAR(6)     NOT NULL CHECK (Action IN ('insert', 'update', 'delete')),
  ModifiedDate DATETIME    NOT NULL,
  SourceID     INT         NOT NULL,
  UserName     VARCHAR(50) NOT NULL
);
GO


-- b
CREATE TRIGGER [Production].[Trigger_Location_After]
  ON [Production].[Location]
AFTER INSERT, UPDATE, DELETE AS
  INSERT INTO [Production].[LocationHost] (Action, ModifiedDate, SourceID, UserName)
    SELECT
      CASE WHEN inserted.LocationID IS NULL
        THEN 'delete'
      WHEN deleted.LocationID IS NULL
        THEN 'insert'
      ELSE 'update'
      END                                               AS Action,
      GETDATE()                                         AS ModifiedDate,
      COALESCE(inserted.LocationID, deleted.LocationID) AS SourceID,
      USER_NAME()                                       AS UserName
    FROM inserted
      FULL OUTER JOIN deleted
        ON inserted.LocationID = deleted.LocationID
GO


-- c
CREATE VIEW [Production].[View_Location] AS
  SELECT *
  FROM [Production].[Location]
GO


--d
INSERT INTO [Production].[View_Location]
([Name]
  , [CostRate]
  , [Availability]
  , [ModifiedDate])
VALUES
  ('Test Location'
    , '123'
    , '1.1'
    , GETDATE())
GO


UPDATE [Production].[Location]
SET [Name] = 'Test location 1'
WHERE [Name] = 'Test location'
GO

DELETE FROM [Production].[Location]
WHERE [Name] = 'Test location 1';

SELECT *
FROM [Production].[LocationHost];


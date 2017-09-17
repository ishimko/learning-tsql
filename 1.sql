USE master;
IF EXISTS(select * from sys.databases where name='NewDatabase')
DROP DATABASE NewDatabase;

CREATE DATABASE NewDatabase;

USE NewDatabase;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);

BACKUP DATABASE NewDatabase
TO DISK = 'C:\tmp\NewDatabase.bak';
GO

USE master;
DROP DATABASE NewDatabase;
GO

RESTORE DATABASE NewDatabase
FROM DISK = 'C:\tmp\NewDatabase.bak';
GO
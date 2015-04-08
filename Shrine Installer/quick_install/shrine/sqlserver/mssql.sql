use master
GO

-- Create the database

IF EXISTS (SELECT name FROM master.sys.databases WHERE name = N'SHRINE_DB_NAME')
  drop database [SHRINE_DB_NAME];


create database [SHRINE_DB_NAME];


-- Create a SQL user for query history
--grant all privileges on shrine_query_history.* to SHRINE_MYSQL_USER@SHRINE_MYSQL_HOST identified by 'SHRINE_MYSQL_PASSWORD';

-- Hibernate will create the schema for us
--drop existing login if it exists
IF EXISTS (SELECT name  FROM master.sys.server_principals WHERE name = 'SHRINE_DB_USER')
	BEGIN
		DROP LOGIN [SHRINE_DB_USER]
	END
GO


IF EXISTS (SELECT name  FROM master.sys.syslogins WHERE name = 'SHRINE_DB_USER')
	BEGIN
		DROP USER [SHRINE_DB_USER]
	END
GO


--create sql account
CREATE LOGIN [SHRINE_DB_USER]
  WITH PASSWORD=N'SHRINE_DB_PASSWORD',
  DEFAULT_DATABASE=[SHRINE_DB_NAME],
  CHECK_EXPIRATION=OFF,
  CHECK_POLICY=OFF
GO


USE SHRINE_DB_NAME
GO

--create user for the database
CREATE USER [SHRINE_DB_USER]
  FOR LOGIN [SHRINE_DB_USER]
  WITH DEFAULT_SCHEMA=[SHRINE_DB_SCHEMA]
GO


--add user to the db_owner role for the database
EXEC sp_addrolemember 'db_owner', 'SHRINE_DB_USER'
GO

---------------------------------------------------------------------------------------------

Script Purpose:
This creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists, it is dropped and recreated.
Additionally the scripts sets up three schemas within the database:bronze,silver,gold

WARNING:
Running this script will drop the entire 'DataWarehouse Database' if it exists
All data in the database will be permanently deleted.
  Proceed with caution and ensure you have proper backup before running this script.*/

USE master;
GO

--Drop and recreate the DataWarehouse Database
IF EXISTS(SELECT 1 FROM sys.database WHERE Name= 'DataWarehouse')
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;
END;
GO

---Create the DataWarehouse Database
CREATE DATABASE DataWarehouse;
GO
USE Database DataWarehouse;
GO

---Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO














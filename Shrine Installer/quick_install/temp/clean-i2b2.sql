-- FILENAME:  ./clean_hive.sql
-- The ONT and CRC DB lookup tables provide path information for the ont-ds.xml
delete from ONT_DB_LOOKUP where C_PROJECT_PATH = 'SHRINE/';
delete from CRC_DB_LOOKUP where C_PROJECT_PATH = '/SHRINE/';


-- FILENAME:  ./clean_ontology.sql
drop user  I2B2_DB_SHRINE_ONT_USER cascade;

-- These tables are dropped by casaded :
--  drop table SHRINE;
--  drop table TABLE_ACCESS;
--  drop table SCHEMES;



-- FILENAME:  ./clean_pm.sql
-- This is the SHRINE user and PROJECT

delete from PM_USER_DATA          where user_id      = 'SHRINE_USER';
delete from PM_USER_PARAMS        where user_id      = 'SHRINE_USER';
delete from PM_PROJECT_DATA       where project_name = 'SHRINE';
delete from PM_PROJECT_USER_ROLES where project_id   = 'SHRINE';
delete from PM_CELL_DATA          where project_path = '/SHRINE';

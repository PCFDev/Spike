-- FILENAME:  ./i2b2/oracle/clean_hive.sql
-- The ONT and CRC DB lookup tables provide path information for the ont-ds.xml
delete from ONT_DB_LOOKUP where C_PROJECT_PATH = 'SHRINE/';
delete from CRC_DB_LOOKUP where C_PROJECT_PATH = '/SHRINE/';


-- FILENAME:  ./i2b2/oracle/clean_ontology.sql
drop user  I2B2_DB_SHRINE_ONT_USER cascade;

-- These tables are dropped by casaded :
--  drop table SHRINE;
--  drop table TABLE_ACCESS;
--  drop table SCHEMES;



-- FILENAME:  ./i2b2/oracle/clean_pm.sql
-- This is the SHRINE user and PROJECT

delete from PM_USER_DATA          where user_id      = 'SHRINE_USER';
delete from PM_USER_PARAMS        where user_id      = 'SHRINE_USER';
delete from PM_PROJECT_DATA       where project_name = 'SHRINE';
delete from PM_PROJECT_USER_ROLES where project_id   = 'SHRINE';
delete from PM_CELL_DATA          where project_path = '/SHRINE';


-- FILENAME:  ./i2b2/oracle/ontology_create_tables.sql
   -- I2b2 1.5 convention: Holds the SHRINE Ontology Table
   CREATE TABLE SHRINE 
   (
    "C_HLEVEL" NUMBER(22,0),
	"C_FULLNAME" VARCHAR2(900), 
	"C_NAME" VARCHAR2(2000), 
	"C_SYNONYM_CD" CHAR(1), 
	"C_VISUALATTRIBUTES" CHAR(3), 
	"C_TOTALNUM" NUMBER(22,0), 
	"C_BASECODE" VARCHAR2(450), 
	"C_METADATAXML" CLOB, 
	"C_FACTTABLECOLUMN" VARCHAR2(50), 
	"C_TABLENAME" VARCHAR2(50), 
	"C_COLUMNNAME" VARCHAR2(50), 
	"C_COLUMNDATATYPE" VARCHAR2(50), 
	"C_OPERATOR" VARCHAR2(10), 
	"C_DIMCODE" VARCHAR2(900), 
	"C_COMMENT" CLOB, 
	"C_TOOLTIP" VARCHAR2(900), 
	"UPDATE_DATE" DATE, 
	"DOWNLOAD_DATE" DATE, 
	"IMPORT_DATE" DATE, 
	"SOURCESYSTEM_CD" VARCHAR2(50), 
	"VALUETYPE_CD" VARCHAR2(50),
        "M_APPLIED_PATH" VARCHAR2(900),
        "M_EXCLUSION_CD" VARCHAR2(900)
   ) ;

  -- I2b2 1.5 convention: Governs access to the SHRINE Ont table
  CREATE TABLE TABLE_ACCESS
   (
    "C_TABLE_CD" VARCHAR2(50),
	"C_TABLE_NAME" VARCHAR2(50), 
	"C_PROTECTED_ACCESS" CHAR(1),
	"C_HLEVEL" NUMBER(22,0), 
	"C_FULLNAME" VARCHAR2(900), 
	"C_NAME" VARCHAR2(2000), 
	"C_SYNONYM_CD" CHAR(1), 
	"C_VISUALATTRIBUTES" CHAR(3), 
	"C_TOTALNUM" NUMBER(22,0), 
	"C_BASECODE" VARCHAR2(450), 
	"C_METADATAXML" CLOB, 
	"C_FACTTABLECOLUMN" VARCHAR2(50), 
	"C_DIMTABLENAME" VARCHAR2(50), 
	"C_COLUMNNAME" VARCHAR2(50), 
	"C_COLUMNDATATYPE" VARCHAR2(50), 
	"C_OPERATOR" VARCHAR2(10), 
	"C_DIMCODE" VARCHAR2(900), 
	"C_COMMENT" CLOB, 
	"C_TOOLTIP" VARCHAR2(900), 
	"C_ENTRY_DATE" DATE, 
	"C_CHANGE_DATE" DATE, 
	"C_STATUS_CD" CHAR(1), 
	"VALUETYPE_CD" VARCHAR(50)
   ) ;

   -- TODO: not sure how this is actually loaded up
   CREATE TABLE  "SCHEMES"
   (
    "C_KEY" VARCHAR2(50) NOT NULL ENABLE,
	"C_NAME" VARCHAR2(50) NOT NULL ENABLE,
	"C_DESCRIPTION" VARCHAR2(100),
	 CONSTRAINT "SCHEMES_PK" PRIMARY KEY ("C_KEY") ENABLE
   )
   ;





-- FILENAME:  ./i2b2/oracle/ontology_table_access.sql
-- DELETE potential conflict entry from previous install, just to be safe.
delete from TABLE_ACCESS where c_table_cd = 'SHRINE';

-- Create a new entry in table access allowing this Ontology to be used for project SHRINE
INSERT into TABLE_ACCESS
( c_table_cd,
  c_table_name,
  c_protected_access,
  c_hlevel,
  c_name,
  c_fullname,
  c_synonym_cd,
  c_visualattributes,
  c_tooltip,
  c_facttablecolumn,
  c_dimtablename,
  c_columnname,
  c_columndatatype,
  c_dimcode,
  c_operator)
values
( 'SHRINE',
  'SHRINE',
  'N',
   0,
   'SHRINE Ontology',
   '\SHRINE\',
   'N',
   'CA',
   'SHRINE Ontology',
   'concept_cd',
   'concept_dimension',
   'concept_path',
   'T',
   '\SHRINE\',
   'LIKE')
;



-- FILENAME:  ./i2b2/oracle/skel/configure_hive_db_lookups.sql
insert into ONT_DB_LOOKUP
(C_DOMAIN_ID, C_PROJECT_PATH, C_OWNER_ID, C_DB_FULLSCHEMA, C_DB_DATASOURCE, C_DB_SERVERTYPE, C_DB_NICENAME)
VALUES
('I2B2_DOMAIN_ID','SHRINE/','@','I2B2_DB_SHRINE_ONT_USER','java:/I2B2_DB_SHRINE_ONT_DATASOURCE_NAME','ORACLE','SHRINE');

insert into CRC_DB_LOOKUP
(C_DOMAIN_ID, C_PROJECT_PATH, C_OWNER_ID, C_DB_FULLSCHEMA, C_DB_DATASOURCE, C_DB_SERVERTYPE, C_DB_NICENAME)
VALUES
( 'I2B2_DOMAIN_ID', '/SHRINE/', '@', 'I2B2_DB_CRC_USER', 'java:/I2B2_DB_CRC_DATASOURCE_NAME', 'ORACLE', 'SHRINE' );


-- FILENAME:  ./i2b2/oracle/skel/configure_pm.sql
-- Create user shrine/demouser
insert into PM_USER_DATA
(user_id, full_name, password, status_cd)
values
('SHRINE_USER', 'shrine', 'SHRINE_PASSWORD_CRYPTED', 'A');

-- TODO Override the ecommons requirement
-- http://open.med.harvard.edu/jira/browse/SHRINE-671
-- insert into PM_USER_PARAMS
-- (DATATYPE_CD, USER_ID, PARAM_NAME_CD, VALUE, CHANGEBY_CHAR, STATUS_CD)
-- values
-- ('T', 'shrine', 'ecommons_username', 'shrine', 'i2b2', 'A');

-- CREATE THE PROJECT for SHRINE
insert into PM_PROJECT_DATA
(project_id, project_name, project_wiki, project_path, status_cd)
values
('SHRINE', 'SHRINE', 'http://open.med.harvard.edu/display/SHRINE', '/SHRINE', 'A');

insert into PM_PROJECT_USER_ROLES
(PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD)
values
('SHRINE', 'SHRINE_USER', 'USER', 'A');

insert into PM_PROJECT_USER_ROLES
(PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD)
values
('SHRINE', 'SHRINE_USER', 'DATA_OBFSC', 'A');

-- captures information and registers the cells associated to the hive.
insert into PM_CELL_DATA
(cell_id, project_path, name, method_cd, url, can_override, status_cd)
values
('CRC', '/SHRINE', 'SHRINE Federated Query', 'REST', 'https://SHRINE_IP:SHRINE_SSL_PORT/shrine/rest/i2b2/', 1, 'A');


-- FILENAME:  ./i2b2/oracle/skel/ontology_create_user.sql
create user I2B2_DB_SHRINE_ONT_USER identified by I2B2_DB_SHRINE_ONT_PASSWORD;
grant create session, connect, resource to I2B2_DB_SHRINE_ONT_USER;

-- i2b2metadata.table_access
grant all privileges to I2B2_DB_SHRINE_ONT_USER;


-- FILENAME:  ./i2b2/postgres/clean_hive.sql
-- The ONT and CRC DB lookup tables provide path information for the ont-ds.xml
delete from ONT_DB_LOOKUP where C_PROJECT_PATH = 'SHRINE/';
delete from CRC_DB_LOOKUP where C_PROJECT_PATH = '/SHRINE/';


-- FILENAME:  ./i2b2/postgres/clean_ontology.sql
drop user  I2B2_DB_SHRINE_ONT_USER cascade;

-- These tables are dropped by casaded :
--  drop table SHRINE;
--  drop table TABLE_ACCESS;
--  drop table SCHEMES;



-- FILENAME:  ./i2b2/postgres/clean_pm.sql
-- This is the SHRINE user and PROJECT

delete from PM_USER_DATA          where user_id      = 'SHRINE_USER';
delete from PM_USER_PARAMS        where user_id      = 'SHRINE_USER';
delete from PM_PROJECT_DATA       where project_name = 'SHRINE';
delete from PM_PROJECT_USER_ROLES where project_id   = 'SHRINE';
delete from PM_CELL_DATA          where project_path = '/SHRINE';


-- FILENAME:  ./i2b2/postgres/skel/configure_hive_db_lookups.sql
insert into ONT_DB_LOOKUP
(C_DOMAIN_ID, C_PROJECT_PATH, C_OWNER_ID, C_DB_FULLSCHEMA, C_DB_DATASOURCE, C_DB_SERVERTYPE, C_DB_NICENAME)
VALUES
('I2B2_DOMAIN_ID','SHRINE/','@','I2B2_DB_SHRINE_ONT_USER','java:/I2B2_DB_SHRINE_ONT_DATASOURCE_NAME','POSTGRESQL','SHRINE');

-- TODO: schema work for crc lookup?
insert into CRC_DB_LOOKUP
(C_DOMAIN_ID, C_PROJECT_PATH, C_OWNER_ID, C_DB_FULLSCHEMA, C_DB_DATASOURCE, C_DB_SERVERTYPE, C_DB_NICENAME)
VALUES
( 'I2B2_DOMAIN_ID', '/SHRINE/', '@', 'public', 'java:/I2B2_DB_CRC_DATASOURCE_NAME', 'POSTGRESQL', 'SHRINE' );


-- FILENAME:  ./i2b2/postgres/skel/configure_pm.sql
-- Create user shrine/demouser
insert into PM_USER_DATA
(user_id, full_name, password, status_cd)
values
('SHRINE_USER', 'shrine', 'SHRINE_PASSWORD_CRYPTED', 'A');

-- TODO Override the ecommons requirement
-- http://open.med.harvard.edu/jira/browse/SHRINE-671
-- insert into PM_USER_PARAMS
-- (DATATYPE_CD, USER_ID, PARAM_NAME_CD, VALUE, CHANGEBY_CHAR, STATUS_CD)
-- values
-- ('T', 'shrine', 'ecommons_username', 'shrine', 'i2b2', 'A');

-- CREATE THE PROJECT for SHRINE
insert into PM_PROJECT_DATA
(project_id, project_name, project_wiki, project_path, status_cd)
values
('SHRINE', 'SHRINE', 'http://open.med.harvard.edu/display/SHRINE', '/SHRINE', 'A');

insert into PM_PROJECT_USER_ROLES
(PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD)
values
('SHRINE', 'SHRINE_USER', 'USER', 'A');

insert into PM_PROJECT_USER_ROLES
(PROJECT_ID, USER_ID, USER_ROLE_CD, STATUS_CD)
values
('SHRINE', 'SHRINE_USER', 'DATA_OBFSC', 'A');

-- captures information and registers the cells associated to the hive.
insert into PM_CELL_DATA
(cell_id, project_path, name, method_cd, url, can_override, status_cd)
values
('CRC', '/SHRINE', 'SHRINE Federated Query', 'REST', 'https://SHRINE_IP:SHRINE_SSL_PORT/shrine/rest/i2b2/', 1, 'A');


-- FILENAME:  ./i2b2/postgres/skel/ontology_create_tables.sql
   -- modified to fit Postgres 2014-07-21

   -- I2b2 1.5 convention: Holds the SHRINE Ontology Table
   CREATE TABLE I2B2_DB_SHRINE_ONT_USER.SHRINE 
   (
	C_HLEVEL NUMERIC(22,0),
	C_FULLNAME VARCHAR(900), 
	C_NAME VARCHAR(2000), 
	C_SYNONYM_CD CHAR(1), 
	C_VISUALATTRIBUTES CHAR(3), 
	C_TOTALNUM NUMERIC(22,0), 
	C_BASECODE VARCHAR(450), 
	C_METADATAXML TEXT, 
	C_FACTTABLECOLUMN VARCHAR(50), 
	C_TABLENAME VARCHAR(50), 
	C_COLUMNNAME VARCHAR(50), 
	C_COLUMNDATATYPE VARCHAR(50), 
	C_OPERATOR VARCHAR(10), 
	C_DIMCODE VARCHAR(900), 
	C_COMMENT TEXT, 
	C_TOOLTIP VARCHAR(900), 
	UPDATE_DATE DATE, 
	DOWNLOAD_DATE DATE, 
	IMPORT_DATE DATE, 
	SOURCESYSTEM_CD VARCHAR(50), 
	VALUETYPE_CD VARCHAR(50),
        M_APPLIED_PATH VARCHAR(900),
        M_EXCLUSION_CD VARCHAR(900)
   ) ;
  ALTER TABLE I2B2_DB_SHRINE_ONT_USER.SHRINE OWNER TO I2B2_DB_SHRINE_ONT_USER;
  GRANT SELECT, INSERT, UPDATE, DELETE ON I2B2_DB_SHRINE_ONT_USER.SHRINE TO I2B2_DB_ONT_USER;
  GRANT SELECT, INSERT, UPDATE, DELETE ON I2B2_DB_SHRINE_ONT_USER.SHRINE TO I2B2_DB_SHRINE_ONT_USER;
  
-- I2b2 1.5 convention: Governs access to the SHRINE Ont table
  CREATE TABLE I2B2_DB_SHRINE_ONT_USER.TABLE_ACCESS
   (
    C_TABLE_CD VARCHAR(50),
	C_TABLE_NAME VARCHAR(50), 
	C_PROTECTED_ACCESS CHAR(1),
	C_HLEVEL NUMERIC(22,0), 
	C_FULLNAME VARCHAR(900), 
	C_NAME VARCHAR(2000), 
	C_SYNONYM_CD CHAR(1), 
	C_VISUALATTRIBUTES CHAR(3), 
	C_TOTALNUM NUMERIC(22,0), 
	C_BASECODE VARCHAR(450), 
	C_METADATAXML TEXT, 
	C_FACTTABLECOLUMN VARCHAR(50), 
	C_DIMTABLENAME VARCHAR(50), 
	C_COLUMNNAME VARCHAR(50), 
	C_COLUMNDATATYPE VARCHAR(50), 
	C_OPERATOR VARCHAR(10), 
	C_DIMCODE VARCHAR(900), 
	C_COMMENT TEXT, 
	C_TOOLTIP VARCHAR(900), 
	C_ENTRY_DATE DATE, 
	C_CHANGE_DATE DATE, 
	C_STATUS_CD CHAR(1), 
	VALUETYPE_CD VARCHAR(50)
   ) ;
  ALTER TABLE I2B2_DB_SHRINE_ONT_USER.TABLE_ACCESS OWNER TO I2B2_DB_SHRINE_ONT_USER;
  GRANT SELECT, INSERT, UPDATE, DELETE ON I2B2_DB_SHRINE_ONT_USER.TABLE_ACCESS TO I2B2_DB_ONT_USER;
  GRANT SELECT, INSERT, UPDATE, DELETE ON I2B2_DB_SHRINE_ONT_USER.TABLE_ACCESS TO I2B2_DB_SHRINE_ONT_USER;

   -- TODO: not sure how this is actually loaded up
   CREATE TABLE I2B2_DB_SHRINE_ONT_USER.SCHEMES
   (
    C_KEY VARCHAR(50) NOT NULL,
	C_NAME VARCHAR(50) NOT NULL,
	C_DESCRIPTION VARCHAR(100),
	 CONSTRAINT SCHEMES_PK PRIMARY KEY (C_KEY)
   )
   ;
  ALTER TABLE I2B2_DB_SHRINE_ONT_USER.SCHEMES OWNER TO I2B2_DB_SHRINE_ONT_USER;
  GRANT SELECT, INSERT, UPDATE, DELETE ON I2B2_DB_SHRINE_ONT_USER.SCHEMES TO I2B2_DB_ONT_USER;
  GRANT SELECT, INSERT, UPDATE, DELETE ON I2B2_DB_SHRINE_ONT_USER.SCHEMES TO I2B2_DB_SHRINE_ONT_USER;




-- FILENAME:  ./i2b2/postgres/skel/ontology_create_user.sql
-- modified to fit Postgres 2014-07-23
create user I2B2_DB_SHRINE_ONT_USER with password 'I2B2_DB_SHRINE_ONT_PASSWORD';

-- create matching schema
create schema authorization I2B2_DB_SHRINE_ONT_USER;

-- i2b2metadata.table_access
grant all privileges on all tables in schema I2B2_DB_SHRINE_ONT_USER to I2B2_DB_SHRINE_ONT_USER;
grant all privileges on all sequences in schema I2B2_DB_SHRINE_ONT_USER to I2B2_DB_SHRINE_ONT_USER;
grant all privileges on all functions in schema I2B2_DB_SHRINE_ONT_USER to I2B2_DB_SHRINE_ONT_USER;


-- FILENAME:  ./i2b2/postgres/skel/ontology_table_access.sql
-- modified to fit Postgres 2014-07-21

-- DELETE potential conflict entry from previous install, just to be safe.
delete from I2B2_DB_SHRINE_ONT_USER.TABLE_ACCESS where C_TABLE_CD = 'SHRINE';

-- Create a new entry in table access allowing this Ontology to be used for project SHRINE
INSERT into I2B2_DB_SHRINE_ONT_USER.TABLE_ACCESS
( C_TABLE_CD,
  C_TABLE_NAME,
  C_PROTECTED_ACCESS,
  C_HLEVEL,
  C_NAME,
  C_FULLNAME,
  C_SYNONYM_CD,
  C_VISUALATTRIBUTES,
  C_TOOLTIP,
  C_FACTTABLECOLUMN,
  C_DIMTABLENAME,
  C_COLUMNNAME,
  C_COLUMNDATATYPE,
  C_DIMCODE,
  C_OPERATOR)
values
( 'SHRINE',
  'SHRINE',
  'N',
   0,
   'SHRINE Ontology',
   '\SHRINE\',
   'N',
   'CA',
   'SHRINE Ontology',
   'concept_cd',
   'concept_dimension',
   'concept_path',
   'T',
   '\SHRINE\',
   'LIKE')
;



-- FILENAME:  ./shrine/mysql.sql
-- Create the database
drop database if exists shrine_query_history;
create database shrine_query_history; 

-- Create a SQL user for query history
grant all privileges on shrine_query_history.* to SHRINE_MYSQL_USER@SHRINE_MYSQL_HOST identified by 'SHRINE_MYSQL_PASSWORD';

-- Hibernate will create the schema for us



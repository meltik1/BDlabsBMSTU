drop table customers;
drop table documents;
drop table locations;
drop table realty;
drop table realty_agencies;

create table customers(customer_id number(6) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1)  primary key ,
                       ra_id number(6),
                       first_name nvarchar2(50), last_name nvarchar2(50), email nvarchar2(50),
                       phone nvarchar2(50), wealth number(9), credit_rating number(2,1), birthdate date);

create table documents(document_id number(6) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) primary  key,
                       customer_id NUMBER(6),
                       realty_id number(6), price number(12), date_of_purchasing date);

create table locations(id number(6) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) primary Key,
                       postal_code number(6), house_num number(4), street NVARCHAR2(40), city nvarchar2(40), country NVARCHAR2(50));

create table realty(realty_id number(6) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) primary key,
                    location_id number(6), ra_id number(6), cadastral_price number(15,1), rent_price number(8,1),
                    is_commercial char(1) check(is_commercial in('Y','N')), date_of_building date);

create table realty_agencies(ra_id number(6) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) primary key, location_id number(6),
                             agency_name nvarchar2(50), rating number(2,1), founding_date date, parent_company number(4));

SET DEFINE OFF
--CREATE OR REPLACE DIRECTORY ORACLE_HOME AS 'C:\Users\meltik\AppData\Roaming\SQL Developer';
--GRANT READ ON DIRECTORY ORACLE_HOME TO USER;
--GRANT WRITE ON DIRECTORY ORACLE_HOME TO USER;
--drop table CUSTOMERS_STAGE;
CREATE TABLE CUSTOMERS_STAGE
( RA_ID NUMBER(6),
  FIRST_NAME NVARCHAR2(50),
  LAST_NAME NVARCHAR2(50),
  EMAIL NVARCHAR2(50),
  PHONE NVARCHAR2(50),
  WEALTH NUMBER(9),
  CREDIT_RATING NUMBER(2, 1),
  BIRTHDATE DATE)
    ORGANIZATION EXTERNAL
    (  TYPE ORACLE_LOADER
        DEFAULT DIRECTORY ORACLE_HOME
        ACCESS PARAMETERS
        (records delimited BY '\r\n'
        NOBADFILE
        NODISCARDFILE
        NOLOGFILE
        skip 1
        fields terminated BY ','
            OPTIONALLY ENCLOSED BY '"' AND '"'
            lrtrim
            missing field VALUES are NULL
            ( RA_ID CHAR(4000),
            FIRST_NAME CHAR(4000),
            LAST_NAME CHAR(4000),
            EMAIL CHAR(4000),
            PHONE CHAR(4000),
            WEALTH CHAR(4000),
            CREDIT_RATING CHAR(4000),
            BIRTHDATE CHAR(4000) date_format DATE mask "YYYY-MM-DD"
            )
        )
        LOCATION ('customers.csv')
        )
        REJECT LIMIT UNLIMITED;



whenever sqlerror exit rollback;
begin
    INSERT INTO CUSTOMERS (RA_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, WEALTH, CREDIT_RATING, BIRTHDATE)
    SELECT RA_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, WEALTH, CREDIT_RATING, BIRTHDATE FROM CUSTOMERS_STAGE ;
    COMMIT;
    EXECUTE IMMEDIATE 'DROP TABLE CUSTOMERS_STAGE';
end;
/

SET DEFINE OFF
--CREATE OR REPLACE DIRECTORY Enter New Dir AS 'C:\Users\meltik\Documents\csvForLab01';
--GRANT READ ON DIRECTORY Enter New Dir TO USER;
--GRANT WRITE ON DIRECTORY Enter New Dir TO USER;
--drop table DOCUMENTS_STAGE;
CREATE TABLE DOCUMENTS_STAGE
( CUSTOMER_ID NUMBER(6),
  REALTY_ID NUMBER(6),
  PRICE NUMBER(12),
  DATE_OF_PURCHASING DATE)
    ORGANIZATION EXTERNAL
    (  TYPE ORACLE_LOADER
        DEFAULT DIRECTORY ORACLE_HOME
        ACCESS PARAMETERS
        (records delimited BY '\r\n'
        NOBADFILE
        NODISCARDFILE
        NOLOGFILE
        skip 1
        fields terminated BY ','
            OPTIONALLY ENCLOSED BY '"' AND '"'
            lrtrim
            missing field VALUES are NULL
            ( CUSTOMER_ID CHAR(4000),
            REALTY_ID CHAR(4000),
            PRICE CHAR(4000),
            DATE_OF_PURCHASING CHAR(4000) date_format DATE mask "YYYY-MM-DD"
            )
        )
        LOCATION ('contracts.csv')
        )
        REJECT LIMIT UNLIMITED;



whenever sqlerror exit rollback;
begin
    INSERT INTO DOCUMENTS (CUSTOMER_ID, REALTY_ID, PRICE, DATE_OF_PURCHASING)
    SELECT CUSTOMER_ID, REALTY_ID, PRICE, DATE_OF_PURCHASING FROM DOCUMENTS_STAGE ;
    COMMIT;
    EXECUTE IMMEDIATE 'DROP TABLE DOCUMENTS_STAGE';
end;
/


SET DEFINE OFF
--CREATE OR REPLACE DIRECTORY ORACLE_HOME AS 'C:\Users\meltik\Documents\csvForLab01';
--GRANT READ ON DIRECTORY ORACLE_HOME TO USER;
--GRANT WRITE ON DIRECTORY ORACLE_HOME TO USER;
--drop table REALTY_STAGE;
CREATE TABLE REALTY_STAGE
( LOCATION_ID NUMBER(6),
  RA_ID NUMBER(6),
  CADASTRAL_PRICE NUMBER(15, 1),
  RENT_PRICE NUMBER(8, 1),
  IS_COMMERCIAL CHAR(1),
  DATE_OF_BUILDING DATE)
    ORGANIZATION EXTERNAL
    (  TYPE ORACLE_LOADER
        DEFAULT DIRECTORY ORACLE_HOME
        ACCESS PARAMETERS
        (records delimited BY '\r\n'
        NOBADFILE
        NODISCARDFILE
        NOLOGFILE
        skip 1
        fields terminated BY ','
            OPTIONALLY ENCLOSED BY '"' AND '"'
            lrtrim
            missing field VALUES are NULL
            ( LOCATION_ID CHAR(4000),
            RA_ID CHAR(4000),
            CADASTRAL_PRICE CHAR(4000),
            RENT_PRICE CHAR(4000),
            IS_COMMERCIAL CHAR(4000),
            DATE_OF_BUILDING CHAR(4000) date_format DATE mask "YYYY-MM-DD"
            )
        )
        LOCATION ('r.csv')
        )
        REJECT LIMIT UNLIMITED;



whenever sqlerror exit rollback;
begin
    SELECT LOCATION_ID, RA_ID, CADASTRAL_PRICE, RENT_PRICE, IS_COMMERCIAL, DATE_OF_BUILDING FROM REALTY_STAGE ;
    COMMIT;
    EXECUTE IMMEDIATE 'DROP TABLE REALTY_STAGE';
end;
/


SET DEFINE OFF
--CREATE OR REPLACE DIRECTORY ORACLE_HOME AS 'C:\Users\meltik\AppData\Roaming\SQL Developer';
--GRANT READ ON DIRECTORY ORACLE_HOME TO USER;
--GRANT WRITE ON DIRECTORY ORACLE_HOME TO USER;
--drop table LOCATIONS_STAGE;
CREATE TABLE LOCATIONS_STAGE
( POSTAL_CODE NUMBER(6),
  HOUSE_NUM NUMBER(4),
  STREET NVARCHAR2(40),
  CITY NVARCHAR2(40),
  COUNTRY NVARCHAR2(50))
    ORGANIZATION EXTERNAL
    (  TYPE ORACLE_LOADER
        DEFAULT DIRECTORY ORACLE_HOME
        ACCESS PARAMETERS
        (records delimited BY '\r\n'
        NOBADFILE
        NODISCARDFILE
        NOLOGFILE
        skip 1
        fields terminated BY ','
            OPTIONALLY ENCLOSED BY '"' AND '"'
            lrtrim
            missing field VALUES are NULL
            ( POSTAL_CODE CHAR(4000),
            HOUSE_NUM CHAR(4000),
            STREET CHAR(4000),
            CITY CHAR(4000),
            COUNTRY CHAR(4000)
            )
        )
        LOCATION ('locations.csv')
        )
        REJECT LIMIT UNLIMITED;


whenever sqlerror exit rollback;
begin
    INSERT INTO LOCATIONS (POSTAL_CODE, HOUSE_NUM, STREET, CITY, COUNTRY)
    SELECT POSTAL_CODE, HOUSE_NUM, STREET, CITY, COUNTRY FROM LOCATIONS_STAGE ;
    COMMIT;
    EXECUTE IMMEDIATE 'DROP TABLE LOCATIONS_STAGE';
end;
/

SET DEFINE OFF
--CREATE OR REPLACE DIRECTORY ORACLE_HOME AS 'C:\Users\meltik\Documents\csvForLab01';
--GRANT READ ON DIRECTORY ORACLE_HOME TO USER;
--GRANT WRITE ON DIRECTORY ORACLE_HOME TO USER;
--drop table REALTY_AGENCIES_STAGE;
CREATE TABLE REALTY_AGENCIES_STAGE
( LOCATION_ID NUMBER(6),
  AGENCY_NAME NVARCHAR2(50),
  RATING NUMBER(2, 1),
  FOUNDING_DATE DATE,
  PARENT_COMPANY NUMBER(4))
    ORGANIZATION EXTERNAL
    (  TYPE ORACLE_LOADER
        DEFAULT DIRECTORY ORACLE_HOME
        ACCESS PARAMETERS
        (records delimited BY '\r\n'
        NOBADFILE
        NODISCARDFILE
        NOLOGFILE
        skip 1
        fields terminated BY ','
            OPTIONALLY ENCLOSED BY '"' AND '"'
            lrtrim
            missing field VALUES are NULL
            ( LOCATION_ID CHAR(4000),
            AGENCY_NAME CHAR(4000),
            RATING CHAR(4000),
            FOUNDING_DATE CHAR(4000) date_format DATE mask "YYYY-MM-DD",
            PARENT_COMPANY CHAR(4000)
            )
        )
        LOCATION ('ra.csv')
        )
        REJECT LIMIT UNLIMITED;



whenever sqlerror exit rollback;
begin
    INSERT INTO REALTY_AGENCIES (LOCATION_ID, AGENCY_NAME, RATING, FOUNDING_DATE, PARENT_COMPANY)
    SELECT LOCATION_ID, AGENCY_NAME, RATING, FOUNDING_DATE, PARENT_COMPANY FROM REALTY_AGENCIES_STAGE ;
    COMMIT;
    EXECUTE IMMEDIATE 'DROP TABLE REALTY_AGENCIES_STAGE';
end;
/













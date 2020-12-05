
/*
 loadjava -resolve -user meltik/300800@dblabs bdalb-1.0.jar
 */
/*1*/
drop function get_ra_id;
create or replace function get_ra_id(id number) return varchar2
as language java name 'lab4/JDBCConnection.get_ra_by_id(int) return java.lang.String';

select get_ra_id(2) from dual;

/*2/
    Возвращает количество собственности у агенства
 */
create or replace function aggregate(ra_id number) return number
as language java name 'lab4/JDBCConnection.agregate_function(int) return int';

select aggregate(5) from dual;


/*
    Таблчичная функция
 */

create type customers_java as OBJECT(id_cust number, first_name varchar2(30), lat_name varchar2(30));
create type customers_java_table as table of customers_java;

create or replace function table_func(id number) return customers_java_table
as LANGUAGE java name 'lab4/JDBCConnection.table_function(int) return oracle.sql.ARRAY';

select * from table (TABLE_FUNC(1));
/*
 процедура
 */





create or replace function fast_create return number as
    language java name 'lab4/JDBCConnection.procedure() return int';

SELECT * from REALTY
where REALTY_ID> 999;

DECLARE
    res number;
BEGIN
    res  := fast_create();
end;


create function struct_ret(id number) return CUSTOMERS_T
as language java name 'lab4/JDBCConnection.struct(int) return oracle.sql.STRUCT';

DECLARE
     f CUSTOMERS_T;
BEGIN
    f := struct_ret(1);
    DBMS_OUTPUT.PUT_LINE(f.ID || ' ' || f.NAME_OF_CUST);
end;


create or replace function trig(id_realty number, id_cust number) return number as
    LANGUAGE JAVA NAME 'lab4/JDBCConnection.trigger(int, int) return int';

create or replace trigger balance_minus
    after insert on DOCUMENTS for each row
    declare
        tmp number;
    begin
        tmp := trig(:NEW.REALTY_ID, :NEW.CUSTOMER_ID);
    end;

SELECT WEALTH FROM CUSTOMERS
    where CUSTOMER_ID = 1;

INSERT INTO DOCUMENTS( CUSTOMER_ID, REALTY_ID)
    values (1, 100 );

SELECT
    object_name,
    object_type,
    status,
    timestamp
FROM
    user_objects
WHERE
    (object_name NOT LIKE 'SYS_%' AND
     object_name NOT LIKE 'CREATE$%' AND
     object_name NOT LIKE 'JAVA$%' AND
     object_name NOT LIKE 'LOADLOB%') AND
        object_type LIKE 'JAVA %'
ORDER BY
    object_type,
    object_name;



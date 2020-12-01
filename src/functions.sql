
drop type customers_t;
drop type customers_t_t;
create type customers_t as OBJECT (
                                      id number, name_of_cust nvarchar2(60)
                                  );
create  type customers_t_t as table of customers_t;

create function customer_ret
    return customers_t_t
    PIPELINED is
    cus customers_t;
    cursor ex is
        select customers_t(CUSTOMER_ID, FIRST_NAME)  from CUSTOMERS;
BEGIN
    OPEN ex;
    LOOP
        FETCH ex into cus;
        EXIT WHEN  ex%NOTFOUND;
        PIPE ROW (customers_t(cus.id, cus.name_of_cust));
    END LOOP ;
    CLOSE EX;
    RETURN;
end;

select * from table(CUSTOMER_RET());

create type ra_t as OBJECT(id number, parent_id number , company nvarchar2(60));
create type ra_t_t as table of ra_t;

/*
 Функция ищущая компанию родителя всех дочерних компаний
 */
create or replace function RA_HIERARCHY(id number) return
    ra_t_t
    is
    ra_i ra_t;
    table_r ra_t_t := ra_t_t();
    table_res ra_t_t := ra_t_t();
    cursor ra_get is
        select ra_t(RA_ID, PARENT_COMPANY, AGENCY_NAME) from REALTY_AGENCIES
        where RA_ID = id;
BEGIN
    OPEN ra_get;
    LOOP
        FETCH ra_get into ra_i;
        EXIT WHEN  ra_get%NOTFOUND;
        table_r.extend;
        table_r(table_r.LAST) := ra_i;
    end loop;
    CLOSE ra_get;
    if (ra_i.parent_id is not null) then
        table_res := RA_HIERARCHY(ra_i.parent_id);
    else
        table_res := table_r;
    end if;

    return  table_res;
end;

select * from table ( RA_HIERARCHY(1));

create or replace procedure update_balance(cus_id number, money_to_add number) IS
BEGIN
    UPDATE CUSTOMERS
    set WEALTH = WEALTH + money_to_add
    where CUSTOMER_ID = cus_id;
end;

select WEALTH from CUSTOMERS
where CUSTOMER_ID = 1;

BEGIN
    update_balance(1, 100);
end;

select * from REALTY;


create or replace procedure consume_realty(ra_id_hunter number , ra_id_prey number) is
    cursor get_realty is select * from CUSTOMERS where RA_ID = ra_id_prey;
    cus CUSTOMERS%ROWTYPE;
BEGIN
    open get_realty;
    LOOP
        FETCH get_realty INTO cus;
        EXIT WHEN get_realty%NOTFOUND;
        Update CUSTOMERS
        set RA_ID = ra_id_hunter
        where CUSTOMER_ID = cus.CUSTOMER_ID;
    end loop;
    close get_realty;
end;

select * from CUSTOMERS
where RA_ID = 4;

select count(*) from CUSTOMERS
where RA_ID = 1;

/*
BEGIN
    CONSUME_REALTY(1, 4);
end;
*/

alter table CUSTOMERS drop constraint wealth_check;
alter table CUSTOMERS add constraint wealth_check check (WEALTH >= 0 );

alter table DRIVER add constraint checker1  check (LICENSE > 0);
alter table DRIVER add constraint checker2  check (PHONE > 0);
select * from USER_CONSTRAINTS;


drop function DROP_CHECK_CONSTR;
create or replace procedure drop_check_constr(table_name_user nvarchar2, type2 nvarchar2) is
    meta_row USER_CONSTRAINTS%ROWTYPE;
    cursor constr is  select * from USER_CONSTRAINTS
                      where TABLE_NAME = table_name_user and CONSTRAINT_TYPE = type2;
BEGIN
    OPEN constr;
    LOOP
        FETCH constr into meta_row;
        EXIT WHEN constr%NOTFOUND;
        EXECUTE IMMEDIATE 'alter table ' || meta_row.TABLE_NAME || ' drop constraint ' || meta_row.CONSTRAINT_NAME;
    end loop;
    CLOSE constr;
end;

BEGIN
    DROP_CHECK_CONSTR('DRIVER', 'C');
end;

create table wealth_logger(id number PRIMARY KEY , client_id number, description nvarchar2(50));

create sequence log_seq
    start with 1
    increment by 1
    NOMAXVALUE;

create trigger incr before insert on wealth_logger for each row
begin
    select log_seq.nextval into :new.id from dual;
end;



create or replace trigger wealth_logging
    after update of WEALTH on CUSTOMERS
    for each row
begin
    if :OLD.WEALTH < :NEW.wealth then
        INSERT INTO wealth_logger(client_id, description)
        values (:NEW.customer_id, 'Added '  || (:NEW.wealth - :OLD.wealth) || 'on balance');
    end if;
    if
            :old.wealth > :new.wealth then
        INSERT INTO wealth_logger(client_id, description)
        values (:NEW.customer_id, 'Removed '  || (:NEW.wealth - :old.wealth) || 'on balance');
    end if;
end;

select * from wealth_logger;

BEGIN
    update_balance(1, 100);
end;

select * from wealth_logger;

create view customers_and_realty as
select unique CUSTOMERS.CUSTOMER_ID as "customer_id", WEALTH as "WEALTH",  count(R2.REALTY_ID) over ( partition by CUSTOMERS.CUSTOMER_ID) as "realty count"
from CUSTOMERS join DOCUMENTS D on CUSTOMERS.CUSTOMER_ID = D.CUSTOMER_ID
               join REALTY R2 on R2.REALTY_ID = D.REALTY_ID
order by 1;

create view loc_view as
select * from LOCATIONS;

INSERT into loc_view(postal_code, house_num, street, city, country) values
(23, 2, 'Pushkina', 'Egipetks', 'Mexica');

select * from loc_view;

select * from LOCATIONS;

create or replace trigger view_updater
    instead of insert on loc_view
    for each row
BEGIN
    if (:new.COUNTRY != 'Mexica' and :new.COUNTRY != 'Ethopia') then
        INSERT into LOCATIONS(postal_code, house_num, street, city, country) values
        (:new.POSTAL_CODE, :new.POSTAL_CODE, :new.STREET, :new.CITY, :new.COUNTRY);
    else
        DBMS_OUTPUT.PUT_LINE('Our managers marked this county as potentinally dangerous');
    end if;
end;




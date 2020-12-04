
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

/*
 Функция ищущая компанию родителя всех дочерних компаний
 */


create type ra_t as OBJECT(id number, parent_id number , company nvarchar2(60));
create type ra_t_t as table of ra_t;

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

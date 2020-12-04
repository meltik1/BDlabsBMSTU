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

BEGIN
    consume_realty(1, 4);
end;
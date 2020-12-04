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

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
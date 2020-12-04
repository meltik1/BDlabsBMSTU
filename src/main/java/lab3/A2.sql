
drop type customers_t;
drop type customers_t_t;
create type customers_t as OBJECT (
                                      id number, name_of_cust nvarchar2(60)
                                  );
create  type customers_t_t as table of customers_t;

create or replace function customer_ret(id_i number)
    return customers_t_t
    PIPELINED is
    cus customers_t;
    cursor ex is
        select customers_t(CUSTOMER_ID, FIRST_NAME)  from CUSTOMERS where  CUSTOMER_ID= id_i ;
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

select * from table(CUSTOMER_RET(2));
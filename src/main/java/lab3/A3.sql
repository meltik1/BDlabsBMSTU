
drop type customers_t;
drop type customers_t_t;
create type customers_t as OBJECT (
                                      id number, name_of_cust nvarchar2(60)
                                  );

create  type customers_t_t as table of customers_t;

create or replace function customer_ret_wealth(wealth_i number, rating number)
    return customers_t_t
    PIPELINED is
    cus CUSTOMERS%ROWTYPE;
    cursor ex is
        select * from CUSTOMERS where  WEALTH > wealth_i  and  CREDIT_RATING >rating;

BEGIN
    OPEN ex;
    LOOP
        FETCH ex into cus;
        EXIT WHEN  ex%NOTFOUND;
        PIPE ROW (customers_t(cus.CUSTOMER_ID, cus.LAST_NAME));
    END LOOP ;
    CLOSE EX;
    RETURN;
end;

select * from table(CUSTOMER_RET_WEALTH(20000, 4.5));
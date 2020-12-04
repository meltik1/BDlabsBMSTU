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

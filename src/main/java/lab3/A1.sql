create FUNCTION CountALl
    return number is
    total number(4):= 0;
BEGIN
    SELECT COUNT(*)  into total FROM REALTY_AGENCIES;
    return total;
END;

select CountALl() from dual;

DECLARE
    total number := CountALl();
BEGIN

    DBMS_OUTPUT.PUT_LINE(total);
end;
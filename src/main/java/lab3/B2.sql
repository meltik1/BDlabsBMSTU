/*
Увеличим рейтинг дочерних компаний если увелечился рейтинг родительской
 */
create or replace procedure RA_RATING(id number, reward number)
    is
    ra_i REALTY_AGENCIES%ROWTYPE;
BEGIN
    select *  INTO ra_i from REALTY_AGENCIES
        where RA_ID = id;
    update REALTY_AGENCIES
        set RATING = RATING + reward
        where RA_ID = id;
    if (ra_i.PARENT_COMPANY is not null) then
        RA_RATING(ra_i.PARENT_COMPANY, reward);
    end if;
end;

select * from REALTY_AGENCIES;

BEGIN
    RA_RATING(1, 0.1);
end;

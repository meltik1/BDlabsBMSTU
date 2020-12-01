/*
    1 all realty from russia
 */

select R.REALTY_ID,  L2.ID, L2.STREET
from REALTY R join LOCATIONS L2 on L2.ID = R.LOCATION_ID
where L2.COUNTRY = 'Russia'
order by r.REALTY_ID;

/*
   2 wealth between
 */
select distinct FIRST_NAME, LAST_NAME, WEALTH
from CUSTOMERS
where WEALTH between 4882775 and  6000000
order by CUSTOMER_ID;


/*
  3 customers of ra that starts with Wa
 */
select c.FIRST_NAME, c.LAST_NAME, c.WEALTH, RA.AGENCY_NAME
from CUSTOMERS c join REALTY_AGENCIES RA on RA.RA_ID = c.RA_ID
where RA.AGENCY_NAME LIKE 'Wa%';

/*
 4 query with rich guys in it
 */

select c.FIRST_NAME || ' ' || c.LAST_NAME  as "RICH guys"
from CUSTOMERS c
where c.CUSTOMER_ID in (select ci.CUSTOMER_ID
    from CUSTOMERS ci join DOCUMENTS D on ci.CUSTOMER_ID = D.CUSTOMER_ID
    where d.PRICE > 5990224);

/*
 if exists customers that doesn't posses realty
 */
select CUSTOMER_ID, LAST_NAME
from CUSTOMERS
where EXISTS(select c.CUSTOMER_ID, DOCUMENT_ID
             from CUSTOMERS c
                      left join DOCUMENTS D on c.CUSTOMER_ID = D.CUSTOMER_ID
             where d.CUSTOMER_ID is null);

/* customers with
   wealth more than all cstomers in that ra
 */
select CUSTOMER_ID, FIRST_NAME, LAST_NAME
from CUSTOMERS
where WEALTH > all (select WEALTH from CUSTOMERS join REALTY_AGENCIES RA on RA.RA_ID = CUSTOMERS.RA_ID
where RA.AGENCY_NAME = 'Robinson, Taylor and Taylor');

/*
 aggregate
 */
select RA_ID, avg(CADASTRAL_PRICE), sum(RENT_PRICE)/count(RA_ID)
from REALTY
group by RA_ID;

/*
 subqueries in columns
 */
select RA.RA_ID, RA.AGENCY_NAME, (select avg(CADASTRAL_PRICE) from REALTY R
where R.RA_ID = RA.RA_ID) as "AVG PRICE", (select min(CADASTRAL_PRICE) from REALTY R
    where R.RA_ID = RA.RA_ID) as "MIN PRICE"
from REALTY_AGENCIES RA;

/*
 case
 */
select  R.REALTY_ID,
       case  EXTRACT( YEAR FROM DATE_OF_BUILDING)
           when EXTRACT( YEAR FROM sysdate) THEN 'This year'
           when EXTRACT(YEAR FROM sysdate) - 1 THEN 'Last year'
           ELSE TO_CHAR(EXTRACT(YEAR  from sysdate) - EXTRACT(YEAR from DATE_OF_BUILDING)) || ' years ago'
           END as "Year of bulding"
from REALTY R;

/*
 case with search
 */
select RA.AGENCY_NAME,
       case
        when RA.RATING >4.7 THEN 'Very High rated'
        when RA.RATING > 4.0 THEN 'High Rated'
        when RA.RATING > 3.0 THEN 'Medium Rated'
        when RA.RATING < 3.0 THEN 'Low Rated'
        END as "Rating"
from REALTY_AGENCIES RA;

/*
 temporary table from statment
 */
create  table  s as
select AGENCY_NAME ,
       count(R2.REALTY_ID) as "Realty quantity",
       avg(R2.CADASTRAL_PRICE) "Average price"
from REALTY_AGENCIES join REALTY R2 on REALTY_AGENCIES.RA_ID = R2.RA_ID
group by AGENCY_NAME;

/*
 union and subqueries in FROM
 */
select 'Customers of RA with best rating' as "criteria", LAST_NAME, RA.RA_ID
from CUSTOMERS c join (select  * from (select  RA_ID, RATING
    from REALTY_AGENCIES RA
    order by  RATING desc )
    where ROWNUM = 1) RA on C.RA_ID = RA.RA_ID
union
select 'Customers of RA worst rating' as "criteria", LAST_NAME, RA.RA_ID
from CUSTOMERS c join (select  * from (select  RA_ID, RATING
                                       from REALTY_AGENCIES RA
                                       order by  RATING  )
                       where ROWNUM = 1) RA on C.RA_ID = RA.RA_ID;

/*
 3 level
 */
select 'Customers in RA with best rating having more than 100 realty' as "criteria", LAST_NAME, RA.RA_ID
from CUSTOMERS c join (select  * from (select  RA_ID, RATING
                                       from (
                                            select RA2.RA_ID, RATING, count(R.REALTY_ID)
                                                from REALTY_AGENCIES RA2 join REALTY R on RA2.RA_ID = R.RA_ID
                                                group by RA2.RA_ID, RATING
                                                having count(R.REALTY_ID) > 100
                                                )
                                       order by  RATING desc
                                            )
                       where ROWNUM = 1) RA on C.RA_ID = RA.RA_ID;

/*
 group by
 */
select AGENCY_NAME, count(R.REALTY_ID), min(R.CADASTRAL_PRICE), avg(R.RENT_PRICE)
from REALTY_AGENCIES join REALTY R on REALTY_AGENCIES.RA_ID = R.RA_ID
group by AGENCY_NAME;

/*
 group by having
 */
select AGENCY_NAME, count(R.REALTY_ID), min(R.CADASTRAL_PRICE), avg(R.RENT_PRICE)
from REALTY_AGENCIES join REALTY R on REALTY_AGENCIES.RA_ID = R.RA_ID
group by AGENCY_NAME
having (max(R.CADASTRAL_PRICE) > 9918876.0);

Insert into REALTY (LOCATION_ID, RA_ID, CADASTRAL_PRICE, RENT_PRICE, IS_COMMERCIAL, DATE_OF_BUILDING)
values (10, 2, 23123213, 56000, 'Y', TO_DATE('2020-10-08', 'YYYY-MM-DD'));

truncate table s;

INSERT INTO S (AGENCY_NAME, "Realty quantity", "Average price")
select AGENCY_NAME ,
       count(R2.REALTY_ID) ,
       avg(R2.CADASTRAL_PRICE)
from REALTY_AGENCIES join REALTY R2 on REALTY_AGENCIES.RA_ID = R2.RA_ID
group by AGENCY_NAME
having count(R2.REALTY_ID) > 100;

select * from s;

select WEALTH from CUSTOMERS
    where CUSTOMER_ID = 10;

update customers
set wealth = wealth*1.5
where customer_id = 10;

update customers
set WEALTH =  (select avg(WEALTH) from CUSTOMERS)
where customer_id = 10;


delete DOCUMENTS
where CUSTOMER_ID = 33;

delete from DOCUMENTS d
where d.DOCUMENT_ID in (
    select d.DOCUMENT_ID from CUSTOMERS c join d on d.CUSTOMER_ID = c.CUSTOMER_ID
    where c.LAST_NAME  LIKE 'A%'
    );


/*Среднее количество собственности в распоряжении для агенист

 */
with ct(realty_name, count) as (
    select AGENCY_NAME, count(R.Realty_id) as "cnt" from REALTY_AGENCIES
    join REALTY R on REALTY_AGENCIES.RA_ID = R.RA_ID
    group by AGENCY_NAME
)
select avg(c.count) from ct  c;


/*
 Иерархия компаний через рекурсию
 */

update REALTY_AGENCIES
set PARENT_COMPANY = null
where RA_ID = 7;


with ierarchy(ra_id, name, parent_com, levele) as (
    select RA_ID, AGENCY_NAME, PARENT_COMPANY, 0 as "levele" from REALTY_AGENCIES hra
    where PARENT_COMPANY is null
    union ALL
    select  sra.RA_ID, AGENCY_NAME, PARENT_COMPANY,  i.levele + 1
    from REALTY_AGENCIES sra join ierarchy i on sra.PARENT_COMPANY = i.ra_id
)
select  lpad (i.name , length(i.name) + (i.levele)*3) as "company ierarchy" from ierarchy i;

/*
 analytic functions
 */
select c.FIRST_NAME, c.LAST_NAME , c.EMAIL,  EXTRACT( YEAR from c.BIRTHDATE),
       avg(WEALTH) over (partition by EXTRACT( YEAR from c.BIRTHDATE)) as "avg wealth",
       min(WEALTH) over (partition by EXTRACT( YEAR from c.BIRTHDATE)) as "max wealth",
       max(WEALTH) over (partition by EXTRACT( YEAR from c.BIRTHDATE)) as "min wealth"
from CUSTOMERS c


select ROW_NUMBER() over (partition by RA_ID order by c.WEALTH), RA_ID, WEALTH
from CUSTOMERS c;

delete from REALTY_AGENCIES
where RA_ID in (
    with tmp(rownnum1, RA_ID, AGENCY_NAME) as (
        SELECT ROW_NUMBER() over (partition by AGENCY_NAME order by RA_ID), RA_ID, AGENCY_NAME
        from REALTY_AGENCIES
    )
    select RA_ID
    from tmp
    where rownnum1 != 1
);
select * from REALTY_AGENCIES;

INSERT INTO REALTY_AGENCIES (AGENCY_NAME, LOCATION_ID, RATING, FOUNDING_DATE)
    select AGENCY_NAME, LOCATION_ID, RATING, FOUNDING_DATE
    from REALTY_AGENCIES
    where RA_ID = 1;


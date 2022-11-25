proc sql;
select sales ,segment
from work.Superstore
where Segment = "Consumer";
run;

/* Total Monthly sales in years*/
proc sql;
CREATE TABLE Annual_Sales as
select sum(sales) as 'Monthly Sales'n  , Omonths, oyears
from work.Superstore
group by oyears , Omonths
order by oyears , Omonths;
run;

proc sgplot data = Annual_Sales;

    title "Monthly total sales per year";
    series x=Omonths  y='Monthly Sales'n /group = Oyears;
    xaxis values = (1 to 12); 
 
run;

/* Shipping speed*/
proc sql;
CREATE TABLE Shipping_Speed as
select distinct('ship mode'n) , round(avg( 'Ship Date'n - 'Order Date'n ),2) as Difference
from work.Superstore
group by 'ship mode'n 
order by Difference;
run;

proc gchart data=work.Shipping_Speed;
  pie 'ship mode'n / sumvar=Difference
           value=arrow
           percent=arrow
                noheading
            percent=inside plabel=(height=12pt)
            slice=inside value=none
            name='PieChart';

run;
/*preffered ship mode for each segment*/
PROC SQL;
CREATE TABLE preffered_ship_mode AS
SELECT segment, 'ship mode'n, COUNT('ship mode'n) As counter
FROM WORK.Superstore
GROUP BY 'ship mode'n,segment 
ORDER BY segment;
RUN;

proc SGPLOT data = work.preffered_ship_mode;
title 'Preffered ship mode on each segment';
    vbar segment / response= counter group = 'ship mode'n GROUPDISPLAY = CLUSTER ;

run;

/*Top 5(regular)customers based on store visit*/
/*customers usually by from the same segment based on all their transactions*/
proc sql outbs = 5;
create table regular_customer as 
select distinct 'customer name'n ,count('customer name'n) as visits
from work.superstore
Group by 'customer name'n
order by visits desc;
run;

proc sgplot data=regular_customer;
    title 'Regular Customers';
    vbar'customer name'n  /
    response=visits;
run;

/*Top 5 customers based on amount spent*/
proc sql outbs = 5;
create table top_customer as 
select distinct 'customer name'n ,round(sum(sales),3) as 'Total Sales'n
from work.superstore
Group by 'customer name'n
order by 'Total Sales'n desc;
run;

proc sgplot data= top_customer ;
    title 'Top Customers';
    vbar'customer name'n  /
    response='Total Sales'n;
run;

proc sql outbs = 5;
select 'product name'n, sales
from work.superstore
order by sales desc;
run;

/*Most expensive product with 50% discount*/
proc sql;
select 'product name'n, sales,quantity,discount
from work.superstore
where 'product name'n = "Cisco TelePresence System EX90 Videoconferencing Unit";
run;

proc sql;
select 'product name'n, sales,quantity
from work.superstore
where quantity = 2
and sales >3773 ;
run;

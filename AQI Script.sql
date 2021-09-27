--Daniel Finley
--27Oct2020
--U1325465
--IS 6420
--Extra Credit



drop table if exists aqi;

create table aqi (
"State Name" varchar (25))
;

select * from aqi 

select distinct(category) 
from aqi;

select distinct("Defining Parameter") 
from aqi;


-- Questions
-- What is the average AQI (air quality index) by year by season (winter, spring, summer, fall)?

select extract (year from "Date") as year, avg(aqi)  as average_AQI
from aqi
group by year;


select 
	extract (year from "Date") as year, avg(aqi)  as average_AQI
	,(case when to_char("Date",'MMDD') between '0321' and '0620' then 'spring'
           when to_char("Date",'MMDD') between '0621' and '0922' then 'summer'
           when to_char("Date",'MMDD') between '0923' and '1220' then 'fall'
           else                                                              'winter'
        end) as season
FROM aqi
group by year, season
        ;



--What were the top 10 locations with worst AQI in each year?  

select extract (year from "Date") as year, avg(aqi)  as average_AQI, aqi."county Name" 
from aqi
group by year, aqi."county Name" ;
      

select 
	extract (year from "Date") as year, aqi."county Name", aqi.aqi 
	,rank() over (order by aqi desc) aqi_rank
	,avg(aqi) over (order by aqi desc) avg_aqi
from aqi
group by year, aqi."county Name", aqi.aqi
order by avg_aqi desc
;





select 
	extract (year from "Date") as year, aqi."county Name", aqi.aqi 
	,rank() over (order by aqi desc) aqi_rank
	,avg(aqi) over (order by aqi desc) avg_aqi
from aqi
group by year, aqi."county Name", aqi.aqi
order by aqi.aqi desc
limit 10;
       
       
with aqi_rank as(
select county_name, sum(aqi), extract (year from "Date") as year,
rank() over(partition by extract (year from "Date") order by sum(aqi) desc) as aqi rank
from aqi 
group by county_name, extract (year from "Date"))
select * from aqi_rank where aqi_rank <= 10;


       
--What were the top 10 locations that had the best improvement from 1999 to 2019?  What were the 10 with the worst decline?



--In Utah counties, how many days of "Unhealthy" air did we have in each year?  Is it improving?  



select extract (year from aqi."Date") as year, count("Date") as days_unhealthy 
from aqi
where "State Name" = 'Utah'
	 and  aqi >= 151 and  aqi <= 200
group by extract (year from aqi."Date");
	 


--In Salt Lake County, which months have the most "Unhealthy" days?  Has that changed since 1999?
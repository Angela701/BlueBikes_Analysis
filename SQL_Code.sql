 ---1.  Docks with relation to the Time User Request Bikes 
 
select distinct date_part('hour', bb18.start_time) as time_req_bikes 
	, case 
		when date_part('hour', start_time) = 1 then '1AM'	 
		when date_part('hour', start_time) = 2 then '2AM'
		when date_part('hour', start_time) = 3 then '3AM'
		when date_part('hour', start_time) = 4 then '4AM'
		when date_part('hour', start_time) = 5 then '5AM'
		when date_part('hour', start_time) = 6 then '6AM'
		when date_part('hour', start_time) = 7 then '7AM'
		when date_part('hour', start_time) = 8 then '8AM'
		when date_part('hour', start_time) = 9 then '9AM'
		when date_part('hour', start_time) = 10 then '10AM'
		when date_part('hour', start_time) = 11 then '11AM'
		when date_part('hour', start_time) = 12 then '12AM'
		when date_part('hour', start_time) = 13 then '1PM'
		when date_part('hour', start_time) = 14 then '2PM'
		when date_part('hour', start_time) = 15 then '3PM'
		when date_part('hour', start_time) = 16 then '4PM'
		when date_part('hour', start_time) = 17 then '5PM'
		when date_part('hour', start_time) = 18 then '6PM'
		when date_part('hour', start_time) = 19 then '7PM'
		when date_part('hour', start_time) = 20 then '8PM'
		when date_part('hour', start_time) = 21 then '9PM'
		when date_part('hour', start_time) = 22 then '10PM'
		when date_part('hour', start_time) = 23 then '11AM'
		when date_part('hour', start_time) = 0 then '12AM'
	end as time 
	, count (bbs.total_docks) as num_docks   
from bluebikes_2018 bb18
left join bluebikes_stations bbs on bb18.start_station_id = bbs.id 
where bbs.total_docks is not null  
group by 1, 2
union
select distinct date_part('hour', bb19.start_time) as time_req_bikes 
	, case 
		when date_part('hour', start_time) = 1 then '1AM'	 
		when date_part('hour', start_time) = 2 then '2AM'
		when date_part('hour', start_time) = 3 then '3AM'
		when date_part('hour', start_time) = 4 then '4AM'
		when date_part('hour', start_time) = 5 then '5AM'
		when date_part('hour', start_time) = 6 then '6AM'
		when date_part('hour', start_time) = 7 then '7AM'
		when date_part('hour', start_time) = 8 then '8AM'
		when date_part('hour', start_time) = 9 then '9AM'
		when date_part('hour', start_time) = 10 then '10AM'
		when date_part('hour', start_time) = 11 then '11AM'
		when date_part('hour', start_time) = 12 then '12AM'
		when date_part('hour', start_time) = 13 then '1PM'
		when date_part('hour', start_time) = 14 then '2PM'
		when date_part('hour', start_time) = 15 then '3PM'
		when date_part('hour', start_time) = 16 then '4PM'
		when date_part('hour', start_time) = 17 then '5PM'
		when date_part('hour', start_time) = 18 then '6PM'
		when date_part('hour', start_time) = 19 then '7PM'
		when date_part('hour', start_time) = 20 then '8PM'
		when date_part('hour', start_time) = 21 then '9PM'
		when date_part('hour', start_time) = 22 then '10PM'
		when date_part('hour', start_time) = 23 then '11AM'
		when date_part('hour', start_time) = 0 then '12AM'
	end as time 
	, count (bbs.total_docks) as num_docks   
from bluebikes_2018 bb19
left join bluebikes_stations bbs on bb19.start_station_id = bbs.id 
where bbs.total_docks is not null 
and date_part('year', start_time) = 2018 -- change to review 2019 year 
group by 1, 2
order by 3 desc 
limit 100000; 


-- 2. Gender with relation to the number of bikes rented

select distinct user_gender   
	, count(bike_id) as num_bike   
	, case 
		when user_gender = 1 then 'Male'   
		when user_gender = 2 then 'Female'
	else 'N/A'
end as gender_type from bluebikes_2018
group by 1     
union
select distinct user_gender   
	, count(bike_id) as num_bike   
	, case 
		when user_gender = 1 then 'Male'   
		when user_gender = 2 then 'Female'
	else 'N/A'
end as gender_type from bluebikes_2019
where date_part('year', start_time) = 2018. -- change to see year 2019 
and date_part('year', start_time) is not null
group by 1     
order by 2 desc  
limit 100000; 

-- 3. Age with relation to the number of bikes rented 

select (2018 - cast(user_birth_year as numeric)) as age  
	, case 
		when (2018 - cast(user_birth_year as numeric)) between 12 and 17 then 'Teens'  
		when (2018 - cast(user_birth_year as numeric)) between 18 and 64 then 'Adults'
		when (2018 - cast(user_birth_year as numeric)) > 64 then 'Senior Citizen'
	end as age_group
	, count(bike_id) as num_bikes    
from bluebikes_2018
where (2018 - cast(user_birth_year as numeric)) is not null   
group by 1,2
union
select (2019 - cast(user_birth_year as numeric)) as age  
	, case 
		when (2019 - cast(user_birth_year as numeric)) between 12 and 17 then 'Teens'  
		when (2019 - cast(user_birth_year as numeric)) between 18 and 64 then 'Adults'
		when (2019 - cast(user_birth_year as numeric)) > 64 then 'Senior Citizen'
	end as age_group
	, count(bike_id) as num_bikes    
from bluebikes_2019
where (select cast(date_part('year', start_time) as numeric) = 2019) -- change to 2018 to review this year 
and (2019 - cast(user_birth_year as numeric)) is not null
group by 1,2
order by 3 desc  
limit 100000;

-- 4. Destination with relation to dock availability

select distinct bb18.user_type as user_type --
	, bbs.name as destination   
	, count(bbs.total_docks) as num_docks  
from bluebikes_2018 bb18
join bluebikes_stations bbs on bb18.start_station_id = bbs.id  
group by 1,2  
union
select distinct bb19.user_type as user_type --
	, bbs.name as destination   
	, count(bbs.total_docks) as num_docks  
from bluebikes_2019 bb19
join bluebikes_stations bbs on bb19.start_station_id = bbs.id  
where (select cast(date_part('year', start_time) as numeric) = 2018) -- Change to see 2019 year 
group by 1,2  
order by 3 desc  
limit 1000;

-- 5.  Trip duration with relation to User Type 

select 
	date_trunc('minute', bb18.end_time) - date_trunc('minute', bb18.start_time) as trip_duration
	, bb18.user_type
	, count(user_type) as num_users   
from bluebikes_2018 bb18
where user_type = 'Subscriber' 
--where user_type = 'Customer'
group by 1,2
union
select 
	date_trunc('minute', bb19.end_time) - date_trunc('minute', bb19.start_time) as trip_duration
	, bb19.user_type
	, count(user_type) as num_users   
from bluebikes_2019 bb19
where user_type = 'Subscriber' 
--where user_type = 'Customer' 
and cast(date_part('year', start_time)as numeric) = 2018 -- change to see 2019 year 
group by 1,2
order by 3 desc
limit 10000; 

-- 6. Destination with relation to time user start requesting bikes 

select date_part('hour', cast(start_time as time)) as initial_time 
	, case 
		when date_part('hour', start_time) = 1 then '1AM' 
		when date_part('hour', start_time) = 2 then '2AM'
		when date_part('hour', start_time) = 3 then '3AM'
		when date_part('hour', start_time) = 4 then '4AM'
		when date_part('hour', start_time) = 5 then '5AM'
		when date_part('hour', start_time) = 6 then '6AM'
		when date_part('hour', start_time) = 7 then '7AM'
		when date_part('hour', start_time) = 8 then '8AM'
		when date_part('hour', start_time) = 9 then '9AM'
		when date_part('hour', start_time) = 10 then '10AM'
		when date_part('hour', start_time) = 11 then '11AM'
		when date_part('hour', start_time) = 12 then '12AM'
		when date_part('hour', start_time) = 13 then '1PM'
		when date_part('hour', start_time) = 14 then '2PM'
		when date_part('hour', start_time) = 15 then '3PM'
		when date_part('hour', start_time) = 16 then '4PM'
		when date_part('hour', start_time) = 17 then '5PM'
		when date_part('hour', start_time) = 18 then '6PM'
		when date_part('hour', start_time) = 19 then '7PM'
		when date_part('hour', start_time) = 20 then '8PM'
		when date_part('hour', start_time) = 21 then '9PM'
		when date_part('hour', start_time) = 22 then '10PM'
		when date_part('hour', start_time) = 23 then '11AM'
		when date_part('hour', start_time) = 0 then '12AM'
	end as time 
	, bbs.name as destination 
	, count(bike_id) as num_bikes 
from bluebikes_2018 bb18
left outer join bluebikes_stations bbs on bb18.start_station_id = bbs.id
where date_part('hour', start_time) is not null  
and bbs.name is not null 
group by 1,2,3 
union 
select date_part('hour', cast(start_time as time)) as initial_time 
	, case 
		when date_part('hour', start_time) = 1 then '1AM' 
		when date_part('hour', start_time) = 2 then '2AM'
		when date_part('hour', start_time) = 3 then '3AM'
		when date_part('hour', start_time) = 4 then '4AM'
		when date_part('hour', start_time) = 5 then '5AM'
		when date_part('hour', start_time) = 6 then '6AM'
		when date_part('hour', start_time) = 7 then '7AM'
		when date_part('hour', start_time) = 8 then '8AM'
		when date_part('hour', start_time) = 9 then '9AM'
		when date_part('hour', start_time) = 10 then '10AM'
		when date_part('hour', start_time) = 11 then '11AM'
		when date_part('hour', start_time) = 12 then '12AM'
		when date_part('hour', start_time) = 13 then '1PM'
		when date_part('hour', start_time) = 14 then '2PM'
		when date_part('hour', start_time) = 15 then '3PM'
		when date_part('hour', start_time) = 16 then '4PM'
		when date_part('hour', start_time) = 17 then '5PM'
		when date_part('hour', start_time) = 18 then '6PM'
		when date_part('hour', start_time) = 19 then '7PM'
		when date_part('hour', start_time) = 20 then '8PM'
		when date_part('hour', start_time) = 21 then '9PM'
		when date_part('hour', start_time) = 22 then '10PM'
		when date_part('hour', start_time) = 23 then '11AM'
		when date_part('hour', start_time) = 0 then '12AM'
	end as time 
	, bbs.name as destination 
	, count(bike_id) as num_bikes 
from bluebikes_2019 bb19
left outer join bluebikes_stations bbs on bb19.start_station_id = bbs.id
where (select cast(date_part('year', start_time)as numeric)) = 2019
and date_part('hour', start_time) is not null  
and bbs.name is not null 
group by 1,2,3 
order by 4 desc 
limit 10000; 

-- 7. Month with relation to number of user requesting bikes 
select 
	date_part('month', start_time) as month  
	, case 
	 	when date_part('month', start_time) = 1 then 'January'  
		when date_part('month', start_time) = 2 then 'February'
		when date_part('month', start_time) = 3 then 'March'
		when date_part('month', start_time) = 4 then 'April'
		when date_part('month', start_time) = 5 then 'May'
		when date_part('month', start_time) = 6 then 'June'
		when date_part('month', start_time) = 7 then 'July'
		when date_part('month', start_time) = 8 then 'August'
		when date_part('month', start_time) = 9 then 'September'
		when date_part('month', start_time) = 10 then 'October'		  
		when date_part('month', start_time) = 11 then 'November'
		when date_part('month', start_time) = 12 then 'December'
	end as month  
	, count(bike_id) as total_bikes 
from bluebikes_2018
group by 1 
union
select 
	date_part('month', start_time) as month  
	, case 
	 	when date_part('month', start_time) = 1 then 'January'  
		when date_part('month', start_time) = 2 then 'February'
		when date_part('month', start_time) = 3 then 'March'
		when date_part('month', start_time) = 4 then 'April'
		when date_part('month', start_time) = 5 then 'May'
		when date_part('month', start_time) = 6 then 'June'
		when date_part('month', start_time) = 7 then 'July'
		when date_part('month', start_time) = 8 then 'August'
		when date_part('month', start_time) = 9 then 'September'
		when date_part('month', start_time) = 10 then 'October'		  
		when date_part('month', start_time) = 11 then 'November'
		when date_part('month', start_time) = 12 then 'December'
	end as month  
	, count(bike_id) as total_bikes 
from bluebikes_2019
where (select cast(date_part('year', start_time) as numeric)) = 2018 -- change to see 2019 year 
group by 1 
order by 3 desc
limit 100; 

-- 8. Seasonality with relation to number of users requesting bikes 

select 
	cast(date_part('month', start_time) as numeric) as month
	, case
		when cast(date_part('month', start_time) as numeric) = '12' then 'Winter' 
		when cast(date_part('month', start_time) as numeric) = '1' then 'Winter'
		when cast(date_part('month', start_time) as numeric) = '2' then 'Winter'
		when cast(date_part('month', start_time) as numeric) = '3' then 'Spring'
		when cast(date_part('month', start_time) as numeric) = '4' then 'Spring'
		when cast(date_part('month', start_time) as numeric) = '5' then 'Spring'
		when cast(date_part('month', start_time) as numeric) = '6' then 'Summer'
		when cast(date_part('month', start_time) as numeric) = '7' then 'Summer'
		when cast(date_part('month', start_time) as numeric) = '8' then 'Summer'
		when cast(date_part('month', start_time) as numeric) = '9' then 'Autumn'
		when cast(date_part('month', start_time) as numeric) = '10' then 'Autumn'
		when cast(date_part('month', start_time) as numeric) = '11' then 'Autumn'
	end as season
	, count(bike_id) as num_bikes 
from bluebikes_2018
group by 1,2 
union
select 
	cast(date_part('month', start_time) as numeric) as month
	, case
		when cast(date_part('month', start_time) as numeric) = '12' then 'Winter' 
		when cast(date_part('month', start_time) as numeric) = '1' then 'Winter'
		when cast(date_part('month', start_time) as numeric) = '2' then 'Winter'
		when cast(date_part('month', start_time) as numeric) = '3' then 'Spring'
		when cast(date_part('month', start_time) as numeric) = '4' then 'Spring'
		when cast(date_part('month', start_time) as numeric) = '5' then 'Spring'
		when cast(date_part('month', start_time) as numeric) = '6' then 'Summer'
		when cast(date_part('month', start_time) as numeric) = '7' then 'Summer'
		when cast(date_part('month', start_time) as numeric) = '8' then 'Summer'
		when cast(date_part('month', start_time) as numeric) = '9' then 'Autumn'
		when cast(date_part('month', start_time) as numeric) = '10' then 'Autumn'
		when cast(date_part('month', start_time) as numeric) = '11' then 'Autumn'
	end as season
	, count(bike_id) as num_bikes 
from bluebikes_2019
where (select cast(date_part('year', start_time) as numeric) = 2018) -- change to see 2019 year 
group by 1,2 
order by 3 desc 
limit 100000; 






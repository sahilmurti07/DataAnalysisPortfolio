-- create database e_rides_db;
   use e_rides_db;
-- Analyze the data set of database
select 
(select count(*) from rides) as total_rides, -- 15000
(select count(*) from users) as total_users, -- 1000
(select count(*) from stations) as total_stations; -- 25

-- statistical summary

select u.user_id, max(minute(timediff(r.end_time,r.start_time))) as max,
min(minute(timediff(r.end_time,r.start_time))) as min,
max(r.distance_km)as max_km,min(r.distance_km)as min_km
from rides r join users u on
r.user_id = u.user_id 
group by u.user_id order by  max_km desc limit 10;

select max(timestampdiff(minute,start_time,end_time))
 as max__time_ride from rides; -- 96 minutes
  
  select min(timestampdiff(minute,start_time,end_time)) as min_time_ride from rides;
  select max(distance_km)as max_dist from rides; -- 19.37
  select min(distance_km) as min_dist from
  rides;
  
  select
  * 
  from rides 
  where distance_km = 0 
  and
  timestampdiff(minute,start_time,end_time) = 0; -- only this recorde has no ride 
  
  -- membership distribution among users
  select u.membership_level,
  count(u.membership_level) as subscription -- casual = 10,676 and subscriber = 4324
  from users u join rides r on
  u.user_id = r.user_id
  group by u.membership_level;
  
  -- peek hours
 -- hour, count_of_ride
 # hour	count_of_ride
--    15        1617
--    16        1500
--    7         1213
--    14        1204
  select  
  extract(hour from start_time) as hour,count(*) as count_of_ride from rides
  group by hour order by count_of_ride desc limit 4; -- 7 am,2 pm ,3 pm,4 pm is highest rides
  
  -- busy station or highest approached station for ride
-- Jennifer Land St
-- Megan Manors St
-- King Harbors St
-- Harper Well St
-- Rhonda Ports St
-- Samuel Extension St
-- Fisher Stravenue St
-- Smith Light St
-- Jimenez Summit St
-- Michael Shores St
  select s.station_id, s.station_name,count(*) as rides from stations s join rides r 
  on s.station_id = r.start_station_id group by s.station_id, s.station_name 
  order by rides desc limit 10;
  
  -- categorize the rides duration
-- Medium_Ride	7092
-- Short_Ride	1428
-- Long_Ride	6480

  select 
  case 
  when timestampdiff(minute,start_time,end_time) <= 10 then "Short_Ride"
  when timestampdiff(minute,start_time,end_time) between 11 and 30 then "Medium_Ride"
else "Long_Ride"
    end as Ride_category,
    count(*) as count
    from rides
    group by Ride_category;
    
  
  -- bikes flow
-- Jennifer Land St	 	-66
-- King Harbors St	 	-56
-- Smith Light St	 	-53
-- Michael Shores St 	-47
-- Megan Manors St	 	-46

  with departures as (
  select start_station_id,count(*) as Total_departure from rides
  group by 1
  ),
   arrivals as (
   select end_station_id,count(*) as Total_arrival from rides
   group by 1
   )
   select 
   s.station_name, 
   a.Total_arrival,
   d.Total_departure,
   (a.Total_arrival- d.Total_departure) as flow 
   from stations as s
   join departures d on s.station_id = d.start_station_id
   join arrivals a on s.station_id = a.end_station_id 
   order by flow asc;
   
   -- customer retention over month by month
   -- july has highest drop in percentage - (-19%) 
--    may has highest growth in percentage - 23%
   with monthly_users as (select  month(created_at) as months , 
   count(user_id) as total_customer  from users
   group by months )
   
SELECT
    months,
    total_customer,
    LAG(total_customer) OVER(ORDER BY months) AS prev_month,
    ROUND(
        (total_customer - LAG(total_customer) OVER(ORDER BY months)) * 100.0 /
        LAG(total_customer) OVER(ORDER BY months)
    ) AS standard_percentage_mom_growth
FROM
    monthly_users
;


# membership_level	subscription	avg_km	avg_duration
   --   Casual	             10676	7	    34.5242
-- Subscriber	             4324	3	    14.4780

 select u.membership_level,count(u.membership_level) as subscription,
round(avg(distance_km))as avg_km,
avg(timestampdiff(minute,start_time,end_time)) as avg_duration
  from users u join rides r on
  u.user_id = r.user_id
  group by u.membership_level;
   
   

  
  
  





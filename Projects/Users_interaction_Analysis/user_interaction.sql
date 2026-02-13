-- Title : Analysis the users interaction or timespend for purchasing products
-- Description : In this project we have a data set in which we are founding insight through
-- which we can grow our buisness smartly.

-- Data overview : Database Name is Users_db , Table Name is user_events , we have 6 columns [event_id,event_type , event_date,product_id,amount,traffic_source]

-- Start Analysing 
-- This Analysing is revolve around only 30 days back how the users itneract with our website
use users_db;
select * from user_events; -- All DataSet Overview

-- funnel conversion analysis
with sector_funnel_analysis as (
select 
  count(distinct case when event_type = "page_view" then user_id end) as page_view_sector,
   count(distinct case when event_type = "add_to_cart" then user_id end) as cart_view_sector,
  count(distinct case when event_type = "checkout_start" then user_id end) as checkout_view_sector,
  count(distinct case when event_type = "payment_info" then user_id end) as payment_info_view_sector,
  count(distinct case when event_type = "purchase" then user_id end) as purchase_view_sector
  from user_events
  where  event_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY))
  
  select * from  sector_funnel_analysis;
  
  -- funnel_conversion analysis in sectors
  
  with funnel_conversion_analysis as (
select 
  count(distinct case when event_type = "page_view" then user_id end)
  as page_view_sector,
   count(distinct case when event_type = "add_to_cart" then user_id end) 
   as cart_view_sector,
  count(distinct case when event_type = "checkout_start" then user_id end)
  as checkout_view_sector,
  count(distinct case when event_type = "payment_info" then user_id end) 
  as payment_info_view_sector,
  count(distinct case when event_type = "purchase" then user_id end) 
  as purchase_view_sector
  from user_events
  where  event_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY))
  
  select
  page_view_sector,
   cart_view_sector,
   (cart_view_sector*100)/ page_view_sector as page_to_cart_conversion,
   checkout_view_sector,
   round((checkout_view_sector*100))/cart_view_sector as cart_to_checkout_conversion,
   payment_info_view_sector,
   round((payment_info_view_sector*100))/checkout_view_sector as checkout_to_payment_conversion,
   round((purchase_view_sector*100),2)/page_view_sector as overall_conversion
   from  funnel_conversion_analysis; 
   
   
   -- # page_view_sector	cart_view_sector	page_to_cart_conversion	checkout_view_sector	cart_to_checkout_conversion	payment_info_view_sector	checkout_to_payment_conversion	overall_conversion
   -- 3040	964	31.7105	675	70.0207	529	78.3704	16.1842

   
   
   
    with traffic_conversion_analysis as (
select 

  count(distinct case when event_type = "page_view" then user_id end)
  as page_view_sector,
   count(distinct case when event_type = "add_to_cart" then user_id end) 
   as cart_view_sector,
  count(distinct case when event_type = "checkout_start" then user_id end)
  as checkout_view_sector,
  count(distinct case when event_type = "payment_info" then user_id end) 
  as payment_info_view_sector,
  count(distinct case when event_type = "purchase" then user_id end) 
  as purchase_view_sector,
  traffic_source
  from user_events
  where  event_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  group by traffic_source
  )
   select
traffic_source,
   round(purchase_view_sector*100)/page_view_sector as overall_conversion
   from  traffic_conversion_analysis; --  the highest traffic source is email	34.1317 and lowest is social  5.7303
   
   WITH journey_analysis AS (
    SELECT 
        user_id,

        MIN(CASE 
                WHEN event_type = 'page_view' 
                THEN event_date 
            END) AS page_view,

        MIN(CASE 
                WHEN event_type = 'add_to_cart' 
                THEN event_date 
            END) AS cart_view,

        MIN(CASE 
                WHEN event_type = 'purchase' 
                THEN event_date 
            END) AS purchase_view

    FROM user_events

    WHERE event_date >=timestamp(DATE_SUB(CURDATE(), INTERVAL 30 DAY))

    GROUP BY user_id

    HAVING MIN(CASE 
                  WHEN event_type = 'purchase' 
                  THEN event_date 
              END) IS NOT NULL
)

SELECT count(*) as converted_Users,
avg(timestampdiff( MINUTE,page_view,cart_view)) as avg_timespend_on_page_to_cart, -- 11 min
avg(timestampdiff(MINUTE,cart_view,purchase_view)) as avg_timespend_on_cart_to_purchase, -- 13 min
avg(timestampdiff(MINUTE, page_view,purchase_view)) as avg_timespend -- 24 min

 FROM journey_analysis;
   
   
   -- KPI's
   select
   count(distinct user_id) as total_users, -- 3040
   count(case when event_type = "purchase" then user_id end) as Total_Orders, -- 492
   round(sum(amount)) as Revenue, -- 52560
   round((round(sum(amount))/ count(case when event_type = "purchase" then user_id end))) as AOV -- 107
   from user_events where event_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
  
  
  select product_id , count(product_id) as loved_product from user_events where event_type = 'purchase' && event_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  group by product_id order by count desc limit 5;
-- p.id loved_product
-- 205	99
-- 201	83
-- 101	83
-- 404	82
-- 102	76

 
  
   
   
   
   
  
  
  
  

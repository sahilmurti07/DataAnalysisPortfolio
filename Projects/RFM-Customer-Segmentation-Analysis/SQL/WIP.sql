-----------------------------------------------------------
-----------------------------------------------------------
-- Joining all tables of rfm18 to rfm_2025 dataset to do analysis
-----------------------------------------------------------
-----------------------------------------------------------
create or replace table `carbon-pride-451107-a0.rfm18.rfm_2025` 
as
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_01` 
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_02` 
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_03` 
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_04` 
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_05` 
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_06` 
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_07` 
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_08` 
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_09`
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_10` 
union all 
SELECT * FROM `carbon-pride-451107-a0.rfm18.2025_11` 
union all
select * from `carbon-pride-451107-a0.rfm18.2025_12` ;

---------------------------------------------------------
---------------------------------------------------------

-- Now we create a View of cte's for Analysis
---------------------------------------------------------
create or replace view `carbon-pride-451107-a0.rfm18.metrics`
as 
with cte1 as (
  select date('2026-03-21') as Date_Analysis
),

rfm as (
  select 
  CustomerID,
  max(OrderDate) as last_order_date,
  date_diff((select Date_Analysis from cte1),max(OrderDate),day) as recency,
  count(*) as frequency,
  round(sum(OrderValue),2) as monetary
  from `carbon-pride-451107-a0.rfm18.rfm_2025`
  group by CustomerID
)
select rfm.*,
row_number() over(order by recency asc) as recency_rnk,
row_number() over(order by frequency desc) as frequency_rnk,
row_number() over(order by monetary desc) as monetary_rnk
from rfm;
-------------------------------------------------------------------
-- Giving score to every rnk 
-------------------------------------------------------------------
create or replace view `carbon-pride-451107-a0.rfm18.rfm_score`
as 
select *,
ntile(10) over(order by recency_rnk desc) as recency_score,
ntile(10) over(order by frequency_rnk desc) as frequency_score,
ntile(10) over(order by monetary_rnk desc) as monetary_score
from  `carbon-pride-451107-a0.rfm18.metrics`;

------------------------------------------------------------------------
------------------------------------------------------------------------
-- finding the scores to categories the customers
------------------------------------------------------------------------
create or replace view `carbon-pride-451107-a0.rfm18.rfm_sum_score`
as 
select 
CustomerID,
recency,
frequency,
monetary,
recency_rnk,
frequency_rnk,
monetary_rnk,
recency_score,
frequency_score,
monetary_score,
(recency_score + frequency_score + monetary_score) as rfm_total
 from `carbon-pride-451107-a0.rfm18.rfm_score`
order by rfm_total desc;

-------------------------------------------------------------------------------------------------------------------------------------
-- BI ready Table with label's ( Like if score is between 28-30 then champion, 24-27 then loyal-vip , 18-23 repeat buyrs , etc...)
-------------------------------------------------------------------------------------------------------------------------------------
create or replace table `carbon-pride-451107-a0.rfm18.segment_table`
as 
select 
CustomerID,
recency,
frequency,
monetary,
recency_rnk,
frequency_rnk,
monetary_rnk,
recency_score,
frequency_score,
monetary_score,
rfm_total,
case
WHEN rfm_total >= 29 THEN 'Can\'t Lose Them'
WHEN rfm_total BETWEEN 26 AND 28 THEN 'Champions'
    WHEN rfm_total BETWEEN 23 AND 25 THEN 'Loyal VIP'
    WHEN rfm_total BETWEEN 20 AND 22 THEN 'Potential Loyalist'
    WHEN rfm_total BETWEEN 17 AND 19 THEN 'Repeat Buyers'
    WHEN rfm_total BETWEEN 14 AND 16 THEN 'Promising'
    WHEN rfm_total BETWEEN 11 AND 13 THEN 'Needs Attention'
    WHEN rfm_total BETWEEN 8 AND 10 THEN 'At Risk'
    WHEN rfm_total BETWEEN 4 AND 7 THEN 'Hibernating'
    ELSE 'Lost' 
  END AS customer_segment

 from `carbon-pride-451107-a0.rfm18.rfm_sum_score`

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------





































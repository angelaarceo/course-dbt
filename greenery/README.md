# WEEK4 PROJECT
## Part1. DBT Snapshots

``` sql
{% snapshot orders_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='order_id',

      strategy='check',
      check_cols=['status'],
    )
  }}

  SELECT * FROM {{ source('src_greenery','orders') }}

{% endsnapshot %}
```

``` sql
SELECT *
FROM snapshots.orders_snapshot
WHERE order_id = '05202733-0e17-4726-97c2-0520c024ab85'
```
image.png

## Part 2 Modeling challenge
I created two data models: ini_funnel and fact_funnel: 
The funnel per days looks like the following table 

|event_created_at |	sessions_to_page_view	| page_view_to_add_cart |	add_cart_to_checkout |	drop_to_page_view |	drop_to_add_cart |	drop_to_checkout |
|-----------------|-----------------------|-----------------------|----------------------|--------------------|------------------|-------------------|
|11/02/21 0:00	  |         1	            |     0.72319202	      |      0.634482759     |       0	          |   0.27680798	   |   0.365517241     |
|10/02/21 0:00	  |         1	            |           1           |        	1            |  	   0	          |        0	       |          0        |
|09/02/21 0:00            	1             |          	1	          |         1            |       0	          |        0         |          0        |

Recently, we presented a 27% of the drop in the step of add_cart and 36% to checkout. 

## Part 3 Reflection questions 

The most significant value that I see in using dbt is the way that you structure your data models. If you have a well-structured data model is easier to debug, document, and collaborate with your team. I would like to take a second course to orchestrate with Airflow because this tool is what I use in my organization and I think scheduling and orchestration are a must in a pipeline. I definitely see dbt as an excellent tool to complement my data stack.

# WEEK3 PROJECT

## 1. What is our overall conversion rate?
``` sql
WITH orders_completed as (
SELECT
session_id,
CASE WHEN has_checkout = TRUE THEN 1 ELSE 0 END has_checkout 
FROM dbt.dbt_angela_arceo.fact_events
)
SELECT
sum(has_checkout::int) * 1.0 / count(distinct(session_id)) as conversion_rate
FROM orders_completed
```
**0.6245674740484429065**

## 2. What is our conversion rate by product?
``` sql
select
product_name,
COUNT(DISTINCT(CASE WHEN event_type = 'checkout' THEN session_id END)) * 1.0 /
COUNT(DISTINCT(session_id)) as conversion_rate_product
from dbt_angela_arceo.ini_sessions_products
group by product_name;
```

# WEEK2 PROJECT

## 1.What is our user repeat rate?

``` sql
WITH order_data AS 
( SELECT 
  user_id ,
  COUNT(DISTINCT order_id) as purchases 
  FROM dbt.dbt_angela_arceo.stg_greenery__orders
  GROUP BY user_id ) 
SELECT 
COUNT(DISTINCT CASE WHEN purchases >1 THEN user_id END) as repeated_users,
COUNT(DISTINCT user_id) as total_users ,
CAST(COUNT(DISTINCT CASE WHEN purchases >1 THEN user_id END) AS DECIMAL(7,2) )/COUNT(DISTINCT user_id) as repeat_pct 
FROM order_data

```
Repeat rate: **.7983**


# WEEK1 PROJECT

## 1.How many users do we have?
``` sql
SELECT COUNT(distinct user_id)
FROM dbt.dbt_angela_arceo.stg_greenery__users
```

**130**

## 2.On average, how many orders do we receive per hour?
```sql
WITH order_data as (
SELECT 
date_trunc('hour',order_created_at_utc) as order_hour
,count(order_id) as nb_orders
FROM dbt.dbt_angela_arceo.stg_greenery__orders
GROUP BY date_trunc('hour',order_created_at_utc)
)
SELECT 
order_hour
,avg(nb_orders) as avg_orders
FROM order_data
GROUP BY order_hour
ORDER BY order_hour

```
## 3.On average, how long does an order take from being placed to being delivered?

```sql
WITH order_data as (
SELECT 
date_trunc('minutes',delivered_at_utc) - date_trunc('minutes',order_created_at_utc) as time_to_deliver
FROM dbt.dbt_angela_arceo.stg_greenery__orders
)
SELECT 
avg(time_to_deliver) as avg_orders
FROM order_data
```
**3 days**

## 4.How many users have only made one purchase? Two purchases? Three+ purchases?
```sql
WITH order_data as (
SELECT 
user_id,
COUNT(order_id) AS purchases
FROM dbt.dbt_angela_arceo.stg_greenery__orders
GROUP BY user_id
)
SELECT 
CASE 
WHEN purchases = 1 THEN '1'
WHEN purchases = 2 THEN '2'
WHEN purchases = 3 THEN '3'
WHEN purchases > 3 THEN '3+'
END as nb_purchases,
COUNT(user_id) as nb_users

FROM order_data
GROUP BY nb_purchases
```
| Number Purchases  | Number Users |
| ----------------- | -------------|
|         1         |      25      |
|         2         |      28      |
|         3         |      34      |
|         3+        |      37      |

## 5.On average, how many unique sessions do we have per hour?

```sql
WITH sessions_data as (
SELECT 
date_trunc('hour',event_created_at_utc) as event_hour
,count(distinct session_id) as nb_sessions
FROM dbt.dbt_angela_arceo.stg_greenery__events
GROUP BY event_hour
)
SELECT 
event_hour
,avg(nb_sessions) as avg_sesions
FROM sessions_data
GROUP BY event_hour
ORDER BY event_hour
```


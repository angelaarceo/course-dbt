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


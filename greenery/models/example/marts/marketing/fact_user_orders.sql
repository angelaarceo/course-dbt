
{{
  config(
    materialized='view'
  )
}}


SELECT 
user_id
,order_created_at_utc
,COUNT(order_id) AS nb_orders
,SUM(order_total) AS total_amount
,SUM(quantity) as total_products


FROM {{ ref('fact_orders') }} o 
GROUP BY user_id, order_created_at_utc

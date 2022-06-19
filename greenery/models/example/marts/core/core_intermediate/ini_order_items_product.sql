{{
  config(
    materialized='table'
  )
}}

SELECT 
oi.product_id
,order_id
,product_price
,product_name
,inventory
,quantity



FROM {{ ref('stg_greenery__order_items') }} oi
LEFT JOIN {{ ref('stg_greenery__products') }} p ON oi.product_id=p.product_id
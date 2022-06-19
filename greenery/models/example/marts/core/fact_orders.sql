{{
  config(
    materialized='view'
  )
}}

SELECT 
o.order_id
,user_id
,order_status
,order_created_at_utc
,delivered_at_utc
,order_total
,product_id
,product_name
,quantity
,o.promo_id
,promo_discount
,promo_status



FROM {{ ref('stg_greenery__orders') }} o 
LEFT JOIN {{ ref('ini_order_items_product') }} t ON o.order_id=t.order_id
LEFT JOIN {{ ref('stg_greenery__promos') }} p ON p.promo_id=o.promo_id
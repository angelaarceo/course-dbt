{{ config(materialized='table') }}

SELECT
    session_id,
    order_id,
    event_type,
    COALESCE(e.product_id, op.product_id) as product_id,
    p.product_name

FROM {{ref('stg_greenery__events')}} e
LEFT JOIN {{ref('fact_orders')}} op using(order_id)
LEFT JOIN {{ref('stg_greenery__products')}} p on COALESCE(e.product_id, op.product_id) = p.product_id
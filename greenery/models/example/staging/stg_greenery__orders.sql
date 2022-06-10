
{{ config(materialized='view') }}

WITH src_greenery_orders as (
SELECT
order_id
,user_id
,status as order_status
,created_at as order_created_at_utc
, delivered_at as delivered_at_utc
from {{ source('src_greenery','orders') }}
)
SELECT *
FROM src_greenery_orders
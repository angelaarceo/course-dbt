
{{ config(materialized='view') }}

WITH src_greenery_events as (
SELECT
event_id
,session_id
,order_id
,user_id
,product_id
,event_type
,created_at as event_created_at_utc
,page_url
from {{ source('src_greenery','events') }}
)
SELECT *
FROM src_greenery_events
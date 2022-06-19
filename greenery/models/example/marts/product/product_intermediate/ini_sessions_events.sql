{{ config(materialized='table') }}


SELECT 
session_id
,event_created_at_utc
,user_id
,SUM(CASE WHEN event_type='packaged_shipped' THEN 1 ELSE 0 END) as package_shipped
,SUM(CASE WHEN event_type='page_view' THEN 1 ELSE 0 END) as page_view
,SUM(CASE WHEN event_type='checkout' THEN 1 ELSE 0 END) as checkout
,SUM(CASE WHEN event_type='add_to_cart' THEN 1 ELSE 0 END) as add_to_cart
FROM {{ ref('stg_greenery__events') }} 
GROUP BY session_id, event_created_at_utc, user_id


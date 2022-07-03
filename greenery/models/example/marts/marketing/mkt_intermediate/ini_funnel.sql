{{
    config(
        materialized = 'table'
    )
}}

WITH events_table as (
SELECT 
event_created_at,
COUNT(DISTINCT session_id) as total_sessions,
COUNT(DISTINCT(CASE WHEN has_page_view THEN session_id END)) AS funnel_page_view,
COUNT(DISTINCT(CASE WHEN has_add_to_cart THEN session_id END)) AS funnel_add_cart,
COUNT(DISTINCT(CASE WHEN has_checkout THEN session_id END)) AS funnel_checkout,
COUNT(DISTINCT session_id) - COUNT(DISTINCT(CASE WHEN has_page_view THEN session_id END)) as drop_page_view,
COUNT(DISTINCT(CASE WHEN has_page_view THEN session_id END)) - COUNT(DISTINCT(CASE WHEN has_add_to_cart THEN session_id END)) as drop_add_cart,
COUNT(DISTINCT(CASE WHEN has_add_to_cart THEN session_id END)) - COUNT(DISTINCT(CASE WHEN has_checkout THEN session_id END)) as drop_checkout

FROM {{ ref('fact_events')}}
GROUP BY event_created_at
)

SELECT
*
FROM events_table
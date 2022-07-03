{{
    config(
        materialized = 'table'
    )
}}

SELECT
event_created_at,
SUM(funnel_page_view::numeric)/SUM(total_sessions::numeric) as sessions_to_page_view,
SUM(funnel_add_cart::numeric)/SUM(funnel_page_view::numeric) as  page_view_to_add_cart,
SUM(funnel_checkout::numeric)/SUM(funnel_add_cart::numeric) as add_cart_to_checkout,
SUM(drop_page_view::numeric)/SUM(total_sessions::numeric) as drop_to_page_view,
SUM(drop_add_cart::numeric)/SUM(funnel_page_view::numeric) as drop_to_add_cart,
SUM(drop_checkout::numeric)/SUM(funnel_add_cart::numeric) as drop_to_checkout

FROM {{ ref('ini_funnel')}}
GROUP BY event_created_at
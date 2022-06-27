{{
    config(
        materialized = 'table'
    )
}}

{% set event_types = distinct_values(ref('stg_greenery__events'), 'event_type') %}

SELECT
    session_id
    , min(event_created_at_utc::date) as event_created_at
    , max(order_id) as order_id
    , count(distinct(order_id)) as n_order_ids
    , count(distinct(product_id)) as products_to_cart
    {% for event_type in event_types %}
    , BOOL_OR(CASE WHEN event_type = '{{event_type}}' THEN TRUE ELSE FALSE END) AS has_{{event_type}}
    {% endfor %}
FROM {{ref('stg_greenery__events')}}
GROUP BY session_id
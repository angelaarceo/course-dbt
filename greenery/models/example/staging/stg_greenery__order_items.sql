
{{ config(materialized='view') }}

WITH src_greenery_order_items as (
SELECT
 order_id,
 product_id,
 quantity

from {{ source('src_greenery','order_items') }}
)
SELECT *
FROM src_greenery_order_items
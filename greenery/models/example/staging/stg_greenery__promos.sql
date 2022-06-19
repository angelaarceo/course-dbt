
{{ config(materialized='view') }}

WITH src_greenery_promos as (
SELECT

  promo_id ,
  discount as promo_discount,
  status as promo_status
from {{ source('src_greenery','promos') }}
)
SELECT *
FROM src_greenery_promos
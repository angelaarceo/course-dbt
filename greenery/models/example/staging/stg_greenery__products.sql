
{{ config(materialized='view') }}

WITH src_greenery_products as (
 SELECT
  product_id,
  name as product_name,
  price as product_price,
  inventory
  FROM {{ source('src_greenery','products') }}
)
SELECT *
FROM src_greenery_products
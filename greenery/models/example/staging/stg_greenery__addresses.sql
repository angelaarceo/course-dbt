
{{ config(materialized='view') }}

WITH src_greenery_addresses as (
SELECT
  address_id,
  address,
  zipcode,
  state,
  country
  FROM {{ source('src_greenery','addresses') }}
)
SELECT *
FROM src_greenery_addresses
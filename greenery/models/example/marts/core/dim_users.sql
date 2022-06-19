{{
  config(
    materialized='table'
  )
}}

SELECT
  u.user_id,
  u.email,
  u.first_name,
  u.last_name,
  ad.address_id,
  address,
  zipcode,
  state, 
  country

  
FROM {{ ref('stg_greenery__users') }} u
LEFT JOIN {{ ref('stg_greenery__addresses') }} ad
  ON u.address_id=ad.address_id
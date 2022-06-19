
{{ config(materialized='view') }}

WITH src_greenery_users as (
SELECT
user_id
,first_name
,last_name
,email
,created_at as created_at_utc
,address_id

from {{ source('src_greenery','users') }}
)
SELECT *
FROM src_greenery_users
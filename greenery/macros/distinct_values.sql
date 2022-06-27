{% macro distinct_values(model, column_name) %}

{% set distinct_query %}
select distinct
{{column_name}}
from {{model}}
order by 1
{% endset %}

{% set results = run_query(distinct_query) %}

{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}

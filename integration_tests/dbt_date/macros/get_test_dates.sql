{% macro synapse__get_test_week_of_year() -%}
    {# who knows what T-SQL uses?! #}
    {# see: https://github.com/calogica/dbt-date/issues/25 #}
    {{ return([49,49]) }}
{%- endmacro %}

{% macro synapse__get_test_timestamps() -%}
    {{ return(['2021-06-07 07:35:20.000000 -07:00',
                '2021-06-07 14:35:20.000000 +00:00']) }}
{%- endmacro %}
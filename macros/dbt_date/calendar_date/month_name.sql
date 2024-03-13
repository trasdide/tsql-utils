{%- macro synapse__month_name(date, short) -%}
{%- set f = 'MMM' if short else 'MMMM' -%}
    format({{ date }}, '{{ f }}')
{%- endmacro %}

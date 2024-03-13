{% macro synapse__test_sequential_values(model, column_name, interval=1, datepart=None) %}

    select
        *
    from (
        select
        {{ column_name }},
        lag({{ column_name }}) over (
            order by {{ column_name }}
        ) as previous_{{ column_name }}
        from {{ model }}
    ) required_alias_for_tsql
    {% if datepart %}
    where not(cast({{ column_name }} as {{ dbt.type_timestamp() }})= cast({{ dbt.dateadd(datepart, interval, 'previous_' + column_name) }} as {{ dbt.type_timestamp() }}))
    {% else %}
    where not({{ column_name }} = previous_{{ column_name }} + {{ interval }})
    {% endif %}

{% endmacro %}

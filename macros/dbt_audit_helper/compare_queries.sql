{% macro synapse__compare_queries(a_query, b_query, primary_key=None, summarize=true) %}

with a as (

    {{ a_query }}

),

b as (

    {{ b_query }}

),

a_intersect_b as (

    select * from a
    {{ dbt.intersect() }}
    select * from b

),

a_except_b as (

    select * from a
    {{ dbt.except() }}
    select * from b

),

b_except_a as (

    select * from b
    {{ dbt.except() }}
    select * from a

),

all_records as (

    select
        *,
        1 as in_a,
        1 as in_b
    from a_intersect_b

    union all

    select
        *,
        1 as in_a,
        0 as in_b
    from a_except_b

    union all

    select
        *,
        0 as in_a,
        1 as in_b
    from b_except_a

),

{%- if summarize %}

summary_stats as (
    select
        in_a,
        in_b,
        count(*) as count
    from all_records
    group by in_a, in_b
),

final as (

    select
    *,
    round(100.0 * count / sum(count) over (), 2) as percent_of_total

    from summary_stats
)

{%- else %}

final as (

    select *
    from all_records
    where not (in_a = 1 and in_b = 1)

)

{%- endif %}

select *
from final

{% endmacro %}

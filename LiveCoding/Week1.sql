-- 10/26/2023 live coding exercise

with customer_to_store as (
    select 
        customer_id,
        store_id,
        specialty,
        round(st_distance(s.geo_location, c.address_geo_location) / 1609, 2) as distance
    from chicago_grocery.product_analytics.customers as c
    join chicago_grocery.product_analytics.stores as s),

distance_rank as (
    select
        *,
        row_number() over (partition by customer_id order by distance) as store_rank
    from customer_to_store),

spend_totals as (
    select 
        p.store_id,
        sum(total_spend) as total_revenue,
        sum(specialty_spend) as special_revenue,
        sum(case 
            when store_rank > 1 then total_spend
        else 0
        end) as not_primary_spend,
        sum(case 
            when store_rank > 1 then specialty_spend
        else 0
        end) as not_primary_special
    from chicago_grocery.product_analytics.purchases as p
    join distance_rank as d on p.store_id = d.store_id and p.customer_id = d.customer_id
    group by p.store_id),

results as (
    select
        s.store_name,
        round(special_revenue / total_revenue * 100, 2) as percent_special,
        round(not_primary_special / total_revenue * 100, 2) as percent_not_primary_special
    from spend_totals as t
    join chicago_grocery.product_analytics.stores as s on t.store_id = s.store_id
    order by percent_special desc)


select *
from results 

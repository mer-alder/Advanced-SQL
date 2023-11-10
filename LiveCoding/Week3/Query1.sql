-- Query 1:  create pairs of customers in the same city and location_type
-- for every customer in PA:  match to a different customer in the same city and location_type, return customer_id1, customer_id2, city, state

with pa_customer_list as (
    select 
        customer_id,
        city,
        location_type,
        row_number() over (partition by city, location_type order by state_code) as row_id
    from customer_address
    where state_code = 'PA'),

    even_customers as (
        select
            *
        from pa_customer_list
        where (row_id % 2) = 0
    )

    select 
        odd.customer_id as customer_1,
        even.customer_id as customer_2,
        odd.location_type,
        odd.city,
        'PA' as state_code
    from even_customers as even -- 1M
    join pa_customer_list as odd on even.city = odd.city and even.location_type = odd.location_type - 1M
    where odd.row_id + 1 = even.row_id

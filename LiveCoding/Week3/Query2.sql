-- Query 2:  Select a random winner for each city and location_type in Texas
-- Return one customer per city, per location_type it must be random, return city, location_type, customer_id
-- we want to ensure the result is truly providing a random customer (vs. sorting and returning a specific result)
with tx_customer_list as (
    select
        customer_id,
        city,
        location_type
    from customer_address 
    where state_code = 'TX')

-- answer should be ~3500
select
    city, 
    location_type,
    customer_id
from tx_customer_list
qualify row_number() over(partition by city, location_type order by city) = 1
order by 1, 2

/* Uncomment the statements below to evaluate the query profile. */


/* The customer_address table has a clustering key on state_code, city
   Review the query plan for these statements to determine whether our SQL syntax uses the clustering key. */

-- select distinct location_type from customer_address
-- select distinct city from customer_address where state_code = 'PA'
-- select distinct city from customer_address where state_code ilike 'PA%'
-- select distinct city from customer_address where trim(upper(state_code)) = 'PA'

/* The two statements below select from views that select from the customer_address table.
   Review the query plan for these statements to determine whether they use the clustering key efficiently. */

-- select distinct city from customer_address_view where state_code = 'TX'
-- select distinct city from texas_customers

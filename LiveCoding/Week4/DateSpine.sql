-- use a recursive CTE to create a table with one row per day for every day in 2021, 2022 and 2023.
-- recursive CTE - a CTE that references itself

with date_spine as (
    select 
        '01/01/2021'::date as activity_date
    union all
    select 
        dateadd(day, 1, activity_date) as activity_date
    from date_spine where activity_date < '12/31/2023')

select
    *
from date_spine

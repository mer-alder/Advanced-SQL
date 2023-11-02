select user_name, count(*) as recipe_count, listagg(recipe_name, ', ') as recipe_suggestions from (select * from
(select recipe_name, trim(lower(username)) username, trim(replace(name, '"', '')) name, row_number() over (partition by recipe_name order by name) ingredient
from (
    select
    recipe_name
    , r.chef_id
    , recipe_id
    , ingredient_list.value name
    from chefs.recipe as r, table(flatten(ingredients)) as ingredient_list
where ingredient_count = 5) r
join chefs.chef_profile c on r.chef_id = c.chef_id) recipe_list
pivot(min(name) for ingredient in (1, 2, 3, 4, 5)) as p(recipe_name, user_name, ing1, ing2, ing3, ing4, ing5)
where recipe_name not ilike '%ice cream%' and (((ing1 = 'flour' or ing2 = 'flour' or ing3 = 'flour' or ing4 = 'flour' or ing5 = 'flour') or (ing1 = 'sugar' or ing2 = 'sugar' or ing3 = 'sugar' or ing4 = 'sugar' or ing5 = 'sugar')) and (ing1 = 'butter' or ing2 = 'butter' or ing3 = 'butter' or ing4 = 'butter' or ing5 = 'butter') and
((ing1 = 'milk' or ing2 = 'milk' or ing3 = 'milk' or ing4 = 'milk' or ing5 = 'milk') or (ing1 = 'vanilla extract' or ing2 = 'vanilla extract' or ing3 = 'vanilla extract' or ing4 = 'vanilla extract' or ing5 = 'vanilla extract') or (ing1 = 'eggs' or ing2 = 'eggs' or ing3 = 'eggs' or ing4 = 'eggs' or ing5 = 'eggs')))
    or recipe_name ilike '%brownie%' or recipe_name ilike '%cookie%')
group by 1
having count(*) > 1
order by 2 desc

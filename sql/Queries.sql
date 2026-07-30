'Queries'

'Viewing the data'

select * from orders
limit 10;


'Number of Orders'

select COUNT(*) from orders;

'Unique Regions'

select distinct region from orders;


'Solving business questions'

'Question 1 - Which region generates the highest profit?'

select region, sum(profit) as total_profit from orders
group by region
order BY total_profit desc;


'Question 2 - Which product categories are most and least profitable?'

select category, sum(profit) as profit from orders
group by category 
order by profit desc;


'Question 3 - Which products have the most impact on losess?'

select "Product Name", round(sum(profit)::numeric, 2) as total_profit_losses from orders
where profit < 0
group by "Product Name"
order by total_profit_losses asc
limit 10;


'Question 4 - How does discount impact profit?'

select discount, round(avg(profit)::numeric, 2) as average_profit,
round(sum(profit)::numeric, 2) as total_profit,
count(*) as number_of_orders
from orders
group by discount
order by discount;



select discount,
round(sum(sales)::numeric, 2) as total_sales,
round(avg(profit)::numeric, 2) as average_profit,
round(sum(profit)::numeric, 2) as total_profit
from orders
group by discount
order by discount;

select discount,
round(avg(profit)::numeric, 2) as average_profit
from orders
group by discount
having avg(profit) < 0
order by average_profit 






	
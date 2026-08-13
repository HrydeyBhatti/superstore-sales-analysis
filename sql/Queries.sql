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


'5. What are the monthly sales trends?'

select
extract(year from to_date("Order Date", 'MM/DD/YYYY'))::int as "year",
extract(month from to_date("Order Date", 'MM/DD/YYYY'))::int as "month",
sum(sales) as total_sales
from orders
group by extract(month from to_date("Order Date", 'MM/DD/YYYY')),
extract(year from to_date("Order Date", 'MM/DD/YYYY'))
order by "year",
"month";


'6. Which products performs more than average profit?'

select "Product Name",
ROUND(profit::numeric,  2) as profit,
ROUND((select avg(profit) from orders)::numeric, 2) as average_profit
from orders
where profit >
(select avg(profit)
from orders)
order by profit desc;


'7. Which customers generated more than £5,000 in sales?'

with customer_sales as  (
	select "Customer Name", Sum(sales) as total_sales
	from orders
	group by "Customer Name"
	
)

select *
from customer_sales
where total_sales > 5000
order by total_sales desc;

'8. Find the total sales for each Category, then show only categories with
sales greater than 100,000'

with category_sales as (
	select category, Sum(sales) as total_category_sales
	from orders
	group by category
)

select *
from category_sales
where total_category_sales > 100000
order by total_category_sales asc;




'9. Which customers spend more than the average customer?'

with customer_sales as (
	select "Customer Name", round(sum(sales)::numeric, 2) as total_customer_spend
	from orders
	group by "Customer Name" 
	


),
avg_sales as (
	select
		round(avg(total_customer_spend)::numeric, 2) as avg_customer_spend
	from customer_sales
)
select
	customer_sales."Customer Name",
	customer_sales.total_customer_spend,
	avg_sales.avg_customer_spend
from customer_sales
cross join avg_sales
where customer_sales.total_customer_spend > avg_sales.avg_customer_spend
order by total_customer_spend desc;




'10. Which region has sales above the company average?'



with regional_sales as (
	select region, sum(sales) as total_sales
	from orders
	group by region
),

company_average as (
	select
		avg(total_sales) as avg_sales
	from regional_sales
)

select
	rs.region,
	rs.total_sales
from regional_sales rs
cross join company_average ca
where rs.total_sales > ca.avg_sales
order by rs.total_sales desc;



'11. Which products have never made a profit?'


select "Product Name", sum(profit) as total_profit
from orders
group by "Product Name" 
having sum(profit) <= 0
order by total_profit desc;


'12. Which customers are in the top 10% of sales?'


select
	"Customer Name", sum(sales) as total_sales
from orders
group by "Customer Name"
having sum(sales) >= (
	select min(total_sales)
	from (
		select
			"Customer Name",
			sum(sales) as total_sales
		from orders
		group by "Customer Name"
		order by total_sales desc
		limit  (
			select ceil(count(distinct "Customer Name") * 0.10)
			from orders
		)
	)as top_10_percent
)
order by total_sales desc;
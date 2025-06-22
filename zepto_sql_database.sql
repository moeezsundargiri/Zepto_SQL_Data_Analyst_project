CREATE DATABASE zepto_SQL_project;
use zepto_SQL_project;

drop table if exists zepto;

create table zepto(
	sku_id serial primary key,
    category varchar(120),
    name varchar(150) not null,
    mrp numeric(8,2),
    discountPercent numeric(5, 2),
    availableQuantity Int,
    discountedSellingPrice numeric(8, 2),
    weightInGms int,
    outOfStock varchar(5),
    quantity int
);
-- ALTER TABLE zepto
-- MODIFY COLUMN outOfStock VARCHAR(5);

-- data exploration
--  count of rows
select count(*) from zepto; 

 -- sample data
 select * from  zepto
 limit 10;

-- null values

select * from zepto
where name is null
or
category is null
or 
mrp is null
or
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity  is null


-- different product category in zepto
Select Distinct category 
from zepto
order by category 

 -- products in stock and out of stock 
 select outOfStock, count(sku_id) 
 from zepto
 group by outOfStock
 
 
--  product names multiple times-- 
select name , count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;


-- data cleaning 
 -- q10 product price with zero 
 select * from zepto
 where mrp = 0 or discountedSellingPrice = 0 ;
 
 delete from zepto
 where mrp = 0
 
 -- convert paise to rupee
 
Update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

-- Find Bussing Insight-------

-- q1 find the top best value product based on the discount percentage

select distinct name , mrp, discountedSellingPrice
from zepto
order by discountedSellingPrice desc
limit 10;

-- q2 what are the product with high mrp but out of stock
select distinct name, mrp 
from zepto
where outOfStock = true  
order by mrp desc;

-- q3 calculate the estimate revenue of each product

select category,
sum(discountedSellingPrice * quantity) as total_revenue
from zepto
group by category
order by total_revenue

-- q4 find the products where mrp is greater than 500 and discount is less than 10%

select distinct  name , mrp , discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc , discountPercent desc;

-- q5 identify the top 10 category offering the higest average discount percentage

select distinct category ,round(avg(discountPercent)) as avg_discount
from zepto
group by category
order by avg_discount desc 
limit 5;

-- q6 find the price per gram for product above 100g and best value
select distinct name ,weightInGms , discountedSellingPrice,
round(discountedSellingPrice/weightInGms , 2) as price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram


-- q7 group the products into categorys like low , medium ,high

select distinct name , weightInGms,
case when weightInGms < 1000 then 'low'
	when weightInGms < 5000 then 'medium'
    else 'Bulk'
    end as weight_category
from zepto
order by weightInGms desc


-- q8 what are the total inventory weight in per category
select category, sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight



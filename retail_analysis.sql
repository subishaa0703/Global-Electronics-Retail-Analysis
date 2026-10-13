-- 1.	Top 10 products sold by revenue
with cte as 
(SELECT p.productkey,p.product_name,sum(Unit_Cost_USD*quantity) as total_cost, sum(Unit_Price_USD*quantity) as revenue,
sum((Unit_Price_USD-Unit_Cost_USD)*quantity) as profit
 FROM products p 
 join sales s on p.ProductKey=s.ProductKey
 group by Product_Name, ProductKey),
ranking as
 (select product_name,revenue, dense_rank() over(order by revenue desc) as rankk from cte)
 select product_name, revenue, rankk from ranking  where rankk<=10 order by rankk;

--2.	Top 10 products sold by profit
with cte as 
(SELECT p.productkey,p.product_name,
sum((Unit_Price_USD-Unit_Cost_USD)*quantity) as profit
 FROM products p 
 join sales s on p.ProductKey=s.ProductKey
 group by Product_Name, ProductKey),
ranking as
 (select productkey,product_name,profit, dense_rank() over(order by profit desc) as rankk from cte)
 select productkey,product_name,profit, rankk from ranking  where rankk<=10 order by rankk;

--3.	Top 10 products by number of quantities sold
with cte as 
(SELECT p.productkey,p.product_name,sum(quantity) as qty,
sum((Unit_Price_USD-Unit_Cost_USD)*quantity) as profit
 FROM products p 
 join sales s on p.ProductKey=s.ProductKey
 group by Product_Name, ProductKey),
ranking as
 (select product_name,qty, dense_rank() over(order by qty desc) as rankk from cte)
 select product_name, qty, rankk from ranking  where rankk<=10 order by rankk;

--4.	Top 5 product categories by revenue
select Category, sum(Unit_Price_USD*quantity) as revenue, sum((Unit_Price_USD-Unit_Cost_USD)*quantity) as profit from products p
join sales s on p.productkey=s.ProductKey
group by category order by revenue desc limit 5;

--5.	Stores selling most products
SELECT es.StoreKey , country, state,sum(unit_price_usd*quantity) as revenue, sum((Unit_Price_USD-Unit_Cost_USD)*quantity) as profit
FROM sales s 
join products p on s.productkey= p.productkey
right join stores es on s.StoreKey=es.StoreKey
group by StoreKey order by revenue desc;

--6.	Total revenue and profit by country
select country,sum(Unit_Cost_USD*quantity)/1000000 as total_cost, sum(Unit_Price_USD*quantity)/1000000 as revenue,
 sum(Unit_Price_USD-Unit_Cost_USD)/1000000 as profit ,  round(sum(Unit_Price_USD-Unit_Cost_USD)/sum(Unit_Price_USD*quantity)*100,2) as profit_margin 
 from customers c
join sales s on c.customerkey=s.CustomerKey
join products p on s.productkey=p.ProductKey
group by country order by revenue desc;

--7.	Total number of distinct customers in each country
select count(*) as customer_count, country from customers group by country order by customer_count desc;

--8.	Total revenue and profit month wise
SELECT year(order_date) as year, month(Order_Date) as month,
sum(Unit_cost_USD*Quantity)/1000000 as total_cost,sum(Unit_Price_USD*Quantity)/1000000 as revenue,
sum(Unit_Price_USD*Quantity-Unit_cost_USD*Quantity)/1000000 as profit
FROM global_electronics.products p
join sales s on p.productkey=s.productkey
group by year(order_date), month(order_date) order by year, month;

--9.	Total revenue and profit year wise
SELECT year(order_date) as year,
sum(Unit_cost_USD*Quantity)/1000000 as total_cost,sum(Unit_Price_USD*Quantity)/1000000 as revenue,
sum(Unit_Price_USD*Quantity-Unit_cost_USD*Quantity)/1000000 as profit
FROM global_electronics.products p
join sales s on p.productkey=s.productkey
group by year(order_date) order by year;



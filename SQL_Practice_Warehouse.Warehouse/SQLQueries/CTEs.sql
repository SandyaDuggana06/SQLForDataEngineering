--Use a CTE to calculate order totals.
WITH order_totals AS
(
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        o.shipping_cost,
        o.discount_amount
)

select sum(ot.order_total) as order_total_value from order_totals ot

--Use a CTE to calculate customer sales.
WITH order_totals AS
(
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        o.shipping_cost,
        o.discount_amount
)

select ot.customer_id, ot.order_total, c.customer_name from order_totals ot inner join customers c
on c.customer_id=ot.customer_id

--Use a CTE to find customers with sales above 500.
WITH order_totals AS
(
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        o.shipping_cost,
        o.discount_amount
)

select sum(ot.order_total), ot.customer_id from order_totals ot group by ot.customer_id having sum(ot.order_total)>500


--Use two CTEs to calculate monthly sales and monthly targets.
WITH order_totals AS
(
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        o.shipping_cost,
        o.discount_amount,
        o.order_date
),

monthly_sales as
(
select FORMAT(ot.order_date, 'MMMM yyyy') AS month_year, sum(ot.order_total) as monthly_sales from order_totals ot
group by FORMAT(ot.order_date, 'MMMM yyyy')
),

sales_target as
(
select FORMAT(mst.target_month, 'MMMM yyyy') as month_year,sum(sales_target) as monthly_sales_targets from monthly_sales_targets mst group by FORMAT(mst.target_month, 'MMMM yyyy')
)

select ms.month_year,
CASE 
when ms.monthly_sales>st.monthly_sales_targets then 'target met'
when ms.monthly_sales<st.monthly_sales_targets then 'target not met'
else 'neutral'
end as target
from monthly_sales ms inner join sales_target st on ms.month_year=st.month_year



--Use a CTE to calculate product profitability.
with product_profitability as
(
select  product_id,product_name, unit_price,cost_price,((unit_price-cost_price)/cost_price) *100 as profit_percentage from products
)

select product_id,product_name, profit_percentage from product_profitability

--Use a CTE to identify low-stock products.
with stock_availability as
(
select product_id,product_name ,stock_quantity from products
)
select product_name,
Case 
when stock_quantity > 30 then 'high stock'
else 'low on stock'
end
from stock_availability


--Use a CTE to calculate customer order counts.
with customer_order_count as
(
select count(order_id) as order_count, customer_id from orders group by customer_id
)
select coc.customer_id,c.customer_name , coc.order_count from customer_order_count coc inner join customers c
on c.customer_id=coc.customer_id

--Use a CTE to find customers with no orders.
with customers_with_NoOrders as
(
select c.customer_id,c.customer_name from customers c where customer_id not in (select customer_id from orders)
)
SELECT *
FROM customers_with_no_orders;


--Use sequential CTEs to calculate category sales and rank categories.
with category_sales as
(
select sum(oi.quantity) as number_of_products_sold, p.category_id from order_items oi inner join products p
on p.product_id =oi.product_id group by p.category_id
),

fetching_category_names as
(select c.category_name, cs.category_id, cs.number_of_products_sold from categories c inner join category_sales cs on
cs.category_id=c.category_id
)

select  fcn.category_name, fcn.number_of_products_sold ,
DENSE_RANK() over (
order by fcn.number_of_products_sold desc
) as category_rank
from fetching_category_names fcn order by category_rank 


--Use a CTE to calculate average resolution time.
with resolution_time_calc as
(
select ticket_id, customer_id, DATEDIFF(DAY, created_date,resolved_date) as resolution_time from customer_support_tickets 
where ticket_status ='Resolved' and  resolved_date IS NOT NULL
)

select avg(resolution_time) as avg_resolution_time_in_days from resolution_time_calc


--Use a CTE to identify customers with high return rates.
with customer_returns as
(
select r.return_id,o.order_id, o.customer_id from returns r inner join orders o on
o.order_id=r.order_id
),
fetching_customer_name as
( select c.customer_name,c.customer_id, cr.return_id from customer_returns cr inner join customers c on
c.customer_id=cr.customer_id
),
 num_returns_per_customer as
 (
 select fcn.customer_name,count(return_id) as num_of_returns from fetching_customer_name fcn group by fcn.customer_name
 ) 

select c. customer_name, 
case 
when c.num_of_returns >=2 then 'high'
else 'low'
end as probabilit_of_return
from  num_returns_per_customer c


--Use a CTE to calculate order totals and apply a discount classification.
WITH order_totals AS
(
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        o.shipping_cost,
        o.discount_amount
)

 select ot.order_id,
        ot.customer_id,
        ot.order_total,
        o.discount_amount,
        case
        when o.discount_amount >0 then 'discount exists'
        else 'no discount'
        end as discount_exists_or_not
        from order_totals ot 
        inner join orders o on ot.order_id=o.order_id

--Use a CTE to find the top customer in each country.
WITH order_totals AS
(
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        o.shipping_cost,
        o.discount_amount
),
customer_order_total as
(select ot.customer_id,c.customer_name, sum(ot.order_total) as order_value, c.country 
from order_totals ot 
inner join customers c 
on c.customer_id=ot.customer_id 
group by ot.customer_id, c.country, c.customer_name)

SELECT
    customer_name,
    country,
    order_value
FROM
(
    SELECT *,
           DENSE_RANK() OVER
           (
               PARTITION BY country
               ORDER BY order_value DESC
           ) AS ranking
    FROM customer_order_total
) t
WHERE ranking = 1;





--Use a CTE to compare employee salary with department average.
with dept_avg as
(select avg(salary) as avg_salary,department from employees group by department
)

SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    e.salary,
    da.avg_salary,
    CASE
        WHEN e.salary >= da.avg_salary
            THEN 'Above Department Average'
        ELSE 'Below Department Average'
    END AS salary_classification
FROM employees e
INNER JOIN dept_avg da
    ON e.department = da.department;




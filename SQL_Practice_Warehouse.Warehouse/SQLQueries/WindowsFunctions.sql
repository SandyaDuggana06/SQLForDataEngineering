--Assign a row number to every order.
select order_id,customer_id,order_date, ROW_NUMBER() OVER (Order by order_date) as row_num from orders

--Assign row numbers to orders for each customer.
select order_id, customer_id, order_date, ROW_NUMBER() OVER(PARTITION by customer_id order by order_date) as row_num from orders

--Rank products by price.
select product_id, product_name, DENSE_RANK() OVER(order by cost_price desc) as rank_based_on_price from products

--Use DENSE_RANK() to rank employee salaries.
select employee_id,employee_name, department, salary , DENSE_RANK() OVER(order by salary desc) as rank_based_on_salary from employees

--Find the top three highest-paid employees.
select top 3 employee_id,employee_name,salary, DENSE_RANK() OVER(order by salary desc) as rank from employees

--Find the top two products in every category.
with ranked_products AS(
select product_id,product_name, unit_price, category_id,
DENSE_RANK() over( PARTITION by category_id ORDER by unit_price DESC) as product_rank from products)

select product_id,product_name, unit_price, category_id, product_rank from  ranked_products where product_rank<=2
Order by category_id , product_rank

--Calculate a running total of monthly sales.
with order_total AS(
   SELECT
   o.order_id,
        month(o.order_date) as sales_month,
        year(o.order_date) as sales_year,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
      month(o.order_date),year(o.order_date),
        o.shipping_cost,
        o.discount_amount,o.order_id
),

monthly_sales AS
(
    SELECT
        sales_year,
        sales_month,
        SUM(order_total) AS monthly_sales
    FROM order_total
    GROUP BY
        sales_year,
        sales_month
)

SELECT
    sales_year,
    sales_month,
    monthly_sales,
    SUM(monthly_sales) OVER
    (
        ORDER BY sales_year, sales_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM monthly_sales
ORDER BY
    sales_year,
    sales_month;


--Calculate a running total of sales by country.
with order_total AS(
   SELECT
   o.order_id,
        o.shipping_country,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
      o.shipping_country,
        o.shipping_cost,
        o.discount_amount,o.order_id
)

select order_id, shipping_country, order_total, 
sum(order_total) over (PARTITION by shipping_country order by order_id) as running_sales from order_total


--Calculate the cumulative number of customers by signup date.
WITH daily_signups AS
(
    SELECT
        signup_date,
        COUNT(*) AS customers_signed_up
    FROM customers
    GROUP BY signup_date
)

SELECT
    signup_date,
    customers_signed_up,
    SUM(customers_signed_up) OVER (
        ORDER BY signup_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_customers
FROM daily_signups
ORDER BY signup_date;

--Compare each product price with the previous product price using LAG.
select product_id, product_name, cost_price, lag(cost_price) over (order by product_id) as previous_cost_price from products


--Compare each month’s sales with the previous month using LAG.
with order_total AS(
   SELECT
   o.order_id,
        month(o.order_date) as sales_month,
        year(o.order_date) as sales_year,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
      month(o.order_date),year(o.order_date),
        o.shipping_cost,
        o.discount_amount,o.order_id
),

monthly_sales AS
(
    SELECT
        sales_year,
        sales_month,
        SUM(order_total) AS monthly_sales
    FROM order_total
    GROUP BY
        sales_year,
        sales_month
)
select sales_year, sales_month, monthly_sales, lag(monthly_sales) over(order by sales_month) as previous_month_sales from monthly_sales

--Calculate month-over-month sales growth.
with order_total AS(
   SELECT
   o.order_id,
        month(o.order_date) as sales_month,
        year(o.order_date) as sales_year,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
      month(o.order_date),year(o.order_date),
        o.shipping_cost,
        o.discount_amount,o.order_id
),

monthly_sales AS
(
    SELECT
        sales_year,
        sales_month,
        SUM(order_total) AS monthly_sales
    FROM order_total
    GROUP BY
        sales_year,
        sales_month
),
sales_comparison AS
(
    SELECT
        sales_year,
        sales_month,
        monthly_sales,
        LAG(monthly_sales) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_month_sales
    FROM monthly_sales
)

SELECT
    sales_year,
    sales_month,
    monthly_sales,
    previous_month_sales,
    monthly_sales - previous_month_sales AS sales_difference,
    ((monthly_sales - previous_month_sales) * 100.0)
        / NULLIF(previous_month_sales, 0) AS monthly_growth_percentage
FROM sales_comparison
ORDER BY
    sales_year,
    sales_month;


--Use LEAD to show the next order date for every customer.
select customer_id, order_date, LEAD(order_date) over(PARTITION by customer_id order by order_date) as next_order_date from orders

--Find the time between consecutive orders for each customer.
with customer_orderdates as(
select customer_id, order_date, LEAD(order_date) over(PARTITION by customer_id order by order_date) as next_order_date from orders
)

select customer_id, order_date, next_order_date, DATEDIFF(day, order_date, next_order_date) as diff_between_consecutive_orders 
from customer_orderdates


--Calculate the average salary within each department using a window function.
select department, avg(salary) over(partition by department) as avg_salary from employees

--Calculate each employee’s salary difference from the department average.
with avg_salary as
(select employee_id, salary, department, avg(salary) over(partition by department) as avg_salary from employees
)

select employee_id,department, salary, avg_salary-salary as diff_from_dept_avg from avg_salary

--Calculate each product’s percentage contribution to category sales.
with product_sales as
(
select oi.product_id, p.product_name,p.category_id,sum(oi.quantity*oi.unit_price) as product_sales from order_items oi inner join products p 
on p.product_id=oi.product_id
group by oi.product_id,p.category_id, p.product_name
),
category_sales as
(
select product_id, product_name, category_id, product_sales, sum(product_sales) over(partition by category_id) as category_sale
from product_sales
)

select product_id, product_name, category_id, product_sales, category_sale, (product_sales/category_sale)* 100.0 as percentage_product_sales
from category_sales

--Calculate each country’s percentage contribution to total sales.
with order_total AS(
   SELECT
        o.order_id,
        o.shipping_country,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
      o.shipping_country,
        o.shipping_cost,
        o.discount_amount,o.order_id
),

country_sales as
(
select  shipping_country, sum(order_total) as country_sales from order_total group by shipping_country
)

select shipping_country, country_sales, sum(country_sales) over () as total_sales,  country_sales * 100.0
        / SUM(country_sales) OVER () AS percentage_of_total_sales from country_sales 
    order by percentage_of_total_sales DESC


--Find the first order for every customer.
with rownumber as
(
select order_id,customer_id,order_date, row_number() over (partition by customer_id order by order_date,order_id) as rn
  from orders
  )

select customer_id,order_id, order_date from rownumber where rn=1

--Find the latest order for every customer.
with rownumber as
(
select customer_id,order_id,order_date, row_number() over (partition by customer_id order by order_date desc) as rn
from orders
)

select customer_id,order_id,order_date from rownumber where rn=1

--Use ROW_NUMBER() to remove duplicate customer records.
with ranked_customers as
(
select customer_id,customer_name, email, row_number() over(partition by email order by customer_id) as rn from customers
)
SELECT
    customer_id,
    customer_name,
    email
FROM ranked_customers
WHERE rn = 1;


--Find the second-highest salary in every department.
with ranked_salaries as(
select employee_id, employee_name, salary, department,
 row_number() over(partition by department order by salary desc) as rn from employees
)
 select employee_id, employee_name, salary, department from ranked_salaries where rn=2

--Find the top-selling product in every category.
with product_category as
(
select  oi.product_id, sum(oi.quantity) as total_products_sold, p.category_id, p.product_name from order_items oi inner join products p 
on p.product_id=oi.product_id group by oi.product_id, p.category_id, p.product_name
),
rownumber_totalprodsold as
(
select product_id, product_name, category_id,total_products_sold, row_number() over(partition by category_id order by  total_products_sold desc) as rn from 
product_category
)
select product_id, product_name, category_id,total_products_sold from rownumber_totalprodsold where rn=1

--Calculate a rolling three-month sales average.
with order_total AS(
   SELECT
   
        month(o.order_date) as sales_month,
        year(o.order_date) as sales_year,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
      month(o.order_date),year(o.order_date),
        o.shipping_cost,
        o.discount_amount
),

monthly_sales AS
(
    SELECT
        sales_year,
        sales_month,
        SUM(order_total) AS monthly_sales
    FROM order_total
    GROUP BY
        sales_year,
        sales_month
)

SELECT
    sales_year,
    sales_month,
    monthly_sales,
    AVG(monthly_sales) OVER (
        ORDER BY sales_year, sales_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3_month_average
FROM monthly_sales
ORDER BY
    sales_year,
    sales_month;


--Divide customers into four spending groups using NTILE(4).
WITH customer_spending AS
(
    SELECT
        o.customer_id,
        SUM(
            oi.quantity * oi.unit_price
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0)
        ) AS total_spending
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id
)

SELECT
    customer_id,
    total_spending,
    NTILE(4) OVER (
        ORDER BY total_spending DESC
    ) AS spending_group
FROM customer_spending;

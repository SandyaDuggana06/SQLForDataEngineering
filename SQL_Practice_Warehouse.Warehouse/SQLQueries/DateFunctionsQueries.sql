-- Question 1 Extract the year from every order date.
select order_id, order_date, year(order_date) as year from orders

--Question 2 Extract the month from every order date.
select order_id, order_date, month(order_date) as month from orders

--Question 3 Count orders by month.
select count(*) as NumOfOrders, month(order_date) as month from orders group by month(order_date)

--Question 4 Find the number of days between order date and payment date.
select o.order_id,DATEDIFF(DAY, o.order_date,p.payment_date) as NumOfDaysBetweenOrderDateNPaymentDate from orders o inner join payments p 
on o.order_id=p.order_id

--Question 5 Find customers who signed up in 2025.
select customer_id, YEAR(signup_date) as signup_year from customers where YEAR(signup_date) =2025


--Question 6 Find orders placed during the first quarter of 2026.
select order_id, order_date from orders where DATEPART(Quarter, order_date)=1

--Question 7 Calculate customer age in days since signup.
select customer_id,customer_name, DATEDIFF(day,signup_date,GETDATE()) as customerAge from customers

--Question 8 Find employees hired before 2022.
select employee_id,employee_name, hire_date from employees where year(hire_date)<2022

--Question 9 Find orders placed in the last 30 days relative to a chosen date.

DECLARE @chosen_date DATE = '2026-04-05';

SELECT
    order_id,
    customer_id,
    order_date
FROM orders
WHERE order_date >= DATEADD(DAY, -30, @chosen_date)
  AND order_date <= @chosen_date;

--Question 10 Find the first order date for every customer.
select c.customer_id, c.customer_name, min(o.order_date) as first_order_date from customers c inner join orders o ON
o.customer_id=c.customer_id group by c.customer_id,c.customer_name


--Question 11 Find the latest order date for every customer.
select c.customer_id, c.customer_name, MAX(o.order_date) as first_order_date from customers c inner join orders o ON
o.customer_id=c.customer_id group by c.customer_id,c.customer_name

--Question 12 Calculate monthly sales.
select format(o.order_date,'MMMM yyyy') as month_year, sum(oi.quantity*oi.unit_price) as sales from orders o inner join order_items oi 
on oi.order_id=o.order_id group by format(o.order_date,'MMMM yyyy')

--Question 13 Calculate monthly sales by country.
select o.shipping_country,format(o.order_date,'MMMM yyyy') as month_year, sum(oi.quantity*oi.unit_price) as sales from orders o inner join order_items oi 
on oi.order_id=o.order_id group by format(o.order_date,'MMMM yyyy'),o.shipping_country

--Question 14 Compare monthly actual sales with targets.

WITH 
monthly_actual_sales as
(
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS actual_sales
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)) ,

monthly_target_sales as
(
select year(target_month) as year, month(target_month) as month, sum(sales_target) as target_sales from monthly_sales_targets 
group by year(target_month),month(target_month)
)

select mts.year,mts.month,
case
when mas.actual_sales >= mts.target_sales then 'target met'
when mas.actual_sales < mts.target_sales then 'target not met'
END

 from monthly_actual_sales mas inner join monthly_target_sales mts on
mts.year=mas.sales_year and mts.month=mas.sales_month

/*
WITH monthly_actual_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS actual_sales
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
),

monthly_targets AS (
    SELECT year(target_month) as target_year,month(target_month) as target_month,
       sales_target
    FROM monthly_sales_targets
)

SELECT
    mas.sales_year,
    mas.sales_month,
    mas.actual_sales,
    mt.sales_target,
    mas.actual_sales - mt.sales_target AS variance
FROM monthly_actual_sales mas
INNER JOIN monthly_targets mt
    ON mas.sales_year = mt.target_year
    AND mas.sales_month = mt.target_month;
*/

--Calculate the number of days required to resolve each support ticket.
select ticket_id, customer_id, DATEDIFF(DAY,created_date,resolved_date) as NumOfDaysToResolve from customer_support_tickets
where resolved_date is Not NULL

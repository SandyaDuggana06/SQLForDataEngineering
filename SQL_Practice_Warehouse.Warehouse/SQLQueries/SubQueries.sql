--Find products priced above the average product price.
select product_id, product_name,cost_price from products where cost_price >
(select avg(cost_price) from products )

--Find employees earning above the company average salary.
select employee_id, employee_name, salary from employees
where salary>
(select avg(salary) from employees)

--Find customers whose total spending is above average customer spending.
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

customer_totals AS
(
    SELECT
        customer_id,
        SUM(order_total) AS total_spent
    FROM order_totals
    GROUP BY customer_id
)

SELECT
    ct.customer_id,
    c.customer_name,
    ct.total_spent
FROM customer_totals AS ct
INNER JOIN customers AS c
    ON ct.customer_id = c.customer_id
WHERE ct.total_spent >
(
    SELECT AVG(total_spent)
    FROM customer_totals
)
ORDER BY ct.total_spent DESC;


--Find the most expensive product.
select product_id,product_name,unit_price from products where 
unit_price=(select max(unit_price) from products)

--Find the second-highest product price.
select max(unit_price) as second_highest_product_price from products 
where unit_price < (select max(unit_price) from products)

SELECT
    product_id,
    product_name,
    unit_price
FROM products
WHERE unit_price =
(
    SELECT MAX(unit_price)
    FROM products
    WHERE unit_price <
    (
        SELECT MAX(unit_price)
        FROM products
    )
);

--Find products in the most expensive category.
select * from products where 
category_id=
(select category_id from products where 
unit_price=(select max(unit_price) from products))

--Find employees earning above their department average.
select employee_id, employee_name, department,salary from employees e1 where 
e1.salary >
(select avg(e2.salary)  from employees e2 where   e1.department=e2.department)


--Find customers who placed at least one order.
select customer_id,customer_name from customers where customer_id in
(select customer_id from orders)


--Find customers who never placed an order using NOT EXISTS.
select customer_id, customer_name from customers c where 
NOT EXISTS (select 1  from orders o where o.customer_id=c.customer_id)

--Find customers who never placed an order using NOT IN.
SELECT
    customer_id,
    customer_name
FROM customers
WHERE customer_id NOT IN
(
    SELECT customer_id
    FROM orders
);


--Find products that were sold at least once using EXISTS.
select product_id, product_name from products p where exists (select 1 from order_items oi where p.product_id=oi.product_id)

--Find products never sold using NOT EXISTS.

select product_id, product_name from products p where not exists (select 1 from order_items oi where p.product_id=oi.product_id)


--Find the highest-paid employee in every department.
select employee_id,employee_name, salary from employees e1 where e1.salary=
(select max(e2.salary) from employees e2 where e1.department=e2.department)

--Find the lowest-priced product in every category.
select c.category_name, c.category_id, sq.product_id,sq.product_name, sq.unit_price from categories c 
inner join
(select p1.category_id,p1.product_id, p1.product_name, p1.unit_price from products p1 where p1.unit_price=
(select min(p2.unit_price) from products p2 where p1.category_id=p2.category_id)) sq
on sq.category_id=c.category_id

--Find orders whose value is above the average order value.
with order_value as
(
select o.order_id, sum(oi.quantity*oi.unit_price)+COALESCE(o.shipping_cost,0)-COALESCE(o.discount_amount,0) as order_value_amount from orders o 
inner join order_items oi on oi.order_id=o.order_id group by o.order_id, o.shipping_cost, o.discount_amount),

avg_order_amt as (
select avg(ov.order_value_amount) as avg_order_amount from order_value ov) 

select ov.order_id, aov.avg_order_amount as avg_order_value, ov.order_value_amount as order_value from order_value ov cross join avg_order_amt aov where ov.order_value_amount > aov.avg_order_amount


--Find customers with more orders than the average customer.
WITH customer_order_counts AS
(
    SELECT
        customer_id,
        COUNT(order_id) AS number_of_orders
    FROM orders
    GROUP BY customer_id
),
avg_customer_orders as (
SELECT
    AVG(CAST(number_of_orders AS DECIMAL(10,2))) AS average_orders_per_customer
FROM customer_order_counts)

select coc.customer_id, coc.number_of_orders, aco.average_orders_per_customer from 
customer_order_counts coc cross join avg_customer_orders aco where coc.number_of_orders>aco.average_orders_per_customer 


--Display all columns from customers.
select * from customers

--Display only customer name, country, and city.
select customer_name,country,city from customers

--Display all unique countries.
select DISTINCT country from customers

--Display all unique customer segments.
select DISTINCT customer_segment from customers

--Rename customer_name as full_name.
select customer_name as full_name from customers


--Display product name and unit price.
select product_name, unit_price from products

--Display employee name and salary.
select employee_name, salary from employees

--Display all order IDs and order dates.
select order_id,order_date from orders

--Return the first five products using TOP.
select top 5 product_name from products order by product_id


--Return the five most expensive products.
select top 5 product_name from products order by unit_price desc

--Display the three most recently hired employees.
select top 3 * from employees order by hire_date desc


--Display all active products.
select * from products WHERE is_active ='Yes'


--Display the names of customers who have an email address.
select customer_name from customers where email is NOT NULL


--Display all products with their supplier names.
select product_name,supplier_name from products

--Display unique payment methods.
select DISTINCT payment_method from payments

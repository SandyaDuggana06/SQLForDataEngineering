--Count all customers.
select count(*) from customers

--Count all products.
select count(*) from products

--Count active products.
select count(*) from products where is_active='Yes'

--Count completed orders.
select count(*) from orders where order_status='Completed'

--Calculate the total quantity sold.
select sum(quantity) as 'total quantity sold'  from order_items

--Calculate the average product price.
select avg(unit_price) as avg_product_price from products

--Find the minimum and maximum product price.
select min(unit_price) as min_product_price, max(unit_price) as max_product_price from products

--Calculate the total payment amount.
select sum(amount)  as 'total payment amount' from payments

--Calculate the average employee salary.
select avg(salary) as 'average employee salary' from employees

--Calculate the total refund amount.
select sum(refund_amount) as 'total refund amount' from returns

--Count support tickets.
select count(*) as 'No. of support tickets' from customer_support_tickets

--Find the earliest order date.
select top 1 * from orders order by order_date
select min(order_date) as 'earliest order date' from orders

--Find the latest order date.
select top 1 * from orders order by order_date desc
select max(order_date) as 'latest order date' from orders

--Count customers with an email address.
select count(*) as 'customers with email address' from customers where email is NOT NULL

--Count customers without an email address.
select count(*) as 'customers without an email address' from customers where email is NULL

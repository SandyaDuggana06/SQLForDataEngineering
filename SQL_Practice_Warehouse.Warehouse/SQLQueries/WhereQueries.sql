--Find customers from Germany.
select * from customers where country='Germany'

--Find customers from India or the USA.
select * from customers where country = 'India' or country='USA'

--Find Premium customers.
select * from customers where customer_segment ='Premium'

--Find products costing more than 100.
select * from products where cost_price >100


--Find products with prices between 50 and 300.
select * from products where cost_price >50 and cost_price <300
select * from products where cost_price BETWEEN 50 and 300

--Find products whose stock is less than 30.
select * from products where stock_quantity <30

--Find orders with status Completed.
select * from orders where order_status ='Completed'

--Find orders that are Pending or Cancelled.
select * from orders where order_status ='Pending' or order_status ='Cancelled'
select * from orders where order_status in ('Pending','Cancelled')



--Find orders created during February 2026.
SELECT *
FROM orders
WHERE order_date >= '2026-02-01'
  AND order_date < '2026-03-01';

SELECT *
FROM orders
WHERE YEAR(order_date) = 2026
  AND MONTH(order_date) = 2;

--Find customers who signed up after 1 May 2025.
select * from customers where signup_date > '2025-05-01'


--Find products supplied by TechSource.
select * from products where supplier_name='TechSource'

--Find employees earning more than 70,000.
select * from employees where salary >70000


--Find employees in Sales or Technology.
select * from employees where department in ('Sales','Technology')

--Find orders with a shipping cost greater than 15.
select * from orders where shipping_cost>15


--Find support tickets with High priority.
select * from customer_support_tickets where priority = 'High'

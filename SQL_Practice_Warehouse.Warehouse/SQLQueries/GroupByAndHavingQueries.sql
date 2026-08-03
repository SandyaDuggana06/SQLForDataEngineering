--Count customers by country.
select  country, count(*) as 'num of customers' from customers group by country

--Count customers by customer segment.
select customer_segment, count(*) as 'num of customers' from customers GROUP BY customer_segment

--Count products by supplier.
select supplier_name, count(*) as 'num of products' from products GROUP BY supplier_name

--Calculate average product price by category.
select avg(unit_price)  AS 'Avg product price' , category_id from products GROUP BY category_id

--Calculate total stock by category.
SELECT category_id, sum(stock_quantity) from products GROUP BY category_id

--Count orders by order status.
select order_status, count(*) as count from orders GROUP by order_status

--Count orders by customer.
SELECT customer_id, COUNT(*) as count from orders GROUP BY customer_id

--Calculate total payment amount by payment method.
select payment_method, SUM(amount) from payments GROUP by payment_method

--Calculate average salary by department.
select department, avg(salary) from employees group by department

--Find the total refund amount by return reason.
select return_reason, sum(refund_amount) from returns GROUP BY return_reason

--Count support tickets by priority.
select priority,count(*) as count from customer_support_tickets GROUP by priority

--Count support tickets by category.
select ticket_category, count(*) as count from customer_support_tickets GROUP by ticket_category

--Find countries with more than three customers.
select * from orders
select country from customers group by country having count(*) >3

--Find customers with more than one order.
select customer_id, count(*) as 'num of orders' from orders group by customer_id having count(*) >1

--Find suppliers with more than two products.
select supplier_name, count(*) AS'num of products' from products group by supplier_name having count(*) >2

--Find departments whose average salary is above 60,000.
select department,avg(salary) as avg_salary from employees group by department having avg(salary)>60000

--Find payment methods with total payments above 500.
select payment_method,sum(amount) as total_payments from payments group by payment_method having sum(amount)>500

--Find countries with more than two Premium customers.
select country, count(customer_id) as count from customers where customer_segment='Premium' group by country having count(*)>2

--Find categories with an average product price above 200.
select category_id, avg(unit_price) as avg_product_price from products group by category_id having avg(unit_price)>200

--Find customers whose total completed payment is above 500.
SELECT o.customer_id, SUM(p.amount) AS total_completed_payment FROM orders AS o INNER JOIN payments AS p
ON o.order_id = p.order_id WHERE p.payment_status = 'Paid' GROUP BY o.customer_id HAVING SUM(p.amount) > 500;

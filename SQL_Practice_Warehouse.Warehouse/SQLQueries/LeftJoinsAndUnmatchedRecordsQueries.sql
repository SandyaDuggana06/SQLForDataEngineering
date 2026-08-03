--Display all customers and their orders.
select  c.customer_id,c.customer_name,o.order_id,o.order_date,o.order_status from 
customers c left join orders o on o.customer_id=c.customer_id

--Find customers who have never placed an order.
select  c.customer_id,c.customer_name,o.order_id,o.order_date,o.order_status from 
customers c left join orders o on o.customer_id=c.customer_id where o.order_id is NULL

--Display all products and their order items.
select p.product_id, p.product_name, oi.order_id,oi.quantity,oi.unit_price from products p left join order_items oi
on p.product_id=oi.product_id

--Find products that have never been sold.
select p.product_id, p.product_name, oi.order_id,oi.quantity,oi.unit_price from products p left join order_items oi
on p.product_id=oi.product_id where oi.order_id is NULL

--Display all categories and their products.
select c.category_id,c.category_name,p.product_name from categories c left join products p on c.category_id=p.category_id

--Find categories with no products.
select c.category_id,c.category_name,p.product_name from categories c left join products p on c.category_id=p.category_id 
where p.product_id is NULL

--Display all orders and their payments.
select o.order_id,o.order_status, p.payment_status from orders o left join payments p on o.order_id = p.order_id

--Find orders without a successful payment.
select o.order_id,o.order_status, p.payment_status from orders o left join payments p on o.order_id = p.order_id WHERE
p.payment_status != 'Paid' or p.payment_status is NULL

--Display all customers and their support tickets.
select c.customer_id,c.customer_name,cst.ticket_id, cst.ticket_category from customers c left join customer_support_tickets cst ON
c.customer_id= cst.customer_id

--Find customers who never created a support ticket.
select c.customer_id,c.customer_name from customers c left join customer_support_tickets cst ON
c.customer_id= cst.customer_id where cst.ticket_id is NULL

--Display all employees and their assigned orders.
select  e.employee_id, e.employee_name,e.job_title,o.order_id,o.order_status from 
employees e left join orders o on e.employee_id= o.employee_id

--Find employees who have never handled an order.
select  e.employee_id, e.employee_name,e.job_title from 
employees e left join orders o on e.employee_id= o.employee_id where o.order_id is NULL

--Display all products and their return information.
select p.product_id, p.product_name ,r.return_id,r.return_reason,r.refund_amount  from products p left join returns r on 
p.product_id=r.product_id

--Find products that were never returned.
select p.product_id, p.product_name from products p left join returns r on 
p.product_id=r.product_id where r.return_id is NULL

--Display every customer and the number of orders, including customers with zero orders.
select c.customer_id,c.customer_name, count(o.order_id) as num_of_orders from customers c left join orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name

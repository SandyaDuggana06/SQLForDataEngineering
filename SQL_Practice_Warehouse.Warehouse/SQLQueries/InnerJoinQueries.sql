--Display orders with customer names.
select c.customer_name,o.order_id from orders o inner join customers c ON
o.customer_id= c.customer_id

--Display orders with employee names.
select o.order_id,e.employee_id,e.employee_name from orders o inner join employees e on o.employee_id=e.employee_id

--Display products with category names.
select  p.product_name,c.category_name from products p inner join categories c on c.category_id=p.category_id

--Display order items with product names.

select oi.order_item_id, oi.order_id,oi.product_id, p.product_name from order_items oi inner join products p 
on oi.product_id=p.product_id

--Display payments with customer names.
select p.payment_id,c.customer_name,p.payment_status from orders o 
inner join payments p on p.order_id=o.order_id
inner join customers c ON o.customer_id=c.customer_id 

--Display returns with product names.
select r.return_id,r.product_id,p.product_name,r.return_reason from returns r inner join products p 
on r.product_id=p.product_id

--Display support tickets with customer names.
select t.ticket_id, t.customer_id,c.customer_name from customers c inner join customer_support_tickets t
on c.customer_id=t.customer_id

--Display each order with customer name and payment status.
select o.order_id,o.customer_id, c.customer_name, p.payment_status from orders o 
inner join customers c on c.customer_id=o.customer_id
inner join payments p on p.order_id=o.order_id 

--Display order ID, customer, product, quantity, and unit price.
select o.order_id,o.product_id,o.quantity,o.unit_price, p.product_name,sq.customer_name,sq.customer_id from order_items o 
inner join products p on o.product_id= p.product_id
inner join (select o.order_id, o.customer_id , c.customer_name from orders o inner join customers c
on c.customer_id=o.customer_id) sq on sq.order_id= o.order_id


SELECT oi.order_id, c.customer_name, p.product_name, oi.quantity, oi.unit_price FROM 
order_items AS oi 
INNER JOIN orders AS o ON oi.order_id = o.order_id 
INNER JOIN customers AS c ON o.customer_id = c.customer_id 
INNER JOIN products AS p ON oi.product_id = p.product_id;

--Calculate total item value for each order.
select o.order_id, o.total_cost-orders.discount_amount+orders.shipping_cost from orders inner JOIN
(select order_id, SUM(quantity* unit_price) as total_cost from order_items group by order_id) o
on o.order_id=orders.order_id

--Calculate total sales by customer.
select c.customer_id, c.customer_name,sum(oi.total_cost) as total_sales from orders o 
inner join customers c on c.customer_id=o.customer_id
inner join 
(select order_id, SUM(quantity* unit_price) as total_cost from order_items group by order_id) oi on 
oi.order_id=o.order_id
group by c.customer_name, c.customer_id

--Calculate total sales by country.
select o.shipping_country, sum((oi.quantity*oi.unit_price)) as total_sales from orders o 
inner join order_items oi on oi.order_id=o.order_id group by o.shipping_country

--Calculate total quantity sold by product.
select p.product_id,p.product_name , sum(oi.quantity) as total_quantity_sold from order_items oi inner join products p 
ON p.product_id=oi.product_id group by p.product_id,p.product_name

--Calculate total sales by category.
select sum(oi.quantity*oi.unit_price) as total_cost, c.category_name,c.category_id from products p 
inner join order_items oi on p.product_id=oi.product_id 
inner join categories c on c.category_id=p.category_id
group by c.category_name,c.category_id


--Find the best-selling product by quantity.
select top 1  p.product_id, p.product_name,sum(oi.quantity) as Quantity_sold from order_items oi inner join products p on 
p.product_id =oi.product_id  group by p.product_id,p.product_name order by  Quantity_sold desc

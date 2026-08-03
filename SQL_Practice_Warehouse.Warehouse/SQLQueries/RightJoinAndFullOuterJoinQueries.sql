--Display all products and all matching order items using RIGHT JOIN.
select p.product_id,oi.order_item_id, oi.order_id ,p.product_name from order_items oi right join products p
on p.product_id=oi.product_id

--Use FULL OUTER JOIN to compare customers with orders.
select c.customer_id,c.customer_name,o.order_id from customers c full outer join orders o on c.customer_id=o.customer_id


--Find records that exist only on the customer side.
select c.customer_id,c.customer_name,o.order_id from customers c full outer join orders o on c.customer_id=o.customer_id where 
o.order_id is NULL

--Find records that exist only on the order side.
select c.customer_id,c.customer_name,o.order_id from customers c full outer join orders o on c.customer_id=o.customer_id where 
c.customer_id is NULL


--Use FULL OUTER JOIN to compare products and returns.
select p.product_id, p.product_name, r.return_id,r.return_reason from products p 
full outer join returns r on p.product_id=r.product_id



Explain why a FULL OUTER JOIN is useful for data reconciliation.
"A FULL OUTER JOIN allows us to compare two datasets by returning matched records as well as unmatched records from both sides.
It helps identify missing records, duplicate loads, synchronization issues, and data quality problems between source systems
and target systems during ETL validation."

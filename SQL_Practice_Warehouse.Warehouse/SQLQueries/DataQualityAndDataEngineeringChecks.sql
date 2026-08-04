--Find duplicate customer emails.
select email, count(*) as duplicate_count from customers group by email having count(*) >1

--Find duplicate product names.
select product_name, count(*) as duplicate_count from products group by product_name having count(*) >1

--Find orders with a NULL customer ID.
select order_id from orders where customer_id is NULL

--Find order items with invalid product IDs.
select oi.order_id,oi.product_id from order_items oi left join products p 
on oi.product_id=p.product_id
where oi.product_id is NULL

--Find order items with invalid order IDs.
SELECT
    oi.order_id,
    oi.product_id
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

--Find orders with invalid employee IDs.
SELECT
    o.order_id,
    o.employee_id
FROM orders o
LEFT JOIN employees e
    ON o.employee_id = e.employee_id
WHERE e.employee_id IS NULL;

--Find negative prices.
select product_id,product_name,cost_price from products where unit_price <0 or cost_price <0

--Find products where cost price is greater than selling price.
select product_id, product_name from products where cost_price>unit_price

--Find negative stock quantities.
select product_id,product_name from products where stock_quantity <0

--Find orders with future dates.
select order_id,customer_id from orders where order_date> CURRENT_TIMESTAMP

--Find payments before their order date.
select p.payment_id, o.order_id from payments p left join orders o on p.order_id= o.order_id 
where o.order_date>p.payment_date

--Find returns before their order date.
select r.return_id, o.order_id from returns r left join orders o on r.order_id=o.order_id 
where r.return_date<o.order_date

--Find support tickets resolved before they were created.
select ticket_id from customer_support_tickets where created_date >resolved_date

--Find completed orders with no order items.
select o.order_id from orders o left join order_items oi on o.order_id=oi.order_id 
where oi.order_item_id is NULL and o.order_status='Completed'

--Find orders with zero total value.
select o.order_id, (sum(oi.quantity*oi.unit_price)+ o.shipping_cost-o.discount_amount) as total_value  from
orders o inner join order_items oi on o.order_id=oi.order_id group by o.order_id,o.shipping_cost,o.discount_amount
having (sum(oi.quantity*oi.unit_price)+ o.shipping_cost-o.discount_amount)=0

--Find payments with negative amounts.
select payment_id,order_id from payments where amount <0

--Find customers with missing country values.
select customer_id, customer_name from customers where country is NULL

--Find products with missing category IDs.
select product_id, product_name from products where category_id is NULL

--Find orders where payment amount differs from expected total.
WITH order_totals AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS expected_total
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.shipping_cost,
        o.discount_amount
),

payment_totals AS (
    SELECT
        order_id,
        SUM(amount) AS paid_total
    FROM payments
    GROUP BY order_id
)

SELECT
    ot.order_id,
    ot.expected_total,
    pt.paid_total
FROM order_totals ot
LEFT JOIN payment_totals pt
    ON ot.order_id = pt.order_id
WHERE COALESCE(pt.paid_total, 0) <> ot.expected_total;

--Create a data-quality report using UNION ALL.
--Every SELECT in a UNION ALL must return the same number of columns, in the same order, with compatible data types

SELECT
    'Duplicate Customer Emails' AS check_name,
    COUNT(*) AS failed_record_count
FROM (
    SELECT email
    FROM customers
    WHERE email IS NOT NULL
    GROUP BY email
    HAVING COUNT(*) > 1
) duplicates

UNION ALL

SELECT
    'Missing Customer ID' AS check_name,
    COUNT(*) AS failed_record_count
FROM orders
WHERE customer_id IS NULL

UNION ALL

SELECT
    'Negative Product Prices' AS check_name,
    COUNT(*) AS failed_record_count
FROM products
WHERE unit_price < 0
OR cost_price < 0;

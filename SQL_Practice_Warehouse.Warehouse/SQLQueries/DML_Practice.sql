--Insert a new customer.
INSERT INTO customers
(
    customer_id,
    customer_name,
    email,
    country,
    city,
    signup_date,
    customer_segment,
    referral_customer_id
)
VALUES
(13, 'Sandya duggana', 'sandya@example.com', 'India', 'Kakinada', '2020-01-10', 'Premium', NULL)

--Insert a new product.
INSERT INTO products
(
    product_id,
    product_name,
    category_id,
    unit_price,
    cost_price,
    stock_quantity,
    supplier_name,
    is_active
)
VALUES
(14, 'Laptop Cover', 1, 120.00, 85.00, 100, 'TechSource', 'Yes')

--Update a customer’s city.
update customers set city='Eberswalde' where customer_id= 1

--Update a product’s stock quantity.
update products set stock_quantity=200 where product_id=1

--Increase all product prices by 5%.
UPDATE products
SET cost_price = cost_price * 1.05;


--Set missing discounts to zero.
update orders set discount_amount=0 where discount_amount is NULL

--Update all inactive products to have zero stock.
update products set stock_quantity=0 where is_active = 'No'

--Delete a test customer.
DELETE FROM customers
WHERE customer_id = 999;

--Delete cancelled orders created before a chosen date.
DELETE FROM orders
WHERE status = 'Cancelled'
  AND order_date < '2026-01-01';

--Delete products that were never sold.
DELETE FROM products
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = products.product_id
);

--Insert data into a summary table using INSERT INTO ... SELECT.
CREATE TABLE customer_sales_summary (
    customer_id INT,
    total_orders INT,
 
 
);

INSERT INTO customer_sales_summary
    (customer_id, total_orders)
SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id;

--Create a table containing completed orders.

CREATE TABLE completed_orders
AS
SELECT *
FROM orders
WHERE order_status = 'Completed';


--Create a customer-sales summary table.

create table customer_sales  as 
select customer_id,order_id from orders


--Use a transaction for multiple related changes.

BEGIN TRANSACTION;

UPDATE customers
SET city = 'Berlin'
WHERE customer_id = 1;

UPDATE customers
SET customer_segment = 'High'
WHERE customer_id = 1;

COMMIT TRANSACTION;

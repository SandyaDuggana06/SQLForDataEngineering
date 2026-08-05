--Combine German and Indian customers using UNION.
select customer_id,customer_name, country from customers where country='India'
union
select customer_id,customer_name, country from customers where country='Germany'

--Combine German and Indian customers using UNION ALL.
select customer_id,customer_name, country from customers where country='India'
union all
select customer_id,customer_name, country from customers where country='Germany'


--Combine active and inactive products.
select product_id, product_name, is_active from products where is_active='Yes'
union
select product_id, product_name, is_active from products where is_active='No'


--Combine customer names and employee names into one list.
select customer_id, customer_name from customers
union
select employee_id,employee_name from employees


--Create a combined activity list containing orders and support tickets.

SELECT
    customer_id,
    order_id AS activity_id,
    'Order' AS activity_type,
    order_date AS activity_date
FROM orders

UNION ALL

SELECT
    customer_id,
    ticket_id AS activity_id,
    'Support Ticket' AS activity_type,
    created_date AS activity_date
FROM customer_support_tickets

ORDER BY
    activity_date;

--Demonstrate the difference between UNION and UNION ALL.
SELECT country
FROM customers

UNION ALL

SELECT shipping_country
FROM orders;

SELECT country
FROM customers

UNION 

SELECT shipping_country
FROM orders;

--Find duplicate rows created by UNION ALL.
select customer_id from customers
union all
select employee_id from employees

--Combine completed and pending orders.
SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM orders
WHERE order_status = 'Completed'

UNION ALL

SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM orders
WHERE order_status = 'Pending';

--Combine payment and refund transactions into one transaction list.

SELECT
    payment_id AS transaction_id,
    order_id,
    amount AS transaction_amount,
    payment_date AS transaction_date,
    'Payment' AS transaction_type
FROM payments

UNION ALL

SELECT
    return_id AS transaction_id,
    order_id,
    refund_amount AS transaction_amount,
    return_date AS transaction_date,
    'Refund' AS transaction_type
FROM returns

ORDER BY transaction_date;

    --Explain why UNION ALL is often preferred in data engineering pipelines.
    -/*UNION ALL is often preferred in data engineering pipelines because it combines datasets without removing duplicates.

The key difference is:

UNION      → combines rows and removes duplicate rows
UNION ALL  → combines rows and keeps all rows

Why UNION ALL is preferred
1. It is usually faster

UNION must check the combined results for duplicate rows and remove them. That extra work can require sorting, hashing, memory, and compute resources.

UNION ALL simply appends one result set to another.

Conceptually:

UNION ALL:

Dataset A
    +
Dataset B
    ↓
Combined dataset

Whereas:

UNION:

Dataset A
    +
Dataset B
    ↓
Check for duplicates
    ↓
Remove duplicates
    ↓
Combined dataset

Because UNION ALL skips duplicate elimination, it is generally more efficient, especially with large datasets. */

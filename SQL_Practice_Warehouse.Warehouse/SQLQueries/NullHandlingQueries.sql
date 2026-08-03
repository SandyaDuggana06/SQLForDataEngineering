--Find customers with no email.
select * from customers where email is NULL

--Find customers with a referral customer.
select * from customers where referral_customer_id is NOT NULL

--Replace missing customer emails with Not Provided.
select customer_name, COALESCE(email,'Not Provided') from customers

--Replace missing discounts with zero.
select order_id, COALESCE(discount_amount,0) from orders

--Replace missing payment dates with a readable value.
SELECT payment_id,COALESCE(CONVERT(VARCHAR(10), payment_date, 23),'Payment Pending') AS payment_dat FROM payments;
select * from payments

--Show shipping discount using COALESCE.
select order_id,COALESCE(discount_amount,0) as discount_amount from orders

--Find orders where the discount is missing.
SELECT order_id, discount_amount FROM orders WHERE discount_amount IS NULL;

--Calculate net order value while treating NULL discounts as zero.
select o.order_id,(SUM(oi.quantity*oi.unit_price)+o.shipping_cost-COALESCE(o.discount_amount,0)) as order_value from orders o 
inner join order_items oi on oi.order_id=o.order_id group by o.order_id,o.shipping_cost,o.discount_amount

--Display customer name and referral customer ID, replacing NULL with zero.
select customer_name, COALESCE(referral_customer_id,0) from customers

--Explain why column = NULL is incorrect.
-- column = NULL is incorrect because NULL represents an unknown or missing value.
-- SQL cannot determine whether an unknown value equals another unknown value.
-- Use IS NULL to find missing values and IS NOT NULL to find existing values.

--Compare COUNT(*) and COUNT(email).
select count(*) from customers 
ans 24
select count(email) from customers 
ans 23

--Find the number of missing emails.
select count(email) as count from customers where email is NULL

--Find the percentage of customers with missing emails.
SELECT
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN email is NULL THEN 1 END) AS customers_with_missing_email,
    CAST(
        COUNT(CASE WHEN email is NULL  THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS missing_email_percentage
FROM customers;


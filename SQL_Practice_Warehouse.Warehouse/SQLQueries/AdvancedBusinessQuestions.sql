--Find the top five customers by total completed sales.
WITH order_totals AS
(
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        o.order_id,
        o.customer_id,
        o.shipping_cost,
        o.discount_amount
),

customer_spending AS
(
    SELECT
        customer_id,
        SUM(order_total) AS total_spending
    FROM order_totals
    GROUP BY customer_id
)

SELECT TOP 5
    customer_id,
    total_spending
FROM customer_spending
ORDER BY total_spending DESC;

--Find the top three products by revenue.
WITH order_totals AS
(
    SELECT
        o.order_id,
        oi.product_id,
        SUM(oi.quantity * oi.unit_price)
            AS order_total
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        o.order_id,
        oi.product_id
)

select top 3 product_id,sum(order_total) as total_revenue from order_totals group by product_id order by sum(order_total) desc

--Find the top product by quantity in each category.
with rownumber as
(
select product_id, product_name,stock_quantity,category_id,
 dense_rank() over (partition by category_id order by stock_quantity desc) as stock_rank from products
)
select * from stock_rank where rn =1


--Calculate gross profit for every product.
with grossprofit as
(
select oi.order_id, p.product_id ,p.product_name, (oi.quantity* (oi.unit_price-p.cost_price))  as gross_profit from order_items oi
inner join 
products p on p.product_id=oi.product_id 
 INNER JOIN orders o
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed' 
)
select sum(gross_profit) as profit, product_id, product_name from grossprofit group by product_id, product_name

--Calculate gross profit by category.
with grossprofit as
(
select oi.order_id, p.product_id ,p.product_name,p.category_id, (oi.quantity* (oi.unit_price-p.cost_price))  as gross_profit from order_items oi
inner join 
products p on p.product_id=oi.product_id 
 INNER JOIN orders o
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed' 
)

select category_id, sum(gross_profit) as profit from grossprofit group by category_id

--Calculate gross profit by country.
with grossprofit as
(
select oi.order_id, p.product_id ,p.product_name,o.shipping_country, (oi.quantity* (oi.unit_price-p.cost_price))  as gross_profit from order_items oi
inner join 
products p on p.product_id=oi.product_id 
 INNER JOIN orders o
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed' 
)

select shipping_country, sum(gross_profit) as profit from grossprofit group by shipping_country

--Calculate average order value.
with order_value as
(
SELECT
   o.order_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
    o.order_id,
        o.shipping_cost,
        o.discount_amount

)

select avg(order_total) as average_order_value from order_value

--Calculate average order value by country.
with order_value as
(
SELECT
   o.order_id,o.shipping_country,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
    o.order_id,
        o.shipping_cost,
        o.discount_amount,
    o.shipping_country

)

select avg(order_total) as average_order_value ,shipping_country from order_value group by shipping_country

--Find customer lifetime value.
WITH order_totals AS
(
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        o.order_id,
        o.customer_id,
        o.shipping_cost,
        o.discount_amount
)
   SELECT
        customer_id,
        SUM(order_total) AS total_spending
    FROM order_totals
    GROUP BY customer_id

--Calculate repeat-customer rate and percentage
with order_count as
(
select count(order_id) as NumOfOrders,customer_id from orders group by customer_id 
),
customerswithmorethanoneorder as
(
select customer_id,NumOfOrders  from order_count where NumOfOrders>1
),
count_repeat_customers as
(
select count(customer_id) as repeat_customers from customerswithmorethanoneorder
),

count_total_customers AS
(
    SELECT
        COUNT(customer_id) AS total_customers
    FROM order_count
)

SELECT
    repeat_customers,
    total_customers,
    CAST(repeat_customers AS DECIMAL(10,2))
        / total_customers * 100 AS repeat_customer_rate
FROM count_repeat_customers
CROSS JOIN count_total_customers;

--Find the product with the highest return amount.
select top 1 product_id, sum(refund_amount) as total_refund_amount from returns group by product_id order by total_refund_amount desc

--Find customers who returned more than one product.
WITH productcount AS
(
    SELECT
        o.customer_id,
        r.product_id,
        COUNT(*) AS return_count
    FROM orders o
    INNER JOIN returns r
        ON r.order_id = o.order_id
    GROUP BY
        o.customer_id,
        r.product_id
)

SELECT
    customer_id,
    product_id,
    return_count
FROM productcount
WHERE return_count > 1;

--Find orders where payment amount does not match calculated order value.
WITH order_totals AS
(
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS order_total
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        o.order_id,
        o.shipping_cost,
        o.discount_amount
)

select p.payment_id,ot.order_id,ot.order_total,
   CASE
        WHEN p.amount = ot.order_total THEN 'Amount Correct'
        WHEN p.amount > ot.order_total THEN 'Overpaid'
        WHEN p.amount < ot.order_total THEN 'Underpaid'
    END AS payment_check
 from payments p inner join order_totals ot on
ot.order_id=p.order_id

--Find cancelled orders that still have a paid payment.
select o.order_id, o.order_status,p.payment_id,p.payment_status,p.amount from orders o inner join payments p on
o.order_id=p.order_id where o.order_status='Cancelled' and p.payment_status='Paid'

--Calculate product return rate.
WITH sold AS
(
    SELECT
        oi.product_id,
        COUNT(*) AS products_sold
    FROM order_items oi
    GROUP BY oi.product_id
),

returned AS
(
    SELECT
        r.product_id,
        COUNT(*) AS products_returned
    FROM returns r
    GROUP BY r.product_id
)

SELECT
    s.product_id,
    s.products_sold,
    COALESCE(r.products_returned, 0) AS products_returned,
    COALESCE(r.products_returned, 0) * 100.0
        / NULLIF(s.products_sold, 0) AS return_rate
FROM sold s
LEFT JOIN returned r
    ON s.product_id = r.product_id;

--Find returned orders without a return record.

select o.order_id,o.customer_id from orders o where  o.order_status='Returned' and not exists
(select 1 from returns r where r.order_id=o.order_id)

--Find completed orders without a paid payment.

select o.order_id from orders o where o.order_status ='Completed' and not exists
(select 1 from payments p where o.order_id= p.order_id and p.payment_status='Paid')

--Find customers who ordered in January and February.
select c.customer_id,c.customer_name  from orders o
inner join customers c on c.customer_id=o.customer_id where month(order_date) in (1,2)
group by c.customer_id,c.customer_name having count(distinct month(o.order_date))=2

--Find customers who ordered in February but not March.
select c.customer_id, c.customer_name from customers c  where 
exists 
(select 1 from orders o where c.customer_id=o.customer_id and month(o.order_date)=2)
and 
not exists
(select 1 from orders o where c.customer_id=o.customer_id and month(o.order_date)=3
)


--Find customers who ordered in every month.

SELECT
    customer_id,
    COUNT(DISTINCT FORMAT(order_date, 'yyyy-MM')) AS distinct_months
FROM orders
GROUP BY customer_id HAVING COUNT(DISTINCT FORMAT(order_date, 'yyyy-MM')) =
(select count(distinct(FORMAT(order_date, 'MMMM yyyy'))) from orders)


--Find products sold in more than one country.
SELECT
    oi.product_id,
    COUNT(DISTINCT o.shipping_country) AS number_of_countries
   -- STRING_AGG(DISTINCT o.shipping_country, ', ') AS countries
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    oi.product_id
HAVING COUNT(DISTINCT o.shipping_country) > 1

--Find customers who purchased both books and electronics.
with categoryiddetails as
(
SELECT
        o.customer_id,
        c.category_name
    FROM order_items oi
    INNER JOIN orders o
        ON oi.order_id = o.order_id
    INNER JOIN products p
        ON p.product_id = oi.product_id
    INNER JOIN categories c
        ON c.category_id = p.category_id
)

SELECT
    customer_id
FROM categoryiddetails
WHERE category_name IN ('Books', 'Electronics')
GROUP BY customer_id
HAVING COUNT(DISTINCT category_name) = 2;


--Find customers who purchased a product but never opened a support ticket.
with customers_product_purchase as
(
select o.order_id, o.customer_id, oi.product_id from orders o
inner join order_items oi on o.order_id=oi.order_id
)
select customer_id from customers_product_purchase cpp where not exists 
(select cst.ticket_id from customer_support_tickets cst where cst.customer_id=cpp.customer_id)


--Find customers with both an order and a return.
select distinct o.customer_id,o.order_id from orders o where exists(select 1 from returns r where r.order_id=o.order_id)


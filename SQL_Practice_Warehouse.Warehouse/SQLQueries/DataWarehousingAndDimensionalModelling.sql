--Identify the fact table in this dataset.
/*
For our current source model, the best candidate for the sales, fact table is:

order_items

Why?

Because each row represents a product within an order, and it contains measurable business events:

quantity
unit price
product
order
sales value

We will create:

fact_sales

with a grain of one row per order + product line.

Source tables
customers
orders
order_items
products
categories
employees
payments
returns
customer_support_tickets
Dimensional model
                    dim_customer
                         │
                         │
                         ▼
dim_date ─────────► fact_sales(orders_items) ◄───────── dim_product
                         │
                         │
                         ▼
                    dim_employee

Depending on your reporting requirements, you could also create dimensions for:

dim_category
dim_payment
dim_supplier
dim_customer_segment
dim_return_reason

But for this exercise, we'll focus on the four requested dimensions.
*/

--Identify all possible dimension tables.

/* Source table	Dimensional role
customers	dim_customer
products	dim_product
employees	dim_employee
Date values from orders	dim_date
categories	Could become dim_category
suppliers	Could become dim_supplier
Payment attributes	Could become dim_payment

The important distinction is:

Fact = measurable business event

Dimension = descriptive context around the event

For example:

Sales = 250

is a fact.

Customer = Sandya
Country = Germany
Product = Laptop
Category = Electronics
Date = 2026-08-10

are dimensions describing that sale.

*/


--Define the grain of orders.
/*The grain of orders is:

One row represents one customer order/order header.

For example:

order_id | customer_id | order_date | status
------------------------------------------------
1001     | 101         | 2026-08-01 | Completed
1002     | 105         | 2026-08-02 | Completed

Each row represents an entire order.

An order can contain multiple products.

For example:

Order 1001
   ├── Laptop
   ├── Mouse
   └── Keyboard

Therefore, orders is order-level grain.
*/

--Define the grain of order_items.
/*
he grain of order_items is:

One row represents one product line within one order.

Example:

order_id | product_id | quantity | unit_price
-----------------------------------------------
1001     | 10         | 1        | 900
1001     | 25         | 2        | 25
1001     | 30         | 1        | 75

Order 1001 has three order-item rows.

Therefore:

orders       → one row per order

order_items  → one row per order-product combination

This distinction is extremely important in dimensional modeling.
*/

--Create a dim_customer table.

CREATE TABLE dbo.dim_customer
(
    customer_key INT,
    customer_id INT,
    customer_name VARCHAR(200),
    country VARCHAR(100),
    city VARCHAR(100),
    email VARCHAR(200),
    customer_segment VARCHAR(50)
);


INSERT INTO dbo.dim_customer
(
    customer_key,
    customer_id,
    customer_name,
    country,
    city,
    email,
    customer_segment
)
SELECT
    customer_id,
    customer_id,
    customer_name,
    country,
    city,
    email,
    customer_segment
FROM dbo.customers;


--Create a dim_product table.

CREATE TABLE dbo.dim_product
(
    product_key INT,
    product_id INT,
    product_name VARCHAR(200),
    category_id INT,
    cost_price DECIMAL(18,2),
    unit_price DECIMAL(18,2)
);
INSERT INTO dbo.dim_product
(
    product_key,
    product_id,
    product_name,
    category_id,
    cost_price,
    unit_price
)
SELECT
    product_id,
    product_id,
    product_name,
    category_id,
    cost_price,
    unit_price
FROM dbo.products;

--Create a dim_employee table.

CREATE TABLE dbo.dim_employee
(
    employee_key INT,
    employee_id INT,
    employee_name VARCHAR(200),
    department VARCHAR(100),
    job_title VARCHAR(100),
    salary DECIMAL(18,2)
);

INSERT INTO dbo.dim_employee
(
    employee_key,
    employee_id,
    employee_name,
    department,
    job_title,
    salary
)
SELECT
    employee_id,
    employee_id,
    employee_name,
    department,
    job_title,
    salary
FROM dbo.employees;

--Create a dim_date table.
CREATE TABLE dbo.dim_date
(
    date_key INT,
    full_date DATE,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(20),
    day INT,
    day_of_week INT,
    day_name VARCHAR(20)
);

INSERT INTO dbo.dim_date
(
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_of_week,
    day_name
)
SELECT DISTINCT
    CONVERT(INT, FORMAT(order_date, 'yyyyMMdd')) AS date_key,
    CAST(order_date AS DATE) AS full_date,
    YEAR(order_date) AS year,
    DATEPART(QUARTER, order_date) AS quarter,
    MONTH(order_date) AS month,
    DATENAME(MONTH, order_date) AS month_name,
    DAY(order_date) AS day,
    DATEPART(WEEKDAY, order_date) AS day_of_week,
    DATENAME(WEEKDAY, order_date) AS day_name
FROM dbo.orders;


--Create a fact_sales table.
CREATE TABLE dbo.fact_sales
(
    sales_key INT,
    order_id INT,
    customer_key INT,
    product_key INT,
    employee_key INT,
    date_key INT,

    quantity INT,
    unit_price DECIMAL(18,2),
    sales_amount DECIMAL(18,2),
    cost_amount DECIMAL(18,2),
    profit_amount DECIMAL(18,2)
);

--Load fact_sales from orders and order items.

INSERT INTO dbo.fact_sales
(
    sales_key,
    order_id,
    customer_key,
    product_key,
    employee_key,
    date_key,
    quantity,
    unit_price,
    sales_amount,
    cost_amount,
    profit_amount
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY o.order_id, oi.product_id
    ) AS sales_key,

    o.order_id,

    c.customer_key,

    p.product_key,

    e.employee_key,

    d.date_key,

    oi.quantity,

    oi.unit_price,

    oi.quantity * oi.unit_price AS sales_amount,

    oi.quantity * p.cost_price AS cost_amount,

    oi.quantity * (oi.unit_price - p.cost_price) AS profit_amount

FROM dbo.orders AS o

INNER JOIN dbo.order_items AS oi
    ON o.order_id = oi.order_id

INNER JOIN dbo.dim_customer AS c
    ON o.customer_id = c.customer_id

INNER JOIN dbo.dim_product AS p
    ON oi.product_id = p.product_id

LEFT JOIN dbo.dim_employee AS e
    ON o.employee_id = e.employee_id

INNER JOIN dbo.dim_date AS d
    ON CAST(o.order_date AS DATE) = d.full_date

WHERE o.order_status = 'Completed';


--Calculate sales using the fact table.
--total sales
SELECT
    SUM(sales_amount) AS total_sales
FROM dbo.fact_sales;

--total cost
SELECT
    SUM(cost_amount) AS total_cost
FROM dbo.fact_sales;

--total profit
SELECT
    SUM(profit_amount) AS total_profit
FROM dbo.fact_sales;

--total quantity
SELECT
    SUM(quantity) AS total_quantity_sold
FROM dbo.fact_sales;


--Calculate sales by customer dimension.
SELECT
    c.customer_id,
    c.customer_name,
    c.country,
    c.customer_segment,
    SUM(f.sales_amount) AS total_sales
FROM dbo.fact_sales AS f
INNER JOIN dbo.dim_customer AS c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_id,
    c.customer_name,
    c.country,
    c.customer_segment
ORDER BY
    total_sales DESC;

--Calculate sales by date dimension.
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS total_sales
FROM dbo.fact_sales AS f
INNER JOIN dbo.dim_date AS d
    ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;


--Calculate sales by product dimension.

SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    SUM(f.quantity) AS quantity_sold,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.profit_amount) AS total_profit
FROM dbo.fact_sales AS f
INNER JOIN dbo.dim_product AS p
    ON f.product_key = p.product_key
GROUP BY
    p.product_id,
    p.product_name,
    p.category_id
ORDER BY
    total_sales DESC;

--Explain why the order-item level is usually a better fact-table grain than the order header.

/*
Imagine:

orders
order_id | customer_id | order_date
------------------------------------
1001     | 101         | 2026-08-01

The customer purchased:

Laptop      €1,000
Mouse       €50
Keyboard    €100

If your fact table uses order-level grain, you get:

order_id | total_sales
----------------------
1001     | 1,150

You've lost the product-level detail.

You cannot easily answer:

How much did we sell from laptops?

or:

How many mice were sold?

With order-item grain:

order_id | product | quantity | sales
--------------------------------------
1001     | Laptop  | 1        | 1000
1001     | Mouse   | 1        | 50
1001     | Keyboard| 1        | 100

Now you can aggregate upward:

Product
Country
Customer
Category
Month
Year
Employee

without losing the underlying detail.

Therefore:

The order-item level is usually a better fact-table grain because it preserves the lowest useful transactional detail and allows flexible aggregation across products, customers, categories, dates, and other dimensions.

*/

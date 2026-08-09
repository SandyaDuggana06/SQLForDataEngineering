--Create a view containing customer order details.
CREATE OR ALTER VIEW dbo.vw_customer_order_details
AS
SELECT
    c.customer_id,
    c.customer_name,
    c.country,
    c.city,
    c.customer_segment,
    o.order_id,
    o.order_date,
    o.order_status,
    o.shipping_cost,
    o.discount_amount
FROM dbo.customers AS c
INNER JOIN dbo.orders AS o
    ON c.customer_id = o.customer_id;
GO

SELECT TOP 10 *
FROM dbo.vw_customer_order_details;


--Create a view containing order totals.
CREATE OR ALTER VIEW dbo.vw_order_totals
AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    SUM(oi.quantity * oi.unit_price) AS gross_order_value,
    COALESCE(o.discount_amount, 0) AS discount,
    SUM(oi.quantity * oi.unit_price)
        - COALESCE(o.discount_amount, 0) AS net_order_value
FROM dbo.orders AS o
INNER JOIN dbo.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    o.discount_amount;
GO

SELECT TOP 10 *
FROM dbo.vw_order_totals
ORDER BY net_order_value DESC;


--Create a view containing monthly sales.
CREATE OR ALTER VIEW dbo.vw_monthly_sales
AS
SELECT
    DATEFROMPARTS(
        YEAR(o.order_date),
        MONTH(o.order_date),
        1
    ) AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    SUM(oi.quantity) AS total_quantity
FROM dbo.orders AS o
INNER JOIN dbo.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date);
GO

SELECT *
FROM dbo.vw_monthly_sales
ORDER BY sales_month;

--Create a view containing customer lifetime value.
CREATE OR ALTER VIEW dbo.vw_customer_lifetime_value
AS
SELECT
    c.customer_id,
    c.customer_name,
    c.country,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS lifetime_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS latest_order_date
FROM dbo.customers AS c
INNER JOIN dbo.orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN dbo.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name,
    c.country;
GO

SELECT *
FROM dbo.vw_customer_lifetime_value
ORDER BY lifetime_value DESC;


--Create a view containing product profitability.
CREATE OR ALTER VIEW dbo.vw_product_profitability
AS
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.cost_price,
    p.unit_price,
    SUM(oi.quantity) AS quantity_sold,

    (p.unit_price - p.cost_price) AS profit_per_unit,

    SUM(
        oi.quantity * (p.unit_price - p.cost_price)
    ) AS total_profit

FROM dbo.products AS p

INNER JOIN dbo.order_items AS oi
    ON p.product_id = oi.product_id

INNER JOIN dbo.orders AS o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'Completed'

GROUP BY
    p.product_id,
    p.product_name,
    p.category_id,
    p.cost_price,
    p.unit_price;
GO

SELECT *
FROM dbo.vw_product_profitability
ORDER BY total_profit DESC;

--Create a view containing open support tickets.
CREATE OR ALTER VIEW dbo.vw_open_support_tickets
AS
SELECT
    t.ticket_id,
    t.customer_id,
    c.customer_name,
    t.priority,
    t.ticket_status,
    t.created_date
FROM dbo.customer_support_tickets AS t
INNER JOIN dbo.customers AS c
    ON t.customer_id = c.customer_id
WHERE t.ticket_status = 'Open';
GO

SELECT *
FROM dbo.vw_open_support_tickets
ORDER BY priority, created_date;

--Create a view containing data-quality failures.
CREATE OR ALTER VIEW dbo.vw_data_quality_failures
AS

SELECT
    'NULL_CUSTOMER_ID' AS failure_type,
    CAST(order_id AS VARCHAR(50)) AS record_id,
    'Order has NULL customer ID' AS failure_description
FROM dbo.orders
WHERE customer_id IS NULL

UNION ALL

SELECT
    'INVALID_PRODUCT_ID',
    CAST(oi.order_id AS VARCHAR(50)),
    'Order item references a product that does not exist'
FROM dbo.order_items AS oi
LEFT JOIN dbo.products AS p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT
    'NEGATIVE_PRICE',
    CAST(product_id AS VARCHAR(50)),
    'Product has a negative selling price'
FROM dbo.products
WHERE unit_price < 0

UNION ALL

SELECT
    'COST_GREATER_THAN_PRICE',
    CAST(product_id AS VARCHAR(50)),
    'Product cost price is greater than selling price'
FROM dbo.products
WHERE cost_price > unit_price

UNION ALL

SELECT
    'NEGATIVE_STOCK',
    CAST(product_id AS VARCHAR(50)),
    'Product has negative stock'
FROM dbo.products
WHERE stock_quantity < 0

UNION ALL

SELECT
    'NEGATIVE_PAYMENT',
    CAST(payment_id AS VARCHAR(50)),
    'Payment has a negative amount'
FROM dbo.payments
WHERE amount < 0;
GO

SELECT *
FROM dbo.vw_data_quality_failures;


--Create a view containing product sales rankings.

CREATE OR ALTER VIEW dbo.vw_product_sales_rankings
AS
WITH product_sales AS
(
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity * oi.unit_price) AS total_sales,
        SUM(oi.quantity) AS quantity_sold
    FROM dbo.products AS p
    INNER JOIN dbo.order_items AS oi
        ON p.product_id = oi.product_id
    INNER JOIN dbo.orders AS o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        p.product_id,
        p.product_name,
        p.category_id
)
SELECT
    product_id,
    product_name,
    category_id,
    quantity_sold,
    total_sales,

    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank

FROM product_sales;
GO

SELECT *
FROM dbo.vw_product_sales_rankings
ORDER BY sales_rank;

--Create a view containing customer return statistics.

CREATE OR ALTER VIEW dbo.vw_customer_return_statistics
AS
WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM dbo.orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),

customer_returns AS
(
    SELECT
        o.customer_id,
        COUNT(r.product_id) AS total_returns,
        SUM(r.refund_amount) AS total_refund_amount
    FROM dbo.orders AS o
    INNER JOIN dbo.returns AS r
        ON o.order_id = r.order_id
    GROUP BY
        o.customer_id
)

SELECT
    c.customer_id,
    c.customer_name,

    COALESCE(co.total_orders, 0) AS total_orders,

    COALESCE(cr.total_returns, 0) AS total_returns,

    COALESCE(cr.total_refund_amount, 0) AS total_refund_amount,

    CASE
        WHEN COALESCE(co.total_orders, 0) = 0
            THEN 0
        ELSE
            CAST(COALESCE(cr.total_returns, 0) AS DECIMAL(18,2))
            / co.total_orders * 100
    END AS return_rate

FROM dbo.customers AS c

LEFT JOIN customer_orders AS co
    ON c.customer_id = co.customer_id

LEFT JOIN customer_returns AS cr
    ON c.customer_id = cr.customer_id;
GO

SELECT *
FROM dbo.vw_customer_return_statistics
ORDER BY return_rate DESC;

--Create a view for your Power BI semantic model.

CREATE OR ALTER VIEW dbo.vw_powerbi_sales
AS
SELECT
    o.order_id,
    o.order_date,

    c.customer_id,
    c.customer_name,
    c.country,
    c.city,
    c.customer_segment,

    p.product_id,
    p.product_name,
    p.category_id,

    oi.quantity,
    oi.unit_price,

    oi.quantity * oi.unit_price AS sales_amount,

    p.cost_price,
    oi.quantity * p.cost_price AS cost_amount,

    oi.quantity * (oi.unit_price - p.cost_price) AS profit_amount,

    o.order_status,
    o.shipping_cost,
    COALESCE(o.discount_amount, 0) AS discount

FROM dbo.orders AS o

INNER JOIN dbo.customers AS c
    ON o.customer_id = c.customer_id

INNER JOIN dbo.order_items AS oi
    ON o.order_id = oi.order_id

INNER JOIN dbo.products AS p
    ON oi.product_id = p.product_id;
GO

SELECT TOP 10 *
FROM dbo.vw_powerbi_sales;

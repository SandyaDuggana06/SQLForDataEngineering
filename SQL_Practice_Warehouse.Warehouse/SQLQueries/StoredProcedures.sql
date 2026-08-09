--Create a stored procedure that returns orders for a customer ID.

create procedure dbo.GetOrdersByCustomer
@customer_id INT
as 
begin
select
     o.order_id,
        o.order_date,
        c.customer_id,
        c.customer_name,
        o.order_status,
        o.shipping_cost,
        o.discount_amount
    FROM orders AS o
    INNER JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.customer_id = @customer_id
    ORDER BY o.order_date DESC;
END;

EXEC GetOrdersByCustomer @customer_id = 1;


--Create a procedure that returns orders between two dates.
create procedure dbo.OrderBetweenTwoDates
@start_date DATE,
@end_date DATE
as
begin
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        o.order_status,
        o.shipping_cost,
        o.discount_amount
    FROM dbo.orders AS o
    WHERE o.order_date >= @start_date
      AND o.order_date < DATEADD(DAY, 1, @end_date)
    ORDER BY o.order_date;

END;

EXEC dbo.OrderBetweenTwoDates
    @start_date = '2026-02-01',
    @end_date = '2026-02-28';

--Create a procedure that returns sales by country.
CREATE PROCEDURE dbo.GetSalesByCountry
AS
BEGIN

    SELECT
        c.country,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        c.country
    ORDER BY
        total_sales DESC;

END;
GO

EXEC dbo.GetSalesByCountry;

--Create a procedure that updates product stock.
CREATE PROCEDURE dbo.UpdateProductStock
    @product_id INT,
    @stock_change INT
AS
BEGIN

    UPDATE products
    SET stock_quantity = stock_quantity + @stock_change
    WHERE product_id = @product_id;

END;
GO

EXEC dbo.UpdateProductStock
    @product_id = 1,
    @stock_change = 20;



--Create a procedure that returns top N customers.
CREATE PROCEDURE dbo.GetTopCustomers
    @top_n INT
AS
BEGIN

    SELECT TOP (@top_n)
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM dbo.customers AS c
    INNER JOIN dbo.orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        c.customer_id,
        c.customer_name
    ORDER BY
        total_sales DESC;

END;
GO

EXEC dbo.GetTopCustomers
    @top_n = 5;


--Create a procedure that returns products below a stock threshold.
CREATE PROCEDURE dbo.GetProductsBelowStockThreshold
    @stock_threshold INT
AS
BEGIN

    SELECT
        p.product_id,
        p.product_name,
        p.stock_quantity,
        p.cost_price
    FROM dbo.products AS p
    WHERE p.stock_quantity < @stock_threshold
    ORDER BY p.stock_quantity ASC;

END;
GO

EXEC dbo.GetProductsBelowStockThreshold
    @stock_threshold = 20;

--Create a procedure that returns open support tickets by priority.

CREATE PROCEDURE dbo.GetOpenSupportTicketsByPriority
    @priority VARCHAR(20)
AS
BEGIN

    SELECT
        ticket_id,
        customer_id,
        priority,
        ticket_status,
        created_date,
        ticket_category
    FROM dbo.customer_support_tickets
    WHERE ticket_status = 'Open'
      AND priority = @priority
    ORDER BY created_date ASC;

END;
GO

EXEC dbo.GetOpenSupportTicketsByPriority
    @priority = 'Medium';


--Create a procedure that calculates monthly sales.
CREATE PROCEDURE dbo.GetMonthlySales
AS
BEGIN

    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM dbo.orders AS o
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
    ORDER BY
        sales_year,
        sales_month;

END;
GO

EXEC dbo.GetMonthlySales;


--Create a procedure that performs a data-quality check.

CREATE PROCEDURE dbo.RunDataQualityChecks
AS
BEGIN

    SELECT
        'Orders with NULL customer ID' AS check_name,
        COUNT(*) AS issue_count
    FROM dbo.orders
    WHERE customer_id IS NULL

    UNION ALL

    SELECT
        'Order items with invalid product ID' AS check_name,
        COUNT(*) AS issue_count
    FROM dbo.order_items AS oi
    LEFT JOIN dbo.products AS p
        ON oi.product_id = p.product_id
    WHERE p.product_id IS NULL

    UNION ALL

    SELECT
        'Products with negative price' AS check_name,
        COUNT(*) AS issue_count
    FROM dbo.products
    WHERE unit_price < 0

    UNION ALL

    SELECT
        'Products where cost exceeds selling price' AS check_name,
        COUNT(*) AS issue_count
    FROM dbo.products
    WHERE cost_price > unit_price

    UNION ALL

    SELECT
        'Products with negative stock' AS check_name,
        COUNT(*) AS issue_count
    FROM dbo.products
    WHERE stock_quantity < 0

    UNION ALL

    SELECT
        'Completed orders with no order items' AS check_name,
        COUNT(*) AS issue_count
    FROM dbo.orders AS o
    LEFT JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
      AND oi.order_id IS NULL

    UNION ALL

    SELECT
        'Payments with negative amount' AS check_name,
        COUNT(*) AS issue_count
    FROM dbo.payments
    WHERE amount < 0;

END;
GO

EXEC dbo.RunDataQualityChecks;

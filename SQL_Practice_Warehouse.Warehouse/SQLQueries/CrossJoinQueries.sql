--Generate every customer–product combination.
SELECT
    c.customer_id,
    c.customer_name,
    p.product_id,
    p.product_name
FROM customers AS c
CROSS JOIN products AS p
ORDER BY
    c.customer_name,
    p.product_name;

--Count the number of customer–product combinations.
select count(*) from customers  cross join products

--Generate every country–customer segment combination.
SELECT
    c.country,
    s.customer_segment
FROM
(
    SELECT DISTINCT country
    FROM customers
) AS c
CROSS JOIN
(
    SELECT DISTINCT customer_segment
    FROM customers
) AS s
ORDER BY
    c.country,
    s.customer_segment;


--Create every month–country combination using a month list.
WITH months AS
(
    SELECT *
    FROM (VALUES
        (1, 'January'),
        (2, 'February'),
        (3, 'March'),
        (4, 'April'),
        (5, 'May'),
        (6, 'June'),
        (7, 'July'),
        (8, 'August'),
        (9, 'September'),
        (10, 'October'),
        (11, 'November'),
        (12, 'December')
    ) AS m(month_number, month_name)
),

countries AS
(
    SELECT DISTINCT country
    FROM customers
)

SELECT
    m.month_number,
    m.month_name,
    c.country
FROM months AS m
CROSS JOIN countries AS c
ORDER BY
    m.month_number,
    c.country;

Explain why a CROSS JOIN can create performance problems.
A CROSS JOIN can cause performance problems because it creates a Cartesian product,
 combining every row from one table with every row from another. 
 The result size grows multiplicatively, so large tables can produce millions or billions of rows.
  This increases CPU, memory, storage, and query execution costs. 
  Therefore, CROSS JOIN should be used intentionally, preferably with filtered or small datasets.

  A CROSS JOIN can create performance problems because it generates every possible combination of rows from two tables.
This can cause:

High CPU usage
High memory usage
Large amounts of data to process
Longer query execution time
Increased Fabric capacity consumption
Large intermediate results that may slow down other operations

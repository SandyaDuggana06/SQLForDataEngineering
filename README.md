# Fabric SQL Mastery

A structured collection of SQL concepts, hands-on exercises, and practical business queries developed in **Microsoft Fabric**.

This repository documents my SQL learning journey through progressively challenging exercises, starting with fundamental data retrieval and filtering and moving toward joins, aggregations, subqueries, window functions, and real-world data analysis.

## 🎯 Project Goals

The goals of this project are to:

* Build a strong foundation in SQL for Data Engineering and Analytics
* Practice writing clean, readable, and efficient SQL queries
* Understand how SQL concepts are applied to real-world business scenarios
* Develop practical experience using SQL in Microsoft Fabric
* Create a structured SQL portfolio for continuous learning and interview preparation

## 🛠️ Technologies Used

* Microsoft Fabric
* Fabric Warehouse
* SQL
* Git
* GitHub

## 📊 Sample Dataset

The exercises use a fictional retail and e-commerce dataset containing the following tables:

| Table                      | Description                                                             |
| -------------------------- | ----------------------------------------------------------------------- |
| `customers`                | Customer information, location, contact details, and customer segments  |
| `orders`                   | Customer orders, order dates, statuses, shipping details, and discounts |
| `order_items`              | Products, quantities, and unit prices associated with each order        |
| `products`                 | Product information, prices, stock levels, suppliers, and categories    |
| `categories`               | Product category information                                            |
| `employees`                | Employee details, departments, job titles, and salaries                 |
| `payments`                 | Payment information and payment status                                  |
| `returns`                  | Product return details, return reasons, and refund amounts              |
| `customer_support_tickets` | Customer support requests, categories, and priorities                   |

## 📚 SQL Topics Covered

### 1. SQL Fundamentals

* `SELECT`
* Selecting specific columns
* Column aliases using `AS`
* `DISTINCT`
* `TOP`
* SQL comments

### 2. Filtering Data

* `WHERE`
* Comparison operators
* `AND`
* `OR`
* `IN`
* `BETWEEN`
* `LIKE`
* Date filtering
* `IS NULL`
* `IS NOT NULL`

### 3. Sorting and Limiting Results

* `ORDER BY`
* Ascending and descending sorting
* Sorting by multiple columns
* `TOP`

### 4. Aggregate Functions

* `COUNT()`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`

### 5. Grouping and Filtering Aggregated Data

* `GROUP BY`
* `HAVING`
* Aggregations by customer, product, category, country, department, and payment method

### 6. SQL Joins

* `INNER JOIN`
* `LEFT JOIN`
* `RIGHT JOIN`
* `FULL OUTER JOIN`
* `SELF JOIN`
* `CROSS JOIN`

### 7. NULL Handling

* `IS NULL`
* `IS NOT NULL`
* `COALESCE()`
* Understanding how `NULL` behaves in comparisons and joins

### 8. Set Operations

* `UNION`
* `UNION ALL`
* Understanding duplicate handling

### 9. Advanced SQL

Planned topics include:

* Subqueries
* Common Table Expressions (CTEs)
* `CASE WHEN`
* Window functions
* `ROW_NUMBER()`
* `RANK()`
* `DENSE_RANK()`
* Running totals
* Moving averages
* Data quality checks
* SQL-based data reconciliation

## 🧩 Example Queries

### Find customers who have never placed an order

```sql
SELECT
    c.customer_id,
    c.customer_name
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

### Find the best-selling product by quantity

```sql
SELECT TOP 1
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS quantity_sold
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY quantity_sold DESC;
```

### Display every customer and their number of orders

```sql
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS num_of_orders
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name;
```

### Reconcile customers and orders using FULL OUTER JOIN

```sql
SELECT
    COALESCE(c.customer_id, o.customer_id) AS customer_id,
    c.customer_name,
    o.order_id,
    CASE
        WHEN c.customer_id IS NOT NULL
             AND o.order_id IS NOT NULL
            THEN 'MATCH'

        WHEN c.customer_id IS NOT NULL
             AND o.order_id IS NULL
            THEN 'CUSTOMER WITHOUT ORDER'

        WHEN c.customer_id IS NULL
             AND o.order_id IS NOT NULL
            THEN 'ORDER WITHOUT CUSTOMER'
    END AS reconciliation_status
FROM customers AS c
FULL OUTER JOIN orders AS o
    ON c.customer_id = o.customer_id;
```

## 📁 Repository Structure

```text
fabric-sql-mastery/
│
├── README.md
│
├── dataset/
│   ├── create_tables.sql
│   └── insert_sample_data.sql
│
├── sql-basics/
│   ├── select.sql
│   ├── where.sql
│   ├── order_by.sql
│   └── null_handling.sql
│
├── aggregation/
│   ├── aggregate_functions.sql
│   ├── group_by.sql
│   └── having.sql
│
├── joins/
│   ├── inner_join.sql
│   ├── left_join.sql
│   ├── right_join.sql
│   ├── full_outer_join.sql
│   ├── self_join.sql
│   └── cross_join.sql
│
├── set-operations/
│   ├── union.sql
│   └── union_all.sql
│
├── advanced-sql/
│   ├── subqueries.sql
│   ├── ctes.sql
│   ├── case_when.sql
│   └── window_functions.sql
│
└── business-scenarios/
    ├── sales_analysis.sql
    ├── customer_analysis.sql
    ├── product_analysis.sql
    └── data_reconciliation.sql
```

## 🚀 How to Use This Repository

1. Create a Warehouse or SQL-enabled environment in Microsoft Fabric.
2. Run the table creation scripts in the `dataset` folder.
3. Load the sample data.
4. Open the SQL files by topic.
5. Attempt the exercises independently.
6. Review and compare the solutions.
7. Modify the queries and experiment with additional business questions.

## 💡 Key Learning Outcomes

Through this project, I am developing practical skills in:

* Querying and filtering relational data
* Combining data from multiple tables
* Performing business-focused aggregations
* Identifying missing records using outer joins
* Handling `NULL` values correctly
* Performing data reconciliation
* Writing readable and maintainable SQL
* Applying SQL concepts to Data Engineering and Analytics use cases

## 👩‍💻 Author

**Sandya Duggana**

Aspiring Data Engineer with experience in Python, SQL, Microsoft Fabric, data pipelines, and enterprise IAM/PAM support.

---

⭐ If you find this repository useful, feel free to explore the queries and follow the project as new SQL topics are added.

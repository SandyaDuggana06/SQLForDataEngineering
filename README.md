# Fabric SQL Mastery

A structured collection of 340 hands-on SQL problems, concepts, and practical business scenarios designed for Data Engineering and Data Analytics.

This repository provides a progressive SQL practice resource, starting with fundamental querying and filtering and moving through joins, aggregations, subqueries, CTEs, window functions, data quality checks, advanced business analysis, and dimensional modeling.

All exercises are practiced using Microsoft Fabric and organized in GitHub so that the repository can be used as a practical SQL reference and interview-preparation resource.

## 🎯 Project Goals

This repository is designed to help learners and aspiring Data Engineers:

Build a strong foundation in SQL
Develop advanced SQL problem-solving skills
Practice writing clean, readable, and maintainable SQL
Apply SQL concepts to realistic business scenarios
Understand relational data and table relationships
Practice SQL in a Microsoft Fabric environment
Develop data-quality and data-reconciliation skills
Understand SQL patterns commonly used in Data Engineering and Analytics
Prepare for SQL and Data Engineering interviews
Build a reusable SQL practice and reference resource

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

📚 SQL Topics Covered

The repository contains 340 exercises organized from fundamental SQL concepts to advanced Data Engineering scenarios.

1. SQL Fundamentals
   
SELECT
Selecting specific columns
Column aliases using AS
DISTINCT
TOP
SQL comments

2. WHERE Filtering

WHERE
Comparison operators
AND
OR
IN
BETWEEN
LIKE
Date filtering
IS NULL
IS NOT NULL

3. ORDER BY and TOP
   
ORDER BY
Ascending and descending sorting
Sorting by multiple columns
TOP
Finding top and bottom records

4. Aggregate Functions
COUNT()
SUM()
AVG()
MIN()
MAX()

5. GROUP BY and HAVING
GROUP BY
HAVING
Aggregations by:
Customer
Product
Category
Country
Department
Payment method
Supplier

6. SQL Joins
   
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL OUTER JOIN
SELF JOIN
CROSS JOIN

Practical scenarios include:

Finding unmatched records
Identifying customers without orders
Identifying products without sales
Reconciling customers and orders
Working with employee-manager relationships

7. NULL Handling
   
IS NULL
IS NOT NULL
COALESCE()
NULL-safe calculations
Missing-value analysis
Understanding NULL behavior in comparisons and joins
Comparing COUNT(*) and COUNT(column)

8. CASE Expressions
   
CASE WHEN
Business categorization
Customer segmentation
Product pricing classification
Stock status classification
Order value classification
Payment classification
Risk categorization

9. UNION and UNION ALL
    
UNION
UNION ALL
Duplicate handling
Combining datasets
Combining transaction types
Understanding when UNION ALL is preferable

10. String Functions

UPPER()
LOWER()
LEN()
LEFT()
LIKE
CHARINDEX()
CONCAT()
TRIM()
REPLACE()
String extraction and standardization

Practical scenarios include:

Extracting email domains
Standardizing customer names
Creating business labels
Searching product names
Creating employee identifiers

11. Date Functions
Extracting year and month
Date filtering
Date differences
Monthly analysis
Quarterly analysis
Customer signup analysis
Order-date analysis
Support-ticket resolution time

12. Subqueries

Practical subquery scenarios include:

Products above average price
Employees above average salary
Customers above average spending
Second-highest values
Highest-paid employees by department
Lowest-priced products by category
Customers with and without orders
EXISTS
NOT EXISTS

13. Common Table Expressions — CTEs
    
Single CTEs
Sequential CTEs
Multi-step transformations
Customer sales analysis
Product profitability
Monthly sales
Customer order counts
Data-quality analysis
Ranking using CTEs

CTEs are used to break complex SQL problems into smaller, readable transformation steps.

14. Window Functions
ROW_NUMBER()
RANK()
DENSE_RANK()
LAG()
LEAD()
NTILE()
PARTITION BY
Running totals
Cumulative calculations
Moving averages
Month-over-month analysis
Top-N analysis
Deduplication

Practical scenarios include:

Top employees by department
Top products by category
First and latest customer orders
Salary comparisons
Running sales totals
Rolling three-month averages
Customer spending segmentation

15. Advanced Business Analysis

The repository includes practical business questions such as:

Top customers by sales
Top products by revenue
Best-selling products
Gross profit
Gross profit by category
Gross profit by country
Average order value
Customer lifetime value
Repeat-customer rate
Product return rate
Customer return analysis
Payment reconciliation
Cancelled orders with successful payments
Completed orders without payments
Cross-category purchasing behavior

16. Data Quality and Data Engineering Checks

Practical data-quality scenarios include:

Duplicate customer emails
Duplicate product names
NULL customer IDs
Invalid product IDs
Invalid order IDs
Invalid employee IDs
Negative prices
Cost price greater than selling price
Negative stock
Future order dates
Payments before order dates
Returns before order dates
Invalid support-ticket dates
Orders without order items
Zero-value orders
Negative payment amounts
Missing country values
Missing category IDs
Payment reconciliation
Data-quality reporting using UNION ALL

17. DML Practice
    
INSERT
UPDATE
DELETE
INSERT INTO ... SELECT
Transactions

Practical scenarios include:

Inserting customers and products
Updating customer information
Updating stock
Updating product prices
Handling missing discounts
Removing test data
Deleting invalid or obsolete records
Loading summary tables
Performing multiple related changes using transactions

18. Views and Reusable SQL

The repository includes exercises for creating reusable SQL objects such as:

Customer order detail views
Order-total views
Monthly sales views
Customer lifetime value views
Product profitability views
Open support-ticket views
Data-quality views
Product ranking views
Customer return-statistics views
Power BI / semantic-model-ready views

19. Stored Procedures and Parameters

Practice scenarios include:

Procedures using customer IDs
Date-range procedures
Sales by country
Product stock updates
Customer-sales summary loading
Top-N customer analysis
Low-stock products
Open support tickets
Monthly sales
Data-quality checks

20. Data Warehousing and Dimensional Modeling

The repository also introduces SQL concepts used in analytical data warehouses.

Topics include:

Identifying fact tables
Identifying dimension tables
Defining table grain
dim_customer
dim_product
dim_employee
dim_date
fact_sales
Loading fact tables
Sales analysis using fact and dimension tables
Customer, product, and date dimensions
Understanding fact-table grain
Star-schema concepts
Dimensional modeling
🧩 Example Queries
Find customers who have never placed an order
SELECT
    c.customer_id,
    c.customer_name
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
Find the best-selling product by quantity
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
Display every customer and their number of orders
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
Reconcile customers and orders using FULL OUTER JOIN
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
2. Run the table creation scripts, create_tables.sql.
3. Load the sample data, insert_sample_data.sql.
4. Open the SQL files by topic.
5. Attempt the exercises independently.
6. Review and compare the solutions.
7. Modify the queries and experiment with additional business questions.

🎓 Suggested Learning Path

The exercises can be approached progressively:

SQL Fundamentals
       ↓
Filtering & Sorting
       ↓
Aggregations
       ↓
GROUP BY & HAVING
       ↓
Joins
       ↓
NULL Handling
       ↓
CASE Expressions
       ↓
UNION / UNION ALL
       ↓
String & Date Functions
       ↓
Subqueries
       ↓
CTEs
       ↓
Window Functions
       ↓
Advanced Business Analysis
       ↓
Data Quality & Reconciliation
       ↓
DML & Transactions
       ↓
Views & Stored Procedures
       ↓
Data Warehousing
       ↓
Dimensional Modeling

💡 Key Learning Outcomes

This repository provides hands-on practice in:

Querying relational data
Filtering and transforming data
Combining multiple tables
Performing business-focused aggregations
Handling NULL values
Identifying unmatched records
Performing data reconciliation
Writing complex SQL using CTEs and subqueries
Applying window functions to analytical problems
Performing data-quality checks
Building reusable SQL objects
Working with transactions
Understanding fact and dimension tables
Applying dimensional modeling concepts
Using SQL within Microsoft Fabric

📌 Who Is This Repository For?

This repository can be useful for:

Aspiring Data Engineers
Data Analysts
SQL learners
Students building SQL portfolios
Professionals preparing for SQL interviews
Microsoft Fabric learners
Anyone looking for hands-on SQL practice
🔄 Project Status
✅ Current Coverage

The repository currently contains 340 SQL exercises covering:

SQL fundamentals
Filtering and sorting
Aggregate functions
GROUP BY and HAVING
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL OUTER JOIN
SELF JOIN
CROSS JOIN
NULL handling
CASE expressions
UNION and UNION ALL
String functions
Date functions
Subqueries
CTEs
Window functions
Advanced business scenarios
Data-quality checks
DML and transactions
Views
Stored procedures
Data warehousing
Dimensional modeling

The repository will continue to evolve with additional Data Engineering, Microsoft Fabric, analytics, and real-world business scenarios.


## 👩‍💻 Author

**Sandya Duggana**

Aspiring Data Engineer with experience in Python, SQL, Microsoft Fabric, data pipelines, and enterprise IAM/PAM support.

⭐ Support the Repository

If you find this repository useful:

⭐ Star the repository
📖 Use the exercises for practice
💡 Create additional business scenarios
🔄 Share it with others learning SQL
💬 Feedback and suggestions are welcome

Repository:
https://github.com/SandyaDuggana06/SQLForDataEngineering

---

⭐ If you find this repository useful, feel free to explore the queries and follow the project as new SQL topics are added.

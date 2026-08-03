
CREATE TABLE customers
(
    customer_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    country VARCHAR(50),
    city VARCHAR(100),
    signup_date DATE,
    customer_segment VARCHAR(30),
    referral_customer_id INT
);


CREATE TABLE employees
(
    employee_id INT NOT NULL,
    employee_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    job_title VARCHAR(100),
    manager_id INT,
    hire_date DATE,
    salary DECIMAL(12,2)
);


CREATE TABLE categories
(
    category_id INT NOT NULL,
    category_name VARCHAR(100) NOT NULL
);


CREATE TABLE products
(
    product_id INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    category_id INT,
    unit_price DECIMAL(12,2),
    cost_price DECIMAL(12,2),
    stock_quantity INT,
    supplier_name VARCHAR(100),
    is_active VARCHAR(10)
);


CREATE TABLE orders
(
    order_id INT NOT NULL,
    customer_id INT,
    employee_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    shipping_country VARCHAR(50),
    shipping_cost DECIMAL(12,2),
    discount_amount DECIMAL(12,2)
);


CREATE TABLE order_items
(
    order_item_id INT NOT NULL,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(12,2)
);


CREATE TABLE payments
(
    payment_id INT NOT NULL,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    amount DECIMAL(12,2)
);


CREATE TABLE returns
(
    return_id INT NOT NULL,
    order_id INT,
    product_id INT,
    return_date DATE,
    return_reason VARCHAR(100),
    refund_amount DECIMAL(12,2)
);


CREATE TABLE customer_support_tickets
(
    ticket_id INT NOT NULL,
    customer_id INT,
    created_date DATE,
    resolved_date DATE,
    ticket_category VARCHAR(50),
    priority VARCHAR(20),
    ticket_status VARCHAR(30)
);


CREATE TABLE monthly_sales_targets
(
    target_month DATE,
    country VARCHAR(50),
    sales_target DECIMAL(14,2)
);




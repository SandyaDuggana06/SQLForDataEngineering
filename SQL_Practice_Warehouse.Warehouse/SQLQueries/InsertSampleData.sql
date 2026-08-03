INSERT INTO customers
(
    customer_id,
    customer_name,
    email,
    country,
    city,
    signup_date,
    customer_segment,
    referral_customer_id
)
VALUES
(1, 'Anna Schmidt', 'anna@example.com', 'Germany', 'Berlin', '2025-01-10', 'Premium', NULL),
(2, 'Ben Müller', 'ben@example.com', 'Germany', 'Hamburg', '2025-02-15', 'Standard', 1),
(3, 'Carla Rao', 'carla@example.com', 'India', 'Hyderabad', '2025-03-01', 'Premium', 1),
(4, 'David Smith', 'david@example.com', 'USA', 'New York', '2025-03-20', 'Standard', NULL),
(5, 'Emma Fischer', 'emma@example.com', 'Germany', 'Munich', '2025-04-05', 'Standard', 2),
(6, 'Farah Khan', 'farah@example.com', 'India', 'Mumbai', '2025-04-22', 'Premium', 3),
(7, 'George Brown', 'george@example.com', 'USA', 'Chicago', '2025-05-10', 'Standard', NULL),
(8, 'Hannah Weber', NULL, 'Germany', 'Berlin', '2025-06-01', 'Premium', 1),
(9, 'Ivan Kumar', 'ivan@example.com', 'India', 'Bengaluru', '2025-06-18', 'Standard', NULL),
(10, 'Julia Wilson', 'julia@example.com', 'USA', 'Seattle', '2025-07-05', 'Premium', 4),
(11, 'Kevin Meier', 'kevin@example.com', 'Germany', 'Cologne', '2025-07-20', 'Standard', NULL),
(12, 'Laura Johnson', 'laura@example.com', 'USA', 'Boston', '2025-08-01', 'Premium', NULL);





INSERT INTO employees
(
    employee_id,
    employee_name,
    department,
    job_title,
    manager_id,
    hire_date,
    salary
)
VALUES
(1, 'Michael Adams', 'Management', 'CEO', NULL, '2018-01-01', 150000),
(2, 'Sarah Becker', 'Sales', 'Sales Director', 1, '2019-03-15', 100000),
(3, 'Thomas Weber', 'Technology', 'Engineering Director', 1, '2019-06-10', 110000),
(4, 'Nina Patel', 'Sales', 'Sales Manager', 2, '2021-02-01', 75000),
(5, 'Robert Klein', 'Sales', 'Sales Representative', 4, '2022-05-10', 55000),
(6, 'Priya Sharma', 'Technology', 'Data Engineer', 3, '2022-08-20', 70000),
(7, 'Daniel Jones', 'Technology', 'Data Analyst', 3, '2023-01-15', 60000),
(8, 'Lisa Martin', 'Support', 'Support Manager', 1, '2021-09-01', 65000),
(9, 'Mark Evans', 'Support', 'Support Specialist', 8, '2024-02-10', 45000);


INSERT INTO categories
(
    category_id,
    category_name
)
VALUES
(1, 'Electronics'),
(2, 'Home and Kitchen'),
(3, 'Books'),
(4, 'Sports'),
(5, 'Office');


INSERT INTO products
(
    product_id,
    product_name,
    category_id,
    unit_price,
    cost_price,
    stock_quantity,
    supplier_name,
    is_active
)
VALUES
(1, 'Laptop Pro', 1, 1200.00, 850.00, 25, 'TechSource', 'Yes'),
(2, 'Wireless Mouse', 1, 35.00, 15.00, 150, 'TechSource', 'Yes'),
(3, 'Mechanical Keyboard', 1, 90.00, 45.00, 80, 'KeyWorld', 'Yes'),
(4, 'Office Chair', 5, 250.00, 140.00, 30, 'OfficePlus', 'Yes'),
(5, 'Standing Desk', 5, 600.00, 350.00, 15, 'OfficePlus', 'Yes'),
(6, 'Coffee Machine', 2, 180.00, 100.00, 40, 'HomeLife', 'Yes'),
(7, 'Cooking Pan Set', 2, 120.00, 65.00, 60, 'HomeLife', 'Yes'),
(8, 'SQL for Data Engineers', 3, 45.00, 20.00, 100, 'BookWorld', 'Yes'),
(9, 'Data Engineering Handbook', 3, 60.00, 25.00, 75, 'BookWorld', 'Yes'),
(10, 'Yoga Mat', 4, 40.00, 18.00, 90, 'SportZone', 'Yes'),
(11, 'Running Shoes', 4, 130.00, 70.00, 50, 'SportZone', 'Yes'),
(12, 'Old Printer', 5, 300.00, 250.00, 0, 'LegacySupply', 'No'),
(13, 'Unused Monitor', 1, 400.00, 250.00, 20, 'TechSource', 'Yes');


INSERT INTO orders
(
    order_id,
    customer_id,
    employee_id,
    order_date,
    order_status,
    shipping_country,
    shipping_cost,
    discount_amount
)
VALUES
(1001, 1, 5, '2026-01-05', 'Completed', 'Germany', 10.00, 0.00),
(1002, 2, 5, '2026-01-10', 'Completed', 'Germany', 8.00, 10.00),
(1003, 3, 5, '2026-01-15', 'Completed', 'India', 20.00, 0.00),
(1004, 4, 4, '2026-01-20', 'Pending', 'USA', 15.00, NULL),
(1005, 1, 5, '2026-02-01', 'Completed', 'Germany', 10.00, 20.00),
(1006, 5, 4, '2026-02-08', 'Cancelled', 'Germany', 8.00, 0.00),
(1007, 6, 5, '2026-02-12', 'Completed', 'India', 25.00, 15.00),
(1008, 7, 4, '2026-02-20', 'Completed', 'USA', 12.00, NULL),
(1009, 8, 5, '2026-03-01', 'Completed', 'Germany', 10.00, 0.00),
(1010, 2, 5, '2026-03-10', 'Completed', 'Germany', 8.00, 5.00),
(1011, 4, 4, '2026-03-15', 'Completed', 'USA', 15.00, 0.00),
(1012, 9, 5, '2026-03-20', 'Returned', 'India', 20.00, 0.00),
(1013, 10, 4, '2026-04-05', 'Completed', 'USA', 15.00, 30.00),
(1014, 1, 5, '2026-04-12', 'Completed', 'Germany', 10.00, NULL),
(1015, 6, 5, '2026-04-18', 'Pending', 'India', 25.00, 0.00);


INSERT INTO order_items
(
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(1, 1001, 1, 1, 1200.00),
(2, 1001, 2, 2, 35.00),

(3, 1002, 3, 1, 90.00),
(4, 1002, 8, 2, 45.00),

(5, 1003, 5, 1, 600.00),
(6, 1003, 9, 1, 60.00),

(7, 1004, 4, 1, 250.00),

(8, 1005, 6, 2, 180.00),
(9, 1005, 7, 1, 120.00),

(10, 1006, 10, 1, 40.00),

(11, 1007, 11, 2, 130.00),
(12, 1007, 8, 1, 45.00),

(13, 1008, 2, 3, 35.00),
(14, 1008, 10, 2, 40.00),

(15, 1009, 4, 1, 250.00),
(16, 1009, 8, 1, 45.00),

(17, 1010, 3, 2, 90.00),

(18, 1011, 1, 1, 1200.00),

(19, 1012, 9, 2, 60.00),

(20, 1013, 5, 1, 600.00),
(21, 1013, 6, 1, 180.00),

(22, 1014, 2, 5, 35.00),
(23, 1014, 8, 2, 45.00),

(24, 1015, 11, 1, 130.00);


INSERT INTO payments
(
    payment_id,
    order_id,
    payment_date,
    payment_method,
    payment_status,
    amount
)
VALUES
(1, 1001, '2026-01-05', 'Credit Card', 'Paid', 1280.00),
(2, 1002, '2026-01-10', 'PayPal', 'Paid', 178.00),
(3, 1003, '2026-01-15', 'Credit Card', 'Paid', 680.00),
(4, 1004, NULL, 'Bank Transfer', 'Pending', 265.00),
(5, 1005, '2026-02-01', 'Credit Card', 'Paid', 470.00),
(6, 1006, NULL, 'PayPal', 'Cancelled', 48.00),
(7, 1007, '2026-02-12', 'Credit Card', 'Paid', 315.00),
(8, 1008, '2026-02-20', 'PayPal', 'Paid', 197.00),
(9, 1009, '2026-03-01', 'Credit Card', 'Paid', 305.00),
(10, 1010, '2026-03-10', 'Credit Card', 'Paid', 183.00),
(11, 1011, '2026-03-15', 'Bank Transfer', 'Paid', 1215.00),
(12, 1012, '2026-03-20', 'PayPal', 'Refunded', 140.00),
(13, 1013, '2026-04-05', 'Credit Card', 'Paid', 765.00),
(14, 1014, '2026-04-12', 'PayPal', 'Paid', 275.00),
(15, 1015, NULL, 'Bank Transfer', 'Pending', 155.00);


INSERT INTO returns
(
    return_id,
    order_id,
    product_id,
    return_date,
    return_reason,
    refund_amount
)
VALUES
(1, 1012, 9, '2026-03-25', 'Damaged', 120.00),
(2, 1012, 9, '2026-03-25', 'Changed Mind', 20.00),
(3, 1007, 11, '2026-02-25', 'Wrong Size', 130.00);


INSERT INTO customer_support_tickets
(
    ticket_id,
    customer_id,
    created_date,
    resolved_date,
    ticket_category,
    priority,
    ticket_status
)
VALUES
(1, 1, '2026-01-07', '2026-01-08', 'Delivery', 'Low', 'Resolved'),
(2, 3, '2026-01-18', '2026-01-22', 'Payment', 'High', 'Resolved'),
(3, 4, '2026-01-22', NULL, 'Delivery', 'Medium', 'Open'),
(4, 6, '2026-02-15', '2026-02-16', 'Product', 'High', 'Resolved'),
(5, 8, '2026-03-02', NULL, 'Account', 'Low', 'Open'),
(6, 9, '2026-03-22', '2026-03-28', 'Return', 'High', 'Resolved'),
(7, 10, '2026-04-07', NULL, 'Payment', 'Medium', 'In Progress');

INSERT INTO monthly_sales_targets
(
    target_month,
    country,
    sales_target
)
VALUES
('2026-01-01', 'Germany', 1500.00),
('2026-01-01', 'India', 700.00),
('2026-01-01', 'USA', 500.00),

('2026-02-01', 'Germany', 600.00),
('2026-02-01', 'India', 500.00),
('2026-02-01', 'USA', 300.00),

('2026-03-01', 'Germany', 700.00),
('2026-03-01', 'India', 200.00),
('2026-03-01', 'USA', 1200.00),

('2026-04-01', 'Germany', 500.00),
('2026-04-01', 'India', 300.00),
('2026-04-01', 'USA', 800.00);





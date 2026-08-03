--Sort customers alphabetically.
select * from customers order by customer_name
--Sort customers by signup date, newest first.
select * from customers order by signup_date desc
--Sort products from most expensive to least expensive.
select * from products order by unit_price desc
--Display the five cheapest products.
select top 5 * from products order by unit_price asc
--Display the three employees with the highest salaries.
select top 3 * from employees order by salary desc
--Sort products first by category and then by price descending.
select * from products order by category_id, unit_price desc
--Find the latest five orders.
select top 5 * from orders order by order_date desc
--Display customers ordered by country and city.
select * from customers order by country, city
--Find the highest-priced active product.
select top 1 * from products where is_active = 'Yes' order by unit_price desc
--Find the employee with the lowest salary.
select  top 1 * from employees order by salary asc 

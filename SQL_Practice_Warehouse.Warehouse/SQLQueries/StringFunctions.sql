--Convert all customer names to uppercase.
select customer_id, upper(customer_name) as uppercase_CustomerName from customers

--Convert all countries to lowercase.
select customer_id,customer_name,lower(country) as lowercase_CountryName from customers

--Find the length of each product name.
select product_name, len(product_name) as productNameLenght from products

--Extract the first five characters of each product name.
select product_id, product_name, SUBSTRING(product_name,1,5) as firstFiveChars from products

--Find customers whose names start with A.
select * from customers where customer_name like 'A%'

--Find products containing the word Data.
select product_name from products where product_name like '%Data%'

--Extract the email domain.
select email, substring(email, charindex('@',email)+1, len(email)) as email_domain from customers

--Create a customer label combining name and country.
select customer_name,country,concat(customer_name,' ',country) as NameAndCountry from customers

--Remove spaces from customer names.
SELECT
    customer_name,
    TRIM(customer_name) AS cleaned_customer_name
FROM customers;

SELECT
    REPLACE(customer_name, ' ', '') AS customer_name_without_spaces
FROM customers;

--Replace Germany with DE.
select country, replace(country, 'Germany','DE') as updated_countryName from customers

--Find the position of a word inside a product name.
select product_name,CHARINDEX('less',product_name) as word_position from products
select * from products

--Create an employee identifier using employee ID and employee name.
select employee_id, employee_name, concat(employee_id,' ',employee_name) as employee_identifier from employees

--Display the first word from every customer name.
SELECT
    customer_name,
    CASE
        WHEN CHARINDEX(' ', customer_name) > 0
            THEN LEFT(
                customer_name,
                CHARINDEX(' ', customer_name) - 1
            )
        ELSE customer_name
    END AS first_word
FROM customers;

--Find names ending with a.
select customer_name from customers where customer_name like '%A' or customer_name like '%a'

--Standardize customer names using trimming and case conversion.
select customer_name , trim(lower(customer_name)) as standardize_customername from customers

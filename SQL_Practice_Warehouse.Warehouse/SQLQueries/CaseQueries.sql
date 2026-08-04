--Categorize products as Cheap, Medium, or Expensive.
select product_id,product_name,
case 
    when unit_price>500 THEN 'Expensive'
    when unit_price>200 and unit_price<500 THEN 'Medium'
    when unit_price<200 THEN 'Cheap'
END as product_category_based_on_price 
from products

--Categorize employees as Junior, Mid, or Senior based on salary.
select employee_id,employee_name,
CASE
when salary>=100000 THEN 'Senior'
when salary>50000 and salary <100000 THEN 'Mid'
when salary <50000 then 'Junior'
END as employee_category_based_on_salary
from employees

--Convert order statuses into business categories.

select order_id,
CASE order_status
when 'Completed' THEN 'Order is Completed'
when 'Returned' THEN 'Order is Returned'
when 'Pending' THEN 'Order is Pending'
when 'Cancelled' THEN 'Order is Cancelled'
END
from orders


--Classify orders as Domestic or International.
select order_id, 
case shipping_country
when 'India' then 'Domestic'
when 'Germany' then 'International'
when 'USA' then 'International'
END
from orders 

--Create a stock status: Out of Stock, Low Stock, or Available.
select product_id,product_name,
case 
when stock_quantity=0 then 'Out Of Stock'
when stock_quantity<30 then 'low stock'
when stock_quantity>=30 then 'Available'
end as 'stock status'
from products

--Create a customer label: Premium or Standard.
with customer_category as (
select c.customer_id,c.customer_name,o.order_id,p.amount from orders o 
inner join payments p on p.order_id=o.order_id
inner join customers c on c.customer_id=o.customer_id)

select customer_id,customer_name,
case 
when sum(amount) >500 THEN 'Premium'
when sum(amount)<=500 THEN 'Standard'
end as customer_categorisation
from customer_category group by customer_id,customer_name


--Create a payment label: Paid, Pending, or Other.

select payment_id,order_id,
case payment_status
when 'Paid' then 'Paid'
when 'Pending' then 'Pending'
else 'Others'
END
from payments

--Classify order values as Small, Medium, or Large.
WITH order_totals AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price)
            + COALESCE(o.shipping_cost, 0)
            - COALESCE(o.discount_amount, 0) AS expected_total
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.shipping_cost,
        o.discount_amount
)

select order_id,expected_total,
case 
when expected_total >1000 then 'large'
when expected_total>=500 and expected_total<=1000 then 'medium'
when expected_total <500 then 'low'
end as order_value
from order_totals


--Create a priority score for support tickets.
select ticket_id,customer_id,
case ticket_category
when 'Payment' then 'High'
when  'Delivery' then 'Medium'
else 'low'
end as ticket_categorisation
from customer_support_tickets

--Flag products whose selling price is less than cost price.
select product_id,product_name,
case 
when unit_price<cost_price then 'loss making'
else 'profit making'
END as ProfitorLoss
from products

--Flag orders with missing discounts.
select order_id,customer_id ,
case 
when discount_amount > 0 then 'discount exists'
else 'no discount'
END as discount_exists_or_not
from orders

--Create a return-risk category based on refund amount.
select return_id,order_id,
case 
when refund_amount >50 then 'high'
else 'low'
end as 'return_risk_category'
from returns

--Display each employee and their manager.
select e.employee_id,e.employee_name,m.employee_name as manager_name from employees e left join employees m ON
e.manager_id=m.employee_id

--Display employees who do not have a manager.
select e.employee_id,e.employee_name,e.job_title,m.employee_name as manager_name from employees e left join employees m ON
e.manager_id=m.employee_id where e.manager_id IS NULL

--Display manager names and the employees reporting to them.
select m.manager_id,e.employee_name as employee, m.employee_name as manager from employees e INNER join employees m ON
e.manager_id=m.employee_id order by m.employee_name,e.employee_name

--Count direct reports for each manager.
select m.employee_name as manager,count(e.employee_name) as employee_count from employees e INNER join employees m ON
e.manager_id=m.employee_id  group by m.employee_name


--Find managers with more than one direct report.
select m.employee_name as manager from employees e INNER join employees m ON
e.manager_id=m.employee_id  group by m.employee_name having count(e.employee_id)>1


--Display employee name, manager name, and employee department.
select e.employee_name, e.department, m.employee_name as manager_name from employees e left join employees m
on m.employee_id=e.manager_id

--Find employees whose manager belongs to a different department.
select e.employee_name, e.department, m.employee_name as manager_name,m.department from employees e inner join employees m
on m.employee_id=e.manager_id and m.department != e.department

--Display the CEO and all employees who report directly to the CEO.
select e.employee_name, e.employee_id , r.employee_name,r.employee_id from employees r inner join
(select employee_id,employee_name from employees where job_title='CEO') e
on e.employee_id= r.manager_id

SELECT
    ceo.employee_id AS ceo_id,
    ceo.employee_name AS ceo_name,
    employee.employee_id AS employee_id,
    employee.employee_name AS employee_name
FROM employees AS employee
INNER JOIN employees AS ceo
    ON employee.manager_id = ceo.employee_id
WHERE ceo.job_title = 'CEO';

/*-------------  SUBQUERIES ASSIGNMENT  ------------*/
use company__db;

CREATE TABLE Employee_Dataset (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id VARCHAR(5),
    salary INT);
    
INSERT INTO Employee_Dataset (emp_id, name, department_id, salary)
VALUES
(101, 'Abhishek', 'D01', 62000),
(102, 'Shubham', 'D01', 58000),
(103, 'Priya', 'D02', 67000),
(104, 'Rohit', 'D02', 64000),
(105, 'Neha', 'D03', 72000),
(106, 'Aman', 'D03', 55000),
(107, 'Ravi', 'D04', 60000),
(108, 'Sneha', 'D04', 75000),
(109, 'Kiran', 'D05', 70000),
(110, 'Tanuja', 'D05', 65000);

select * from Employee_Dataset;

CREATE TABLE Department_Dataset (
    department_id VARCHAR(5) PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50));
    
INSERT INTO Department_Dataset (department_id, department_name, location) 
VALUES
('D01', 'Sales', 'Mumbai'),
('D02', 'Marketing', 'Delhi'),
('D03', 'Finance', 'Pune'),
('D04', 'HR', 'Bengaluru'),
('D05', 'IT', 'Hyderabad');

select * from Department_Dataset;

CREATE TABLE Sales_Dataset (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount INT,
    sale_date DATE);

INSERT INTO Sales_Dataset (sale_id, emp_id, sale_amount, sale_date) 
VALUES
(201, 101, 4500, '2025-01-05'),
(202, 102, 7800, '2025-01-10'),
(203, 103, 6700, '2025-01-14'),
(204, 104, 12000, '2025-01-20'),
(205, 105, 9800, '2025-02-02'),
(206, 106, 10500, '2025-02-05'),
(207, 107, 3200, '2025-02-09'),
(208, 108, 5100, '2025-02-15'),
(209, 109, 3900, '2025-02-20'),
(210, 110, 7200, '2025-03-01');

select * from Sales_Dataset;
 
/*---------------- BASIC LEVEL -----------------*/

/*--Q1. Retrieve the names of employees who earn more than the average salary of all employees.--*/
SELECT name,salary
FROM Employee_Dataset
WHERE salary > (SELECT AVG(salary) FROM Employee_Dataset);


/*--Q2. Find the employees who belong to the department with the highest average salary.--*/
SELECT name
FROM Employee_Dataset
WHERE department_id = (
    SELECT department_id
    FROM Employee_Dataset
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 1);


/*--Q3. List all employees who have made at least one sale.--*/
SELECT 	Name
FROM Employee_Dataset
WHERE emp_id IN (SELECT emp_id FROM Sales_Dataset);

/*--Q4. Find the employee with the highest sale amount.--*/
SELECT name
FROM Employee_Dataset
WHERE emp_id = (
    SELECT emp_id
    FROM Sales_Dataset
    ORDER BY sale_amount DESC
    LIMIT 1);
    
/*--Q5. Retrieve the names of employees whose salaries are higher than Shubham’s salary.--*/

SELECT name,salary
FROM Employee_Dataset
WHERE salary > (
    SELECT salary
    FROM Employee_Dataset
    WHERE name = 'Shubham');

/*-------------------- INTERMEDIATE LEVEL -------------------*/

/* Q1. Find employees who work in the same department as Abhishek. */

SELECT name,department_id
FROM Employee_Dataset
WHERE department_id = (
    SELECT department_id
    FROM Employee_Dataset
    WHERE name = 'Abhishek');

/* Q2. List departments that have at least one employee earning more than ₹60,000. */

SELECT department_name
FROM department_dataset
WHERE department_id IN (
    SELECT department_id
    FROM Employee_Dataset
    WHERE salary > 60000);

/* Q3 Find the department name of the employee who made the highest sale */
SELECT department_name
FROM department_dataset
WHERE department_id = (
    SELECT department_id
    FROM employee_dataset
    WHERE emp_id = (
        SELECT emp_id
        FROM sales_dataset
        ORDER BY sale_amount DESC
        LIMIT 1));

/* Q4. Retrieve employees who have made sales greater than the average sale amount. */
SELECT DISTINCT e.name,sale_amount
FROM employee_dataset e
JOIN sales_dataset s 
ON e.emp_id = s.emp_id
WHERE s.sale_amount > (SELECT AVG(sale_amount) FROM sales_dataset);

/* Q5. Find the total sales made by employees who earn more than the average salary. */
SELECT SUM(s.sale_amount) AS total_sales
FROM sales_dataset s
WHERE s.emp_id IN (
    SELECT emp_id
    FROM employee_dataset
    WHERE salary > (SELECT AVG(salary) FROM employee_dataset));
    
    /* -------------- ADVANCED LEVEL -------------- */
    
/*Q1. Find employees who have not made any sales. */
SELECT name
FROM employee_dataset
WHERE emp_id NOT IN (SELECT emp_id FROM sales_dataset);

/*Q2. List departments where the average salary is above ₹55,000. */
SELECT department_name
FROM department_dataset
WHERE department_id IN (
    SELECT department_id
    FROM employee_dataset
    GROUP BY department_id
    HAVING AVG(salary) > 55000);

/*Q3. Retrieve department names where the total sales exceed ₹10,000. */
SELECT d.department_name
FROM department_dataset d
WHERE d.department_id IN (
    SELECT e.department_id
    FROM employee_dataset e
    JOIN sales_dataset s 
    ON e.emp_id = s.emp_id
    GROUP BY e.department_id
    HAVING SUM(s.sale_amount) > 10000);

/*Q4. Find the employee who has made the second-highest sale. */
SELECT name
FROM employee_dataset
WHERE emp_id = (
    SELECT emp_id
    FROM sales_dataset
    WHERE sale_amount < (SELECT MAX(sale_amount) FROM sales_dataset)
    ORDER BY sale_amount DESC
    LIMIT 1);

/*Q5. Retrieve the names of employees whose salary is greater than the highest sale amount recorded. */
SELECT name
FROM employee_dataset
WHERE salary > (SELECT MAX(sale_amount) FROM sales_dataset);

    
    
    








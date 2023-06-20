-- Task 1:
--Revision one
SELECT dept_emp.dept_no, employees.gender, AVG(salaries.salary) AS average_earnings
FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN salaries ON dept_emp.emp_no = salaries.emp_no
GROUP BY dept_emp.dept_no, employees.gender;


-- Task 2:
-- To find the lowest department number:

SELECT MIN(dept_no) AS lowest_dept_no FROM dept_emp;

-- To find the highest department number:

SELECT MAX(dept_no) AS highest_dept_no FROM dept_emp;


-- Task 3:

SELECT employees.emp_no, 
       (SELECT COUNT(DISTINCT dept_no) FROM dept_emp WHERE emp_no = employees.emp_no) AS num_departments,
       CASE
           WHEN employees.emp_no <= 10020 THEN 110022
           WHEN employees.emp_no BETWEEN 10021 AND 10040 THEN 110039
       END AS manager
FROM employees
WHERE employees.emp_no <= 10040;


-- Task 4:

SELECT * FROM employees WHERE YEAR(hire_date) = 2000;


-- Task 5:
-- To list all employees who are engineers:

SELECT employees.*
FROM employees
JOIN titles ON employees.emp_no = titles.emp_no
WHERE titles.title = 'Engineer'
LIMIT 10;

-- To list senior engineers:

SELECT employees.*
FROM employees
JOIN titles ON employees.emp_no = titles.emp_no
WHERE titles.title = 'Senior Engineer'
LIMIT 10;


-- Task 6:
-- You need to create a stored procedure in MySQL to achieve this task. Here's the procedure:

DELIMITER //
CREATE PROCEDURE last_dept(IN emp_no_param INT)
BEGIN
    SELECT dept_name
    FROM departments
    JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
    WHERE dept_emp.emp_no = emp_no_param
    ORDER BY dept_emp.to_date DESC
    LIMIT 1;
END //
DELIMITER ;

-- After creating the procedure, you can call it for employee 10010:

CALL last_dept(10010);


-- Task 7:

SELECT COUNT(*) AS num_contracts
FROM salaries
WHERE DATEDIFF(end_date, start_date) > 365 AND salary > 100000;


-- Task 8:
-- You need to create a trigger in MySQL to achieve this task. Here's the trigger:

CREATE TRIGGER check_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.hire_date > CURDATE() THEN
        SET NEW.hire_date = CURDATE();
    END IF;
END;

-- After creating the trigger, you can run the provided code to test it.

-- Task 9:
-- You need to create two functions in MySQL. Here's the function to find the highest salary for a given employee:

CREATE FUNCTION find_highest_salary(emp_no_param INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE highest_salary DECIMAL(10,2);
    SELECT MAX(salary) INTO highest_salary
    FROM salaries
    WHERE emp_no = emp_no_param;
    RETURN highest_salary;
END;

-- To find the highest salary for employee no. 11356:

SELECT find_highest_salary(11356);

Similarly, create another function to find the lowest salary based on a similar employee no.

-- Task 10:
-- Here's the function that uses a second parameter to find either the lowest or highest salary, or the difference between the two:

CREATE FUNCTION find_salary_difference(emp_no_param INT, mode_param VARCHAR(3)) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE salary_diff DECIMAL(10,2);
    
    IF mode_param = 'min' THEN
        SELECT MIN(salary) INTO salary_diff
        FROM salaries
        WHERE emp_no = emp_no_param;
    ELSEIF mode_param = 'max' THEN
        SELECT MAX(salary) INTO salary_diff
        FROM salaries
        WHERE emp_no = emp_no_param;
    ELSE
        SELECT MAX(salary) - MIN(salary) INTO salary_diff
        FROM salaries
        WHERE emp_no = emp_no_param;
    END IF;
    
    RETURN salary_diff;
END;

-- To find the highest salary for employee no. 11356:

SELECT find_salary_difference(11356, 'max');

-- To find the lowest salary for employee no. 11356:

SELECT find_salary_difference(11356, 'min');

-- To find the salary difference for employee no. 11356:

SELECT find_salary_difference(11356, 'diff');


-- Please note that for Task 6, Task 8, Task 9, and Task 10, you need to execute those queries in a MySQL environment that supports stored procedures, triggers, and functions.
USE employees;

-- INNER JOIN
SELECT 
    e.emp_no, e.first_name , e.last_name, m.dept_no, e.hire_date
FROM
    employees e
		INNER JOIN
    dept_manager m ON e.emp_no=m.emp_no ORDER BY emp_no;


-- Left Join
SELECT e.emp_no, e.first_name, e.last_name, md.dept_no, md.from_date FROM employees e LEFT JOIN dept_manager md ON e.emp_no = md.emp_no 
WHERE e.last_name = 'Markovitch' ORDER BY md.dept_no DESC, e.emp_no;

-- Left Join
SELECT e.emp_no, e.first_name, e.last_name, md.dept_no, md.from_date FROM employees e LEFT JOIN dept_manager md ON e.emp_no = md.emp_no 
WHERE e.last_name = 'Markovitch' ORDER BY e.emp_no;

SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date FROM employees e, dept_manager dm WHERE e.emp_no = dm.emp_no;

-- Inner Join
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date FROM employees e JOIN dept_manager dm ON  e.emp_no = dm.emp_no;


SELECT e.first_name, e.last_name, t.title, e.hire_date FROM employees e JOIN titles t ON e.emp_no = t.emp_no WHERE e.first_name = 'Margareta' AND e.last_name = 'Markovitch';

-- Cross Join
SELECT dm.*, d.* from dept_manager dm CROSS JOIN departments d WHERE d.dept_no ='d009';

-- Join multiple tables
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    d.dept_name,
    dm.from_date
FROM
    dept_manager dm
        JOIN
    employees e ON dm.emp_no = e.emp_no
        JOIN
    titles t ON dm.emp_no = t.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no WHERE t.title = 'Manager';
    
-- Aggregate Functions with Join
SELECT 
    COUNT(*)
FROM
    employees;
Select count(*) from departments;
SELECT count(*) from employees dm CROSS JOIN departments; 

SELECT e.gender, COUNT(*) FROM employees e JOIN titles t ON e.emp_no = t.emp_no WHERE t.title = 'Manager' GROUP BY gender;


SELECT

    e.gender, COUNT(dm.emp_no)

FROM

    employees e

        JOIN

    dept_manager dm ON e.emp_no = dm.emp_no

GROUP BY gender;

-- Self Join
SELECT

    *

FROM

    (SELECT

        e.emp_no,

            e.first_name,

            e.last_name,

            NULL AS dept_no,

            NULL AS from_date

    FROM

        employees e

    WHERE

        last_name = 'Denis' UNION SELECT

        NULL AS emp_no,

            NULL AS first_name,

            NULL AS last_name,

            dm.dept_no,

            dm.from_date

    FROM

        dept_manager dm) as a
ORDER BY -a.emp_no DESC;

-- Select query with condition
SELECT * from dept_manager WHERE emp_no IN (SELECT emp_no from employees WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');

SELECT * from employees e WHERE EXISTS ( SELECT * from titles t WHERE e.emp_no = t.emp_no AND t.title = 'Assistant Engineer') ORDER BY emp_no;
SELECT * from dept_manager ORDER BY emp_no;
SELECT * from departments;
CREATE TABLE emp_manager (emp_no INT NOT NULL, dept_no CHAR(4) NULL, manager_no INT NOT NULL);
DESCRIBE emp_manager;

SELECT emp_no as manager_id FROM dept_manager WHERE emp_no = 110022;
SELECT * FROM employees e WHERE emp_no <= '10020' ; 
-- WHERE emp_no IN (SELECT emp_no FROM dept_manager WHERE emp_no = 110022);

INSERT INTO emp_manager(emp_no, dept_no, manager_no) SELECT U.* FROM (SELECT A.* FROM(SELECT e.emp_no as emplyee_id, MIN(de.dept_no) as dept_code, (SELECT emp_no as manager_id FROM dept_manager WHERE emp_no = 110022) as manager_id
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no WHERE e.emp_no <= 10020 GROUP BY e.emp_no) AS A
UNION
SELECT B.* FROM(SELECT e.emp_no as emplyee_id, MIN(de.dept_no) as dept_code, (SELECT emp_no as manager_id FROM dept_manager WHERE emp_no = 110039) as manager_id
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no WHERE e.emp_no > 10020 GROUP BY e.emp_no LIMIT 20) AS B
UNION
SELECT C.* FROM(SELECT e.emp_no as emplyee_id, MIN(de.dept_no) as dept_code, (SELECT emp_no as manager_id FROM dept_manager WHERE emp_no = 110039) as manager_id
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no WHERE e.emp_no = 110022 GROUP BY e.emp_no) AS C
UNION
SELECT D.* FROM(SELECT e.emp_no as emplyee_id, MIN(de.dept_no) as dept_code, (SELECT emp_no as manager_id FROM dept_manager WHERE emp_no = 110022) as manager_id
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no WHERE e.emp_no = 110039 GROUP BY e.emp_no) AS D) AS U;

SELECT * FROM emp_manager;

CREATE OR REPLACE VIEW v_average_salary AS SELECT ROUND(AVG(s.salary),2) AS average_salary from salaries s JOIN dept_manager dm ON s.emp_no = dm.emp_no;

SELECT * FROM v_average_salary;

DELIMITER $$
Create Procedure avg_salary()
BEGIN
  SELECT ROUND(AVG(salary), 2) From salaries;

End$$
Delimiter ;

call employees.avg_salary();

-- SQL Stored Procedure
DELIMITER $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(14), p_last_name VARCHAR(16), out emp_no_out INT)
BEGIN
SELECT 
    e.emp_no
INTO emp_no_out FROM
    employees e
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name;

END $$
Delimiter ;

SELECT * from employees LIMIT 10;
SET @v_emp_no = 0;
call emp_info('Aruna','Journel', @v_emp_no);
select @v_emp_no;

-- SQL Function 
-- Note use Select statement to run the function
DELIMITER $$
CREATE FUNCTION f_emp_info(p_first_name VARCHAR(225), p_last_name VARCHAR(225)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
DECLARE v_max_from_date date;
DECLARE v_salary decimal(10,2);
Select MAX(s.from_date) into v_max_from_date FROM salaries JOIN employees e ON e.emp_no = s.emp_no 
WHERE e.first_name = p_first_name and e.last_name = p_last_name;
Select s.salarys into v_salary FROM salaries JOIN employees e ON e.emp_no = s.emp_no 
WHERE e.first_name = p_first_name and e.last_name = p_last_name;
RETURN v_salary;
END $$
Delimiter ;



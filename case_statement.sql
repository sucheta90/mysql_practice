USE employees;
SELECT * from salaries s WHERE s.salary > 89000;
DROP INDEX higher_sal on salaries;
CREATE INDEX higher_sal on salaries(salary);
SELECT * from salaries s WHERE s.salary > 89000;

-- Case Statement 1
SELECT e.emp_no, e.first_name, e.last_name,
	CASE
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
        END AS title
FROM employees e LEFT JOIN dept_manager dm ON dm.emp_no = e.emp_no WHERE e.emp_no > 109990;

-- Case Statement 2
Select e.emp_no, e.first_name, e.last_name, MAX(s.salary)- MIN(s.salary) As salary_diff,
	CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Raised more than 30000'
        else 'NOT'
        END AS raise
FROM employees e LEFT JOIN dept_manager dm ON e.emp_no = dm.emp_no JOIN salaries s on e.emp_no = s.emp_no GROUP BY e.emp_no;

-- Case Statement 3
Select e.emp_no, e.first_name, e.last_name,
	CASE
		WHEN MAX(de.to_date)> SYSDATE() THEN 'Is still employed'
        else 'Not an employee anymore'
END as current_employee
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no GROUP BY e.emp_no LIMIT 100;
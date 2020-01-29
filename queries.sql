-- 1.) List the following details of each employee: 
-- employee number, last name, first name, gender, and salary.

SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no;

-- 2.) List employees who were hired in 1986.

SELECT first_name, last_name, birthdate
	FROM employees 
	WHERE (hire_date < '1987-01-01' 
	AND (hire_date >= '1986-01-01'));

-- 3.) List the manager of each department with the following information: 
-- department number, department name, the manager's 
-- employee number, last name, first name, and start and end employment dates.

SELECT dm.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date
FROM employees AS e 
INNER JOIN dept_manager AS dm ON e.emp_no=dm.emp_no
INNER JOIN departments AS d ON dm.dept_no=d.dept_no;

-- 4.) List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e 
LEFT JOIN dept_emp AS de
ON e.emp_no=de.emp_no
INNER JOIN departments AS d
ON d.dept_no=de.dept_no
WHERE de.to_date='9999-01-01';

-- 5.) List all employees whose first name is "Hercules" and 
-- last names begin with "B."

SELECT emp_no, last_name, first_name
FROM employees
WHERE (first_name = 'Hercules' AND last_name LIKE 'B%');

-- 6.) List all employees in the Sales department, including their 
-- employee number, last name, first name, and department name.

-- Past, current, and reassigned employees
CREATE VIEW dept_view AS
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no=d.dept_no;

SELECT * FROM dept_view 
WHERE dept_name ='Sales';

-- Current employees in most recent positions
CREATE VIEW dept_view_current AS
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no=d.dept_no
WHERE de.to_date='9999-01-01';

SELECT * FROM dept_view_current
WHERE dept_name ='Sales';

-- 7.) List all employees in the Sales and Development departments, 
-- including their employee number, last name, first name, and 
-- department name.

SELECT * FROM dept_view
WHERE (dept_name ='Sales' or dept_name='Development');

SELECT * FROM dept_view_current
WHERE (dept_name ='Sales' or dept_name='Development');

/* 
Subquestion, have any employees been in both departments?
The query below returned no results.  Then, double check that column values 
are unique.
*/

SELECT * FROM dept_view 
WHERE emp_no IN (SELECT emp_no FROM dept_view WHERE (dept_name ='Sales'))
AND dept_name = 'Development';

SELECT CASE WHEN count(distinct emp_no)= count(emp_no)
THEN 'column values are unique' ELSE 'column values are NOT unique' END
FROM dept_view WHERE (dept_name ='Sales')
AND dept_name = 'Development';

-- 8.) In descending order, list the frequency count of employee last names, 
-- i.e., how many employees share each last name.

SELECT count(emp_no), last_name 
FROM employees
GROUP BY last_name
ORDER BY last_name DESC;

-- Epilogue

SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary, d.dept_name, t.title
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no
INNER JOIN dept_emp AS de
ON e.emp_no=de.emp_no
INNER JOIN titles AS t
ON t.emp_no=e.emp_no
INNER JOIN departments AS d
ON d.dept_no=de.dept_no
WHERE e.emp_no=499942;






-- Double checking relationships for ERD

-- Many Department Managers per department (past and present)
SELECT CASE WHEN count(distinct dept_no)= count(dept_no)
THEN 'column values are unique' ELSE 'column values are NOT unique' END
FROM dept_manager;

-- Many Titles per employee
SELECT CASE WHEN count(distinct emp_no)= count(emp_no)
THEN 'column values are unique' ELSE 'column values are NOT unique' END
FROM titles;

-- One Salary per employee
SELECT CASE WHEN count(distinct emp_no)= count(emp_no)
THEN 'column values are unique' ELSE 'column values are NOT unique' END
FROM salaries;

-- Many departments per employee
SELECT CASE WHEN count(distinct emp_no)= count(emp_no)
THEN 'column values are unique' ELSE 'column values are NOT unique' END
FROM dept_emp;


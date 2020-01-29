-- Table schema

DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;


CREATE TABLE employees (
	emp_no INT PRIMARY KEY,
	birthdate date NOT NULL,
	first_name VARCHAR(45),
	last_name VARCHAR(45),
	gender VARCHAR(10),
	hire_date date NOT NULL
);



SELECT * FROM employees LIMIT 10;

CREATE TABLE departments (
	dept_no VARCHAR(10) PRIMARY KEY,
	dept_name VARCHAR(45)
);

SELECT * FROM departments LIMIT 10;

CREATE TABLE dept_emp (
	emp_no INT,
	FOREIGN KEY (emp_no)
    REFERENCES employees (emp_no),
	dept_no VARCHAR(10),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	from_date date NOT NULL,
	to_date date NOT NULL
);

SELECT * FROM dept_emp LIMIT 10;


CREATE TABLE salaries (
	emp_no INT,
	FOREIGN KEY (emp_no)
    REFERENCES employees (emp_no),
	salary DECIMAL(11,2),
	from_date date NOT NULL,
	to_date date NOT NULL
);

SELECT * FROM salaries LIMIT 10;

CREATE TABLE titles (
	emp_no INT,
	FOREIGN KEY (emp_no)
    REFERENCES employees (emp_no),
	title VARCHAR(45),
	from_date date NOT NULL,
	to_date date NOT NULL
);

SELECT * FROM title LIMIT 10;

CREATE TABLE dept_manager (
	dept_no VARCHAR(10),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	emp_no INT,
	FOREIGN KEY (emp_no)
    REFERENCES employees (emp_no),
	from_date date NOT NULL,
	to_date date NOT NULL
);

SELECT * FROM dept_manager LIMIT 10;

/*
This didn't work
SELECT format('\copy %s C:\Users\Herman D Schaumburg\Documents\NU_Data_Bootcamp\Homework 7\sql-challenge\data\%s.csv', item, item) 
  FROM generate_series('employees','departments','dept_emp','dept_manager','salaries','titles') t(item);
*/

/*
\copy employees FROM 'C:\Users\Herman D Schaumburg\Documents\NU_Data_Bootcamp\Homework 7\sql-challenge\data\employees.csv' WITH DELIMITER ',' CSV HEADER;
\copy departments FROM 'C:\Users\Herman D Schaumburg\Documents\NU_Data_Bootcamp\Homework 7\sql-challenge\data\departments.csv' WITH DELIMITER ',' CSV HEADER;
\copy dept_emp FROM 'C:\Users\Herman D Schaumburg\Documents\NU_Data_Bootcamp\Homework 7\sql-challenge\data\dept_emp.csv' WITH DELIMITER ',' CSV HEADER;
\copy dept_manager FROM 'C:\Users\Herman D Schaumburg\Documents\NU_Data_Bootcamp\Homework 7\sql-challenge\data\dept_manager.csv' WITH DELIMITER ',' CSV HEADER;
\copy salaries FROM 'C:\Users\Herman D Schaumburg\Documents\NU_Data_Bootcamp\Homework 7\sql-challenge\data\salaries.csv' WITH DELIMITER ',' CSV HEADER;
\copy titles FROM 'C:\Users\Herman D Schaumburg\Documents\NU_Data_Bootcamp\Homework 7\sql-challenge\data\titles.csv' WITH DELIMITER ',' CSV HEADER;
*/


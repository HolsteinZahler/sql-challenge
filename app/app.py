from flask import Flask, jsonify, render_template, redirect, make_response, json, request
import os

# import subprocess

#DB Imports
import sqlalchemy.dialects.postgresql
from flask_sqlalchemy import SQLAlchemy
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from sqlalchemy import create_engine, inspect

app = Flask(__name__)
app.config['DEBUG']= True
#Disable deprecation warning and overhead
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

#DATABASE SET UP
uri = 'postgres://caixrenevwqjud:f0731c0add372f910c5b2e5de563c60439c22f341bb1caeb6cee823c2d3f3f15@ec2-34-200-15-192.compute-1.amazonaws.com:5432/d6rf0vuf79mnlm'
app.config['SQLALCHEMY_DATABASE_URI'] = uri
db = SQLAlchemy(app)
engine = db.engine

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/hire-date')
def hire_date_db_form():
    return render_template('hire-date.html')


@app.route('/hire-date', methods=['POST'])
def hire_date_db_query():
    query_string = request.form['text']
    if len(query_string)!=4:
        sql_string_out = "Error: must enter year in YYYY format"
        results = []
        query_string_out = 'You entered: \"'+query_string+'\"'
        return render_template('hire-date.html', results=results, query_string_out = query_string_out, sql_string_out=sql_string_out)
    else:
        for j in range(0,3):
            if query_string[j] not in ['0','1','2','3','4','5','6','7','8','9']:
                sql_string_out = "Error: must enter year in YYYY format"
                results = []
                query_string_out = 'You entered: \"'+query_string+'\"'
                return render_template('hire-date.html', results=results, query_string_out = query_string_out, sql_string_out=sql_string_out)
        lower_date = query_string+'-01-01'
        upper_date= str(int(query_string)+1)+'-01-01'
        query = F"SELECT first_name, last_name, birthdate, hire_date FROM employees WHERE (hire_date < '{upper_date}') AND (hire_date >= '{lower_date}') LIMIT 10"

        results = ''
        query_string_out = ''
        results = engine.execute(query).fetchall()
        query_string_out = 'You entered: \"'+query_string+'\"'
        sql_string_out = F"SELECT first_name, last_name, birthdate, hire_date \n FROM employees \n WHERE (hire_date < '{upper_date}') AND (hire_date >= '{lower_date}') \n LIMIT 10 \n"

        return render_template('hire-date.html', results=results, query_string_out = query_string_out, sql_string_out=sql_string_out)

@app.route('/salary')
def salary_db_form():
    return render_template('salary.html')

@app.route('/salary', methods=['POST'])
def salary_db_query():
    query_string = request.form['text']
    try:
        salary = int(query_string)
        query = F"SELECT e.emp_no, e.last_name, e.first_name, d.dept_name, s.salary FROM employees AS e LEFT JOIN dept_emp AS de ON e.emp_no=de.emp_no INNER JOIN departments AS d ON d.dept_no=de.dept_no RIGHT JOIN salaries AS s ON e.emp_no=s.emp_no WHERE de.to_date='9999-01-01' AND s.salary>={salary} LIMIT 10;"
        results = ''
        query_string_out = ''
        results = engine.execute(query).fetchall()
        query_string_out = 'You entered: \"'+query_string+'\"'
        sql_string_out = F"SELECT e.emp_no, e.last_name, e.first_name, d.dept_name, s.salary \n FROM employees AS e \n LEFT JOIN dept_emp AS de \n ON e.emp_no=de.emp_no \n INNER JOIN departments AS d \n ON d.dept_no=de.dept_no \n RIGHT JOIN salaries AS s \n ON e.emp_no=s.emp_no \n WHERE de.to_date='9999-01-01' AND s.salary>={salary} \n LIMIT 10; \n"

        return render_template('salary.html', results=results, query_string_out = query_string_out, sql_string_out=sql_string_out)
    except:
        sql_string_out = "Error: salary must be an integer"
        results = []
        query_string_out = 'You entered: \"'+query_string+'\"'
        return render_template('salary.html', results=results, query_string_out = query_string_out, sql_string_out=sql_string_out)

@app.route('/title')
def title_db_form():
    return render_template('title.html')

@app.route('/title', methods=['POST'])
def title_db_query():
    query_string = request.form['text']

    query = F"SELECT title, count(ID) FROM titles WHERE to_date='9999-01-01' GROUP BY title HAVING count(ID)>{query_string} LIMIT 10;"
    results = ''
    query_string_out = ''
    results = engine.execute(query).fetchall()
    query_string_out = 'You entered: \"'+query_string+'\"'
    sql_string_out = F"SELECT title, count(ID) \n FROM titles \n WHERE to_date='9999-01-01' \n GROUP BY title \n HAVING count(ID)>{query_string} \n LIMIT 10; \n"

    return render_template('title.html', results=results, query_string_out = query_string_out, sql_string_out=sql_string_out)

if __name__ == '__main__':

    app.run(debug=True)
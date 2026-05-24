/*-- Create a high-retention environment
CREATE OR REPLACE DATABASE architect_demo 
    DATA_RETENTION_TIME_IN_DAYS = 90; 

CREATE OR REPLACE SCHEMA time_travel_lab;

-- This table inherits the 90 days from the database
CREATE OR REPLACE TABLE employee_salary (
    id INT,
    name STRING,
    salary INT
);

INSERT INTO employee_salary VALUES (1, 'Kunal', 5000), (2, 'Ajay', 6000), (3, 'Manaber', 90000);*/

SET ts_before_disaster=CURRENT_TIMESTAMP();

Select * from employee_Salary;

update employee_Salary set salary=999999;

select * from employee_Salary BEFORE (TIMESTAMP=> $ts_before_disaster);

SELECT * FROM EMPLOYEE_SALARY AT (OFFSET=> -60*4);

sELECT * FROM EMPLOYEE_SALARY BEFORE (STATEMENT => '01c3f2e7-0308-9703-0027-be63001e2ae');


DROP TABLE EMPLOYEE_SALARY;

UNDROP TABLE EMPLOYEE_SALARY;






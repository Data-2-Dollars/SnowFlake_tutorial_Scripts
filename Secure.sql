create or replace table Employees(
employeeID INT PRIMARY KEY,
EMPLOYEENAME VARCHAR,
ROLE VARCHAR
);


INSERT INTO Employees (EmployeeID, EmployeeName, Role) VALUES (1, 'Mahesh', 'AccountAdmin');
INSERT INTO Employees (EmployeeID, EmployeeName, Role) VALUES (2, 'Suresh', 'AccountAdmin');
INSERT INTO Employees (EmployeeID, EmployeeName, Role) VALUES (3, 'Mayank', 'SysAdmin');
INSERT INTO Employees (EmployeeID, EmployeeName, Role) VALUES (4, 'Shruti', 'SysAdmin');
INSERT INTO Employees (EmployeeID, EmployeeName, Role) VALUES (5, 'Vaibhav', 'UserAdmin');
INSERT INTO Employees (EmployeeID, EmployeeName, Role) VALUES (6, 'Sami', 'UserAdmin');


CREATE OR REPLACE SECURE VIEW VW_EMP AS 
SELECT * FROM EMPLOYEES WHERE UPPER(ROLE)=CURRENT_ROLE();


SELECT * FROM VW_EMP;

SELECT GET_DDL('VIEW','ANALYST_DB.PUBLIC.VW_EMP');
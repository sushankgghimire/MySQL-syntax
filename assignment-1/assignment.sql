/*
employee(employee-name, street, city)
works(employee-name, company-name, salary)
company(company-name, city)
manages (employee-name, manager-name)
*/

CREATE DATABASE db_Company;
USE db_Company;

-- QN 1
CREATE TABLE Tbl_employee (
    employee_name VARCHAR(64) NOT NULL PRIMARY KEY,
    street VARCHAR(32),
    city VARCHAR(32)
);


CREATE TABLE Tbl_Company (
    company_name VARCHAR(64) NOT NULL PRIMARY KEY,
    city VARCHAR(32)
);


CREATE TABLE Tbl_works (
    employee_name VARCHAR(64) NOT NULL PRIMARY KEY,
    company_name VARCHAR(64),
    salary FLOAT,
    FOREIGN KEY (employee_name)
        REFERENCES Tbl_employee (employee_name),
    FOREIGN KEY (company_name)
        REFERENCES Tbl_Company (company_name)
);



CREATE TABLE Tbl_manages (
    employee_name VARCHAR(64) NOT NULL PRIMARY KEY,
    manager_name VARCHAR(64) NOT NULL,
    FOREIGN KEY (employee_name)
        REFERENCES Tbl_employee (employee_name)
);

INSERT INTO Tbl_employee(employee_name, street, city)
VALUES ('Sushank', 'Nilgirigalli', 'Kathmandu'),
('Pratigya', 'Prithivi Chowk', 'Pokhara'),
('Sujan', 'Hattiban', 'Lalitpur'),
('Samir', 'Damauli', 'Pokhara'),
('Rajin', 'SB', 'Bhaktapur'),
('Pratima', 'Raniban', 'Budhanilkantha'),
('Rashmi', 'UN Park', 'Dolakha'),
('Bikrant', 'UN PARK', 'Kathmandu');

SELECT 
    *
FROM
    Tbl_employee;

INSERT INTO Tbl_Company(company_name, city)
VALUES ('GAS Nepal', 'Lalitpur'),
        ('MSI Corporated','Kathmandu'),
        ('First Bank Corporation','Bhaktapur'),
        ('Small Bank Corporation','Bhaktapur');

SELECT 
    *
FROM
    Tbl_Company;

INSERT INTO tbl_Works(employee_name, company_name, salary)
VALUES ('Sushank', 'GAS Nepal', 100000),
('Pratigya', 'MSI Corporated', 98000),
('Sujan', 'First Bank Corporation', 50000),
('Samir', 'Small Bank Corporation', 12000),
('Rajin', 'Small Bank Corporation', 19000),
('Pratima', 'MSI Corporated', 200),
('Rashmi', 'First Bank Corporation', 500),
('Bikrant', 'GAS Nepal', 10000);

SELECT 
    *
FROM
    Tbl_works;

INSERT INTO Tbl_manages(employee_name, manager_name)
VALUES ('Bikrant', 'Sushank'),
('Pratima', 'Pratigya'),
('Rashmi', 'Sujan'),
('Samir', 'Rajin');

SELECT 
    *
FROM
    Tbl_manages;

-- 2a.  Find the names of all employees who work for First Bank Corporation

SELECT 
    em.employee_name
FROM
    tbl_employee AS em
WHERE
    em.employee_name = ANY (SELECT DISTINCT
            wk.employee_name
        FROM
            tbl_works AS wk
        WHERE
            wk.company_name = 'First Bank Corporation');

-- Using Join Statement
SELECT 
    em.employee_name
FROM
    tbl_employee AS em
        INNER JOIN
    tbl_works ON em.employee_name = tbl_works.employee_name
WHERE
    tbl_works.company_name = 'First Bank Corporation';

-- 2b. Find the names and cities of residence of all employees who work for First Bank Corporation.

SELECT 
    em.employee_name, em.city
FROM
    tbl_employee AS em
WHERE
    em.employee_name = ANY (SELECT DISTINCT
            wk.employee_name
        FROM
            tbl_works AS wk
        WHERE
            wk.company_name = 'First Bank Corporation');

-- Using Join Statement
SELECT 
    em.employee_name, em.city
FROM
    tbl_employee AS em
        INNER JOIN
    tbl_works ON em.employee_name = tbl_works.employee_name
WHERE
    tbl_works.company_name = 'First Bank Corporation';

-- 2c. Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000.

SELECT 
    em.employee_name, em.street, em.city
FROM
    tbl_employee AS em
WHERE
    em.employee_name = ANY (SELECT 
            wk.employee_name
        FROM
            tbl_works AS wk
        WHERE
            wk.company_name = 'First Bank Corporation'
                AND wk.salary > 10000);

-- using join
SELECT 
    em.employee_name, em.street, em.city
FROM
    tbl_employee AS em
        INNER JOIN
    tbl_works AS wk ON em.employee_name = wk.employee_name
WHERE
    wk.company_name = 'First Bank Corporation'
        AND wk.salary > 10000;


-- 2d.  Find all employees in the database who live in the same cities as the companies for which they work.

SELECT 
    em.employee_name, em.city
FROM
    tbl_employee AS em
WHERE
    em.city = (SELECT 
            cp.city
        FROM
            tbl_Company AS cp
        WHERE
            cp.company_name = (SELECT 
                    wk.company_name
                FROM
                    tbl_Works AS wk
                WHERE
                    wk.employee_name = em.employee_name));

-- using Join
SELECT 
    em.employee_name, em.city
FROM
    tbl_employee AS em
        INNER JOIN
    tbl_works AS wk ON em.employee_name = wk.employee_name
        INNER JOIN
    tbl_company AS cp ON wk.company_name = cp.company_name
WHERE
    cp.city = em.city;

-- creating data that fits the criterion for qn 2e
INSERT INTO Tbl_employee
VALUES('Nishant Uprety', 'Nilgirigalli', 'Kathmandu');

INSERT INTO tbl_Works(employee_name, company_name, salary)
VALUES ('Nishant Uprety', 'GAS Nepal', 1000);

INSERT INTO Tbl_manages(employee_name, manager_name)
VALUES ('Nishant Uprety', 'Sushank');

-- 2e. Find all employees in the database who live in the same cities and on the same streets as do their managers
SELECT 
    mg.employee_name, mg.manager_name
FROM
    Tbl_manages AS mg
WHERE
    (SELECT 
            em.city
        FROM
            Tbl_employee AS em
        WHERE
            em.employee_name = mg.manager_name) = (SELECT 
            em.city
        FROM
            Tbl_employee AS em
        WHERE
            em.employee_name = mg.employee_name)
        AND (SELECT 
            em.street
        FROM
            Tbl_employee AS em
        WHERE
            em.employee_name = mg.manager_name) = (SELECT 
            em.street
        FROM
            Tbl_employee AS em
        WHERE
            em.employee_name = mg.employee_name);

-- Using Join
SELECT 
    mg.employee_name, mg.manager_name
FROM
    Tbl_manages AS mg
        INNER JOIN
    tbl_employee AS em ON mg.employee_name = em.employee_name
        INNER JOIN
    tbl_employee AS mag ON mg.manager_name = mag.employee_name
WHERE
    em.city = mag.city
        AND em.street = mag.street;
        
-- 2f.  Find all employees in the database who do not work for First Bank Corporation

-- Using Sub Query
SELECT 
    employee_name
FROM
    tbl_works
WHERE
    company_name != 'First Bank Corporation';
    
-- 2g. Find all employees in the database who earn more than each employee of Small Bank Corporation.

-- Using Sub Query
SELECT 
    employee_name
FROM
    tbl_works
WHERE
    (salary >= (SELECT 
            MAX(salary)
        FROM
            tbl_works
        WHERE
            company_name = 'Small Bank Corporation'));

-- Using Join

-- 2h.  Assume that the companies may be located in several cities. Find all companies located in every city in which Small Bank Corporation is located.
SELECT 
    *
FROM
    tbl_company
WHERE
    city = (SELECT 
            city
        FROM
            tbl_company
        WHERE
            company_name = 'Small Bank Corporation')
        AND NOT company_name = 'Small Bank Corporation'
;

-- 2i.  Find all employees who earn more than the average salary of all employees of their company.
SELECT 
    tbl_works.employee_name, tbl_works.company_name
FROM
    (SELECT 
        company_name, AVG(salary) AS average_salary
    FROM
        tbl_works
    GROUP BY company_name) AS avg_salary
        JOIN
    tbl_works ON avg_salary.company_name = tbl_works.company_name
WHERE
    tbl_works.salary > avg_salary.average_salary;
    
-- 2j. Find the company that has the most employees.
SELECT 
    company_name, employee_count
FROM
    (SELECT 
        company_name, COUNT(employee_name) AS employee_count
    FROM
        tbl_works
    GROUP BY company_name) as C1
ORDER BY employee_count DESC
LIMIT 1;

-- 2k. Find the company that has the smallest payroll.

SELECT 
    company_name, payroll
FROM
    (SELECT 
        company_name, SUM(salary) AS payroll
    FROM
        tbl_works
    GROUP BY company_name) AS total_payroll
ORDER BY payroll ASC
LIMIT 1;

-- 2l. Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation.

SELECT 
    company_name,average_salary
FROM
    (SELECT 
        company_name, AVG(salary) AS average_salary
    FROM
        tbl_works
    GROUP BY company_name) AS avg_salary
WHERE
    avg_salary.average_salary > (SELECT 
            avgs
        FROM
            (SELECT 
                company_name, AVG(salary) AS avgs
            FROM
                tbl_works
            GROUP BY company_name) AS avgs_salary
        WHERE
            avgs_salary.company_name = 'First Bank Corporation');
            
-- 3a. Modify the database so that Jones now lives in Newtown.

-- Preparing Data for no 3.
INSERT INTO Tbl_employee
VALUES('Jones', 'Thamel', 'Kathmandu');

INSERT INTO tbl_Works(employee_name, company_name, salary)
VALUES ('Jones', 'GAS Nepal', 15000);

INSERT INTO Tbl_manages(employee_name, manager_name)
VALUES ('Jones', 'Sushank');

UPDATE tbl_employee 
SET 
    city = 'New York',
    street = 'Times Square'
WHERE
    employee_name = 'Jones';
Select * from tbl_employee;

-- 3b.  Give all employees of First Bank Corporation a 10 percent raise.
UPDATE tbl_works 
SET 
    salary = salary * 1.1
WHERE
    company_name = 'First Bank Corporation';
Select * from tbl_works;

-- 3c. Give all managers of First Bank Corporation a 10 percent raise.

-- using sub query
UPDATE tbl_works 
SET 
    salary = salary * 1.1
WHERE
    employee_name = ANY (SELECT DISTINCT
            manager_name
        FROM
            tbl_manages)
        AND company_name = 'First Bank Corporation';

-- using join
UPDATE tbl_works
        INNER JOIN
    tbl_manages ON tbl_manages.manager_name = tbl_works.employee_name 
SET 
    salary = salary * 1.1
WHERE
    tbl_works.company_name = 'First Bank Corporation';
    
SELECT 
    *
FROM
    tbl_works;
    
-- 3d. Give all managers of First Bank Corporation a 10 percent raise unless the salary becomes greater than $100,000; in such cases, give only a 3 percent raise.

-- using sub query
UPDATE tbl_works 
SET 
    salary = IF(salary < 100000,
        salary * 1.1,
        salary * 1.03)
WHERE
    employee_name = ANY (SELECT DISTINCT
            manager_name
        FROM
            tbl_manages)
        AND company_name = 'First Bank Corporation';
        
-- using join        
UPDATE tbl_works
        INNER JOIN
    tbl_manages ON tbl_manages.manager_name = tbl_works.employee_name 
SET 
    salary = IF(salary < 100000,
        salary * 1.1,
        salary * 1.03)
WHERE
    tbl_works.company_name = 'First Bank Corporation';
    
SELECT 
    *
FROM
    tbl_works
WHERE
    company_name = 'First Bank Corporation'
        AND employee_name = ANY (SELECT DISTINCT
            manager_name
        FROM
            tbl_manages);
            
-- 3e.  Delete all tuples in the works relation for employees of Small Bank Corporation.

-- disable foreign key check for easier deletion
SET foreign_key_checks = 0;

DELETE tbl_works , tbl_employee , tbl_manages FROM tbl_works
        JOIN
    tbl_employee ON tbl_employee.employee_name = tbl_works.employee_name
        JOIN
    tbl_manages ON tbl_works.employee_name = tbl_manages.employee_name 
WHERE
    tbl_works.company_name = 'Small Bank Corporation';

-- now enable the foreign key check after deletion
SET foreign_key_checks = 1;
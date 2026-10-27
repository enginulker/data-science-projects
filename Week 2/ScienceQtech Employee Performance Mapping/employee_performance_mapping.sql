/* =====================================================================
   ScienceQtech Employee Performance Mapping  (MySQL 8.0+)
   ---------------------------------------------------------------------
   Run the whole file in MySQL Workbench or:
       mysql -u root -p < employee_performance_mapping.sql
   Task 1 : create database `employee` and load the three CSV files
            (data is embedded below as INSERT statements so the script
            is self-contained; LOAD DATA alternative shown in README).
   ===================================================================== */

DROP DATABASE IF EXISTS employee;
CREATE DATABASE employee;
USE employee;

CREATE TABLE proj_table (
    PROJECT_ID   VARCHAR(10)  PRIMARY KEY,
    PROJ_NAME    VARCHAR(100) NOT NULL,
    DOMAIN       VARCHAR(50),
    START_DATE   DATE,
    CLOSURE_DATE DATE,
    DEV_QTR      VARCHAR(5),
    STATUS       VARCHAR(20)
);

CREATE TABLE emp_record_table (
    EMP_ID      VARCHAR(10) PRIMARY KEY,
    FIRST_NAME  VARCHAR(50) NOT NULL,
    LAST_NAME   VARCHAR(50) NOT NULL,
    GENDER      CHAR(1),
    ROLE        VARCHAR(50),
    DEPT        VARCHAR(50),
    EXP         INT,
    COUNTRY     VARCHAR(50),
    CONTINENT   VARCHAR(50),
    SALARY      DECIMAL(10,2),
    EMP_RATING  INT,
    MANAGER_ID  VARCHAR(10),
    PROJ_ID     VARCHAR(10)
);

CREATE TABLE data_science_team (
    EMP_ID      VARCHAR(10) PRIMARY KEY,
    FIRST_NAME  VARCHAR(50) NOT NULL,
    LAST_NAME   VARCHAR(50) NOT NULL,
    GENDER      CHAR(1),
    ROLE        VARCHAR(50),
    DEPT        VARCHAR(50),
    EXP         INT,
    COUNTRY     VARCHAR(50),
    CONTINENT   VARCHAR(50)
);

-- ---------------------------------------------------------------- data
INSERT INTO emp_record_table VALUES
  ('E001', 'Arthur', 'Black', 'M', 'PRESIDENT', 'ALL', 20, 'USA', 'NORTH AMERICA', 16500, 5, NULL, NULL),
  ('E005', 'Eric', 'Hoffman', 'M', 'LEAD DATA SCIENTIST', 'FINANCE', 11, 'USA', 'NORTH AMERICA', 8500, 3, 'E103', 'P105'),
  ('E010', 'William', 'Butler', 'M', 'LEAD DATA SCIENTIST', 'AUTOMOTIVE', 12, 'FRANCE', 'EUROPE', 9000, 2, 'E428', 'P204'),
  ('E052', 'Dianna', 'Wilson', 'F', 'SENIOR DATA SCIENTIST', 'HEALTHCARE', 6, 'CANADA', 'NORTH AMERICA', 5500, 5, 'E083', 'P103'),
  ('E057', 'Dorothy', 'Wilson', 'F', 'SENIOR DATA SCIENTIST', 'HEALTHCARE', 9, 'USA', 'NORTH AMERICA', 7700, 1, 'E083', 'P302'),
  ('E083', 'Patrick', 'Voltz', 'M', 'MANAGER', 'HEALTHCARE', 15, 'USA', 'NORTH AMERICA', 9500, 5, 'E001', NULL),
  ('E103', 'Emily', 'Grove', 'F', 'MANAGER', 'FINANCE', 14, 'CANADA', 'NORTH AMERICA', 10500, 4, 'E001', NULL),
  ('E204', 'Karene', 'Nowak', 'F', 'SENIOR DATA SCIENTIST', 'AUTOMOTIVE', 8, 'GERMANY', 'EUROPE', 7500, 5, 'E428', 'P204'),
  ('E245', 'Nian', 'Zhen', 'M', 'SENIOR DATA SCIENTIST', 'RETAIL', 6, 'CHINA', 'ASIA', 6500, 2, 'E583', 'P109'),
  ('E260', 'Roy', 'Collins', 'M', 'SENIOR DATA SCIENTIST', 'RETAIL', 7, 'INDIA', 'ASIA', 7000, 3, 'E583', NULL),
  ('E403', 'Steve', 'Hoffman', 'M', 'ASSOCIATE DATA SCIENTIST', 'FINANCE', 4, 'USA', 'NORTH AMERICA', 5000, 3, 'E103', 'P105'),
  ('E428', 'Pete', 'Allen', 'M', 'MANAGER', 'AUTOMOTIVE', 14, 'GERMANY', 'EUROPE', 11000, 4, 'E001', NULL),
  ('E478', 'David', 'Smith', 'M', 'ASSOCIATE DATA SCIENTIST', 'RETAIL', 3, 'COLOMBIA', 'SOUTH AMERICA', 4000, 4, 'E583', 'P109'),
  ('E505', 'Chad', 'Wilson', 'M', 'ASSOCIATE DATA SCIENTIST', 'HEALTHCARE', 5, 'CANADA', 'NORTH AMERICA', 5000, 2, 'E083', 'P103'),
  ('E532', 'Claire', 'Brennan', 'F', 'ASSOCIATE DATA SCIENTIST', 'AUTOMOTIVE', 3, 'GERMANY', 'EUROPE', 4300, 1, 'E428', 'P204'),
  ('E583', 'Janet', 'Hale', 'F', 'MANAGER', 'RETAIL', 14, 'COLOMBIA', 'SOUTH AMERICA', 10000, 2, 'E001', NULL),
  ('E612', 'Tracy', 'Norris', 'F', 'MANAGER', 'RETAIL', 13, 'INDIA', 'ASIA', 8500, 4, 'E001', NULL),
  ('E620', 'Katrina', 'Allen', 'F', 'JUNIOR DATA SCIENTIST', 'RETAIL', 2, 'INDIA', 'ASIA', 3000, 1, 'E612', 'P406'),
  ('E640', 'Jenifer', 'Jhones', 'F', 'JUNIOR DATA SCIENTIST', 'RETAIL', 1, 'COLOMBIA', 'SOUTH AMERICA', 2800, 4, 'E612', 'P406');

INSERT INTO proj_table VALUES
  ('P103', 'Drug Discovery', 'HEALTHCARE', '2021-04-06', '2021-06-20', 'Q1', 'DONE'),
  ('P105', 'Fraud Detection', 'FINANCE', '2021-04-11', '2021-06-25', 'Q1', 'DONE'),
  ('P109', 'Market Basket Analysis', 'RETAIL', '2021-04-12', '2021-06-30', 'Q1', 'DELAYED'),
  ('P204', 'Supply Chain Management', 'AUTOMOTIVE', '2021-07-15', '2021-09-28', 'Q2', 'WIP'),
  ('P302', 'Early Detection of Lung Cancer', 'HEALTHCARE', '2021-10-08', '2021-12-18', 'Q3', 'YTS'),
  ('P406', 'Customer Sentiment Analysis', 'RETAIL', '2021-07-09', '2021-09-24', 'Q2', 'WIP');

INSERT INTO data_science_team VALUES
  ('E005', 'Eric', 'Hoffman', 'M', 'LEAD DATA SCIENTIST', 'FINANCE', 11, 'USA', 'NORTH AMERICA'),
  ('E010', 'William', 'Butler', 'M', 'LEAD DATA SCIENTIST', 'AUTOMOTIVE', 12, 'FRANCE', 'EUROPE'),
  ('E052', 'Dianna', 'Wilson', 'F', 'SENIOR DATA SCIENTIST', 'HEALTHCARE', 6, 'CANADA', 'NORTH AMERICA'),
  ('E057', 'Dorothy', 'Wilson', 'F', 'SENIOR DATA SCIENTIST', 'HEALTHCARE', 9, 'USA', 'NORTH AMERICA'),
  ('E204', 'Karene', 'Nowak', 'F', 'SENIOR DATA SCIENTIST', 'AUTOMOTIVE', 8, 'GERMANY', 'EUROPE'),
  ('E245', 'Nian', 'Zhen', 'M', 'SENIOR DATA SCIENTIST', 'RETAIL', 6, 'CHINA', 'ASIA'),
  ('E260', 'Roy', 'Collins', 'M', 'SENIOR DATA SCIENTIST', 'RETAIL', 7, 'INDIA', 'ASIA'),
  ('E403', 'Steve', 'Hoffman', 'M', 'ASSOCIATE DATA SCIENTIST', 'FINANCE', 4, 'USA', 'NORTH AMERICA'),
  ('E478', 'David', 'Smith', 'M', 'ASSOCIATE DATA SCIENTIST', 'RETAIL', 3, 'COLOMBIA', 'SOUTH AMERICA'),
  ('E505', 'Chad', 'Wilson', 'M', 'ASSOCIATE DATA SCIENTIST', 'HEALTHCARE', 5, 'CANADA', 'NORTH AMERICA'),
  ('E532', 'Claire', 'Brennan', 'F', 'ASSOCIATE DATA SCIENTIST', 'AUTOMOTIVE', 3, 'GERMANY', 'EUROPE'),
  ('E620', 'Katrina', 'Allen', 'F', 'JUNIOR DATA SCIENTIST', 'RETAIL', 2, 'INDIA', 'ASIA'),
  ('E640', 'Jenifer', 'Jhones', 'F', 'JUNIOR DATA SCIENTIST', 'RETAIL', 1, 'COLOMBIA', 'SOUTH AMERICA');


-- Relationships (added after loading so insert order does not matter)
ALTER TABLE emp_record_table
    ADD CONSTRAINT fk_emp_manager FOREIGN KEY (MANAGER_ID) REFERENCES emp_record_table(EMP_ID),
    ADD CONSTRAINT fk_emp_project FOREIGN KEY (PROJ_ID)    REFERENCES proj_table(PROJECT_ID);
ALTER TABLE data_science_team
    ADD CONSTRAINT fk_dst_emp FOREIGN KEY (EMP_ID) REFERENCES emp_record_table(EMP_ID);


/* ---------------------------------------------------------------------
   Task 2 : ER diagram  -> see the Mermaid ER diagram in README.md
   --------------------------------------------------------------------- */


/* Task 3 : EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT for every employee */
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT
FROM emp_record_table
ORDER BY DEPT, EMP_ID;


/* Task 4 : employees by rating band */
-- 4a. rating less than two
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table WHERE EMP_RATING < 2;

-- 4b. rating greater than four
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table WHERE EMP_RATING > 4;

-- 4c. rating between two and four
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table WHERE EMP_RATING BETWEEN 2 AND 4;


/* Task 5 : full name of Finance employees, alias NAME */
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME
FROM emp_record_table
WHERE DEPT = 'FINANCE';


/* Task 6 : employees who have someone reporting to them, with number of reporters
           (the President is included because managers report to him) */
SELECT m.EMP_ID, m.FIRST_NAME, m.LAST_NAME, m.ROLE,
       COUNT(e.EMP_ID) AS NUMBER_OF_REPORTERS
FROM emp_record_table m
JOIN emp_record_table e ON e.MANAGER_ID = m.EMP_ID
GROUP BY m.EMP_ID, m.FIRST_NAME, m.LAST_NAME, m.ROLE
ORDER BY NUMBER_OF_REPORTERS DESC;


/* Task 7 : Healthcare and Finance employees using UNION */
SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT FROM emp_record_table WHERE DEPT = 'HEALTHCARE'
UNION
SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT FROM emp_record_table WHERE DEPT = 'FINANCE';


/* Task 8 : employee details grouped by department with the department's max rating */
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT, EMP_RATING,
       MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS MAX_DEPT_RATING
FROM emp_record_table
ORDER BY DEPT, EMP_RATING DESC;


/* Task 9 : minimum and maximum salary per role */
SELECT ROLE,
       MIN(SALARY) AS MIN_SALARY,
       MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY ROLE
ORDER BY MAX_SALARY DESC;


/* Task 10 : rank employees by experience */
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP,
       RANK()       OVER (ORDER BY EXP DESC) AS EXP_RANK,
       DENSE_RANK() OVER (ORDER BY EXP DESC) AS EXP_DENSE_RANK
FROM emp_record_table;


/* Task 11 : view of employees in various countries with salary > 6000 */
CREATE OR REPLACE VIEW high_salary_employees AS
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
FROM emp_record_table
WHERE SALARY > 6000;

SELECT * FROM high_salary_employees ORDER BY COUNTRY, SALARY DESC;


/* Task 12 : nested query - employees with more than ten years of experience */
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
FROM emp_record_table
WHERE EMP_ID IN (SELECT EMP_ID FROM emp_record_table WHERE EXP > 10);


/* Task 13 : stored procedure - employees with more than three years of experience */
DROP PROCEDURE IF EXISTS get_experienced_employees;
DELIMITER $$
CREATE PROCEDURE get_experienced_employees()
BEGIN
    SELECT * FROM emp_record_table WHERE EXP > 3 ORDER BY EXP DESC;
END $$
DELIMITER ;

CALL get_experienced_employees();


/* Task 14 : stored function - does each data-science employee's role match the standard?
     EXP <= 2        -> JUNIOR DATA SCIENTIST
     2  < EXP <= 5   -> ASSOCIATE DATA SCIENTIST
     5  < EXP <= 10  -> SENIOR DATA SCIENTIST
     10 < EXP <= 12  -> LEAD DATA SCIENTIST
     12 < EXP <= 16  -> MANAGER                                            */
DROP FUNCTION IF EXISTS standard_job_profile;
DELIMITER $$
CREATE FUNCTION standard_job_profile(experience INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN experience <= 2  THEN 'JUNIOR DATA SCIENTIST'
        WHEN experience <= 5  THEN 'ASSOCIATE DATA SCIENTIST'
        WHEN experience <= 10 THEN 'SENIOR DATA SCIENTIST'
        WHEN experience <= 12 THEN 'LEAD DATA SCIENTIST'
        WHEN experience <= 16 THEN 'MANAGER'
        ELSE 'NOT DEFINED'
    END;
END $$
DELIMITER ;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP, ROLE AS ASSIGNED_ROLE,
       standard_job_profile(EXP) AS STANDARD_ROLE,
       IF(ROLE = standard_job_profile(EXP), 'MATCH', 'MISMATCH') AS PROFILE_CHECK
FROM data_science_team
ORDER BY EXP DESC;


/* Task 15 : index to speed up search for FIRST_NAME = 'Eric' */
-- Before: full table scan (type = ALL)
EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

CREATE INDEX idx_first_name ON emp_record_table(FIRST_NAME);

-- After: index lookup (type = ref, key = idx_first_name)
EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';


/* Task 16 : bonus = 5% of salary * employee rating */
SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING,
       ROUND(0.05 * SALARY * EMP_RATING, 2) AS BONUS
FROM emp_record_table
ORDER BY BONUS DESC;


/* Task 17 : average salary distribution by continent and country */
SELECT CONTINENT, COUNTRY,
       ROUND(AVG(SALARY), 2) AS AVG_SALARY_COUNTRY,
       ROUND(AVG(AVG(SALARY)) OVER (PARTITION BY CONTINENT), 2) AS AVG_OF_COUNTRIES_IN_CONTINENT,
       COUNT(*) AS EMPLOYEES
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY
ORDER BY CONTINENT, AVG_SALARY_COUNTRY DESC;

-- Continent level summary
SELECT CONTINENT, ROUND(AVG(SALARY), 2) AS AVG_SALARY, COUNT(*) AS EMPLOYEES
FROM emp_record_table
GROUP BY CONTINENT
ORDER BY AVG_SALARY DESC;

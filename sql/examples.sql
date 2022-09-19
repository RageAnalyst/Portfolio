podzielić eksplorację na kategorie: operacje na tekście, operacje na liczbach itd., funkcje analityczne

-- SIMPLE WORKS ON DATA

-- alphabetical display of the list of employees

SELECT id_employee ID, INITCAP(name)||' '|| INITCAP(surname) EMPLOYEES, SUBSTR(UPPER(name),1,1) 
|| '.' || SUBSTR(UPPER(surname),1,1) || '.' INITIALS
FROM employees
ORDER BY 1 ASC;


-- number of people employed in each department

SELECT INITCAP (d.name) DEPARTMENT, COUNT (e.id_p) NO_PEOPLE
FROM departments d JOIN employments e ON d.id_d = e.id_d
WHERE e.to IS NULL
GROUP BY d.name
ORDER BY NO_People DESC;


-- total annual salary and total annual salary with bonuses for employees hired in 3 quarter 

SELECT UPPER(name), UPPER(surname), 12*SALARY ANNUAL_SALARY, 12*SALARY+NVL(bonus,0) TOTAL_ANNUAL_SALARY
FROM employees
WHERE TO_CHAR(hire_date,'Q')='3'
ORDER BY 2, 1;


-- current date & time

SELECT TO_CHAR(SYSDATE, 'DD fmRM YYYY HH24:MI:SS')  "CURRENT DATE AND TIME"
FROM DUAL;


-- change character in text

SELECT surname, TRANSLATE(surname, 'WO', '*?') "SURNAME AFTER CHANGE V1", REPLACE(surname, 'SON', 'UMP') "SURNAME AFTER CHANGE V2"
FROM employees;


-- surnames with 'G' letter

-- way 1
SELECT surname
FROM employees
WHERE INSTR(surname, 'G') > 0;

-- way 2
SELECT surname
FROM employees
WHERE surname LIKE '%G%';


-- women with an even id employee

SELECT name, surname
FROM employees
WHERE sex='F' AND MOD(id_employee,2)=0;


-- courses according to lenght

SELECT name
FROM courses
ORDER BY LENGTH(name) DESC;


-- seniority

SELECT name, surname, pesel, FLOOR((SYSDATE - hire_date)) AS "Seniority in days", FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date)) AS "Seniority in months",
FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date)/12) AS "Seniority in years"
FROM employees
ORDER BY 6 DESC, 5 DESC, 4 DESC, 2 ASC;


-- employees hired between

SELECT surname, profession, hire_date
FROM employees
WHERE hire_date >= TO_DATE('2015/09/01', 'YYYY/MM/DD') AND hire_date <= TO_DATE('2021/11/30', 'YYYY/MM/DD');


-- average salary in individual establishment

SELECT name, ROUND(AVG(salary),6) AS "Average salary"
FROM establishments es JOIN employees em ON es.id_establishment = em.id_establishment
GROUP BY ROLLUP(es.name)
ORDER BY 1;


-- surnames of employees

SELECT surname ||'*'
FROM employees
WHERE id_establishment = 1
UNION ALL
SELECT surname
FROM employees
WHERE id_establishment != 1
ORDER BY 1;


-- count of employees in individual month

SELECT TO_CHAR(birthday_date, 'MONTH') AS Month, COUNT (id_employee) AS "Count of people"
FROM employees
GROUP BY ROLLUP(TO_CHAR(birthday_date, 'MONTH'))
ORDER BY 2;


-- average salary in individual profession

-- way 1

SELECT profession, sex, ROUND(AVG(salary), 2) AS "Average Salary"
FROM employees
GROUP BY ROLLUP(profession, sex)
ORDER BY 1, 2;

-- way 2

SELECT profession, sex, ROUND(AVG(salary), 2) AS "Average Salary"
FROM employees
GROUP BY CUBE (profession, sex)
ORDER BY 1, 2;


-- minimum salry in establishments and professions

SELECT es.name, emp.profession, MIN(emp.salary) AS "Minimum Salry"
FROM employees p JOIN establishments es ON emp.id_establishment = es.id_establishment
GROUP BY GROUPING SETS(es.name, emp.profession)
ORDER BY MIN(emp.salary) DESC;


-- the names of the months in which more than three person was employed

SELECT TO_CHAR (dfrom, 'MONTH') "Month", COUNT (id_p) "Count of persons"
FROM employments
GROUP BY TO_CHAR (dfrom, 'MONTH')
HAVING COUNT(id_p) > 3
ORDER BY 2 DESC;


-- positions with an average salary of more than 2,500 and less than 3,500

SELECT name AS "Position"
FROM positions JOIN employments
USING(id_pos)
GROUP BY name
HAVING AVG(salary) > 2500 AND AVG(salary) < 3500
ORDER BY 1 ASC;


-- names of departments with the currently average salary charge without the department with the highest average salary

CREATE VIEW average_s AS
SELECT INITCAP(d.name) department, AVG(e.salary) average_salary
FROM departments d JOIN employments e ON e.id_d = d.id_d
GROUP BY INITCAP(d.name);

SELECT department, average_salary
FROM average_s
WHERE average_salary < (SELECT MAX(average_salary) FROM average_s);

SELECT department, average_salary
FROM average_s
WHERE average_salary = (SELECT MAX(average_salary) FROM average_s);
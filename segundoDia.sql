
/**
mostrar la ciudad , nombre empleado
 y el mes  ( letra ) en el que entró en la empresa para todos los empleados
que llevan entre 30 y 40 años en la empresa o que su salario está entre 1500 y 3000
**/
SELECT dept.loc, emp.ename,emp.hiredate, TO_CHAR(emp.hiredate,'Month')
FROM emp
NATURAL JOIN dept
WHERE (MONTHS_BETWEEN(SYSDATE, hiredate)<(40*12)
      AND MONTHS_BETWEEN(SYSDATE, hiredate)>(30*12))
OR sal BETWEEN 1500 AND 3000;

/**
mostramos el grade, nombre ciudad, máximo salario
siempre que dicho máximo salario sea inferior a 5000 mostrando todos los grade aunque no tengan dpto. asociado
**/
SELECT loc, grade,MAX(sal)
FROM dept
RIGHT JOIN salgrade
ON dept.deptno = salgrade.grade
LEFT JOIN emp
on dept.deptno=emp.deptno
GROUP BY loc,grade
HAVING MAX(sal)<5000

--incrementar la comisión de los empleados de dallas en un 10% de su salario
UPDATE emp
SET comm=NVL(comm,0)+sal*.1
WHERE deptno = (SELECT deptno 
                FROM dept 
                WHERE loc='DALLAS');

--Borrar todos los empleados que no sean de NEW YORK
DELETE FROM emp
WHERE deptno <>(SELECT deptno FROM dept
              WHERE loc='NEW YORK')
OR deptno IS NULL;


--insert select 
INSERT INTO emp SELECT * FROM scott.emp;
--Buscar constraints
select * from user_constraints where table_name ='emp'



CREATE table genres(
codGen number(2) PRIMARY KEY  constraint ch_gnre_cod check(codGen>0),
genre varchar2(20) NOT NULL);



CREATE TABLE customers(
id  NUMBER(5) PRIMARY KEY,
cname VARCHAR(20) NOT NULL,
clastname varchar(20)NOT NULL)
registration_date DATE NOT NULL;

CREATE TABLE books(
isbn VARCHAR2(20) PRIMARY KEY,
bname VARCHAR2(50),
author VARCHAR2(50),
genre number(2) REFERENCES genres(codGen));


CREATE TABLE employees(

idemployee NUMBER(5) PRIMARY KEY,
ename VARCHAR2(20) NOT NULL,
elastname VARCHAR2(30) NOT NULL
hiredate DATE NOT NULL);

CREATE TABLE loan(
idemployee NUMBER(5) REFERENCES employees(idemployee),
idcustomer NUMBER(5) REFERENCES customers(id),
isbn VARCHAR2(20) REFERENCES books(isbn),
delivery_date DATE default(sysdate),
return_date DATE,
constraint pk_loan PRIMARY KEY(idemployee,idcustomer,isbn,delivery_date)
);









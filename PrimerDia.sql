--Numero empleados por cargo , no contengan s nobre,
--total de empleados por cargo superior a 2
SELECT count(*)
FROM emp
WHERE INSTR(LOWER(empno),'%s%')=0
GROUP BY job
having count(*) >2;

--Nombre de empleado (initcap ) meses en la emprea , suma de salario * comision
-- para aquellos que no son de dallas
SELECT INITCAP(ename) NOMBRE,
      ROUND(MONTHS_BETWEEN(sysdate,hiredate),2) MESES_EN_EMPRESA,
      sal+nvl(comm,0) "SALARIO+COMISION"
FROM emp
WHERE deptno NOT IN(SELECT deptno FROM dept
                  WHERE loc = 'DALLAS')           
AND (sal+ nvl(comm,0)) > (SELECT AVG(sal)
                        FROM emp
                        WHERE deptno= (SELECT deptno 
                                      FROM dept 
                                      WHERE loc LIKE 'DALLAS'));

--Ciudad y cargo codificado
SELECT dept.loc,
      CASE emp.job
      WHEN 'MANAGER' THEN 'jefe'
      WHEN 'ANALYST' THEN 'analista'
      ELSE 'otro' END,
      count(*)
FROM dept,emp
WHERE dept.deptno=emp.deptno
AND emp.hiredate NOT BETWEEN '01-01-1980' AND '31-12-1980'
GROUP BY dept.loc,emp.job
ORDER BY LOC;

SELECT dept.loc,
      CASE emp.job
      WHEN 'MANAGER' THEN 'jefe'
      WHEN 'ANALYST' THEN 'analista'
      ELSE 'otro' END CARGO,
      COUNT(*)
FROM dept,emp
WHERE dept.deptno=emp.deptno
AND emp.hiredate NOT BETWEEN '01-01-1980' AND '31-12-1980'
GROUP BY dept.loc,CASE emp.job
      WHEN 'MANAGER' THEN 'jefe'
      WHEN 'ANALYST' THEN 'analista'
      ELSE 'otro' END
ORDER BY dept.loc;


SELECT dept.dname,
      emp.ename,
      ABS(sal-salgrade.hisal) "Diferencia sobre máximo",
      ABS(sal-salgrade.losal) "Diferencia sobre mínimo"
FROM dept,emp,salgrade
WHERE emp.deptno=dept.deptno 
AND dept.deptno=salgrade.grade
AND emp.deptno =salgrade.grade;

inner Join
select c2,....cx 
from t1, t2 , t3
where t1.cx=t2.cn and t2.ca=t3.cb and ...

select t1.*, t2.* 
from t1 join t2 on ( t1.c1=t2.c2)
join t3 on ( t2.ca=t3.cb ) 
where condiciones...

Natural join
select t1.*, t2.* 
from t1 natural join t2 using (c1,..,cn)


Producto Cartesiano
select c2,....cx 
from t1, t2 , t3

select t1.*, t2.* 
from t1 cross join t2

Outer Join
select c2,....cx 
from t1, t2
where t1.cx=t2.cn (+)

select c2,....cx 
from t1, t2
where t1.cx(+)=t2.cn 

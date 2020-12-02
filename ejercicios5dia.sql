/*
realizar un procedimiento un cargo calcule el salario medio teniendo 
solo en cuenta aquellos salarios q están entre losal y hisal. Con dicho salario actualizamos la comisión  a los empleados  de Dallas
Con dicho salario actualizamos la comisión  a los empleados  de Dallas
 ( esto en el programa principal )
*/
DECLARE
avg_sal number(5,2);
BEGIN
  calcular_salario_medio_cargo('&cargo',avg_sal);
  IF avg_sal IS NOT NULL THEN
    UPDATE emp
    SET sal=avg_sal
    WHERE emp.deptno in(select deptno 
                      FROM dept
                      WHERE LOWER(d.loc) = LOWER('DALLAS'));
   dbms_output.put_line(SQL%ROWCOUNT);     
   END IF;
END;


CREATE OR REPLACE PROCEDURE 
calcular_salario_medio_cargo (cargo VARCHAR2,avg_sal OUT NUMBER)
  IS
   BEGIN
     SELECT AVG(sal) into avg_sal FROM emp e, salgrade s
     WHERE e.deptno=s.grade
     AND e.sal BETWEEN s.hisal AND s.losal;
END;
--FUNCTION METHOD
DECLARE
avg_sal number(5);
BEGIN
  avg_sal:=calcular_cargo_func('&cargo');
  IF avg_sal IS NOT NULL THEN
    UPDATE emp
    SET sal=avg_sal
    WHERE emp.deptno in(select deptno 
                      FROM dept
                      WHERE LOWER(loc) = LOWER('DALLAS'));
   dbms_output.put_line(SQL%ROWCOUNT);     
   END IF;
END;

CREATE OR REPLACE FUNCTION 
calcular_cargo_func (cargo VARCHAR2)
RETURN number
  AS
  avg_sal number;
   BEGIN
     SELECT AVG(sal) into avg_sal FROM emp e, salgrade s
     WHERE e.deptno=s.grade
     AND e.sal BETWEEN s.hisal AND s.losal;
     return (avg_sal);
END;


--PAQUETES 
CREATE PACKAGE
CREATE PACKAGE BODY

--SOBRECARGA

/*
Crear un paquete GESTION_DE_EMPLEADOS, en el que se declaren 2 procedimientos y una función:

- Procedure ALTA_EMP con tres argumentos: nombre del empleado, trabajo y jefe. Este
procedimiento debe insertar un empleado en la tabla EMP. El resto de los datos se
calcularán de la siguiente forma: el número de empleado será el siguiente al último
insertado, el departamento será el mismo que el de su jefe,  el salario se obtendrá del salario medio de su dpto, 
la fecha de alta la del sistema. La comisión,dependiendo del trabajo, si es salesman =0, si no lo es, comisión nula.

- FUnción BAJA_EMP con un argumento que es el número del empleado. Dado un número de empleado, borrarlo. 
Devolver en una variable boolean si el empleado fue borrado o no.

- Procedure MOD_EMP con dos argumentos. Dado un número de empleado, actualizar su
departamento. Informar si se ha podido realizar el cambio ( verificar si existe el numero empleado y/o numero de nuevo dpto )

Controlar las excepciones

*/

CREATE OR REPLACE PACKAGE GESTION_DE_EMPLEADOS
AS
  PROCEDURE alta_emp (nombre VARCHAR2, trabajo VARCHAR2, jefe NUMBER);
  FUNCTION baja_emp (emp_num NUMBER) RETURN BOOLEAN; 
  PROCEDURE mod_emp (emp_num NUMBER, dept_num NUMBER);
  
END GESTION_DE_EMPLEADOS;


CREATE OR REPLACE PACKAGE BODY GESTION_DE_EMPLEADOS
AS
  PROCEDURE alta_emp (nombre VARCHAR2, trabajo VARCHAR2, jefe NUMBER)
  IS
    emp_num NUMBER(5);
    avg_sal NUMBER(5);
    dept_jefe NUMBER(5);
    comm1 NUMBER(5);
  BEGIN
 
  
    SELECT DISTINCT deptno INTO dept_jefe
    FROM emp
    WHERE empno = jefe;
    SELECT MAX(empno) INTO emp_num
    FROM emp; 
   
    IF LOWER(trabajo) = LOWER('SALESMAN') 
    THEN comm1:=0;
    END IF;
  
    SELECT AVG(NVL(sal,0)) INTO avg_sal
    FROM emp
    WHERE deptno = dept_jefe;
    
    INSERT INTO emp(empno,ename,job,mgr,hiredate,sal,comm,deptno)
    VALUES (emp_num + 1,nombre,trabajo,jefe,sysdate,avg_sal,comm1,dept_jefe);
    dbms_output.put_line('Insertado con exito');
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('EL JEFE NO EXISTE');
  END alta_emp;

  FUNCTION baja_emp (emp_num number) RETURN BOOLEAN
  IS
    BEGIN
      DELETE FROM emp
      WHERE empno =emp_num;
    
      IF sql%rowcount <1
      THEN return FALSE;
      ELSE return TRUE;
      END IF;
      
    END baja_emp;
    
  
    PROCEDURE mod_emp (emp_num NUMBER, dept_num NUMBER)
    IS
    aux number(5);
    noemp EXCEPTION;
      BEGIN
        SELECT deptno into aux
        FROM dept
        WHERE deptno =dept_num;
        
        UPDATE emp
        SET deptno = aux
        WHERE empno = emp_num;
        IF sql%rowcount <1 THEN
        RAISE NOEMP;
        END IF;
      dbms_output.put_line('actualizado con exito');
      EXCEPTION 
      WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('el departamento no existe');
      WHEN NOEMP THEN
      dbms_output.put_line('el empleado no existe');
      END mod_emp;
     
END GESTION_DE_EMPLEADOS;



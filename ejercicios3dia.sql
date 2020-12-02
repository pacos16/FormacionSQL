/*
hacer un código pl que inserte en la tabla temp los siguientes valores:

*/
DECLARE 
texto varchar2(15);
BEGIN 
    FOR i IN 1..10
    LOOP 
        IF mod(i,2)=0 THEN
            texto := ' es par';
        ELSE
            texto := ' es impar';
        END IF;
        INSERT INTO temp1 VALUES (i, TO_CHAR(i)||texto);
    END LOOP;    
END;

/*
Actualizar el trabajo a DIRECTOR a todos aquellos empleados cuyo salario sea mayor que
2000$. Almacenar el número de empleados actualizados por la operación en la tabla TEMP. Si los
afectados son más de cinco personas, borrar los empleados cuyo salario sea mayor que 3000$,
insertar en la tabla TEMP el número de empleados borrados y validar la transacción.
*/

DECLARE 
rownums NUMERIC(10);
BEGIN
  UPDATE emp
  SET job = 'Director'
  WHERE sal>2000;
  rownums:=SQL%ROWCOUNT;
  INSERT INTO temp1 VALUES 
  (NULL,'se han actualizado '||rownums||' registros');
  IF rownums >5 THEN
    DELETE FROM emp
    WHERE sal > 3000;
    rownums:=SQL%ROWCOUNT;
    INSERT INTO temp1 VALUES
    (NULL,'se han borrado '||rownums||' registros');
  END IF;
END;

--PRINTF
BEGIN 
dbms_output.put_line('HOLA MUNDO');
END;

/*Solicitar al usuario un job. Si dicho Job no existe, mostrar un mensaje por pantalla. En caso
contrario, cambiar el salario de los empleados de Dallas, con la media del salario de los empleados
de dicho Job.
*/
DECLARE
  jobname emp.job%type;
  var emp.job%type;
  avgSalary emp.sal%type;
BEGIN
  jobname:='&insertJob';
  SELECT DISTINCT JOB INTO var FROM emp
  WHERE LOWER(job) = LOWER(jobname);

  SELECT AVG(sal) INTO avgSalary
  FROM emp
  WHERE job = JOBNAME;

  UPDATE emp
  SET sal= avgSalary
  WHERE deptno = (SELECT deptno FROM dept WHERE loc ='DALLAS');
  dbms_output.put_line(sql%rowcount||' Filas modificadas');
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  dbms_output.put_line(sqlcode||' '||sqlerrm);
END;







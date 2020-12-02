/*
DECLARE 
    nombre_excepcion EXCEPTION;
    PRAGMA EXCEPTION_INIT(nombre_excepcion,numero_error_oracle);
BEGIN 
RAISE nombre_exepcion;
RAISE_application_error (-20104,'Salario demasiado alto')
*/

/*
Solicitar tres valores que correspondan al número, nombre y localidad de un departamento.
Realizar un bloque PL/SQL12c que inserte en la tabla DEPT los valores que se han introducido. Controlar los
siguientes errores:
 Si el departamento ya existe, visualizar un mensaje de error
 Si algún datos de los insertados es de mayor longitud que la especificada en la tabla,
mostrar un mensaje de error
 Si se producen otros errores, insertar en la tabla TEMP el número y el mensaje del
error producido.
*/

DECLARE
  num_dept dept.deptno%type;
  name_dept dept.dname%type;
  loc_dept dept.loc%type;
  errm VARCHAR2(500);
  errnum NUMBER(6);
  
  tooLargeNumber EXCEPTION;
  PRAGMA EXCEPTION_INIT(tooLargeNumber,-01438);
  tooLargeVarchar EXCEPTION;
  PRAGMA EXCEPTION_INIT(tooLargeVarchar,-12899);
  
BEGIN 
  num_dept := &numero_dept;
  name_dept := '&nombre_departamento';
  loc_dept := '&localizacion_departamento';
  
  INSERT INTO dept (deptno,dname,loc)
  VALUES (num_dept,name_dept,loc_dept);
  
EXCEPTION
 WHEN tooLargeNumber THEN
 dbms_output.put_line(SQLERRM);
 WHEN tooLargeVarchar THEN 
 dbms_output.put_line(SQLERRM);
 WHEN DUP_VAL_ON_INDEX THEN
 dbms_output.put_line(sqlerrm);
 WHEN OTHERS THEN
 errm:= sqlerrm;
 errnum:=sqlcode;
 INSERT INTO temp1 values(errnum,errm);
END;
/*
Incrementar la comisión, en función del salario, de los empleados de Boston y Nueva York
según su antigüedad y cargo, según la siguiente tabla:

Boston:
 Antigüedad   Incremento
< 30 años 			10%
>=30 y <= 40 		15%
> 40 				20%


New York:
Director		1%
salesman 		12%
Otros 			17%
*/
DECLARE
  CURSOR cursor_name IS SELECT e.empno, e.ename,e.hiredate,e.job,e.sal,d.loc 
  FROM emp e,dept d
  WHERE d.deptno=e.deptno;
  filasAct NUMBER(10);
BEGIN 
  filasAct:=0;
  FOR reg IN cursor_name
  LOOP
    FETCH cursor_name INTO reg;
    IF LOWER(reg.loc) = LOWER('DALLAS')
      THEN CASE  
        WHEN reg.hiredate < ADD_MONTHS(sysdate,-12*40) 
        THEN UPDATE emp SET comm=NVL(comm,0)+sal*.2
        WHERE empno = reg.empno;

        filasAct:= filasAct+sql%rowcount;

        WHEN reg.hiredate < ADD_MONTHS(sysdate,-12*30) 
        THEN UPDATE emp SET comm=NVL(comm,0)+sal*.15
        WHERE empno = reg.empno;

        filasAct:= filasAct+sql%rowcount;

        ELSE UPDATE emp SET comm=NVL(comm,0)+sal*.1
        WHERE empno = reg.empno;

        filasAct:= filasAct+sql%rowcount;

        END CASE;
    END IF;
    
    IF LOWER(reg.loc) = LOWER('NEW YORK')
      THEN CASE  
        WHEN LOWER(reg.job) = LOWER('MANAGER') 
        THEN UPDATE emp SET comm=NVL(comm,0)+sal*.01
        WHERE empno = reg.empno;

        filasAct:= filasAct+sql%rowcount;

        WHEN LOWER(reg.job) = LOWER('ANALYST') 
        THEN UPDATE emp SET comm=NVL(
          comm,0)+sal*.12
        WHERE empno = reg.empno;
        filasAct:= filasAct+sql%rowcount;

        ELSE UPDATE emp SET comm=NVL(comm,0)+sal*.17
        WHERE empno = reg.empno;
        filasAct:= filasAct+sql%rowcount;

      END CASE;
    END IF;
  END LOOP;
  dbms_output.put_line(filasAct);
END;

/*
Con motivo del 10º aniversario de la Biblioteca, queremos
regalar unos libros a los socios más fieles. Para ello tendremos en cuenta la antigüedad, el uso de
la biblioteca, así como el sexo.
A los socios/as con mas de 3 años de antigüedad, le vamos a regalar 1 ó 2 libros dependiendo del
número de prestamos solicitados;
 Hombres:
o Se le regalará el ejemplar: ‘Las edades del Hombre’ si han solicitado 2 o menos libros
en los 2 últimos años.
o Si el número de prestamos es superior a 2, también se le regalará el ejemplar: 'Como España ganó el mundial'
 Mujeres:
o Se le regalará el ejemplar: ‘D. Quijote de la Mancha’. si han solicitado 2 o menos
libros en los 2 últimos años.
o Si el número de prestamos es superior a 2, también se le regalará el ejemplar: ‘La
vida es sueño’.
Realizar código que extrae el nombre del socio con los volúmenes a regalar. Mostrar también la
información de los socios que no tienen regalo, con el nombre del mismo y el texto ‘Sin regalo’.
*/

DECLARE
  CURSOR cursor_name IS SELECT * FROM customers;                
  aux NUMBER(10);
  price boolean;
BEGIN 
  
  FOR reg IN cursor_name
  LOOP
    IF reg.registration_date < ADD_MONTHS(SYSDATE,-3*12)
    THEN
      SELECT count(*) INTO aux
      FROM loans 
      WHERE idcustomer = reg.id
      AND delivery_date>ADD_MONTHS(SYSDATE,-2*12);
    
     FETCH cursor_name INTO reg;
      IF 2 < aux
        THEN price:=true;
        ELSE price:=false;
      END IF;
    
      CASE
      WHEN price AND LOWER(reg.sexo) = LOWER('V')
      THEN dbms_output.put_line(reg.cname||' '||reg.sexo||' '||'Las edades del Hombre, Como España ganó el mundial');
      WHEN NOT price AND LOWER(reg.sexo)= LOWER('V')
      THEN dbms_output.put_line(reg.cname||' '||reg.sexo||' '||'Las edades del Hombre');
      WHEN price AND LOWER(reg.sexo)= LOWER('H')
      THEN dbms_output.put_line(reg.cname||' '||reg.sexo||' '||'Don quijote, La vida es sueño');
      ELSE dbms_output.put_line(reg.cname||' '||reg.sexo||' '||'Don quijote');
     END CASE;
    ELSE dbms_output.put_line(reg.cname||' '||'NO TIENE PREMIO');
    END IF;
  END LOOP;

END;


--Suma tres numeros
CREATE OR REPLACE PROCEDURE suma(s1 number, s2 number, s3 number, total out number)
IS
BEGIN
total:= s1+s2+s3;
END;


select * from user_objects where object_type='PROCEDURE'

grant execute on jose.suma to public; 
create or replace procedure suma ( s1 in number, s2 number, s3 number, total out number)
is
begin
total:=s1 + s2 + s3;
end;

declare
sum_tot number(10);
begin
suma(&v1,&v2,&v3, sum_tot);
dbms_output.put_line ( 'LA SUMA ES ' || sum_tot);
end;


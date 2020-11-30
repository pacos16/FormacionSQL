-- Mostrar el código del genero, nombre del genero,
-- y el título de los libros asociados a cada genero

SELECT g.codGen, g.genre, b.bname
FROM books b,genres g
WHERE b.genre=g.codGen
ORDER BY g.codGen;
--1983


--Nombre del socio, título de los libros prestados en los dos 
--últimos años para aquellos socios dados de alta en los 3 últimos años
SELECT c.cname, b.bname
FROM loans l, customers c, books b
WHERE l.idcustomer=c.id AND l.isbn=b.isbn
AND l.delivery_date > ADD_MONTHS(SYSDATE,-24)
AND c.registration_date > ADD_MONTHS(SYSDATE,-36);
--3156

--Nombre del empleado, número distintos libros prestados a las 
--socias cuyo nombre finalice en ‘S’ y longitud superior a 5 caracteres.

SELECT e.ename, count(DISTINCT l.isbn) 
FROM employees e
INNER JOIN loans l
ON e.idemployee=l.idemployee
INNER JOIN customers c
ON l.idcustomer=c.id
WHERE c.cname LIKE '%s'
AND LENGTH(c.cname) >5
GROUP BY e.idemployee,e.ename;
--21

--Visualizar el nombre de todos los generos con los títulos de 
--los libros asociados incluyendo aquellos generos que no tienen libros
SELECT g.genre, b.bname 
FROM genres g
LEFT JOIN books b
ON g.codgen=b.genre;
--1985


--Buscar cada nombre de socio, título de libro y número de ejemplar
--incluyendo aquellos socios que no hayan solicitado ningún libro.

SELECT c.cname,b.bname,b.isbn
FROM customers c, loans l, books b
where c.id=l.idcustomer(+) AND l.isbn=b.isbn(+);
--6446

--Mostrar el empleado y nombre del socio al que han prestado libros 
--incluyendo aquellos empleados que no han prestado ningún libro

SELECT e.ename,c.cname
FROM employees e
LEFT JOIN loans l
ON e.idemployee = l.idemployee
LEFT JOIN customers c
ON l.idcustomer=c.id;
--6444

--Visualizar el nombre del socio y número de libros prestados
--en la actualidad
SELECT c.cname, count(*)
FROM customers c
INNER JOIN loans l
ON c.id=l.idcustomer
GROUP BY c.id,c.cname;
--35



--Visualizar el nombre del socio y nombre del empleado que le 
--ha atendido incluyendo socios que no han solicitado préstamos y 
--empleados que no han realizado préstamos

SELECT c.cname,e.ename
FROM customers c
LEFT JOIN loans l
ON c.id=l.idcustomer
FULL OUTER JOIN employees e
ON l.idemployee = e.idemployee;
--6447

--nombre de los socios que tienen prestado en la actualidad más
-- de un libro y nunca les ha atendido ningún empleado cuyo 
--nombre comienza por ‘J’
SELECT c.cname
FROM customers c
INNER JOIN loans l
ON c.id=l.idcustomer
WHERE l.return_date IS NULL
AND c.id NOT IN(SELECT DISTINCT l.idcustomer
                FROM loans l
                INNER JOIN employees e
                ON l.idemployee = e.idemployee
                WHERE e.ename LIKE 'J%')
GROUP BY c.id,c.cname
HAVING COUNT(*) > 1;
--7

--Identificar los números de socio que tienen realizado 
--algún prestamo en la actualidad
SELECT DISTINCT c.id
FROM customers c
INNER JOIN loans l
ON c.id=l.idcustomer
WHERE l.return_date IS NULL;
--35

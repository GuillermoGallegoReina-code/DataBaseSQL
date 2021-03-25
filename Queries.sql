--RENAME TABLE
--ALTER TABLE enfermero
--RENAME TO enfermo;

--1. Encuentre a todos los miembros del personal cuyo nombre empiece por 'H'.
select * FROM plantilla WHERE UPPER(apellido) LIKE 'H%';
--2. )Quienes son las enfermeras y enfermeros que trabajan en turnos de Tarde o Mañana?
select apellido FROM plantilla WHERE UPPER(funcion) in ('ENFERMERO','ENFERMERA') and UPPER (turno) in ('T','M');
--3. Haga un listado de las enfermeras que ganan entre 2.000.000 y 2.500.000 Pts.
select apellido,salario FROM plantilla WHERE salario BETWEEN 2000000 and 2500000 and UPPER(funcion) in ('ENFERMERA');
--4. Mostrar, para todos los hospitales, el código de hospital, el nombre completo del hospital y
--su nombre abreviado de tres letras (a esto podemos llamarlo ABR) Ordenar la recuperación por esta abreviatura.
select SUBSTRING(UPPER(nombre), 1, 3) AS ABR, hospital_cod ,nombre  FROM hospital ORDER BY 1;
---5. En la tabla DOCTOR otorgar a Cardiología un código de 1, a Psiquiatría un código de 2, 
--a Pediatría un código de 3 y a cualquier otra especialidad un código de 4. Recuperar todos los doctores, 
--su especialidad y el código asignado.

select doctor_no,especialidad,
	CASE 
		WHEN especialidad LIKE 'Cardiología' then 1
  		WHEN especialidad LIKE 'Psiquiatría' then 2
        WHEN especialidad LIKE 'Pediatría' then 3
    else 
        4
    end as CASIGNADO from doctor;

--6. Hacer un listado de los nombres de los pacientes y la posición de la primera letra 'A' que aparezca en su apellido, 
--tomando como referencia la primera letra del mismo
select apellido , POSITION ('A' IN UPPER(apellido)) AS posicion FROM enfermo;

--7. Queremos conseguir:
--COMENTARIO
--------------------
--El departamento de CONTABILIDAD esta en SEVILLA
--El departamento de INVESTIGACIÓN esta en MADRID
--El departamento de VENTAS esta en BARCELONA
--El departamento de PRODUCCIÓN esta en BILBAO

select 'El departamento de ' || dnombre || 'esta en '||loc comentario from dept2;

--8. Para cada empleado cuyo apellido contenga una "N", queremos que nos devuelva "nnn", 
--pero solo para la primera ocurrencia de la "N". La salida debe estar ordenada por apellido ascendentemente.

select SUBSTRING(apellido,1,POSITION('N' IN UPPER(apellido))-1)||'nnn'||SUBSTRING(apellido,POSITION('N' IN UPPER(apellido))+1) AS apellido

FROM empleado  WHERE UPPER(apellido) LIKE '%N%' ORDER BY apellido ASC;

---9. Para cada empleado se pide que salga su salario total (salario mas comisión) y 
--luego su salario fragmentado, es decir, en centenas de mil, decenas de mil... decenas y unidades.
--La salida debe estar ordenada por el salario y el apellido descendéntemente.

---SELECT coalesce(comisiÓn, 0) AS comisiÓn FROM empleado;

--Actualizar elemneso que esten Vacios
UPDATE empleado 
SET comisiÓn =  coalesce(comisiÓn, 0 );
select * FROM empleado;

--select apellido , (salario + comisiÓn) as TOTAL  FROM empleado order by 2 DESC, 1

--10. Para cada empleado que no tenga comisión o cuya comisión sea mayor que el 15% de su
--salario, se pide el salario total que tiene. Este será: si tiene comisión su salario mas 
--su comisión, y si no tiene, su salario mas su nueva comisión (15% del salario). La salida 
--deberá estar ordenada por el oficio y por el salario que le queda descendéntemente.

select DISTINCT(apellido),oficio, salario+coalesce(comisiÓn, salario*0.15 ) as SalarioTotal from empleado 
WHERE comisiÓn IS NULL or comisiÓn > salario*0.15 ORDER BY 2,3 DESC;

---11. Encuentre a todas las enfermeras y enfermeros con indicación del salario mensual de cada uno.
--TRUNC truncamos los valores
select apellido , TRUNC(salario/12) as MENSUAL FROM  plantilla WHERE funcion IN ('Enfermera','Enfermero');

---12. Que fecha fue hace tres semanas?
---select sysdate -21 fecha from dual

---13. Se pide el nombre, oficio y fecha de alta del personal del departamento 20 que ganan mas de 150000 ptas. mensuales.
select DISTINCT(apellido),oficio,to_char (fecha_alta, 'day month dd " de " yyyy hh24:mi') alta,salario FROM empleado WHERE salario > 150000 and dept_no = 20 ORDER BY salario;

---14. Se pide el nombre, oficio y el día de la semana en que han sido dados de alta los empleados 
--de la empresa, pero solo de aquellos cuyo día de alta haya sido entre martes y jueves. Ordenado por oficio.

select DISTINCT(apellido),oficio,to_char (fecha_alta, 'day month dd " de " yyyy hh24:mi') as alta,salario  FROM empleado WHERE
to_char (fecha_alta, 'day month dd " de " yyyy hh24:mi') LIKE '%thursday%' or to_char (fecha_alta, 'day month dd " de " yyyy hh24:mi')  LIKE '%tuesday%';

select DISTINCT(apellido),oficio,to_char (fecha_alta, 'DY') as alta,salario  FROM empleado WHERE 
to_char (fecha_alta, 'DY') in ('TUE','WED','THU') ORDER BY 2;

--15. Para todos los empleados, el día en que fueron dados de alta en la empresa debe estar ordenada por el día
--de la semana (Lunes, Martes ... Viernes) . Los días no laborables serán "Fin de semana".

select distinct(apellido),oficio,
CASE
	WHEN to_char (fecha_alta, 'DY') in ('MON') then  'Lunes'
	WHEN to_char (fecha_alta, 'DY') in ('TUE') then  'Martes'
	WHEN to_char (fecha_alta, 'DY') in ('WED') then  'Miercoles'
	WHEN to_char (fecha_alta, 'DY') in ('THU') then  'Jueves'
	WHEN to_char (fecha_alta, 'DY') in ('FRI') then  'Viernes'
	else
	'Fin de semana'
	end
	dia FROM empleado order by 3;
	
---CLÁUSULA GROUP BY



--16. Encontrar el salario medio de los Analistas.
select TRUNC(AVG(salario)) salarioMedio FROM empleado WHERE oficio LIKE 'ANALISTA';

--17. Encontrar el salario mas alto y el salario mas bajo de la tabla de empleados, así como la diferencia entre ambos.

select MAX(salario) maximo, MIN(salario) minimo , (MAX(salario) - MIN(salario)) diferencia FROM empleado;

--18. Calcular el numero de oficios diferentes que hay, en total, en los departamentos 10 y 20 de la empresa.
select oficio, COUNT(oficio) Noficio ,dept_no FROM empleado WHERE dept_no = 20 or dept_no = 10 GROUP BY (oficio,dept_no); 
select oficio, COUNT(oficio) Noficio  FROM empleado WHERE dept_no in (10,20) GROUP BY (oficio);
select COUNT(DISTINCT(oficio)) TOTAL  from empleado where dept_no in (10,20);

---19. Calcular el numero de personas que realizan cada oficio en cada departamento.
select dept_no,oficio,count(*) TOTAL  FROM empleado GROUP BY oficio,dept_no ORDER BY 1;


---20. Buscar que departamentos tienen mas de cuatro personas trabajando.
select  count(*) Personas ,dept_no   FROM empleado GROUP BY dept_no HAVING count(*) > 6;

---21. Buscar que departamentos tienen mas de dos personas trabajando en la misma profesión.
select count(*), dept_no ,oficio FROM empleado GROUP BY dept_no,oficio HAVING COUNT(*) > 2;

--22. Se desea saber el numero de empleados por departamento que tienen por oficio el de "EMPLEADO".
--La salida debe estar ordenada por el numero de departamento.
select count(*), dept_no TOTALEMPLEADO FROM empleado WHERE oficio LIKE 'EMPLEADO' GROUP BY oficio,dept_no ORDER BY TOTALEMPLEADO;


--23. Se desea saber el salario total (salario mas comisión) medio anual de los vendedores de nuestra empresa.
select   TRUNC(AVG(salario + coalesce(comisiÓn,0))) Total from empleado WHERE oficio LIKE 'VENDEDOR';

--24. Se desea saber el salario total (salario mas comisión) medio anual, tanto de los empleados como de los vendedores de nuestra empresa.

select   TRUNC(AVG(salario + coalesce(comisiÓn,0))) Total , oficio  from empleado WHERE oficio IN ('VENDEDOR','EMPLEADO') GROUP BY oficio;

---25. Se desea saber para cada departamento y en cada oficio, el maximo salario y la suma total de salarios, 
--pero solo de aquellos departamentos y oficios cuya suma salarial supere o sea igual que el 50% de su maximo salario.
--En el muestreo, solo se estudiaron a aquellos empleados que no tienen comisión o la tengan menor que el 25% de su salario.

select max(salario) MaximoSal,dept_no,oficio,sum(salario) TOTAL  FROM empleado GROUP BY (dept_no,oficio) HAVING sum(salario) >=  max(salario)*0.5 
ORDER BY 2;


--26. Se desea saber para cada oficio, dentro de cada año de alta distinto que existe en nuestra empresa, el numero de empleados y la media salarial 
--que tiene. Para este estudio, no se tendrá en cuenta a los empleados que no hayan sido dados de alta en un día laboral.
--Además, solo se desea saber estos datos, de aquellos oficios y años que tienen mas de un empleado. La salida debe estar ordenada por
--el año de alta y la media salarial descendéntemente.
select to_char(fecha_alta,'yyyy') alta, oficio,
count(*) "N1 EMPL", avg(salario) "MEDIA SALARIAL"
from empleado
where to_char(fecha_alta, 'd') not in ( '1','7')
group by to_char(fecha_alta, 'yyyy'), oficio
having count(*) > 1
order by 1, 4 DESC;



select  TRUNC(AVG(salario)),count(*),oficio , fecha_alta from empleado WHERE to_char (fecha_alta, 'DY') in ('MON','TUE','WED','THU','FRI')
GROUP BY fecha_alta,oficio ORDER BY oficio;

---27. Se desea saber, para cada inicial de apellido que exista en la empresa (tratando solo 
--las iniciales consonantes), el maximo salario que tiene asociada. No se tendrá en cuenta en el 
--estudio a aquellos empleados que contengan en su apellido mas de una "N". La salida debe estar ordenada por la inicial.

select MAX(salario) MAXSALARIO,SUBSTRING(apellido,1,1) FROM empleado WHERE SUBSTRING(apellido,1,1) NOT IN ('A','E','I','O','U')
GROUP BY SUBSTRING(apellido,1,1) ORDER BY  2;

---28. Se desea obtener un informe matriz como el que se presenta, en el que la coordenada vertical
--hace referencia a los distintos oficios existentes en la empresa, y la coordenada horizontal a los 
--distintos departamentos. Los valores de la matriz, indicaran la suma de salarios por oficio y departamento. 
--La ultima columna indica la suma total de salarios por oficio.

--to_char(fecha_alt, 'yyyy')

--select oficio, sum(coalesce(dept_no,10,salario,0)) dep10,
--sum(coalesce(dept_no,20,salario,0)) dep20,
--sum(coalesce(dept_no,30,salario,0)) dep30,
--sum(coalesce(dept_no,40,salario,0)) dep40,
--sum(salario) total
--from empleado group by oficio order by 6 desc

---29. Se desea saber para cada departamento y oficio, 
--la suma total de comisiones, teniendo en cuenta que para los empleados que no tienen comisión, 
--se les asignara:
-- El 10% de su salario si son del departamento 10.
-- El 15% de su salario si son del departamento 20.
-- El 17% de su salario si son del departamento 30.
-- Cualquier otro departamento, el 5% de su salario.
--No se tendrá en cuenta a los empleados que hayan sido dados 
--de alta después de 1981, ni al que ostente el cargo de "PRESIDENTE".

select  dept_no , oficio,
CASE
WHEN dept_no = 10 THEN sum(TRUNC(salario*0.10))
WHEN dept_no = 20 THEN sum(TRUNC(salario*0.15))
WHEN dept_no = 30 THEN sum(TRUNC(salario*0.17))
ELSE
	sum(TRUNC(salario*0.05))
END ComisionSal
FROM empleado
WHERE to_char(fecha_alta,'YYYY') LIKE '1981' and  oficio NOT LIKE 'PRESIDENTE'
GROUP BY dept_no,oficio,salario ORDER BY  dept_no;

--30.- Queremos saber el máximo, el mínimo y la media salarial, de cada departamento de la empresa.

SELECT TRUNC(max(coalesce(salario,0))) MaximSal , TRUNC(max(coalesce(salario,0))) MinSala , 
TRUNC(AVG(coalesce(salario,0))) MediaSala,dept_no
FROM empleado 
GROUP BY dept_no 
ORDER BY dept_no;


--COMBINACIONES TABLAS 
---31. Listar, a partir de las tablas EMP y DEPT2, 
--el nombre de cada empleado, su oficio, su numero de departamento 
--y el nombre del departamento donde trabajan.

select apellido, oficio, e.dept_no, dnombre
from empleado e, dept2 d
where e.dept_no = d.dept_no;

--32. Seleccionar los nombres, profesiones y localidades de los departamentos 
--donde trabajan los Analistas.

select  DISTINCT(e.apellido), d.dnombre, d.loc ,e.oficio
FROM empleado e , dept2 d
WHERE e.oficio LIKE 'ANALISTA'  and d.dept_no = e.dept_no;

--33. Se desea conocer el nombre y oficio de todos aquellos empleados que trabajan en Madrid.
--La salida deberá estar ordenada por el oficio.

SELECT distinct(e.apellido),e.oficio
FROM empleado e, dept2 d
WHERE d.loc LIKE 'MADRID' and d.dept_no = e.dept_no
ORDER BY e.oficio;

---34. se desea conocer cuantos empleados existen en cada departamento. 
--Devolviendo una salida como la que se presenta (deberá estar ordenada 
--por el numero de empleados descendéntemente).

select d.dept_no NUMP_DEP , d.dnombre DEPARTAMENTO , count(*) N_EMPL
FROM empleado e , dept2 d
WHERE e.dept_no = d.dept_no
GROUP BY d.dept_no, d.dnombre
ORDER BY N_EMPL DESC;


---35. Se desea conocer, tanto para el departamento de VENTAS, 
--como para el de CONTABILIDAD, su maximo, su mínimo y su media 
--salarial, así como el numero de empleados en cada departamento. 
--La salida deberá estar ordenada por el nombre del departamento, 
--y se deberá presentar como la siguiente:

select d.dnombre DNOMBRE, TRUNC(max(e.salario)) MAXIMO , 
TRUNC(min(e.salario)) MINIMO,
TRUNC(avg(e.salario)) MEDIA,
count(*) N_EMPL
from empleado e , dept2 d
WHERE d.dnombre IN ('VENTAS','CONTABILIDAD') and d.dept_no = e.dept_no
GROUP BY d.dnombre
ORDER BY d.dnombre;

--36. Se desea conocer el maximo salario que existe en 
--cada sala de cada hospital, dando el resultado como sigue:

select TRUNC(max(pl.salario)) MAXIMO,sl.nombre,hp.nombre
FROM plantilla pl , sala sl , hospital hp
WHERE hp.hospital_cod = pl.hospital_cod and
pl.sala_cod = sl.sala_cod
GROUP BY pl.hospital_cod,sl.nombre,hp.nombre
ORDER BY hp.nombre;

---37. Se desea obtener un resultado como el que aparece, 
--en el que se presenta el numero, nombre y oficio de cada 
--empleado de nuestra empresa que tiene jefe, y lo mismo de su jefe directo.
--La salida debe estar ordenada por el nombre del empleado.

select e.emp_n0 empleado, e.apellido nombre,
e.oficio oficio, e.dir jefe, e2.apellido nombre, e2.oficio oficio
from empleado e, empleado e2
where e.dir = e2.emp_n0
order by 2;

---38. Se desea conocer, para todos los departamentos existentes, 
--el mínimo salario de cada departamento, mostrando el resultado como aparece. 
--Para el muestreo del mínimo salario, no queremos tener en cuenta a las personas 
--con oficio de EMPLEADO. La salida estará ordenada por el salario descendéntemente.

select d.dnombre DEPARTAMENTO , min(e.salario) MINIMO
FROM dept2 d , empleado e 
WHERE e.oficio NOT LIKE 'EMPLEADO'  and e.dept_no = d.dept_no
GROUP BY d.dnombre
ORDER BY MINIMO DESC;

--Dejamos la 39 hasta 58 incluidos ambos

---59. Insertar en la tabla Plantilla al Garcia J. con un sueldo de 3000000 ptas, y 
--número de empleado 1234. Trabaja en el hospital 22, sala2.

--DELETE FROM plantilla WHERE apellido LIKE 'GarciaJ'
--INSERT INTO plantilla (hospital_cod,sala_cod,empleado_no,apellido,funcion,turno,salario)
--VALUES (22,2,1234,'Garcia J.','Enfermo', 'M',3000000);

--60. Insertar la misma fila anterior sin indicar en que campos se insertan. )
--Por qué no se indican?
--INSERT INTO plantilla 
--VALUES (22,2,1234,'Garcia J.','Enfermo', 'M',3000000);

--ACTUALIZACIONES
--63. Cambiar al paciente (tabla ENFERMO) número 74835 la dirección a Alcala 411.
--UPDATE enfermo
--SET direccion = 'Alacla411'
--WHERE inscripcion = 74835;
--64. Poner todas las direcciones de la tabla ENFERMO a null.
--UPDATE enfermo
--SET direccion = null

--65. Igualar la dirección y fecha de nacimiento del paciente
--10995 a los valores de las columnas correspondientes almacenadas para el paciente 14024.

UPDATE enfermo
SET (direccion, fecha_nac) =(select direccion, fecha_nac from enfermo where inscripcion = 14024)
WHERE inscripcion = 10995 

select * FROM enfermo WHERE inscripcion IN (10995,14024);

--66. En todos los hospitales del país se ha recibido un aumento del presupuesto,
--por lo que se incrementará el número de camas disponibles en un 10%. )Como se haría en SQL?.
--Habría que cambiar la estructura de la tabla pues es posible que cambie la longitud del campo.
--Modificamos con alter y después con update
--spool upd4
--create table hospitales2
--as select * from hospital
--alter table hospitales2
--modify num_cama number(4)
--update hospitales2
--set num_cama = num_cama + (num_cama*0.1)

--70. Crear la tabla EMPLEADOS con la misma estructura que la tabla Emp y 
--conteniendo los datos de oficio PRESIDENTE o comisión mayor que el 25% del salario.

DROP TABLE empleados;
create TABLE empleados as select * FROM empleado WHERE
oficio LIKE 'PRESIDENTE' or comisiÓn > salario*0.25;

select * FROM empleados;

--Crear una vista para los departamentos 10 y 20.
create view emp10 as
select *
from empleado
where dept_no in (10,20)

--ALTER TABLE Customers
--ADD Email varchar(255);






















































































































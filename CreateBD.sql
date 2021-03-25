CREATE TABLE HOSPITAL (
HOSPITAL_COD NUMERIC(2) NOT NULL ,
NOMBRE VARCHAR(10),
DIRECCION VARCHAR(20),
TELEFONO VARCHAR(8),
NUM_CAMA NUMERIC(3)
);

CREATE TABLE SALA (
HOSPITAL_COD NUMERIC(2) NOT NULL,
SALA_COD NUMERIC(2) NOT NULL,
NOMBRE VARCHAR(20),
NUM_CAMA NUMERIC(3)
);


CREATE TABLE PLANTILLA (
HOSPITAL_COD NUMERIC(2) NOT NULL,
SALA_COD NUMERIC(2) NOT NULL,
EMPLEADO_NO NUMERIC(4) NOT NULL,
APELLIDO VARCHAR(15),
FUNCION VARCHAR(10),
TURNO VARCHAR(1),
SALARIO NUMERIC(10)
);

CREATE TABLE OCUPACION(
INSCRIPCION NUMERIC(5) NOT NULL,
HOSPITAL_COD NUMERIC(2) NOT NULL,
SALA_COD NUMERIC(2) NOT NULL,
CAMA NUMERIC(4)
);

CREATE TABLE DOCTOR(
HOSPITAL_COD  NUMERIC(2) NOT NULL,
DOCTOR_NO NUMERIC(3) NOT NULL,
APELLIDO VARCHAR(13),
ESPECIALIDAD VARCHAR(16)
);

CREATE TABLE ENFERMERO(
INSCRIPCION NUMERIC(5) NOT NULL,
APELLIDO VARCHAR(15),
DIRECCION VARCHAR(20),
FECHA_NAC DATE,
S VARCHAR(1),
NSS NUMERIC(9)
);

CREATE TABLE EMPLEADO(
EMP_N0 NUMERIC(4) NOT NULL,
APELLIDO VARCHAR(10),
OFICIO VARCHAR(10),
DIR NUMERIC(4),
FECHA_ALTA DATE,
SALARIO NUMERIC(10),
COMISIÓN NUMERIC(10),
DEPT_NO NUMERIC(2) NOT NULL
);

CREATE TABLE DEPT2(
DEPT_NO NUMERIC(2) NOT NULL,
DNOMBRE VARCHAR(14),
LOC VARCHAR(14)
);


COPY HOSPITAL(HOSPITAL_COD,NOMBRE,DIRECCION,TELEFONO,NUM_CAMA)
FROM 'Data\Hosptial.csv'
DELIMITER ','
CSV HEADER;


COPY SALA(HOSPITAL_COD,SALA_COD,NOMBRE,NUM_CAMA)
FROM 'Data\SALA.csv'
DELIMITER ','
CSV HEADER;


COPY PLANTILLA(HOSPITAL_COD,SALA_COD,EMPLEADO_NO,APELLIDO,FUNCION,TURNO,SALARIO)
FROM 'Data\plantilla.csv'
DELIMITER ','
CSV HEADER;


COPY OCUPACION(INSCRIPCION,HOSPITAL_COD,SALA_COD,CAMA)
FROM 'Data\ocupacion.csv'
DELIMITER ','
CSV HEADER;


COPY DOCTOR(HOSPITAL_COD,DOCTOR_NO,APELLIDO,ESPECIALIDAD)
FROM 'Data\doctor.csv'
DELIMITER ','
CSV HEADER;

COPY ENFERMERO(INSCRIPCION,APELLIDO,DIRECCION,FECHA_NAC,S,NSS)
FROM 'Data\Enfermo.csv'
DELIMITER ','
CSV HEADER;

COPY EMPLEADO(EMP_N0,APELLIDO,OFICIO,DIR,FECHA_ALTA,SALARIO,COMISIÓN,DEPT_NO)
FROM 'Data\empleado.csv'
DELIMITER ','
CSV HEADER;


COPY DEPT2(DEPT_NO,DNOMBRE,LOC)
FROM 'Data\DEPT2.csv'
DELIMITER ','
CSV HEADER;

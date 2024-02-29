CREATE TABLE clienti_DEF (
   codcl NUMBER (4) PRIMARY KEY,
   dencl VARCHAR2 (20),
   localit VARCHAR2(30) 
);

CREATE TABLE clienti_DEF1 (
   codcl NUMBER (4),
   dencl VARCHAR2 (20),
   localit VARCHAR2(30),
   CONSTRAINT pk_cl_def1_codcl PRIMARY KEY (codcl)
);

----

CREATE TABLE facturi_DEF (
   nrfact NUMBER (8) PRIMARY KEY,
   datafact DATE,
   codcl NUMBER (4) REFERENCES clienti_DEF (codcl),
   valoare NUMBER(10)
);


CREATE TABLE facturi_DEF1 (
   nrfact NUMBER (8),
   datafact DATE,
   codcl NUMBER (4),
   valoare NUMBER(10),
   CONSTRAINT pk_fact_def1_nrfact PRIMARY KEY (nrfact),
   CONSTRAINT fk_fact_def1_codcl FOREIGN KEY (codcl) REFERENCES clienti_DEF1 (codcl)
);

----

INSERT INTO clienti_DEF VALUES (10,'Popescu','Arad');
INSERT INTO clienti_DEF VALUES (20,'Georgescu','Timisoara');
INSERT INTO clienti_DEF VALUES (30,'Ionescu','Lugoj');
INSERT INTO clienti_DEF VALUES (40,'Radulescu','Timisoara');
INSERT INTO clienti_DEF VALUES (50,'Florescu','Arad');

DESCRIBE clienti_DEF;

SELECT * FROM clienti_DEF;

INSERT INTO clienti_DEF1 VALUES (10,'Popescu','Arad');

INSERT INTO clienti_DEF1 VALUES (20,'Georgescu');
INSERT INTO clienti_DEF1(codcl,dencl) VALUES (20,'Georgescu');

INSERT INTO clienti_DEF1(codcl,localit) VALUES (30,'Lugoj');

----

INSERT INTO facturi_DEF VALUES (101,TO_DATE('10.02.2023','dd.mm.yyyy'),10,2500);
INSERT INTO facturi_DEF VALUES (102,TO_DATE('15/02/2023','dd/mm/yyyy'),20,2800);
INSERT INTO facturi_DEF VALUES (103,TO_DATE('03/22/2023','mm/dd/yyyy'),30,2000);
INSERT INTO facturi_DEF VALUES (104,TO_DATE('04/21/23','mm/dd/yy'),40,1800);
INSERT INTO facturi_DEF VALUES (105,TO_DATE('2023/17/05','yyyy/dd/mm'),30,2700);
INSERT INTO facturi_DEF VALUES (106,TO_DATE('2023/06/10','yyyy/mm/dd'),10,1800);
INSERT INTO facturi_DEF VALUES (107,TO_DATE('22-06-2023','dd-mm-yyyy'),20,3000);
INSERT INTO facturi_DEF VALUES (108,TO_DATE('07-12-23','mm-dd-yy'),40,2800);
INSERT INTO facturi_DEF VALUES (109,TO_DATE('15/08/2023','dd/mm/yyyy'),20,1500);
INSERT INTO facturi_DEF VALUES (110,TO_DATE('17/09/2023','dd/mm/yyyy'),10,1700);
INSERT INTO facturi_DEF VALUES (111,TO_DATE('23/10/2023','dd/mm/yyyy'),30,1000);
INSERT INTO facturi_DEF VALUES (112,TO_DATE('14/11/2023','dd/mm/yyyy'),40,2400);

INSERT INTO facturi_DEF VALUES (113,TO_DATE('17/12/2023','dd/mm/yyyy'),60,1300);

INSERT INTO facturi_DEF1 VALUES (101,TO_DATE('10.02.2023','dd.mm.yyyy'),10,2500);
INSERT INTO facturi_DEF1 VALUES (102,TO_DATE('15/02/2023','dd/mm/yyyy'),20,2800);
INSERT INTO facturi_DEF1 VALUES (103,TO_DATE('03/22/2023','mm/dd/yyyy'),30,2000);
INSERT INTO facturi_DEF1 VALUES (105,TO_DATE('2023/17/05','yyyy/dd/mm'),30,2700);
INSERT INTO facturi_DEF1 VALUES (106,TO_DATE('2023/06/10','yyyy/mm/dd'),10,1800);
INSERT INTO facturi_DEF1 VALUES (107,TO_DATE('22-06-2023','dd-mm-yyyy'),20,3000);
INSERT INTO facturi_DEF1 VALUES (109,TO_DATE('15/08/2023','dd/mm/yyyy'),20,1500);
INSERT INTO facturi_DEF1 VALUES (110,TO_DATE('17/09/2023','dd/mm/yyyy'),10,1700);
INSERT INTO facturi_DEF1 VALUES (111,TO_DATE('23/10/2023','dd/mm/yyyy'),30,1000);

SELECT * FROM facturi_DEF;
SELECT * FROM facturi_DEF1;

----

ALTER TABLE clienti_DEF1 
ADD 
CONSTRAINT ck_codcl_def1 CHECK (codcl IN ('10','20')); 

ALTER TABLE clienti_DEF1 
ADD 
CONSTRAINT ck_codcl_def1 CHECK (codcl IN ('10','20', '30', '40', '50')); 

ALTER TABLE clienti_DEF1 
DROP 
CONSTRAINT ck_codcl_def1; 

----

ALTER TABLE facturi_DEF1 
ADD
luna NUMBER(2);

ALTER TABLE facturi_DEF1 
ADD 
an NUMBER(4); 

ALTER TABLE facturi_DEF1 
DROP 
COLUMN an; 

----

UPDATE facturi_DEF1 
SET luna=EXTRACT(MONTH FROM datafact);

UPDATE clienti_DEF1 
SET localit='Timisoara'
WHERE codcl=20;

UPDATE clienti_DEF1 
SET dencl='Ionescu'
WHERE codcl=30;

DELETE FROM facturi_DEF1 
WHERE nrfact=109;

----

DROP TABLE clienti_DEF1;

DROP TABLE facturi_DEF1;
DROP TABLE clienti_DEF1;

----

SELECT * FROM clienti_DEF;

SELECT nrfact, valoare, datafact
FROM facturi_DEF;

SELECT nrfact, valoare, datafact
FROM facturi_DEF
ORDER BY valoare;

SELECT nrfact, valoare, datafact
FROM facturi_DEF
ORDER BY 2 DESC;

----

SELECT nrfact, valoare, datafact
FROM facturi_DEF
WHERE valoare>=2000
ORDER BY valoare;

SELECT codcl, nrfact, valoare
FROM facturi_DEF
ORDER BY codcl;

SELECT codcl, nrfact, SUM(valoare)
FROM facturi_DEF
GROUP BY codcl, nrfact
ORDER BY codcl;

SELECT codcl, SUM(valoare) 
FROM facturi_DEF
GROUP BY codcl
ORDER BY codcl;

SELECT codcl, SUM(valoare) AS Total 
FROM facturi_DEF
GROUP BY codcl
ORDER BY codcl;

SELECT codcl, COUNT(nrfact) AS Nr_facturi, SUM(valoare) AS Total  
FROM facturi_DEF
GROUP BY codcl
ORDER BY codcl;

----

SELECT codcl, SUM(valoare) 
FROM facturi_DEF
GROUP BY codcl
ORDER BY SUM(valoare) DESC;

SELECT codcl, SUM(valoare) AS Total 
FROM facturi_DEF
GROUP BY codcl
ORDER BY Total DESC;

SELECT codcl, SUM(valoare) 
FROM facturi_DEF
GROUP BY codcl
ORDER BY SUM(valoare) DESC
;

SELECT codcl, valoare 
FROM facturi_DEF
ORDER BY valoare DESC
FETCH FIRST 3 ROWS ONLY;

SELECT codcl, SUM(valoare) AS Total 
FROM facturi_DEF
GROUP BY codcl
ORDER BY Total DESC;

SELECT codcl, SUM(valoare) AS Total, RANK()OVER(ORDER BY SUM(valoare) DESC)
FROM facturi_DEF
GROUP BY codcl;

SELECT codcl, SUM(valoare) AS Total, RANK()OVER(ORDER BY Total DESC)
FROM facturi_DEF
GROUP BY codcl;

SELECT codcl, SUM(valoare) AS Total, RANK()OVER(ORDER BY SUM(valoare) DESC) AS Loc
FROM facturi_DEF
GROUP BY codcl;

----

DROP TABLE FACTURI_DEF;
DROP TABLE CLIENTI_DEF;
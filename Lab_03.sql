CREATE TABLE clienti_DEF (
   codcl NUMBER (4) PRIMARY KEY,
   dencl VARCHAR2 (20),
   localit VARCHAR2(30) 
);

CREATE TABLE facturi_DEF (
   nrfact NUMBER (8) PRIMARY KEY,
   datafact DATE,
   codcl NUMBER (4) REFERENCES clienti_DEF (codcl),
   valoare NUMBER(10)
);

----------
DESCRIBE clienti_DEF;
DESCRIBE facturi_DEF;
----------------

BEGIN

INSERT INTO clienti_DEF VALUES (10,'Popescu','Arad');
INSERT INTO clienti_DEF VALUES (20,'Georgescu','Timisoara');
INSERT INTO clienti_DEF VALUES (30,'Ionescu','Lugoj');
INSERT INTO clienti_DEF VALUES (40,'Radulescu','Timisoara');
INSERT INTO clienti_DEF VALUES (50,'Florescu','Arad');

INSERT INTO clienti_DEF VALUES (60,'Petrescu','Timisoara');

INSERT INTO facturi_DEF VALUES (101,TO_DATE('10/02/2023','dd/mm/yyyy'),10,2500);
INSERT INTO facturi_DEF VALUES (102,TO_DATE('15/02/2023','dd/mm/yyyy'),20,2800);
INSERT INTO facturi_DEF VALUES (103,TO_DATE('22/03/2023','dd/mm/yyyy'),30,2000);
INSERT INTO facturi_DEF VALUES (104,TO_DATE('21/04/2023','dd/mm/yyyy'),40,1800);
INSERT INTO facturi_DEF VALUES (105,TO_DATE('17/05/2023','dd/mm/yyyy'),30,2700);
INSERT INTO facturi_DEF VALUES (106,TO_DATE('10/06/2023','dd/mm/yyyy'),10,1800);
INSERT INTO facturi_DEF VALUES (107,TO_DATE('22/06/2023','dd/mm/yyyy'),20,3000);
INSERT INTO facturi_DEF VALUES (108,TO_DATE('12/07/2023','dd/mm/yyyy'),40,2800);
INSERT INTO facturi_DEF VALUES (109,TO_DATE('15/08/2023','dd/mm/yyyy'),20,1500);
INSERT INTO facturi_DEF VALUES (110,TO_DATE('17/09/2023','dd/mm/yyyy'),10,1700);
INSERT INTO facturi_DEF VALUES (111,TO_DATE('23/10/2023','dd/mm/yyyy'),30,1000);
INSERT INTO facturi_DEF VALUES (112,TO_DATE('14/11/2023','dd/mm/yyyy'),40,2400);

INSERT INTO facturi_DEF VALUES (201,TO_DATE('12/03/2023','dd/mm/yyyy'),40,2100);
INSERT INTO facturi_DEF VALUES (202,TO_DATE('15/04/2023','dd/mm/yyyy'),10,1500);
INSERT INTO facturi_DEF VALUES (203,TO_DATE('11/05/2023','dd/mm/yyyy'),20,2200);
INSERT INTO facturi_DEF VALUES (204,TO_DATE('22/07/2023','dd/mm/yyyy'),30,1400);
INSERT INTO facturi_DEF VALUES (205,TO_DATE('24/08/2023','dd/mm/yyyy'),10,3000);
INSERT INTO facturi_DEF VALUES (206,TO_DATE('10/09/2023','dd/mm/yyyy'),40,2800);
INSERT INTO facturi_DEF VALUES (207,TO_DATE('14/10/2023','dd/mm/yyyy'),10,1200);
INSERT INTO facturi_DEF VALUES (209,TO_DATE('27/11/2023','dd/mm/yyyy'),20,1100);
INSERT INTO facturi_DEF VALUES (210,TO_DATE('14/12/2023','dd/mm/yyyy'),10,1900);
INSERT INTO facturi_DEF VALUES (211,TO_DATE('18/12/2023','dd/mm/yyyy'),60,2000);

END;
/

---------------
SELECT * FROM clienti_DEF;
SELECT * FROM facturi_DEF;
---------------

SELECT nrfact, valoare, datafact
FROM facturi_DEF
ORDER BY valoare;

SELECT codcl, valoare, datafact
FROM facturi_DEF
ORDER BY codcl;

----------------

SELECT nrfact, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl
ORDER BY valoare;

SELECT nrfact, dencl, valoare, datafact
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
ORDER BY 3;

SELECT codcl, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl
ORDER BY 1;

SELECT clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl
ORDER BY 1;

--------

SELECT clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND valoare>=2000
ORDER BY 1,3;

SELECT clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE valoare>=2000
ORDER BY 1,3;

---------------

SELECT clienti_DEF.codcl, dencl, valoare
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+)
ORDER BY 1;

SELECT clienti_DEF.codcl, dencl, valoare
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
ORDER BY 1;

SELECT clienti_DEF.codcl, dencl, NVL(valoare,0) AS Val
FROM facturi_DEF RIGHT JOIN clienti_DEF ON facturi_DEF.codcl=clienti_DEF.codcl
ORDER BY 1;

-----

SELECT clienti_DEF.codcl, dencl, valoare
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+) AND valoare>=2000
ORDER BY 1;

SELECT clienti_DEF.codcl, dencl, valoare
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE valoare>=2000
ORDER BY 1;

-----------------------------------------------

SELECT nrfact, clienti_DEF.codcl, dencl, SUM(valoare)
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+) 
GROUP BY nrfact, clienti_DEF.codcl, dencl
ORDER BY 2;


SELECT clienti_DEF.codcl, dencl, SUM(valoare)
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+) 
GROUP BY clienti_DEF.codcl, dencl
ORDER BY 1;


SELECT clienti_DEF.codcl, dencl, SUM(valoare), COUNT(nrfact)
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+) 
GROUP BY clienti_DEF.codcl, dencl
ORDER BY 1;

SELECT clienti_DEF.codcl, dencl, SUM(NVL(valoare,0)) AS Totval, COUNT(nrfact) AS Nrfacturi
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY clienti_DEF.codcl, dencl
ORDER BY 1;

-------

SELECT clienti_DEF.codcl, dencl, SUM(valoare), COUNT(nrfact)
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+) AND SUM(valoare)>=10000  
GROUP BY clienti_DEF.codcl, dencl 
ORDER BY SUM(valoare) DESC;

SELECT clienti_DEF.codcl, dencl, SUM(valoare), COUNT(nrfact)
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+)   
GROUP BY clienti_DEF.codcl, dencl
HAVING SUM(valoare)>=10000
ORDER BY SUM(valoare) DESC;

SELECT clienti_DEF.codcl, dencl, SUM(NVL(valoare,0)) AS Totval, COUNT(nrfact) AS Nrfacturi
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY clienti_DEF.codcl, dencl
HAVING Totval>=10000
ORDER BY SUM(NVL(valoare,0)) DESC;


SELECT clienti_DEF.codcl, dencl, SUM(NVL(valoare,0)) AS Totval, COUNT(nrfact) AS Nrfacturi
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY clienti_DEF.codcl, dencl
HAVING SUM(NVL(valoare,0))>=10000
ORDER BY Totval DESC;

----------

SELECT clienti_DEF.codcl, dencl, localit, AVG(valoare) AS medie_client
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl    
GROUP BY clienti_DEF.codcl, dencl, localit
ORDER BY dencl;

SELECT clienti_DEF.codcl, dencl, localit, AVG(valoare) AS medie_client
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND localit='Timisoara'   
GROUP BY clienti_DEF.codcl, dencl, localit
ORDER BY dencl;

SELECT clienti_DEF.codcl, dencl, localit, AVG(valoare) AS medie_client
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl   
GROUP BY clienti_DEF.codcl, dencl, localit
HAVING localit='Timisoara'
ORDER BY dencl;

SELECT clienti_DEF.codcl, dencl, localit, AVG(valoare) AS medie_client
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE localit='Timisoara'   
GROUP BY clienti_DEF.codcl, dencl, localit
ORDER BY dencl;

SELECT clienti_DEF.codcl, dencl, localit, AVG(valoare) AS medie_client
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY clienti_DEF.codcl, dencl, localit
HAVING localit='Timisoara'
ORDER BY dencl;

-----------

SELECT AVG(valoare)
FROM facturi_DEF;

SELECT ROUND(AVG(valoare),2) AS medie_facturi
FROM facturi_DEF;

SELECT clienti_DEF.codcl, dencl, valoare
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl   
ORDER BY valoare DESC;

SELECT clienti_DEF.codcl, dencl, valoare
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND valoare>(SELECT ROUND(AVG(valoare),2) AS medie_facturi
                                                       FROM facturi_DEF)   
ORDER BY valoare DESC;


SELECT clienti_DEF.codcl, dencl, valoare
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND valoare>(SELECT AVG(valoare)
                                                       FROM facturi_DEF)   
ORDER BY valoare DESC;

SELECT clienti_DEF.codcl, dencl, valoare
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE valoare>(SELECT AVG(valoare)
               FROM facturi_DEF)   
ORDER BY valoare DESC;

-----------

DROP TABLE FACTURI_DEF;
DROP TABLE CLIENTI_DEF;





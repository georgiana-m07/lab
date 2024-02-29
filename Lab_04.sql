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

CREATE TABLE incasari_DEF (
   codinc NUMBER (8) PRIMARY KEY,
   datainc DATE,
   nrfact NUMBER (8) REFERENCES facturi_DEF (nrfact),
   valinc NUMBER(10)
);

----------
DESCRIBE clienti_DEF;
DESCRIBE facturi_DEF;
DESCRIBE incasari_DEF;
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
INSERT INTO facturi_DEF VALUES (103,TO_DATE('22/03/2023', 'dd/mm/yyyy'),30,2000);
INSERT INTO facturi_DEF VALUES (104,TO_DATE('21/04/2023', 'dd/mm/yyyy'),40,1800);
INSERT INTO facturi_DEF VALUES (105,TO_DATE('17/05/2023', 'dd/mm/yyyy'),30,2700);
INSERT INTO facturi_DEF VALUES (106,TO_DATE('10/06/2023', 'dd/mm/yyyy'),10,1800);
INSERT INTO facturi_DEF VALUES (107,TO_DATE('22/06/2023','dd/mm/yyyy'),20,3000);
INSERT INTO facturi_DEF VALUES (108,TO_DATE('12/07/2023','dd/mm/yyyy'),40,2800);
INSERT INTO facturi_DEF VALUES (109,TO_DATE('15/08/2023','dd/mm/yyyy'),20,1500);
INSERT INTO facturi_DEF VALUES (110,TO_DATE('17/09/2023','dd/mm/yyyy'),10,1700);
INSERT INTO facturi_DEF VALUES (111,TO_DATE('23/10/2023','dd/mm/yyyy'),30,1000);
INSERT INTO facturi_DEF VALUES (112,TO_DATE('14/11/2023','dd/mm/yyyy'),40,2400);
INSERT INTO facturi_DEF VALUES (201,TO_DATE('12/03/2023','dd/mm/yyyy'),40,2100);
INSERT INTO facturi_DEF VALUES (202,TO_DATE('15/04/2023','dd/mm/yyyy'),10,1500);
INSERT INTO facturi_DEF VALUES (203,TO_DATE('11/05/2023', 'dd/mm/yyyy'),20,2200);
INSERT INTO facturi_DEF VALUES (204,TO_DATE('22/07/2023', 'dd/mm/yyyy'),30,1400);
INSERT INTO facturi_DEF VALUES (205,TO_DATE('24/08/2023', 'dd/mm/yyyy'),10,3000);
INSERT INTO facturi_DEF VALUES (206,TO_DATE('10/09/2023', 'dd/mm/yyyy'),40,2800);
INSERT INTO facturi_DEF VALUES (207,TO_DATE('14/10/2023', 'dd/mm/yyyy'),10,1200);
INSERT INTO facturi_DEF VALUES (209,TO_DATE('27/11/2023', 'dd/mm/yyyy'),20,1100);
INSERT INTO facturi_DEF VALUES (210,TO_DATE('14/12/2023', 'dd/mm/yyyy'),10,1900);
INSERT INTO facturi_DEF VALUES (211,TO_DATE('18/12/2023', 'dd/mm/yyyy'),60,2000);

INSERT INTO incasari_DEF VALUES (1011,TO_DATE('10/03/2023', 'dd/mm/yyyy'),101,200);
INSERT INTO incasari_DEF VALUES (1012,TO_DATE('10/04/2023', 'dd/mm/yyyy'),101,200);
INSERT INTO incasari_DEF VALUES (1041,TO_DATE('21/05/2023', 'dd/mm/yyyy'),104,150);
INSERT INTO incasari_DEF VALUES (1042,TO_DATE('21/06/2023', 'dd/mm/yyyy'),104,150);
INSERT INTO incasari_DEF VALUES (1071,TO_DATE('22/07/2023', 'dd/mm/yyyy'),107,250);
INSERT INTO incasari_DEF VALUES (1072,TO_DATE('22/08/2023', 'dd/mm/yyyy'),107,250);
INSERT INTO incasari_DEF VALUES (1101,TO_DATE('17/10/2023', 'dd/mm/yyyy'),110,100);
INSERT INTO incasari_DEF VALUES (2011,TO_DATE('12/04/2023', 'dd/mm/yyyy'),201,180);
INSERT INTO incasari_DEF VALUES (2012,TO_DATE('12/05/2023', 'dd/mm/yyyy'),201,180);
INSERT INTO incasari_DEF VALUES (2013,TO_DATE('12/06/2023', 'dd/mm/yyyy'),201,180);
INSERT INTO incasari_DEF VALUES (2051,TO_DATE('24/09/2023', 'dd/mm/yyyy'),205,280);
INSERT INTO incasari_DEF VALUES (2052,TO_DATE('24/10/2023', 'dd/mm/yyyy'),205,280);
INSERT INTO incasari_DEF VALUES (2091,TO_DATE('27/12/2023', 'dd/mm/yyyy'),209,80);

END;
/

---------------
SELECT * FROM clienti_DEF;
SELECT * FROM facturi_DEF;
SELECT * FROM icasari_DEF;
---------------

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+) AND (clienti_DEF.codcl=10 OR clienti_DEF.codcl=30 OR clienti_DEF.codcl=50)
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE clienti_DEF.codcl=10 OR clienti_DEF.codcl=30 OR clienti_DEF.codcl=50
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+) AND clienti_DEF.codcl IN (10,30,50)
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE clienti_DEF.codcl IN (10,30,50)
ORDER BY 2,4;

----

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND valoare>=1500 AND valoare<=2400
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND valoare BETWEEN 1500 AND 2400
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND (valoare<1500 OR valoare>2400)
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE valoare<1500 OR valoare>2400
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND valoare NOT BETWEEN 1500 AND 2400
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, datafact
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE valoare NOT BETWEEN 1500 AND 2400
ORDER BY 2,4;

-------
SELECT facturi_DEF.nrfact, valoare, datafact, codinc, valinc
FROM facturi_DEF,incasari_DEF
WHERE facturi_DEF.nrfact=incasari_DEF.nrfact(+) AND codinc IS NULL
ORDER BY datafact;

SELECT facturi_DEF.nrfact, valoare, datafact, codinc, valinc
FROM facturi_DEF LEFT JOIN incasari_DEF ON facturi_DEF.nrfact=incasari_DEF.nrfact
WHERE codinc IS NOT NULL
ORDER BY 3;

SELECT clienti_DEF.codcl, dencl, facturi_DEF.nrfact, valoare, datafact, codinc, valinc
FROM clienti_DEF,facturi_DEF,incasari_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND facturi_DEF.nrfact=incasari_DEF.nrfact(+) AND codinc IS NULL
ORDER BY dencl;

SELECT clienti_DEF.codcl, dencl, facturi_DEF.nrfact, valoare, datafact, codinc, valinc
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl LEFT JOIN incasari_DEF ON facturi_DEF.nrfact=incasari_DEF.nrfact 
WHERE codinc IS NULL
ORDER BY dencl;

-----------

ALTER TABLE facturi_DEF ADD 
cota_tva NUMBER(3,2);

UPDATE facturi_DEF  
SET cota_tva=
CASE 
WHEN nrfact IN (102, 105, 203, 206) THEN 0.05
WHEN nrfact IN (104, 107, 207, 210) THEN 0.10
ELSE 0.19
END;

SELECT * From facturi_DEF;

SELECT nrfact, clienti_DEF.codcl, dencl, valoare, cota_tva, valoare*(1+cota_tva)
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl(+) 
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, NVL(valoare,0) AS valnoua, NVL(cota_tva,0) AS cota_noua, valnoua*(1+cota_noua) AS Valoare_cu_TVA
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, NVL(valoare,0) AS valnoua, NVL(cota_tva,0) AS cota_noua, valnoua*(1+NVL(cota_tva,0)) AS Valoare_cu_TVA
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
ORDER BY 2,4;

SELECT nrfact, clienti_DEF.codcl, dencl, NVL(valoare,0) AS valnoua, NVL(cota_tva,0) AS cota_noua, NVL(valoare,0)*(1+NVL(cota_tva,0)) AS Valoare_cu_TVA
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
ORDER BY 2,4;

-----------

SELECT SUM(valoare*(1+cota_tva)) AS Total_brut_general
FROM facturi_DEF;

SELECT SUM(valoare*(1+cota_tva)) AS Total_brut_lunar
FROM facturi_DEF
GROUP BY EXTRACT(MONTH FROM datafact)
ORDER BY EXTRACT(MONTH FROM datafact);

SELECT EXTRACT(MONTH FROM datafact) AS Luna, SUM(valoare*(1+cota_tva)) AS Total_brut_lunar
FROM facturi_DEF
GROUP BY EXTRACT(MONTH FROM datafact)
ORDER BY Luna;

------------

SELECT clienti_DEF.codcl, dencl, SUM(valoare*(1+cota_tva)) AS Total_brut, COUNT(nrfact) AS Nr_facturi
FROM clienti_DEF LEFT JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY clienti_DEF.codcl, dencl
ORDER BY Nr_facturi DESC, Total_brut DESC;

-------

SELECT clienti_DEF.codcl, dencl, SUM(valoare*(1+cota_tva)) AS Total_brut, COUNT(nrfact) AS Nr_facturi
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl   
GROUP BY clienti_DEF.codcl, dencl
HAVING SUM(valoare*(1+cota_tva))>=10000
ORDER BY Total_brut DESC;

SELECT clienti_DEF.codcl, dencl, SUM(valoare*(1+cota_tva)) AS Total_brut, COUNT(nrfact) AS Nr_facturi
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY clienti_DEF.codcl, dencl
HAVING SUM(valoare*(1+cota_tva))>=10000  
ORDER BY Total_brut DESC;

----------

SELECT clienti_DEF.codcl, dencl, SUM(valoare*(1+cota_tva)) AS Total_brut, COUNT(nrfact) AS Nr_facturi
FROM clienti_DEF,facturi_DEF
WHERE clienti_DEF.codcl=facturi_DEF.codcl AND datafact>=TO_DATE('01/05/2023','dd/mm/yyyy')  
GROUP BY clienti_DEF.codcl, dencl
HAVING SUM(valoare*(1+cota_tva))>=10000
ORDER BY Total_brut DESC;

SELECT clienti_DEF.codcl, dencl, SUM(valoare*(1+cota_tva)) AS Total_brut, COUNT(nrfact) AS Nr_facturi
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE datafact>=TO_DATE('01/05/2023','dd/mm/yyyy') 
GROUP BY clienti_DEF.codcl, dencl
HAVING SUM(valoare*(1+cota_tva))>=10000
ORDER BY Total_brut DESC;  

------------

SELECT MAX(valoare) AS Maxim_facturi, ROUND(AVG(valoare),2) AS Medie_facturi
FROM facturi_DEF;

SELECT clienti_DEF.codcl, dencl, MAX(valoare) AS Maxim_facturi 
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY clienti_DEF.codcl, dencl;

SELECT clienti_DEF.codcl, dencl, nrfact, valoare AS Maxim
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
WHERE valoare=(SELECT MAX(valoare)
               FROM facturi_DEF)
;

--------------

SELECT localit, SUM(valoare) AS Total_loc 
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY localit;

SELECT localit, MAX(SUM(valoare)) AS Maxim_totaluri_loc
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY localit;

SELECT MAX(SUM(valoare)) AS Maxim_totaluri_loc
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY localit;

SELECT localit, SUM(valoare) AS Max_t_l 
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY localit
HAVING SUM(valoare)= (SELECT MAX(SUM(valoare))
                      FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
                      GROUP BY localit)
;

SELECT localit, SUM(valoare) AS Top_valori 
FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
GROUP BY localit
HAVING SUM(valoare)>=0.5*(SELECT MAX(SUM(valoare))
                          FROM clienti_DEF INNER JOIN facturi_DEF ON clienti_DEF.codcl=facturi_DEF.codcl
                          GROUP BY localit)
ORDER BY 2 DESC;

------------------------------------

SELECT EXTRACT(MONTH FROM datafact) AS Luna, SUM(valoare) AS Total_lunar
FROM facturi_DEF
GROUP BY EXTRACT(MONTH FROM datafact);

SELECT AVG(SUM(valoare)) AS Media_totaluri_lunare
FROM facturi_DEF
GROUP BY EXTRACT(MONTH FROM datafact);

SELECT EXTRACT(MONTH FROM datafact) AS Luna, SUM(valoare) AS Total_lunar
FROM facturi_DEF
GROUP BY EXTRACT(MONTH FROM datafact)
HAVING SUM(valoare)>=(SELECT AVG(SUM(valoare))
                      FROM facturi_DEF
                      GROUP BY EXTRACT(MONTH FROM datafact))
ORDER BY 2 DESC;

-------------
DROP TABLE INCASARI_DEF;
DROP TABLE FACTURI_DEF;
DROP TABLE CLIENTI_DEF;


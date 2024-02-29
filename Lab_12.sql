--1 Crearea tabelelor

CREATE TABLE ctl_XY (
cod_p VARCHAR2(4) PRIMARY KEY, 
den_prod VARCHAR2(50),
um VARCHAR2(5));

CREATE TABLE misc_XY (
cod_misc NUMBER(4) PRIMARY KEY, 
data_misc DATE, 
explicatii VARCHAR2(50));

CREATE TABLE detalii_misc_XY (
cod_p VARCHAR2(4), 
cod_misc NUMBER(4), 
tip_op VARCHAR2(1), 
cant NUMBER(5), 
pret NUMBER(5),
PRIMARY KEY (cod_p, cod_misc),
FOREIGN KEY(cod_p) REFERENCES ctl_XY(cod_p),
FOREIGN KEY(cod_misc) REFERENCES misc_XY(cod_misc)
);

--2 Adaugarea de date si modificarea structurii unui tabel

BEGIN

INSERT INTO ctl_XY VALUES(11, 'abc', 'kg');
INSERT INTO ctl_XY VALUES(12, 'def', 'l');
INSERT INTO ctl_XY VALUES(21, 'ghi', 'm');
INSERT INTO ctl_XY VALUES(22, 'jkl', 'buc');
INSERT INTO ctl_XY VALUES(31, 'mno', 'kg');
INSERT INTO ctl_XY VALUES(32, 'pqr', 'm');

INSERT INTO misc_XY VALUES(10, TO_DATE('24.04.2023','dd.mm.yyyy'),'fact1');
INSERT INTO misc_XY VALUES(20, TO_DATE('25.04.2023','dd.mm.yyyy'),'fact2');
INSERT INTO misc_XY VALUES(30, TO_DATE('26.04.2023','dd.mm.yyyy'),'fact3');
INSERT INTO misc_XY VALUES(40, TO_DATE('18.05.2023','dd.mm.yyyy'),'fact4');
INSERT INTO misc_XY VALUES(50, TO_DATE('22.05.2023','dd.mm.yyyy'),'fact5');
INSERT INTO misc_XY VALUES(60, TO_DATE('25.05.2023','dd.mm.yyyy'),'fact6');

INSERT INTO detalii_misc_XY VALUES(21,10,'a',25,4);
INSERT INTO detalii_misc_XY VALUES(11,10,'a',20,3);
INSERT INTO detalii_misc_XY VALUES(31,10,'a',10,3);
INSERT INTO detalii_misc_XY VALUES(21,20,'v',7,6);
INSERT INTO detalii_misc_XY VALUES(11,30,'a',6,3);
INSERT INTO detalii_misc_XY VALUES(12,30,'a',10,8);
INSERT INTO detalii_misc_XY VALUES(22,30,'a',20,7);
INSERT INTO detalii_misc_XY VALUES(22,40,'v',6,11);
INSERT INTO detalii_misc_XY VALUES(11,40,'v',3,4);
INSERT INTO detalii_misc_XY VALUES(12,50,'v',2,10);
INSERT INTO detalii_misc_XY VALUES(21,50,'v',4,7);
INSERT INTO detalii_misc_XY VALUES(21,60,'a',10,4);

END;
/

--exista produsul cu codul 32 care exista doar in tabela catalog
--exista produsul cu codul 31 care doar s-a achizitionat

--inserare camp 'categ' in tabelul ctl_XY

ALTER TABLE ctl_XY ADD categ VARCHAR2(20);

--inlocuirea cu categoria 'alimente' pentru produsele al caror cod de produs incepe cu 1
--inlocuirea cu categoria 'electronice' pentru produsele al caror cod de produs incepe cu 2
--inlocuirea cu categoria 'jucarii' pentru produsele al caror cod de produs incepe cu 3

UPDATE ctl_XY
SET categ='alimente'
WHERE SUBSTR(cod_p,1,1) ='1';

SELECT * FROM ctl_XY;

--realizarea simultana a actualizarilor utilizarea lui CASE

UPDATE ctl_XY
SET categ=
CASE 
WHEN SUBSTR(cod_p,1,1) ='1' THEN 'alimente'
WHEN SUBSTR(cod_p,1,1) ='2' THEN 'electronice'
WHEN SUBSTR(cod_p,1,1) ='3' THEN 'jucarii'
END;

SELECT * FROM ctl_XY;

--3 Interogari progresive

SELECT ctl_XY.cod_p, den_prod, tip_op,cant
FROM ctl_XY, detalii_misc_XY
WHERE ctl_XY.cod_p=detalii_misc_XY.cod_p
ORDER BY ctl_XY.cod_p,tip_op;

SELECT ctl_XY.cod_p, den_prod, tip_op,cant
FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
ORDER BY 1,3;

SELECT ctl_XY.cod_p, misc_XY.cod_misc AS Nrfactura, den_prod, tip_op,cant
FROM ctl_XY, misc_XY, detalii_misc_XY
WHERE ctl_XY.cod_p=detalii_misc_XY.cod_p AND misc_XY.cod_misc=detalii_misc_XY.cod_misc
ORDER BY ctl_XY.cod_p, misc_XY.cod_misc ;

SELECT ctl_XY.cod_p, misc_XY.cod_misc AS Nrfactura, den_prod, tip_op,cant
FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p 
            INNER JOIN misc_XY ON detalii_misc_XY.cod_misc=misc_XY.cod_misc
ORDER BY 1,2;

--semnul (+), LEFT JOIN, RIGHT JOIN

SELECT ctl_XY.cod_p, den_prod, tip_op,cant
FROM ctl_XY, detalii_misc_XY
WHERE ctl_XY.cod_p=detalii_misc_XY.cod_p(+) 
ORDER BY 1,3;

SELECT ctl_XY.cod_p, den_prod, tip_op,cant
FROM ctl_XY LEFT JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
ORDER BY 1,3;

SELECT ctl_XY.cod_p, den_prod, tip_op,cant
FROM detalii_misc_XY RIGHT JOIN ctl_XY ON detalii_misc_XY.cod_p=ctl_XY.cod_p
ORDER BY 1,3;

--filtrari 

SELECT ctl_XY.cod_p, den_prod, tip_op,cant
FROM ctl_XY, detalii_misc_XY
WHERE ctl_XY.cod_p=detalii_misc_XY.cod_p AND cant>15
ORDER BY ctl_XY.cod_p;

SELECT ctl_XY.cod_p, den_prod, tip_op,cant
FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
WHERE cant>15
ORDER BY 1;

--produsele din catalog la care NU s-au realizat aprovizionari si vanzari

SELECT ctl_XY.cod_p, den_prod
FROM ctl_XY, detalii_misc_XY
WHERE ctl_XY.cod_p=detalii_misc_XY.cod_p(+) AND tip_op IS NULL
ORDER BY ctl_XY.cod_p;

SELECT ctl_XY.cod_p, den_prod
FROM ctl_XY LEFT JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
WHERE tip_op IS NULL
ORDER BY 1;

SELECT cod_p, den_prod
FROM ctl_XY
WHERE cod_p NOT IN (SELECT DISTINCT cod_p FROM detalii_misc_XY)
ORDER BY cod_p;

--calcul agregat

SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_cant
FROM ctl_XY LEFT JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
GROUP BY ctl_XY.cod_p, den_prod, tip_op
ORDER BY 1,3;

--filtrare anterioara gruparii

SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_cant
FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
WHERE UPPER (tip_op)='A'
GROUP BY ctl_XY.cod_p, den_prod, tip_op
ORDER BY 1;

--filtrare dupa grupare

SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_apr
FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
GROUP BY ctl_XY.cod_p, den_prod, tip_op
HAVING UPPER (tip_op)='A'
ORDER BY 1;

SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_vanz
FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
GROUP BY ctl_XY.cod_p, den_prod, tip_op
HAVING UPPER (tip_op)='V'
ORDER BY 1;

--UNIFICAREA celor doua tabele in FROM --utilizare ALIASURI

SELECT ta.cod_p, ta.den_prod, Total_apr,Total_vanz
FROM
   (SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_apr
   FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
   GROUP BY ctl_XY.cod_p, den_prod, tip_op
   HAVING UPPER (tip_op)='A'
   ORDER BY 1) ta,

   (SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_vanz
    FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
    GROUP BY ctl_XY.cod_p, den_prod, tip_op
    HAVING UPPER (tip_op)='V'
    ORDER BY 1) tv

WHERE ta.cod_p=tv.cod_p(+);

SELECT ta.cod_p, ta.den_prod, Total_apr,Total_vanz
FROM
   (SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_apr
   FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
   GROUP BY ctl_XY.cod_p, den_prod, tip_op
   HAVING UPPER (tip_op)='A'
   ORDER BY 1) ta
LEFT JOIN   
   (SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_vanz
    FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
    GROUP BY ctl_XY.cod_p, den_prod, tip_op
    HAVING UPPER (tip_op)='V'
    ORDER BY 1) tv
ON ta.cod_p=tv.cod_p;

--calcul diferenta

SELECT ta.cod_p, ta.den_prod, Total_apr,NVL(Total_vanz,0) AS Total_vanz, Total_apr-NVL(Total_vanz,0) AS Stoc
FROM
   (SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_apr 
   FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
   GROUP BY ctl_XY.cod_p, den_prod, tip_op
   HAVING UPPER (tip_op)='A'
   ORDER BY 1) ta
LEFT JOIN   
   (SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant) AS Total_vanz
    FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
    GROUP BY ctl_XY.cod_p, den_prod, tip_op
    HAVING UPPER (tip_op)='V'
    ORDER BY 1) tv
ON ta.cod_p=tv.cod_p
ORDER BY Stoc DESC;

--4 Calcule agregate, parametrii, subinterogari

--parametru de tip text

SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(cant*pret) AS Total_valoric
FROM ctl_XY INNER JOIN detalii_misc_XY ON ctl_XY.cod_p=detalii_misc_XY.cod_p
WHERE UPPER (tip_op)=UPPER('&tipul_operatiei')
GROUP BY ctl_XY.cod_p, den_prod,tip_op
ORDER BY 1;

--calcul agregat - total miscari in luna curenta

SELECT EXTRACT(MONTH from data_misc) AS luna, tip_op, SUM(cant*pret) AS Total_val
FROM misc_XY INNER JOIN detalii_misc_XY ON misc_XY.cod_misc=detalii_misc_XY.cod_misc
GROUP BY EXTRACT (MONTH from data_misc),tip_op
HAVING EXTRACT (MONTH from data_misc) = EXTRACT (MONTH from SYSDATE)
ORDER BY Total_val;

--subinterogari
--toate aprovizionarile cu pretul sub media preturilor de aprovizionare 

SELECT AVG(pret)
FROM detalii_misc_XY
WHERE UPPER (tip_op)='A';

SELECT ctl_XY.cod_p, den_prod, tip_op, pret, cant, pret*cant AS Valoare
FROM ctl_XY, detalii_misc_XY
WHERE ctl_XY.cod_p=detalii_misc_XY.cod_p 
AND UPPER (tip_op)='A'
AND pret<=(SELECT AVG(pret)
           FROM detalii_misc_XY
           WHERE UPPER (tip_op)='A')
ORDER BY 1;

SELECT ctl_XY.cod_p, den_prod, tip_op, SUM(pret*cant) AS Total_val
FROM ctl_XY, detalii_misc_XY
WHERE ctl_XY.cod_p=detalii_misc_XY.cod_p 
AND UPPER (tip_op)='A'
AND pret<=(SELECT AVG(pret) 
           FROM detalii_misc_XY
           WHERE UPPER (tip_op)='A')
GROUP BY ctl_XY.cod_p, den_prod, tip_op
ORDER BY 1;

--5 stabilirea categoriei pentru care totalul valoric al aprovizionarilor 
--este cel mai mare  

--testare subinterogarii 

SELECT SUBSTR(cod_p,1,1), tip_op, SUM(cant*pret) 
FROM detalii_misc_XY
WHERE UPPER(tip_op)='A'
GROUP BY SUBSTR(cod_p,1,1),tip_op
ORDER BY SUBSTR(cod_p,1,1);

--filtrarea doar a unei valori

SELECT SUBSTR(cod_p,1,1), tip_op, MAX(SUM(cant*pret)) 
FROM detalii_misc_XY
WHERE UPPER(tip_op)='A'
GROUP BY SUBSTR(cod_p,1,1),tip_op;

--renuntarea la campurile suplimentare

SELECT MAX(SUM(cant*pret)) 
FROM detalii_misc_XY
WHERE UPPER(tip_op)='A'
GROUP BY SUBSTR(cod_p,1,1),tip_op;

--utilizarea acestei subinterogari

SELECT categ, tip_op, SUM(cant*pret) AS Valoare
FROM ctl_XY, detalii_misc_XY
WHERE ctl_XY.cod_p=detalii_misc_XY.cod_p 
      AND UPPER(tip_op)='A'
GROUP BY categ, tip_op
HAVING SUM(cant*pret)=(SELECT MAX(SUM(cant*pret)) 
                       FROM detalii_misc_XY
                       WHERE UPPER(tip_op)='A'
                       GROUP BY SUBSTR(cod_p,1,1),tip_op)
;

--6 transformarea intr-o procedura

SET SERVEROUTPUT ON;

DECLARE
  v_categ ctl_XY.categ%TYPE;
  v_tip_op detalii_misc_XY.tip_op%TYPE;
  v_suma NUMBER;

BEGIN
SELECT categ, tip_op, SUM(cant*pret) INTO v_categ,v_tip_op,v_suma
FROM ctl_XY, detalii_misc_XY
WHERE ctl_XY.cod_p=detalii_misc_XY.cod_p 
      AND UPPER(tip_op)='A'
GROUP BY categ, tip_op
HAVING SUM(cant*pret)=(SELECT MAX(SUM(cant*pret)) 
                       FROM detalii_misc_XY
                       WHERE UPPER(tip_op)='A'
                       GROUP BY SUBSTR(cod_p,1,1),tip_op)
;

DBMS_OUTPUT.PUT_LINE('Categoria '||v_categ||' are la categoria '||v_tip_op||' cea mai mare valoare '||v_suma);
END;
/
------

DROP TABLE detalii_misc_XY;
DROP TABLE misc_XY;
DROP TABLE ctl_XY;



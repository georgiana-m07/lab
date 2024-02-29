--1 Crearea tabelelor

CREATE TABLE soferi_XY(
   codpers NUMBER(5) PRIMARY KEY, 
   nume VARCHAR2(30), 
   categ VARCHAR2(1));

CREATE TABLE parc_XY (
   id_auto NUMBER(3) PRIMARY KEY, 
   nrauto VARCHAR2(8) NOT NULL, 
   nr_locuri NUMBER(2));

CREATE TABLE curse_XY (
   id_cursa NUMBER (5) PRIMARY KEY, 
   codpers NUMBER (5) REFERENCES soferi_XY(codpers), 
   id_auto NUMBER(3) REFERENCES parc_XY(id_auto), 
   data_cursa DATE,
   incasari NUMBER(5));


--2 Adaugarea de date

BEGIN
INSERT INTO soferi_XY VALUES(10, 'Popescu', 'B');
INSERT INTO soferi_XY VALUES(20, 'Ionescu', 'C');
INSERT INTO soferi_XY VALUES(30, 'Georgescu', 'F');
INSERT INTO soferi_XY VALUES(40, 'Florescu', 'B');
INSERT INTO soferi_XY VALUES(50, 'Dumitrescu', 'F');

INSERT INTO parc_XY VALUES(100, 'TM17ABC', 24);
INSERT INTO parc_XY VALUES(200, 'TM19AOS', 44);
INSERT INTO parc_XY VALUES(300, 'TM21BOC', 10);
INSERT INTO parc_XY VALUES(400, 'TM44DEF', 16);
INSERT INTO parc_XY VALUES(500, 'TM22GHK', 8);


INSERT INTO curse_XY VALUES(1001, 10, 100, TO_DATE('10.01.2023','dd.mm.yyyy'),1233 );
INSERT INTO curse_XY VALUES(1002, 20, 100, TO_DATE('17.01.2023','dd.mm.yyyy'),725 );
INSERT INTO curse_XY VALUES(1003, 10, 200, TO_DATE('22.01.2023','dd.mm.yyyy'),1250 );
INSERT INTO curse_XY VALUES(1004, 30, 300, TO_DATE('5.02.2023','dd.mm.yyyy'),1190 );
INSERT INTO curse_XY VALUES(1005, 10, 400, TO_DATE('12.02.2023','dd.mm.yyyy'),644 );
INSERT INTO curse_XY VALUES(1006, 30, 500, TO_DATE('18.02.2023','dd.mm.yyyy'),1750 );
INSERT INTO curse_XY VALUES(1007, 20, 100, TO_DATE('22.02.2023','dd.mm.yyyy'),1860 );
INSERT INTO curse_XY VALUES(1008, 40, 400, TO_DATE('13.03.2023','dd.mm.yyyy'),540 );
INSERT INTO curse_XY VALUES(1009, 30, 200, TO_DATE('18.03.2023','dd.mm.yyyy'),1750 );
INSERT INTO curse_XY VALUES(1010, 50, 300, TO_DATE('25.03.2023','dd.mm.yyyy'),325 );
INSERT INTO curse_XY VALUES(1011, 40, 500, TO_DATE('27.03.2023','dd.mm.yyyy'),875 );
INSERT INTO curse_XY VALUES(1012, 20, 400, TO_DATE('3.04.2023','dd.mm.yyyy'),2411 );
INSERT INTO curse_XY VALUES(1013, 50, 500, TO_DATE('7.04.2023','dd.mm.yyyy'),2666 );
INSERT INTO curse_XY VALUES(1014, 40, 200, TO_DATE('12.04.2023','dd.mm.yyyy'),2700 );

END;
/

--proceduri si functii

SET SERVEROUTPUT ON;

--3  Alte exemple de functii

--interogari pregatitoare

SELECT EXTRACT(MONTH FROM data_cursa) AS luna, SUM(incasari), COUNT(id_cursa) 
FROM curse_XY
GROUP BY EXTRACT(MONTH FROM data_cursa);

SELECT EXTRACT(MONTH FROM data_cursa) AS luna, SUM(incasari), COUNT(id_cursa) 
FROM curse_XY
GROUP BY EXTRACT(MONTH FROM data_cursa)
HAVING EXTRACT(MONTH FROM data_cursa)=1;
   
SELECT SUM(incasari), COUNT(id_cursa) 
FROM curse_XY
GROUP BY EXTRACT(MONTH FROM data_cursa)
HAVING EXTRACT(MONTH FROM data_cursa)=1;

CREATE OR REPLACE FUNCTION sit_lun_f1 (p_luna NUMBER) RETURN NUMBER AS
v_tot_inc NUMBER;
v_nrc NUMBER;
BEGIN
    SELECT SUM(incasari), COUNT(id_cursa) INTO v_tot_inc,v_nrc
    FROM curse_XY
    GROUP BY EXTRACT(MONTH FROM data_cursa)
    HAVING EXTRACT(MONTH FROM data_cursa)=p_luna;

RETURN v_tot_inc;
RETURN v_nrc;
END;
/

--apelarea functiei

DECLARE 

v_prel_luna NUMBER;
v1 NUMBER;
v2 NUMBER;

BEGIN
v_prel_luna:=&dati_luna;
v1:=sit_lun_f1(v_prel_luna);
v2:=sit_lun_f1(v_prel_luna);
DBMS_OUTPUT.PUT_LINE ('Totalul lunii '||v_prel_luna||' este '||v1||' iar numarul de curse este '||v2);
END;
/

-- se poate returna doar o valoare
-- pentru a returna doua valori e nevoie de o functie cu parametru de iesire

CREATE OR REPLACE FUNCTION sit_lun_f2 (p_luna NUMBER, p_nrc OUT NUMBER) RETURN NUMBER AS
v_tot_inc NUMBER;
BEGIN
    SELECT SUM(incasari), COUNT(id_cursa) INTO v_tot_inc,p_nrc
    FROM curse_XY
    GROUP BY EXTRACT(MONTH FROM data_cursa)
    HAVING EXTRACT(MONTH FROM data_cursa)=p_luna;

RETURN v_tot_inc;
END;
/

--apelarea functiei

DECLARE 

v_prel_luna NUMBER;
v1 NUMBER;
v2 NUMBER;

BEGIN
v_prel_luna:=&dati_luna;
v1:=sit_lun_f2(v_prel_luna, v2);
DBMS_OUTPUT.PUT_LINE ('Totalul lunii '||v_prel_luna||' este '||v1||' iar numarul de curse este '||v2);
END;
/

--metoda 2
--definirea unui OBIECT

CREATE OR REPLACE TYPE OB_INF AS OBJECT (v_ob1 NUMBER, v_ob2 NUMBER);
/

CREATE OR REPLACE FUNCTION sit_lun_f3 (p_luna NUMBER) RETURN OB_INF AS
v_tot_inc NUMBER;
v_nrc NUMBER;
BEGIN
    SELECT SUM(incasari), COUNT(id_cursa) INTO v_tot_inc,v_nrc
    FROM curse_XY
    GROUP BY EXTRACT(MONTH FROM data_cursa)
    HAVING EXTRACT(MONTH FROM data_cursa)=p_luna;

RETURN OB_INF(v_tot_inc,v_nrc);
END;
/

--apelarea functiei

DECLARE 

v_prel_luna NUMBER;
v1_2 OB_INF;
v1 NUMBER;
v2 NUMBER;

BEGIN
v_prel_luna:=&dati_luna;
v1_2:=sit_lun_f3(v_prel_luna);
v1:=v1_2.v_ob1;
v2:=v1_2.v_ob2;
DBMS_OUTPUT.PUT_LINE ('Totalul lunii '||v_prel_luna||' este '||v1||' iar numarul de curse este '||v2);
END;
/

--apelarea functiei dintr-un cursor

DECLARE
CURSOR c_luna IS
   SELECT EXTRACT(MONTH FROM data_cursa) AS luna
   FROM curse_XY
   GROUP BY EXTRACT(MONTH FROM data_cursa)
   ORDER BY 1;
   
v1_2 OB_INF;

BEGIN
DBMS_OUTPUT.PUT_LINE ('Luna          Suma         Nr_curse');
DBMS_OUTPUT.PUT_LINE ('------------------------------------');
FOR i IN c_luna LOOP
v1_2:=sit_lun_f3(i.luna);
DBMS_OUTPUT.PUT_LINE (' '||i.luna||'            '||v1_2.v_ob1||'             '||v1_2.v_ob2);
END LOOP;

END;
/

--varianta imbunatatita

DECLARE
CURSOR c_luna IS
   SELECT EXTRACT(MONTH FROM data_cursa) AS luna
   FROM curse_XY
   GROUP BY EXTRACT(MONTH FROM data_cursa)
   ORDER BY 1;
   
v1_2 OB_INF;
v_nluna VARCHAR2(15);

BEGIN
DBMS_OUTPUT.PUT_LINE ('  Luna                 Suma         Nr_curse');
DBMS_OUTPUT.PUT_LINE ('--------------------------------------------');
FOR i IN c_luna LOOP
v1_2:=sit_lun_f3(i.luna);
v_nluna:=TO_CHAR(TO_DATE(i.luna, 'MM'), 'MONTH','NLS_DATE_LANGUAGE = romanian');
DBMS_OUTPUT.PUT_LINE (' '||v_nluna||'            '||v1_2.v_ob1||'             '||v1_2.v_ob2);
END LOOP;

END;
/

--stergerea unui tip de obiect

DROP TYPE OB_INF;

----
DROP TABLE curse_XY;
DROP TABLE parc_XY;
DROP TABLE soferi_XY;


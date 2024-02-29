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

--3 Functie si procedura cu parametrii de iesire

SELECT parc_XY.id_auto, AVG(incasari) AS mdpa, MAX(incasari) AS mxpa
FROM parc_XY INNER JOIN curse_XY ON parc_XY.id_auto=curse_XY.id_auto
GROUP BY parc_XY.id_auto
ORDER BY 1;

SELECT AVG(AVG(incasari)), MAX(MAX(incasari))
FROM parc_XY INNER JOIN curse_XY ON parc_XY.id_auto=curse_XY.id_auto
GROUP BY parc_XY.id_auto;

SELECT AVG(incasari), MAX(incasari)
FROM curse_XY;

-- rotunjiri

SELECT parc_XY.id_auto, ROUND(AVG(incasari),2) AS mdpa, MAX(incasari) AS mxpa
FROM parc_XY INNER JOIN curse_XY ON parc_XY.id_auto=curse_XY.id_auto
GROUP BY parc_XY.id_auto
ORDER BY 1;

SELECT ROUND(AVG(AVG(incasari)),2), MAX(MAX(incasari))
FROM parc_XY INNER JOIN curse_XY ON parc_XY.id_auto=curse_XY.id_auto
GROUP BY parc_XY.id_auto;

SELECT ROUND(AVG(incasari),2), MAX(incasari)
FROM curse_XY;

CREATE OR REPLACE PROCEDURE sit_auto_proc (p_idauto IN parc_XY.id_auto%TYPE, p_mdpa OUT NUMBER, p_mxpa OUT NUMBER) AS

BEGIN
   SELECT ROUND(AVG(incasari),2),MAX(incasari) INTO p_mdpa,p_mxpa
   FROM parc_XY INNER JOIN curse_XY ON parc_XY.id_auto=curse_XY.id_auto
   GROUP BY parc_XY.id_auto   
   HAVING parc_XY.id_auto=p_idauto
   ORDER BY 1;
END;
/

CREATE OR REPLACE FUNCTION sit_auto_func (p_idauto IN parc_XY.id_auto%TYPE, p_mxpa OUT NUMBER) RETURN NUMBER AS
v_mdpa NUMBER;
BEGIN
   SELECT ROUND(AVG(incasari),2),MAX(incasari) INTO v_mdpa,p_mxpa
   FROM parc_XY INNER JOIN curse_XY ON parc_XY.id_auto=curse_XY.id_auto
   GROUP BY parc_XY.id_auto   
   HAVING parc_XY.id_auto=p_idauto
   ORDER BY 1;
RETURN v_mdpa;
END;
/

--utilizarea obiectelor de mai sus

CREATE OR REPLACE PROCEDURE sit_auto1 AS

CURSOR c_auto IS
   SELECT id_auto,nrauto
   FROM parc_XY;

v_med NUMBER;
v_max NUMBER;

BEGIN
DBMS_OUTPUT.PUT_LINE ('Id_auto         Nrauto          Media         Maxim');
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------');
FOR i IN c_auto LOOP
sit_auto_proc(i.id_auto,v_med, v_max);
DBMS_OUTPUT.PUT_LINE ('  '||i.id_auto||'          '||i.nrauto||'          '||v_med||'          '||v_max);
END LOOP;

END;
/

EXECUTE  sit_auto1;

---

CREATE OR REPLACE PROCEDURE sit_auto2 AS

CURSOR c_auto IS
   SELECT id_auto,nrauto
   FROM parc_XY;

v_med NUMBER;
v_max NUMBER;

BEGIN
DBMS_OUTPUT.PUT_LINE ('Id_auto         Nrauto          Media         Maxim');
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------');
FOR i IN c_auto LOOP
v_med:=sit_auto_func(i.id_auto,v_max);
DBMS_OUTPUT.PUT_LINE ('  '||i.id_auto||'          '||i.nrauto||'          '||v_med||'          '||v_max);
END LOOP;

END;
/

EXECUTE  sit_auto2;

--procedura imbunatatita

CREATE OR REPLACE PROCEDURE sit_auto3 AS

CURSOR c_auto IS
   SELECT id_auto,nrauto
   FROM parc_XY;

v_med NUMBER;
v_max NUMBER;
v_mmed NUMBER;
v_mmax NUMBER;
v_medc NUMBER;
v_maxc NUMBER;

BEGIN
DBMS_OUTPUT.PUT_LINE ('Id_auto         Nrauto          Media         Maxim');
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------');
FOR i IN c_auto LOOP
v_med:=sit_auto_func(i.id_auto,v_max);
DBMS_OUTPUT.PUT_LINE ('  '||i.id_auto||'          '||i.nrauto||'          '||v_med||'          '||v_max);
END LOOP;
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------');

SELECT ROUND(AVG(AVG(incasari)),2), MAX(MAX(incasari)) INTO v_mmed,v_mmax
FROM parc_XY INNER JOIN curse_XY ON parc_XY.id_auto=curse_XY.id_auto
GROUP BY parc_XY.id_auto;

SELECT ROUND(AVG(incasari),2), MAX(incasari) INTO v_medc,v_maxc
FROM curse_XY;

DBMS_OUTPUT.PUT_LINE (' Media mediilor                 '||v_mmed);
DBMS_OUTPUT.PUT_LINE (' Maximul maximelor                               '||v_mmax);
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------');
DBMS_OUTPUT.PUT_LINE (' Media curselor                 '||v_medc);
DBMS_OUTPUT.PUT_LINE (' Maximul curselor                                '||v_maxc);

END;
/

EXECUTE  sit_auto3;

--afisare ordonata

CREATE OR REPLACE PROCEDURE sit_auto4 AS

CURSOR c_auto IS
   SELECT id_auto,nrauto
   FROM parc_XY;

v_med NUMBER;
v_max NUMBER;
v_mmed NUMBER;
v_mmax NUMBER;
v_medc NUMBER;
v_maxc NUMBER;
c1 CHAR(15);
c2 CHAR(15);
c3 CHAR(15);
c4 CHAR(15);

BEGIN
DBMS_OUTPUT.PUT_LINE ('Id_auto          Nrauto          Media        Maxim');
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------');
FOR i IN c_auto LOOP
v_med:=sit_auto_func(i.id_auto,v_max);
c1:=TO_CHAR(i.id_auto);
c2:=TO_CHAR(i.nrauto);
c3:=TO_CHAR(v_med);
c4:=TO_CHAR(v_max);
DBMS_OUTPUT.PUT_LINE ('  '||c1||c2||c3||c4);
END LOOP;
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------');

SELECT ROUND(AVG(AVG(incasari)),2), MAX(MAX(incasari)) INTO v_mmed,v_mmax
FROM parc_XY INNER JOIN curse_XY ON parc_XY.id_auto=curse_XY.id_auto
GROUP BY parc_XY.id_auto;

SELECT ROUND(AVG(incasari),2), MAX(incasari) INTO v_medc,v_maxc
FROM curse_XY;

DBMS_OUTPUT.PUT_LINE (' Media mediilor                 '||v_mmed);
DBMS_OUTPUT.PUT_LINE (' Maximul maximelor                             '||v_mmax);
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------');
DBMS_OUTPUT.PUT_LINE (' Media curselor                 '||v_medc);
DBMS_OUTPUT.PUT_LINE (' Maximul curselor                              '||v_maxc);

END;
/

EXECUTE  sit_auto4;

--------

CREATE TABLE parc_XY_C AS 
    SELECT * FROM parc_XY;

ALTER TABLE parc_XY_C ADD PRIMARY KEY(id_auto);
ALTER TABLE parc_XY_C ADD (med NUMBER, max NUMBER);

CREATE OR REPLACE PROCEDURE sit_auto5 AS

CURSOR c_auto IS
   SELECT id_auto,nrauto
   FROM parc_XY;

v_med NUMBER;
v_max NUMBER;

BEGIN
FOR i IN c_auto LOOP
v_med:=sit_auto_func(i.id_auto,v_max);
UPDATE parc_XY_C SET 
  med=v_med, 
  max=v_max
WHERE id_auto=i.id_auto;
END LOOP;
END;
/

EXECUTE sit_auto5;

SELECT * FROM parc_XY_C;

--5 Trigger

CREATE OR REPLACE TRIGGER modif_sit AFTER INSERT OR DELETE OR UPDATE ON curse_XY  
BEGIN
DBMS_OUTPUT.PUT_LINE ('Atentie !!! S-au operat modificari in tabela curse');
sit_auto5;
END;
/

SELECT * FROM parc_XY_C;

INSERT INTO curse_XY VALUES(1015, 30, 300, TO_DATE('05.05.2023','dd.mm.yyyy'),1400 );

SELECT * FROM parc_XY_C;

DELETE FROM curse_XY WHERE id_cursa=1015;

SELECT * FROM parc_XY_C;

UPDATE curse_XY SET INCASARI=1600 WHERE id_cursa=1001;

SELECT * FROM parc_XY_C;

UPDATE curse_XY SET INCASARI=1233 WHERE id_cursa=1001;

SELECT * FROM parc_XY_C;

-----
DROP TABLE parc_XY_C;
DROP TABLE curse_XY;
DROP TABLE parc_XY;
DROP TABLE soferi_XY;

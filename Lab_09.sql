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

--3 Procedura stocata totalul incasarilor realizate de soferii 
--  categoriei precizata ca parametru

SELECT categ, SUM(incasari) AS total
FROM curse_XY INNER JOIN soferi_XY ON curse_XY.codpers=soferi_XY.codpers
GROUP BY categ
HAVING UPPER(categ)='B'; 

--transferul instructiunii SELECT intr-o procedura stocata cu parametru

CREATE OR REPLACE PROCEDURE calc_tot_categ (p_categ soferi_XY.categ%TYPE) AS

v_categ soferi_XY.categ%TYPE;
v_tot NUMBER;

BEGIN
SELECT categ, SUM(incasari) INTO v_categ, v_tot
FROM curse_XY INNER JOIN soferi_XY ON curse_XY.codpers=soferi_XY.codpers
GROUP BY categ
HAVING UPPER(categ)=UPPER(p_categ); 
DBMS_OUTPUT.PUT_LINE ('Totalul categoriei '||v_categ||' este '||v_tot);
END;
/

EXECUTE calc_tot_categ('&dati_categoria');

--utilizarea si apelarea unei functii care realizeaza acelasi lucru

CREATE OR REPLACE FUNCTION total_categ (pf_categ soferi_XY.categ%TYPE) RETURN NUMBER AS
vf_total NUMBER;

BEGIN
SELECT SUM(incasari) INTO vf_total
FROM curse_XY INNER JOIN soferi_XY ON curse_XY.codpers=soferi_XY.codpers
GROUP BY categ
HAVING UPPER(categ)=UPPER(pf_categ); 
RETURN vf_total;
END;
/

--apelarea functiei

DECLARE 

v_prel_categ soferi_XY.categ%TYPE;
v_tot NUMBER;

BEGIN
v_prel_categ:=UPPER('&dati_categoria');
v_tot:=total_categ(v_prel_categ); 
DBMS_OUTPUT.PUT_LINE ('Totalul categoriei '||v_prel_categ||' este '||v_tot);
END;
/

--trecerea la cursor pentru a afisa totalul incasarilor fiecarei categorii
--totalul se va calcula cu ajutorul functiei stocate
--se va realiza si un total general la sfarsitul tabelului
--pregatire SELECT

SELECT categ
FROM soferi_XY 
GROUP BY categ; 

SELECT DISTINCT categ
FROM soferi_XY; 

--procedura de calcul pe fiecare categorie

CREATE OR REPLACE PROCEDURE calc_tot_categ_c1 AS

CURSOR c IS
  SELECT DISTINCT categ
  FROM soferi_XY; 

v_calc NUMBER:=0; 
v_tg NUMBER:=0;

BEGIN
FOR i IN c LOOP
v_calc:=total_categ(i.categ);
v_tg:=v_tg+v_calc;
DBMS_OUTPUT.PUT_LINE ('Totalul categoriei '||i.categ||' este '||v_calc);
END LOOP;
DBMS_OUTPUT.PUT_LINE ('--------------------------------------');

DBMS_OUTPUT.PUT_LINE ('Total general            '||v_tg);

END;
/

EXECUTE calc_tot_categ_c1;

-----

CREATE OR REPLACE PROCEDURE calc_tot_categ_c2 AS

CURSOR c IS
  SELECT DISTINCT categ
  FROM soferi_XY; 

v_calc NUMBER:=0; 
v_tg NUMBER:=0;

BEGIN
DBMS_OUTPUT.PUT_LINE ('Cod categorie       Total incasari');
FOR i IN c LOOP
v_calc:=total_categ(i.categ);
DBMS_OUTPUT.PUT_LINE ('    '||i.categ||'                     '||v_calc);
END LOOP;
DBMS_OUTPUT.PUT_LINE ('--------------------------------------');

SELECT SUM(incasari) INTO v_tg
FROM curse_XY;

DBMS_OUTPUT.PUT_LINE ('Total general            '||v_tg);

END;
/

EXECUTE calc_tot_categ_c2;

----
--4 Intrucat oricare dintre soferi poate efectua curse cu oricare dintre vehiculele din parc, 
--sa se afiseze totalul incasarilor pe fiecare din combinatiile POSIBILE!! dintre soferi si vehicule,
--ordonate alfabetic dupa numele soferilor;

  SELECT SUM(incasari)
  FROM curse_XY
  GROUP BY codpers, ID_AUTO;

--construirea functiei

CREATE OR REPLACE FUNCTION total_sf_auto (p_cp soferi_XY.codpers%TYPE, p_id parc_XY.id_auto%TYPE) RETURN NUMBER AS
v_tot_f NUMBER;
BEGIN
  SELECT SUM(incasari) INTO v_tot_f
  FROM curse_XY
  GROUP BY codpers,id_auto
  HAVING codpers=p_cp AND id_auto=p_id;

RETURN v_tot_f;

EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN 0;

END;
/
 
--afisarea tuturor combinatiilor posibile--produs cartezian, relatie fara WHERE

SELECT codpers,id_auto,nume,nrauto
FROM soferi_XY,parc_XY
ORDER BY nume,id_auto; 

--procedura

CREATE OR REPLACE PROCEDURE list_inc AS

CURSOR c IS
    SELECT codpers,id_auto,nume,nrauto
    FROM soferi_XY,parc_XY
    ORDER BY nume,id_auto; 

v_total NUMBER;

BEGIN
DBMS_OUTPUT.PUT_LINE ('   Nume sofer           Nr auto               Suma');
DBMS_OUTPUT.PUT_LINE ('-------------------------------------------------------------');
FOR i IN c LOOP
  v_total:=total_sf_auto(i.codpers,i.id_auto);
  IF v_total > 0 THEN
    DBMS_OUTPUT.PUT_LINE ('   '||i.nume||'           '||i.nrauto||'              '||v_total);
  ELSE
    DBMS_OUTPUT.PUT_LINE ('   '||i.nume||'           '||i.nrauto||'        nu a efectuat curse');
  END IF;
END LOOP;
END;
/

EXECUTE list_inc;

----

CREATE OR REPLACE PROCEDURE list_inc_supl AS

CURSOR c1 IS
    SELECT codpers,nume
    FROM soferi_XY
    ORDER BY nume; 

v_trs_cod soferi_XY.codpers%TYPE;

CURSOR c2 IS
    SELECT codpers,id_auto,nume,nrauto
    FROM soferi_XY,parc_XY
    WHERE codpers=v_trs_cod
    ORDER BY nume,id_auto; 

v_total NUMBER;
contor NUMBER :=0;
v_tot_sof NUMBER :=0;

BEGIN
DBMS_OUTPUT.PUT_LINE ('   Nume sofer           Nr auto               Suma');
DBMS_OUTPUT.PUT_LINE ('-------------------------------------------------------------');
FOR i IN c1 LOOP
  DBMS_OUTPUT.PUT_LINE ('   '||i.nume);
  v_tot_sof:=0;
  v_trs_cod:=i.codpers;
   FOR j IN c2 LOOP
       v_total:=total_sf_auto(j.codpers,j.id_auto); 
       IF v_total > 0 THEN
          DBMS_OUTPUT.PUT_LINE ('                        '||j.nrauto||'              '||v_total);
          contor:=contor+1;
       ELSE
          DBMS_OUTPUT.PUT_LINE ('                        '||j.nrauto||'        nu a efectuat curse');
       END IF;
   v_tot_sof:=v_tot_sof+v_total;    
   END LOOP;
DBMS_OUTPUT.PUT_LINE ('-------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE ('   Total sofer                               '||v_tot_sof);
DBMS_OUTPUT.PUT_LINE ('-------------------------------------------------------------');
END LOOP; 
DBMS_OUTPUT.PUT_LINE ('   Combinatii realizate                       '||contor);
END;
/

EXECUTE list_inc_supl;


----
DROP TABLE curse_XY;
DROP TABLE parc_XY;
DROP TABLE soferi_XY;


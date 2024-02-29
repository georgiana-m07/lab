--1 Crearea tabelelor

CREATE TABLE stud_XY (
matr_st NUMBER(4) PRIMARY KEY,
cnp VARCHAR2(13), 
nume_st VARCHAR2(50),
spec VARCHAR2(5));

CREATE TABLE disc_XY (
cod_disc CHAR(3) PRIMARY KEY, 
den_disc VARCHAR2(20),
nr_credite NUMBER(2));

CREATE TABLE ex_XY(
cod_ex NUMBER(5) PRIMARY KEY, 
matr_st NUMBER(4) REFERENCES stud_XY(matr_st), 
cod_disc CHAR(3)  REFERENCES disc_XY(cod_disc), 
nota NUMBER(2));

--2 Completarea cu date 

BEGIN

INSERT INTO stud_XY VALUES (10, '1820127204771', 'ABC', 'CIG');
INSERT INTO stud_XY VALUES (20, '2870310350002', 'DEF', 'IE');
INSERT INTO stud_XY VALUES (30, '5021003220045', 'GHI', 'MK');
INSERT INTO stud_XY VALUES (40, '6010310039955', 'JKL', 'IE');
INSERT INTO stud_XY VALUES (50, '1730210223455', 'MNO', 'MK');
INSERT INTO stud_XY VALUES (60, '6021120205402', 'PQR', 'CIG');


INSERT INTO disc_XY VALUES ('110', 'AAA', 5);
INSERT INTO disc_XY VALUES ('120', 'BBB', 4);
INSERT INTO disc_XY VALUES ('210', 'CCC', 4);
INSERT INTO disc_XY VALUES ('220', 'DDD', 5);
INSERT INTO disc_XY VALUES ('310', 'EEE', 2);
INSERT INTO disc_XY VALUES ('320', 'FFF', 3);
INSERT INTO disc_XY VALUES ('330', 'GGG', 3);

INSERT INTO ex_XY VALUES (10001, 10, '110', 9);
INSERT INTO ex_XY VALUES (10002, 20, '110', 6);
INSERT INTO ex_XY VALUES (10003, 50, '110', 8);
INSERT INTO ex_XY VALUES (10004, 10, '120', 5);
INSERT INTO ex_XY VALUES (10005, 20, '120', 10);
INSERT INTO ex_XY VALUES (10006, 30, '120', 6);
INSERT INTO ex_XY VALUES (10007, 40, '120', 7);
INSERT INTO ex_XY VALUES (10008, 20, '210', 7);
INSERT INTO ex_XY VALUES (10009, 30, '210', 9);
INSERT INTO ex_XY VALUES (10010, 40, '210', 4);
INSERT INTO ex_XY VALUES (10011, 50, '210', 4);
INSERT INTO ex_XY VALUES (10012, 10, '220', 8);
INSERT INTO ex_XY VALUES (10013, 20, '220', 6);
INSERT INTO ex_XY VALUES (10014, 40, '220', 10);
INSERT INTO ex_XY VALUES (10015, 10, '310', 9);
INSERT INTO ex_XY VALUES (10016, 20, '310', 10);
INSERT INTO ex_XY VALUES (10017, 20, '320', 9);
INSERT INTO ex_XY VALUES (10018, 30, '320', 6);
INSERT INTO ex_XY VALUES (10019, 40, '320', 4);
INSERT INTO ex_XY VALUES (10020, 50, '320', 7);

END;
/

 
SELECT * FROM stud_XY;
SELECT * FROM disc_XY;
SELECT * FROM ex_XY;

--activarea afisarii

SET SERVEROUTPUT ON; 


--3 Alte variante de implementare a cursorului 

-- procedura stocata cu cursor v2

CREATE OR REPLACE PROCEDURE calc_crdt1_cs2 IS

CURSOR c IS
  SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite)   
  FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
  WHERE nota>4
  GROUP BY disc_XY.cod_disc, den_disc
  ORDER BY 1;

v_cod_disc disc_XY.cod_disc%TYPE;
v_den_disc disc_XY.den_disc%TYPE;
v_total NUMBER;

BEGIN

DBMS_OUTPUT.PUT_LINE ('Cod disciplina     Denumire disciplina      Numar credite');

OPEN c;
LOOP
FETCH c INTO v_cod_disc, v_den_disc, v_total;
EXIT WHEN c%NOTFOUND;
DBMS_OUTPUT.PUT_LINE ('    '||v_cod_disc||'                   '||v_den_disc||'                    '||v_total);
END LOOP;
CLOSE c;

END;
/

EXECUTE calc_crdt1_cs2;

-- procedura stocata cu cursor v3

CREATE OR REPLACE PROCEDURE calc_crdt1_cs3 IS

CURSOR c IS
  SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite)   
  FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
  WHERE nota>4
  GROUP BY disc_XY.cod_disc, den_disc
  ORDER BY 1;

v_cod_disc disc_XY.cod_disc%TYPE;
v_den_disc disc_XY.den_disc%TYPE;
v_total NUMBER;

BEGIN

DBMS_OUTPUT.PUT_LINE ('Cod disciplina     Denumire disciplina      Numar credite');

OPEN c;
FETCH c INTO v_cod_disc, v_den_disc, v_total;
WHILE c%FOUND LOOP
DBMS_OUTPUT.PUT_LINE ('    '||v_cod_disc||'                   '||v_den_disc||'                    '||v_total);
FETCH c INTO v_cod_disc, v_den_disc, v_total;
END LOOP;
CLOSE c;

END;
/

EXECUTE calc_crdt1_cs3;

--4 Functie de calcul al totalului de credite
--extragerea informatiei privind anul de studiu ..SUBSTR
--adaugarea unui camp calculat pe parcursul parcurgerii liniilor cursorului
--adaugarea unor linii de separare a informatiilor

CREATE OR REPLACE FUNCTION f_calc_crdt1_cs_tot RETURN NUMBER IS

CURSOR c IS
  SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) AS totalcredite, SUBSTR(disc_XY.cod_disc,1,1) AS an_st   
  FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
  WHERE nota>4
  GROUP BY disc_XY.cod_disc, den_disc
  ORDER BY 1;

v_tot_cr NUMBER :=0;

BEGIN

DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE ('Cod disciplina     Denumire disciplina      Numar credite    An studiu');
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------------------------');

FOR i IN c LOOP

DBMS_OUTPUT.PUT_LINE ('    '||i.cod_disc||'                   '||i.den_disc||'                    '||i.totalcredite||'               '||i.an_st);
v_tot_cr:=v_tot_cr+i.totalcredite;

END LOOP;

DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------------------------');

RETURN v_tot_cr;
END;
/


--apelarea si utilizarea rezultatului functiei

DECLARE
v_prel_tot_cr NUMBER;
v_nrdisc NUMBER;
v_med NUMBER;
BEGIN
v_prel_tot_cr:=f_calc_crdt1_cs_tot;

DBMS_OUTPUT.PUT_LINE ('Total credite                                    '||v_prel_tot_cr);
DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------------------------');
SELECT COUNT(DISTINCT cod_disc) INTO v_nrdisc
FROM ex_XY;
v_med:=ROUND(v_prel_tot_cr/v_nrdisc,2);
DBMS_OUTPUT.PUT_LINE ('Medie                                          '||v_med);
END;
/



------
DROP TABLE ex_XY;
DROP TABLE disc_XY;
DROP TABLE stud_XY;

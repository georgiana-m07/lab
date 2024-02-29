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

--3 Determinarea si afisarea sumei creditelor obitnute la 
--fiecare disciplina de catre toti studentii 

SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) AS totalcredite 
FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
WHERE nota>4
GROUP BY disc_XY.cod_disc, den_disc
ORDER BY 1;

SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) AS totalcredite 
FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
WHERE nota>4 AND disc_XY.cod_disc=120
GROUP BY disc_XY.cod_disc, den_disc
ORDER BY 1;

SET SERVEROUTPUT ON; 

--procedura nestocata

DECLARE
v_cod_disc disc_XY.cod_disc%TYPE;
v_den_disc disc_XY.den_disc%TYPE;
v_total NUMBER;
BEGIN
SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) INTO v_cod_disc, v_den_disc, v_total  
FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
WHERE nota>4 AND disc_XY.cod_disc=120
GROUP BY disc_XY.cod_disc, den_disc
ORDER BY 1;
DBMS_OUTPUT.PUT_LINE ('La disciplina cu codul '||v_cod_disc||' denumita '||v_den_disc||' s-au obtinut '||v_total||' credite');
END;
/

--transformarea in procedura stocata

CREATE OR REPLACE PROCEDURE calc_crdt1 IS
v_cod_disc disc_XY.cod_disc%TYPE;
v_den_disc disc_XY.den_disc%TYPE;
v_total NUMBER;
BEGIN
SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) INTO v_cod_disc, v_den_disc, v_total  
FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
WHERE nota>4 AND disc_XY.cod_disc=120
GROUP BY disc_XY.cod_disc, den_disc
ORDER BY 1;
DBMS_OUTPUT.PUT_LINE ('La disciplina cu codul '||v_cod_disc||' denumita '||v_den_disc||' s-au obtinut '||v_total||' credite');
END;
/

EXECUTE calc_crdt1;

--transformarwa in procedura stocata cu parametru

CREATE OR REPLACE PROCEDURE calc_crdt1_p (p_cod disc_XY.cod_disc%TYPE) IS
v_cod_disc disc_XY.cod_disc%TYPE;
v_den_disc disc_XY.den_disc%TYPE;
v_total NUMBER;
BEGIN
SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) INTO v_cod_disc, v_den_disc, v_total  
FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
WHERE nota>4 AND disc_XY.cod_disc=p_cod
GROUP BY disc_XY.cod_disc, den_disc
ORDER BY 1;
DBMS_OUTPUT.PUT_LINE ('La disciplina cu codul '||v_cod_disc||' denumita '||v_den_disc||' s-au obtinut '||v_total||' credite');
END;
/

EXECUTE calc_crdt1_p(110);
EXECUTE calc_crdt1_p(&dati_codul);

BEGIN 
calc_crdt1_p(110);
END;
/

BEGIN 
calc_crdt1_p(&dati_codul);
END;
/

DECLARE
v_slct_cod disc_XY.cod_disc%TYPE;
BEGIN
v_slct_cod:=&dati_codul;
DBMS_OUTPUT.PUT_LINE ('Situatia disciplinei cu codul '||v_slct_cod);
calc_crdt1_p(v_slct_cod);
END;
/

-------------

CREATE OR REPLACE PROCEDURE calc_crdt1_p_ex (p_cod disc_XY.cod_disc%TYPE) IS
v_cod_disc disc_XY.cod_disc%TYPE;
v_den_disc disc_XY.den_disc%TYPE;
v_total NUMBER;
BEGIN
SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) INTO v_cod_disc, v_den_disc, v_total  
FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
WHERE nota>4 AND disc_XY.cod_disc=p_cod
GROUP BY disc_XY.cod_disc, den_disc
ORDER BY 1;
DBMS_OUTPUT.PUT_LINE ('La disciplina cu codul '||v_cod_disc||' denumita '||v_den_disc||' s-au obtinut '||v_total||' credite');
EXCEPTION
WHEN no_data_found THEN
DBMS_OUTPUT.PUT_LINE ('Nu exista disciplina ');
END;
/

DECLARE
v_slct_cod disc_XY.cod_disc%TYPE;
BEGIN
v_slct_cod:=&dati_codul;
DBMS_OUTPUT.PUT_LINE ('Situatia disciplinei cu codul '||v_slct_cod);
calc_crdt1_p_ex(v_slct_cod);
END;
/

------------------------

--transformarea procedurii in functie si utilizarea 
--informatiei pe care o returneaza functia 

CREATE OR REPLACE FUNCTION f_calc_crdt1_p (p_cod disc_XY.cod_disc%TYPE) RETURN NUMBER IS
v_cod_disc disc_XY.cod_disc%TYPE;
v_den_disc disc_XY.den_disc%TYPE;
v_total NUMBER;
BEGIN
SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) INTO v_cod_disc, v_den_disc, v_total  
FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
WHERE nota>4 AND disc_XY.cod_disc=p_cod
GROUP BY disc_XY.cod_disc, den_disc
ORDER BY 1;
DBMS_OUTPUT.PUT_LINE ('La disciplina cu codul '||v_cod_disc||' denumita '||v_den_disc||' s-au obtinut '||v_total||' credite');
RETURN v_total;
END;
/

--apelarea functiei presupune definirea unei variabile
--care sa preia rezultatul totalului de credite returnat de functie

DECLARE
v_slct_cod disc_XY.cod_disc%TYPE;
v_prel_tot NUMBER;
BEGIN
v_slct_cod:=&dati_codul;
DBMS_OUTPUT.PUT_LINE ('Situatia disciplinei cu codul '||v_slct_cod);
v_prel_tot:=f_calc_crdt1_p(v_slct_cod);
DBMS_OUTPUT.PUT_LINE ('Aici se afiseaza totalul de '||v_prel_tot||' credite returnat de functie');
END;
/

--daca se doreste ca rezultatul totalului de credite sa fie extras 
--din procedura, este necesar ca procedura sa aiba parametru de iesire

CREATE OR REPLACE PROCEDURE calc_crdt1_p_io (p_cod disc_XY.cod_disc%TYPE, p_ies_tot OUT NUMBER) IS
v_cod_disc disc_XY.cod_disc%TYPE;
v_den_disc disc_XY.den_disc%TYPE;
v_total NUMBER;
BEGIN
SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) INTO v_cod_disc, v_den_disc, v_total  
FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
WHERE nota>4 AND disc_XY.cod_disc=p_cod
GROUP BY disc_XY.cod_disc, den_disc
ORDER BY 1;
DBMS_OUTPUT.PUT_LINE ('La disciplina cu codul '||v_cod_disc||' denumita '||v_den_disc||' s-au obtinut '||v_total||' credite');
p_ies_tot:=v_total;
END;
/

--apelarea procedurii cu parametru de iesire seamana cu apelarea unei functii, in sensul ca
--presupune definirea unei variabile care sa preia rezultatul totalului de credite care "paraseste"
--procedura prin intermediul parametrului de iesire

DECLARE
v_slct_cod disc_XY.cod_disc%TYPE;
v_prel_tot NUMBER;
BEGIN
v_slct_cod:=&dati_codul;
DBMS_OUTPUT.PUT_LINE ('Situatia disciplinei cu codul '||v_slct_cod);
calc_crdt1_p_io(v_slct_cod,v_prel_tot);
DBMS_OUTPUT.PUT_LINE ('Aici se afiseaza totalul de '||v_prel_tot||' credite returnat de procedura cu parametru de iesire');
END;
/

-----4 Utilizare cursor
--pornind de la interogarea initiala, sa se defineasca o procedura cu cursor
--pentru afisarea situatiei tuturor disciplinelor

CREATE OR REPLACE PROCEDURE calc_crdt1_cs IS

CURSOR c IS
  SELECT disc_XY.cod_disc, den_disc, SUM(nr_credite) AS totalcredite   
  FROM disc_XY INNER JOIN ex_XY ON disc_XY.cod_disc=ex_XY.cod_disc
  WHERE nota>4
  GROUP BY disc_XY.cod_disc, den_disc
  ORDER BY 1;

BEGIN

DBMS_OUTPUT.PUT_LINE ('Cod disciplina     Denumire disciplina      Numar credite');

FOR i IN c LOOP
    DBMS_OUTPUT.PUT_LINE ('    '||i.cod_disc||'                   '||i.den_disc||'                    '||i.totalcredite);
END LOOP;

END;
/

EXECUTE calc_crdt1_cs;

------
DROP TABLE ex_XY;
DROP TABLE disc_XY;
DROP TABLE stud_XY;

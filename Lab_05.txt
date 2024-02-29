CREATE TABLE dept(
  deptno NUMBER(2,0) PRIMARY KEY, 
  dname VARCHAR2(14), 
  loc VARCHAR2(13)
);  

CREATE TABLE emp(
empno NUMBER(4,0) PRIMARY KEY, 
ename VARCHAR2(10), 
job VARCHAR2(9), 
mgr NUMBER(4,0), 
hiredate DATE, 
sal NUMBER(7,2), 
comm NUMBER(7,2), 
deptno NUMBER(2,0) REFERENCES dept(deptno)
);


BEGIN 

INSERT INTO dept VALUES(10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept VALUES(20, 'RESEARCH', 'DALLAS');
INSERT INTO dept VALUES(30, 'SALES', 'CHICAGO');
INSERT INTO dept VALUES(40, 'OPERATIONS', 'BOSTON');

INSERT INTO emp VALUES(7839, 'KING', 'PRESIDENT', null, to_date('17-11-1981','dd-mm-yyyy'), 5000, null, 10);
INSERT INTO emp VALUES(7698, 'BLAKE', 'MANAGER', 7839, to_date('1-5-1981','dd-mm-yyyy'),2850, null, 30);
INSERT INTO emp VALUES(7782, 'CLARK', 'MANAGER', 7839,  to_date('9-6-1981','dd-mm-yyyy'), 2450, null, 10);
INSERT INTO emp VALUES(7566, 'JONES', 'MANAGER', 7839, to_date('2-4-1981','dd-mm-yyyy'), 2975, null, 20);
INSERT INTO emp VALUES(7788, 'SCOTT', 'ANALYST', 7566, to_date('13-JUL-87','dd-mm-rr'), 3000, null, 20);
INSERT INTO emp VALUES(7902, 'FORD', 'ANALYST', 7566, to_date('3-12-1981','dd-mm-yyyy'), 3000, null, 20 );
INSERT INTO emp VALUES(7369, 'SMITH', 'CLERK', 7902, to_date('17-12-1980','dd-mm-yyyy'),  800, null, 20 );
INSERT INTO emp VALUES(7499, 'ALLEN', 'SALESMAN', 7698,to_date('20-2-1981','dd-mm-yyyy'),  1600, 300, 30);
INSERT INTO emp VALUES(7521, 'WARD', 'SALESMAN', 7698,  to_date('22-2-1981','dd-mm-yyyy'), 1250, 500, 30);
INSERT INTO emp VALUES(7654, 'MARTIN', 'SALESMAN', 7698, to_date('28-9-1981','dd-mm-yyyy'), 1250, 1400, 30);
INSERT INTO emp VALUES(7844, 'TURNER', 'SALESMAN', 7698, to_date('8-9-1981','dd-mm-yyyy'),1500, 0, 30);
INSERT INTO emp VALUES(7876, 'ADAMS', 'CLERK', 7788, to_date('13-JUL-87', 'dd-mm-rr'), 1100, null, 20);
INSERT INTO emp VALUES(7900, 'JAMES', 'CLERK', 7698,to_date('3-12-1981','dd-mm-yyyy'),950, null, 30);
INSERT INTO emp VALUES(7934, 'MILLER', 'CLERK', 7782, to_date('23-1-1982','dd-mm-yyyy'),1300, null, 10);

END;
/

SELECT * FROM dept;
SELECT * FROM emp;

--EXEMPLE DE INTEROGARI

SELECT empno, ename, deptno 
FROM emp 
WHERE ename = 'blake';

SELECT empno, ename, deptno 
FROM emp 
WHERE UPPER(ename) = 'BLAKE';

SELECT empno, ename, deptno 
FROM emp 
WHERE LOWER(ename) = 'blake';

SELECT * 
FROM emp 
WHERE ename LIKE 'A%' OR ename LIKE 'M%'
ORDER BY 2;

SELECT * 
FROM emp 
WHERE deptno IN (10,20)
ORDER BY 8;

SELECT * 
FROM emp 
WHERE deptno NOT IN (10,20)
ORDER BY 8;

SELECT * 
FROM emp
WHERE hiredate BETWEEN TO_DATE ('01/01/1981', 'dd/mm/yyyy') AND TO_DATE('28/02/1982','dd/mm/yyyy')
ORDER BY 5;

SELECT ename, job, sal, comm, sal+comm
FROM emp;

SELECT ename, job, sal, comm, sal+NVL(comm,0) AS sal_tot
FROM emp;

SELECT emp.deptno, loc,dname, COUNT(empno) AS nr_ang
FROM emp, dept
WHERE emp.deptno=dept.deptno AND emp.deptno<>10
GROUP BY emp.deptno,loc,dname
ORDER BY nr_ang DESC;

SELECT emp.deptno, loc,dname, COUNT(empno) AS nr_ang
FROM emp, dept
WHERE emp.deptno=dept.deptno
GROUP BY emp.deptno,loc,dname
HAVING emp.deptno<>10
ORDER BY 4 DESC;

SELECT emp.deptno, loc,dname, COUNT(empno) AS nr_ang
FROM emp, dept
WHERE emp.deptno=dept.deptno
GROUP BY emp.deptno,loc,dname
HAVING COUNT(empno)>5
ORDER BY nr_ang DESC;

SELECT emp.deptno, loc,dname, COUNT(empno) AS nr_ang
FROM emp, dept
WHERE emp.deptno(+)=dept.deptno 
GROUP BY emp.deptno,loc,dname
ORDER BY 1;

SELECT dept.deptno, loc,dname, COUNT(empno) AS nr_ang
FROM emp, dept
WHERE emp.deptno(+)=dept.deptno 
GROUP BY dept.deptno,loc,dname
ORDER BY 1;

SELECT loc, 
   MIN(sal+NVL(comm,0)) AS minim,
   AVG(sal+NVL(comm,0)) AS medie
FROM emp,dept
WHERE emp.deptno=dept.deptno
GROUP BY loc
ORDER BY 3;

SELECT loc, 
   MIN(sal+NVL(comm,0)) AS minim,
   ROUND(AVG(sal+NVL(comm,0)),2) AS medie
FROM emp,dept
WHERE emp.deptno=dept.deptno
GROUP BY loc
ORDER BY 3;

SELECT loc, 
   MIN(sal+comm) AS minim,
   ROUND(AVG(sal+comm),2) AS medie
FROM emp,dept
WHERE emp.deptno=dept.deptno
GROUP BY loc
ORDER BY 3;

--EXEMPLE DE SUBINTEROGARI - IN CLAUZA HAVING SAU IN CLAUZA WHERE 

--selectarea departamentelor care au cel mai mic numar de angajati

SELECT dept.deptno, dname, COUNT(empno) AS Total
FROM emp INNER JOIN dept ON emp.deptno=dept.deptno
GROUP BY dept.deptno, dname
HAVING COUNT(empno)=(SELECT MIN(COUNT(empno)) 
                     FROM emp
                     GROUP BY deptno)
;

--calculul salariului mediu si apoi persoanele care au salariul mai mare decat 
--salariul mediu, ORDONATE DESCRESCATOR 

SELECT ROUND(AVG(sal+NVL(comm,0)),2) AS salariu_mediu
FROM emp;

SELECT dept.deptno,empno,ename,job,dname,sal+NVL(comm,0) AS salariu
FROM emp INNER JOIN dept ON emp.deptno=dept.deptno
WHERE sal+NVL(comm,0)>=(SELECT AVG(sal+NVL(comm,0))
                        FROM emp)
ORDER BY 6 DESC;

--IMBUNATATIREA PRIN FOLOSIREA LUI RANK

SELECT dept.deptno,empno,ename,job,dname,sal+NVL(comm,0) AS salariu,
RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) AS Top
FROM emp INNER JOIN dept ON emp.deptno=dept.deptno
WHERE sal+NVL(comm,0)>=(SELECT AVG(sal+NVL(comm,0))
                        FROM emp)
;

SELECT dept.deptno,empno,ename,job,dname,sal+NVL(comm,0) AS salariu,
RANK() OVER(ORDER BY sal+NVL(comm,0) DESC, empno) AS Top
FROM emp INNER JOIN dept ON emp.deptno=dept.deptno
WHERE sal+NVL(comm,0)>=(SELECT AVG(sal+NVL(comm,0))
                        FROM emp)
;

SELECT dept.deptno,empno,ename,job,dname,sal+NVL(comm,0) AS salariu,
RANK() OVER(ORDER BY sal+NVL(comm,0) DESC, empno) AS Top
FROM emp INNER JOIN dept ON emp.deptno=dept.deptno
WHERE sal+NVL(comm,0)>=(SELECT AVG(sal+NVL(comm,0))
                        FROM emp)
      AND ROWNUM<=4
;

-- aliasurile (porecle) tabelelor

SELECT empno, ename, a.deptno, dname
FROM emp a, dept b 
WHERE a.deptno=b.deptno;

SELECT empno, ename, a.deptno, dname
FROM emp a INNER JOIN dept b ON a.deptno=b.deptno;

SELECT a.empno, a.ename, a.deptno, b.dname
FROM emp a INNER JOIN dept b ON a.deptno=b.deptno;

------

SELECT e.empno as ID_Angajat, e.ename as Nume_Angajat, e.job AS Job_Angajat, e.mgr AS Id_Sef, 
              m.ename AS Nume_sef, m.job AS Functie_sef 
FROM emp e INNER JOIN emp m ON e.mgr = m.empno;

--pentru a vedea si pe KING

SELECT e.empno as ID_Angajat, e.ename as Nume_Angajat, e.job AS Job_Angajat, e.mgr AS Id_Sef, 
              m.ename AS Nume_sef, m.job AS Functie_sef 
FROM emp e LEFT JOIN emp m ON e.mgr = m.empno;

--proceduri

--angajatii subordonati lui BLAKE, cu codul 7698

SELECT e.empno AS ID_angajat, e.ename AS Nume_Angajat, e.job AS Job_Angajat, 
       e.mgr AS Id_Sef, m.ename AS Nume_sef, m.job AS Functie_sef 
FROM emp e INNER JOIN emp m ON e.mgr = m.empno
WHERE e.mgr=7698;

--numarul de subordonati 

SELECT COUNT(e.empno) AS nrsubordonati, 
       e.mgr AS Id_Sef, m.ename AS Nume_sef, m.job AS Functie_sef 
FROM emp e INNER JOIN emp m ON e.mgr = m.empno
WHERE e.mgr=7698
GROUP BY e.mgr, m.ename, m.job;

SELECT COUNT(e.empno) AS nrsubordonati 
FROM emp e INNER JOIN emp m ON e.mgr = m.empno
WHERE e.mgr=7698
GROUP BY e.mgr, m.ename, m.job;

----

SET SERVEROUTPUT ON;

DECLARE
  v_nr_sbd NUMBER;
BEGIN  
  SELECT COUNT(e.empno) INTO v_nr_sbd 
  FROM emp e INNER JOIN emp m ON e.mgr = m.empno
  WHERE e.mgr=7698
  GROUP BY e.mgr, m.ename, m.job;

  DBMS_OUTPUT.PUT_LINE ('Numarul de subordonati este '||v_nr_sbd);
END;
/

--imbunatatirea procedurii prin afisarea tuturor informatiilor

DECLARE
  v_nr_sbd NUMBER;
  v_cod_mgr emp.mgr%TYPE;
  v_nume_mgr emp.ename%TYPE;
  v_fct_mgr emp.job%TYPE;
    
BEGIN  
  SELECT COUNT(e.empno),e.mgr,m.ename,m.job INTO v_nr_sbd,v_cod_mgr,v_nume_mgr,v_fct_mgr 
  FROM emp e INNER JOIN emp m ON e.mgr = m.empno
  WHERE e.mgr=7698
  GROUP BY e.mgr, m.ename, m.job;

  DBMS_OUTPUT.PUT_LINE ('Cod manager '||v_cod_mgr);
  DBMS_OUTPUT.PUT_LINE ('Nume manager '||v_nume_mgr);
  DBMS_OUTPUT.PUT_LINE ('Functie manager '||v_fct_mgr);
  DBMS_OUTPUT.PUT_LINE ('Numar subordonati '||v_nr_sbd);
END;
/

--transformarea in procedura stocata

CREATE OR REPLACE PROCEDURE afis_sbd IS
  v_nr_sbd NUMBER;
  v_cod_mgr emp.mgr%TYPE;
  v_nume_mgr emp.ename%TYPE;
  v_fct_mgr emp.job%TYPE;
    
BEGIN  
  SELECT COUNT(e.empno),e.mgr,m.ename,m.job INTO v_nr_sbd,v_cod_mgr,v_nume_mgr,v_fct_mgr 
  FROM emp e INNER JOIN emp m ON e.mgr = m.empno
  WHERE e.mgr=7698
  GROUP BY e.mgr, m.ename, m.job;

  DBMS_OUTPUT.PUT_LINE ('Cod manager '||v_cod_mgr);
  DBMS_OUTPUT.PUT_LINE ('Nume manager '||v_nume_mgr);
  DBMS_OUTPUT.PUT_LINE ('Functie manager '||v_fct_mgr);
  DBMS_OUTPUT.PUT_LINE ('Numar subordonati '||v_nr_sbd);
END;
/

EXECUTE afis_sbd;

--imbunatatirea cu parametru

CREATE OR REPLACE PROCEDURE afis_sbd_p (p_cod NUMBER)  IS
  v_nr_sbd NUMBER;
  v_cod_mgr emp.mgr%TYPE;
  v_nume_mgr emp.ename%TYPE;
  v_fct_mgr emp.job%TYPE;
    
BEGIN  
  SELECT COUNT(e.empno),e.mgr,m.ename,m.job INTO v_nr_sbd,v_cod_mgr,v_nume_mgr,v_fct_mgr 
  FROM emp e INNER JOIN emp m ON e.mgr = m.empno
  WHERE e.mgr=p_cod
  GROUP BY e.mgr, m.ename, m.job;

  DBMS_OUTPUT.PUT_LINE ('Cod manager '||v_cod_mgr);
  DBMS_OUTPUT.PUT_LINE ('Nume manager '||v_nume_mgr);
  DBMS_OUTPUT.PUT_LINE ('Functie manager '||v_fct_mgr);
  DBMS_OUTPUT.PUT_LINE ('Numar subordonati '||v_nr_sbd);
END;
/

EXECUTE afis_sbd_p(7698);
EXECUTE afis_sbd_p(7566);
EXECUTE afis_sbd_p(7839);

--tratarea erorii

EXECUTE afis_sbd_p(7200);
EXECUTE afis_sbd_p(7499);

----
CREATE OR REPLACE PROCEDURE afis_sbd_p_err (p_cod NUMBER)  IS
  v_nr_sbd NUMBER;
  v_cod_mgr emp.mgr%TYPE;
  v_nume_mgr emp.ename%TYPE;
  v_fct_mgr emp.job%TYPE;
    
BEGIN  
  SELECT COUNT(e.empno),e.mgr,m.ename,m.job INTO v_nr_sbd,v_cod_mgr,v_nume_mgr,v_fct_mgr 
  FROM emp e INNER JOIN emp m ON e.mgr = m.empno
  WHERE e.mgr=p_cod
  GROUP BY e.mgr, m.ename, m.job;

  DBMS_OUTPUT.PUT_LINE ('Cod manager '||v_cod_mgr);
  DBMS_OUTPUT.PUT_LINE ('Nume manager '||v_nume_mgr);
  DBMS_OUTPUT.PUT_LINE ('Functie manager '||v_fct_mgr);
  DBMS_OUTPUT.PUT_LINE ('Numar subordonati '||v_nr_sbd);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('Angajat inexistent sau nu are functie de manager !!');
END;
/

EXECUTE afis_sbd_p_err(7839);
EXECUTE afis_sbd_p_err(7200);
EXECUTE afis_sbd_p_err(7499);

--apelarea procedurii stocate dintr-o alta procedura anonima

DECLARE
codpersoana NUMBER;
BEGIN
codpersoana := &dati_codul_persoanei;
afis_sbd_p_err(codpersoana);
END;
/

---------

DROP TABLE emp;
DROP TABLE dept;



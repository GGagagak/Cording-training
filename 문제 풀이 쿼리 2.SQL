SELECT s.NAME , s.deptno1 , d.DNAME
FROM STUDENT s, DEPARTMENT d
WHERE s.DEPTNO1 = d.DEPTNO;
--- 1번 문제

SELECT e.name,e.POSITION,e.pay,
	   p.S_PAY "low pay",
	   p.E_PAY "High pay"
FROM emp2 e,P_GRADE p
WHERE e.POSITION = p.POSITION
AND e.POSITION IS NOT NULL;
-- emp2 의 사람 이름,pay,psotition
-- 2번 문제

SELECT e.name,
	  TRUNC((SYSDATE - E.BIRTHDAY)/365)- 10 "AGE",
	  e.POSITION,
	  p.POSITION
FROM EMP2 e, P_GRADE p
WHERE TRUNC((SYSDATE - E.BIRTHDAY)/365)- 10 BETWEEN p.S_AGE(+)
AND p.E_AGE (+)
ORDER BY "AGE";
-- 3번 문제

SELECT c.gname,c.point,
	   g.gname "GIFT_NAME"
FROM CUSTOMER c, gift g
WHERE c.point >= G.G_START 
AND g.GNAME = 'Notebook'
;
--4번 문제



SELECT p.PROFNO,
	   p.name,
	   TO_CHAR(p.HIREDATE,'YYYY/MM/DD') HIREDATE,
	   COUNT(NVL2(p2.PROFNO,p.profno,NULL)) COUNT
FROM PROFESSOR p, PROFESSOR p2 
WHERE p.HIREDATE > p2.HIREDATE(+)
GROUP BY p.PROFNO,p.name , p.HIREDATE
ORDER BY 4 ASC ;
-- 5번 문제

SELECT e.empno,e.ename,
	   TO_CHAR(e.HIREDATE,'YY/MM/DD') HIREDATE,
	   COUNT(NVL2(e2.HIREDATE,e.HIREDATE,NULL)) COUNT
FROM emp e, emp e2
WHERE e.HIREDATE > e2.HIREDATE(+)
GROUP BY e.empno,e.ename,e.HIREDATE 
ORDER BY 4 ASC
-- 6번문제
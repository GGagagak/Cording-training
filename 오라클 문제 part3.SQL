SELECT DEPTNO,ENAME,
	   sal,
	   SUM(sal) OVER () "TOTAL_SAL",
	   ROUND(RATIO_TO_REPORT(sum(sal)) over()*100,2)
FROM emp
GROUP BY deptno,ename,sal
ORDER BY sal DESC
;
-- 10번 문제

SELECT deptno,
	   name,
	   pay,
	   SUM(pay) OVER (PARTITION BY deptno) "TOTAL_DEPTNO",
	   ROUND(RATIO_TO_REPORT(SUM(pay)) OVER(PARTITION BY deptno)*100,2) "RATIO(%)"
FROM PROFESSOR
GROUP BY deptno,name,pay;
;
-- 15번 문제


SELECT deptno,
	   name,
	   pay,
	   SUM(pay) OVER (PARTITION BY deptno) "TOTAL_DEPTNO",
	   ROUND(RATIO_TO_REPORT(SUM(pay)) OVER(PARTITION BY deptno)*100,2) "RATIO(%)"
FROM PROFESSOR
GROUP BY deptno,name,pay;
;

SELECT 
	   L_CODE,
	   L_STORE,
	   l_date,
	   L_qty,
	   L_total,
	   SUM(L_total) OVER (PARTITION BY L_code,L_STORE ORDER BY L_total DESC )
FROM loan
;
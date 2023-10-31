SELECT ename, hiredate, sal,
	   LAG(sal,3,2) OVER (ORDER BY hiredate) "LAG"
FROM emp;
--이전 행 값을 가져올때

SELECT  ename, hiredate, sal,
		LEAD(sal,2,1) OVER (ORDER BY hiredate) "LEAD"
FROM emp;

SELECT RANK('SMITH') WITHIN GROUP (ORDER BY ename) "RANK"
FROM emp;
-- RANK(조건값) 이 조건값이 ename 컬럼에서 ORDER BY 한후에 몇번째냐?

SELECT ename
FROM emp
ORDER BY ename
;

SELECT empno, ename, sal,
	   RANK() OVER (ORDER BY sal) AS RANK_ASC,
	   RANK() OVER (ORDER BY sal DESC) AS RANK_DESC
FROM emp;

--ASC 오름차순 , DESC 내림차순

SELECT empno,ename,sal,
	   RANK() OVER (ORDER BY sal DESC) "RANK"
FROM emp
WHERE DEPTNO  = '10'
;

SELECT empno,ename,sal,deptno,
	   RANK() OVER (PARTITION BY deptno
	   				ORDER BY sal DESC) "RANK"
FROM emp
;

SELECT empno,ename,sal,deptno,job,
	   RANK() OVER (PARTITION BY deptno,job
	   				ORDER BY sal DESC) "RANK"
FROM emp
;

SELECT empno, ename, job, sal,
	   RANK() OVER (ORDER BY sal DESC) sal_rank,
	   DENSE_RANK() OVER (ORDER BY sal DESC) sal_dense_rank,
	   ROW_NUMBER () OVER (ORDER BY sal DESC) sal_row_num
FROM emp;

SELECT deptno
	   ,sal
	   ,empno
	   ,ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal)		row_number1
	   ,RANK() OVER (PARTITION BY deptno ORDER BY sal)			rank1
	   ,DENSE_RANK()  OVER (PARTITION BY deptno ORDER BY sal)			dense_rank1
	   ,ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal,empno)  row_number2
	   ,RANK() OVER  (PARTITION BY deptno ORDER BY sal,empno)		rank2
	   ,DENSE_RANK()  OVER (PARTITION BY deptno ORDER BY sal,empno)	dense_RANK2
FROM emp
WHERE deptno IN ('10','20')
ORDER BY deptno, sal ,empno
;

SELECT  p_date,
		p_code,
		p_qty,
		p_total,
		SUM(p_total) OVER (ORDER BY p_total) "TOTAL"
FROM panmae
WHERE p_store = 1000;

SELECT deptno
	   ,SUM(DECODE(job,'CLERK',sal, 0)) "CLERK"
	   ,SUM(DECODE(job,'MANAGER',sal, 0)) "MANAGER"
	   ,SUM(DECODE(job,'PRESIDENT',sal, 0)) "PRESIDENT"
	   ,SUM(DECODE(job,'ANALYST',sal, 0)) "ANALYST"
	   ,SUM(DECODE(job,'SALESMAN',sal, 0)) "SALESMAN"
	   ,SUM(NVL2(job,sal,0)) "TOTAL"
FROM emp
GROUP BY rollup(DEPTNO)
ORDER BY deptno
;

SELECT deptno,
	   ename,
	   sal,
	   SUM(sal) OVER (ORDER BY sal,deptno) "TOTAL"
FROM emp;

SELECT p_date,
	   p_code,
	   p_qty,
	   p_total,
	   SUM(p_total) OVER (ORDER BY p_total) "TOTAL"
FROM PANMAE
WHERE p_store = 1000;

SELECT p_date,
	   p_code,
	   p_qty,
	   p_total,
	   SUM(p_total) OVER (PARTITION BY p_code ORDER BY p_total) "TOTAL"
FROM panmae

SELECT p_code,
	   p_store,
	   p_date,
	   p_qty,
	   p_total,
	   SUM(p_total) OVER (PARTITION BY p_code,p_store ORDER BY p_date) "TOTAL"
FROM panmae
;

SELECT p_code,
	   SUM(SUM(p_qty)) OVER() "TOTAL_QTY",
	   SUM(SUM(p_total)) OVER() "TOTAL_PRICE",
	   P_store,
	   p_qty,
	   p_total,
	   ROUND((RATIO_TO_REPORT(SUM(p_qty)) OVER())*100,2) "qty_%",
	   ROUND((RATIO_TO_REPORT(SUM(p_total)) OVER())*100,2) "total_%"
FROM PANMAE
WHERE p_code = 100
GROUP BY p_code, p_store, p_qty, P_total;

SELECT p_store,
	   p_date,
	   p_code,
	   p_qty,
	   LAG(p_qty,1) OVER(ORDER BY p_date)"D-1 QTY",
	   p_qty - LAG(p_qty,1) OVER(ORDER BY p_date)"DIFF-QTY",
	   p_total,
	   LAG(p_total,1) OVER(ORDER BY p_date) "D-1 PRICE",
	   p_total - LAG(p_total,1) OVER (ORDER BY p_date) "DIFF-PRICE"
FROM PANMAE
WHERE P_STORE = 1000;

SELECT DEPTNO,ENAME,
	   sal,
	   SUM(sal) OVER () "TOTAL_SAL",
	   ROUND(RATIO_TO_REPORT(sum(sal)) over()*100,2)
FROM emp
GROUP BY deptno,ename,sal
ORDER BY sal DESC
;

col tablespace_name for a10
col MB for 999.99
col file_name for a50
SELECT tablespace_name
        ,bytes/1024/1024 MB
        ,file_name
FROM dba_data_files;


ALTER DATABASE DATAFILE 'C:\APP\HBI\PRODUCT\18.0.0\ORADATA\XE\USERS01.DBF'
AUTOEXTEND ON;

테스트용 테이블을 생성한 후 500만 건의 데이터를 입력합니다.
CREATE TABLE with_test1(
    no NUMBER
    ,name VARCHAR2(10)
    ,pay NUMBER(6)
)
TABLESPACE users
;

BEGIN
    FOR i IN 1..5000000 LOOP
        INSERT INTO with_test1
        VALUES(i,DBMS_RANDOM.STRING('A',5)
                ,DBMS_RANDOM.VALUE(6,999999));
    
    END LOOP;
    COMMIT;
END;
/

-- DBMS_RANDOM.STRING(OPTION, LENGTH) FROM DUAL
-- 아래는 OPTION값들
-- U 혹은 u : 대문자 알파벳의 문자열
-- L 혹은 l  : 소문자 알파벳의 문자열
-- A 혹은 a : 대소문자 구분 없이 임의의 알파벳의 문자열
-- X 혹은 x : 임의의 대문자 알파벳 혹은 숫자의 문자열
-- P 혹은 p : 임의의 출력 가능한 문자들의 배열


-- DBMS_RANDOM.VALUE(x1,x2) : x1부터 x2의 사이에 있는 숫자를 생성한다 (디폴트: 0과 1사이중 하나)

SELECT COUNT(*) FROM with_test1;

SELECT ROWNUM NUM, T1.*
FROM(
    SELECT* FROM with_test1
)T1
WHERE

SELECT MAX(pay) - MIN(PAY)
FROM with_test1
;

-- set timing on 쓰면 경과시간 측정가능

-- 인덱스를 생성한 후 최댓값과 최솟값의 차이를 구하고 소요시간을 확인한다.
-- PAY 컬럼에 인덱스 생성
set timing on
CREATE INDEX idx_with_pay
ON with_test1(pay);

-- 인덱스 사용하면 정렬한 후 투입
-- 경   과: 00:00:12.38

SELECT MAX(pay) - MIN(PAY)
FROM with_test1
WHERE pay > 0;

-- 경   과: 00:00:02.89  이쪽이 더 빠름

-- with절을 사용하여 최댓값과 최솟값의 차이를 구하고 소요 시간을 확인합니다.
WITH a AS
(
    /*최대값*/
    SELECT /* + index_desc(w idx_with_pay) */ pay
    FROM with_test1 w
    WHERE pay>0
    AND ROWNUM = 1
),
b AS 
(
    /* 최소값 */
    SELECT /* + index(w idx_with_pay) */ pay
    FROM with_test1 w
    WHERE pay > 0
    AND  ROWNUM =1
)
SELECT a.pay - b.pay
FROM b,a
;

-- 앞의 실습에서 생성한 with_test1 테이브레서 no가 120000번에서 130000 사이인 사람들 중 
-- 가장 pay가 작은 살마을 찾은 후 그 사람보다 apy가 작은 사람 수를 세는
-- with_test1 테이블의 no 인덱스 생성 : idx_with_no
CREATE INDEX idx_with_no
ON with_test1(no);


-- 일반적인 sub Query를 사용하여 데이터를 조회하고 시간을 측정합니다
SELECT COUNT(*)
FROM with_test1
WHERE pay < ALL(SELECT /* + INDEX (w idx_with_no) */ pay
                FROM with_test1 w
                WHERE no BETWEEN 12000 AND 130000)
                ;


WITH t AS(
     SELECT /*+ INDEX(w idx_with_no) */ min(pay) min_pay
     FROM with_test1 w
      WHERE no > 0
     AND no BETWEEN 120000 AND 130000
     AND ROWNUM = 1
 )
 SELECT *
FROM t
 ;


-- 아래 쿼리가 위 커리보다 훨씬 빠르다!

WITH t AS(
    SELECT /*+ INDEX(w idx_with_no) */ min(pay) min_pay
    FROM with_test1 w
    WHERE no > 0
    AND no BETWEEN 120000 AND 130000
    AND ROWNUM = 1
)
SELECT COUNT(*)
FROM t, with_test1 w1
WHERE w1.pay < t.min_pay
;

-- 반복된 테이블 수행을 한 번만 수행하도록 하고 소요시간을 확인합니다
-- pay 중에 제일 작은 값과 제일 큰 값, 그리고 제일 큰 값과 제일 작은 값 차이를 구하려
-- 한다면 아래와 같이 작성할 수 있다.

--full scan 유도 : index drop (idx_with_pay)
-- DROP INDEX idx_with_pay;
explain plan for
SELECT'max_pay' c1, MAX(pay) 
FROM with_test1
UNION ALL
SELECT 'min_pay' c1, MIN(pay) 
FROM with_test1
UNION ALL
SELECT 'max_pay' - 'min_pay' c1, (MAX(pay) - MIN(pay)) diff_pay
FROM with_test1
;

col plan_table_output format a120;
select * from table(DBMS_x)

DROP INDEX idx_with_pay;
WITH sub_pay AS(
select max(pay) max_pay,
       min(pay) min_pay
FROM with_test1
)
SELECT'max_pay' c1, max_pay FROM sub_pay
UNION ALL
SELECT 'min_pay' c1, min_pay FROM sub_pay
UNION ALL
SELECT 'max_pay' - 'min_pay' c1, (max_pay - min_pay) diff_pay FROM with_test1
;

CREATE TABLE s_order(
    ord_no NUMBER(4)
    ,ord_name VARCHAR2(10)
    ,p_name VARCHAR2(20)
    ,p_qty NUMBER
);



INSERT INTO s_order VALUES(100,'james','apple',5);
(시퀀스 만들어)

select *
FROM s_order
;

--MAXVALUE/ MINVALUE 항목과 CYCLE 값을 테스트 합니다
BEGIN
    FOR i IN 1..9 LOOP
        INSERT INTO s_order VALUES(jno_seq.NEXTVAL,'jiral','banana',5);
    END LOOP;
    COMMIT;
END;

CREATE SEQUENCE jno_seq
INCREMENT BY 1
START WITH 100
MAXVALUE 110
MINVALUE 90
CYCLE
CACHE 2;

--값이 감소하는 시퀀스

CREATE SEQUENCE jno_seq_rev
INCREMENT BY -2
MINVALUE 0
MAXVALUE 20
START WITH 10;

-- CREATE TABLE s_revl (no NUMBER);

INSERT INTO s_revl VALUES(jno_seq_rev.NEXTVAL);

--SEQUENCE조회 : user_sequences

col sequence_name for a15
SELECT sequence_name
      ,min_value
      ,max_value
      ,INCREMENT_by
      ,cycle_flag
      ,order_flag
      ,cache_size
      ,last_number
FROM user_sequences
WHERE sequence_name='JNO_SEQ'

SEQUENCE_NAME    MIN_VALUE  MAX_VALUE INCREMENT_BY CY OR CACHE_SIZE LAST_NUMBER
--------------- ---------- ---------- ------------ -- -- ---------- -----------
JNO_SEQ                 90        110            1 Y  N           2         100

-- 시퀀스 삭제
DROP SEQUENCE JNO_SEQ;

-- 시퀀스 초기화

SYNONYM
--동의어는 테이블, 뷰, 시퀀스 등 객체 이름 대신 사용할 수 있는 이름.
-- 1. 편의성
-- 2. 보안

-- 문법
-- CREATE[public] SYNONYM 동의어 이름
-- OFR[사용자(SCHEMA).]대상객체;

-- SYNONYM 권한 할당

-- 11:28:48 SYS@XE>GRANT create SYNONYM TO scott;

-- 권한이 부여되었습니다.

-- 11:28:54 SYS@XE>GRANT create public SYNONYM TO scott;

-- 권한이 부여되었습니다.
CONN/AS SYSDBA
GRANT create SYNONYM TO scott;
GRANT create public SYNONYM TO scott;

11:28:58 SYS@XE>conn scott/pcwk
연결되었습니다.

-- scott emp테이블의 동의어 e로 생성
CREATE SYNONYM e FOR emp;

SELECT * FROM e;

-- scott dept테이블의 동의어 d2로 생성 ( 단 모든 사용자가 사용할 수 있도록) --> public만 치면됨
-- CREATE public SYNONYM d2 FOR dept;

--SYNONYM 조희 : user_synonyms
COL SYNONYM_NAME FOR A10
COL TABLE_NAME FOR A10
COL TABLE_owner FOR A10
DESC user_synonyms;
SELECT SYNONYM_NAME,TABLE_NAME,TABLE_owner
FROM user_synonyms
WHERE table_name = 'DEPT'
;

-- public SYNONYM은 user_synonyms에 없음, DBA_SYNONYMS
COL SYNONYM_NAME FOR A10
COL TABLE_NAME FOR A10
COL TABLE_owner FOR A10
DESC user_synonyms;
SELECT SYNONYM_NAME,TABLE_NAME,TABLE_owner
FROM DBA_SYNONYMS
WHERE table_name = 'DEPT'
;
--SYNONYM 삭제

DROP SYNONYM D2;

--계층형 쿼리

--계층형 쿼리 사용전
SELECT ename FROM emp;

ENAME
--------------------
SMITH
ALLEN
WARD
JONES
MARTIN
BLAKE
CLARK
SCOTT
KING
TURNER
JAMES
FORD
MILLER
Tiger
Cat

=> EMP테이블의 데이터들

select * FROM emp;

--계층형 쿼리
COL "ENAME" FOR A25
select LPAD(ename, level*4,'*') "ename"
FROM emp
START WITH empno = 7839 -- 계층구조를 시작할 조건
CONNECT BY PRIOR empno = mgr --부모와 자식 간의 과계를 정의
;


COL "ENAME" FOR A25
select LPAD(ename, level*4,'*') "ename"
FROM emp
START WITH empno = 7839 -- 계층구조를 시작할 조건
CONNECT BY PRIOR empno = PRIOR mgr --부모와 자식 간의 과계를 정의 
;
-- PRIOR mgr : 해당 컬럼에서 바로 이전의 데이터 값을 찾는 데 사용한다.
-- EMPNO = 7839 사람의 MGR을 찾아라,

select LPAD (ENAME, LEVEL*5,'-')ENAME
FROM EMP
CONNECT BY EMPNO = PRIOR MGR
START WITH EMPNO = 7369
;

--계층형 쿼리 수행 순서
1.START WITH : 시작조건
2.CONNECT BY : 연결조건
3.WHERE 절의 조건 검색

-- 계층형 쿼리 주의 사항
1.CONNECT BY절에는 SUB QUERY사용할 수 없다
2.CONNECT BY, WHERE 적절한 인덱스 설정,조회시간이 오래걸린다
3.부분 범위 처리 기법을 아쉽게도 사용할 수 없다.

col mgr for a12
col "depth_name" for a30
SELECT empno,ename,job,mgr,level,PRIOR ename ,LPAD(' ' , (LEVEL-1)*2, ' ') || ename "depth_name" ,
PRIOR ename AS mgr_name
FROM emp
START WITH mgr IS NULL -- 시작 조건 KING
CONNECT BY PRIOR empno = mgr --계층 구조 전계 조건 : PRIOR empno는 상위의 사원 번호를 말한다.
ORDER SIBLINGS BY empno;

select *
from emp2,dept2;


SELECT LPAD(t1.name||'-'||NVL(t1.POSITION,'Team-Worker') || '-' ||t2.dname,LEVEL*27,'-') name_and_position
FROM emp2 t1, dept2 t2
WHERE t1.deptno = t2.dcode 
START WITH t1.pempno IS NULL 
CONNECT BY PRIOR t1.empno = t1.pempno
;
--WHERE절은 겹치는것
--START WIHT 절은 우선순위조건, pempno가 높은것 부터 차례로 내려간다

SELECT LEVEL
	  ,name
	  ,PRIOR name "MGR_NAME"
FROM emp2
START WITH pempno IS NULL
CONNECT BY pempno = PRIOR empno;

SELECT 

SELECT *
FROM emp2;

e.empno ,e.name, d.dname ,e.position

SELECT *
FROM dept2;

SELECT e.empno
	  ,e.name||'-'||d.dname||'-'||e.POSITION name_and_position
	  ,(SELECT COUNT(*)
	  	FROM emp2 t3
	  	START WITH t3.empno = t1.empno
	  	CONNECT BY PRIOR t3.empno = t3.pempno)-1 "COUNT"
FROM emp2 t1,dept2 
FROM emp2 e, dept2 d;

SELECT empno,ename,dname
FROM emp e, dept d
WHERE e.DEPTNO = d.DEPTNO
ORDER BY 3;

SELECT *
FROM STUDENT;

SELECT *
FROM DEPARTMENT;

SELECT *
FROM PROFESSOR;

SELECT s.name,p.name
FROM STUDENT s,PROFESSOR p

SELECT s.name,d.dname,p.name
FROM STUDENT s,DEPARTMENT d,PROFESSOR p
WHERE s.DEPTNO1 = d.DEPTNO
AND s.profno = p.profno
ORDER BY 2;

SELECT s.name,p.name
FROM STUDENT s,PROFESSOR p
WHERE s.PROFNO=p.PROFNO
AND s.deptno1 = 101;

SELECT *
FROM CUSTOMER c;

SELECT *
FROM gift

SELECT c.gname, c.point,g.gname
FROM CUSTOMER c , GIFT g
WHERE c.POINT BETWEEN g.G_START AND g.G_END

SELECT c.gname, c.point,g.gname
FROM CUSTOMER c JOIN GIFT g
ON c.POINT >= g.G_START
AND c.POINT <= g.G_END;
--비교 연산자 사용시 FROM절에 JOIN 추가
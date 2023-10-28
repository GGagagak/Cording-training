-- GRADE가 4인 학생들의 이름을 가져오는 쿼리를 작성하시오

SELECT *
FROM STUDENT
WHERE GRADE = 4;

-- 키가 170 이상이고 몸무게가 50 이상인 학생들의 이름을 가져오는 쿼리를 작성하시오

SELECT NAME, WEIGHT, HEIGHT 
FROM STUDENT
WHERE WEIGHT >= 50 
AND HEIGHT >= 170;

SELECT * FROM TEMP_STUDENT


-- 이름이 J로 시작하고 몸무게가 2로 끝나는 학생들의 데이터를 삭제하세요
DELETE FROM STUDENT
WHERE NAME LIKE 'J%'
AND WEIGHT LIKE '%2'
;

SELECT *
FROM STUDENT
WHERE NAME LIKE 'J%'
AND WEIGHT LIKE '%2'
;
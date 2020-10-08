-- SELECT MIN(height) FROM member;
-- SELECT AVG(height) FROM member;
-- -- AVG는 NULL값을 제외하고 평균을 계산한다.
-- SELECT * FROM member WHERE MIN(height);


-- SELECT COALESCE(address, '****') FROM member WHERE address IS NULL;
-- SELECT COALESCE(address, '****') FROM member;
-- SELECT * FROM member;



-- SELECT AVG(age) FROM member WHERE age BETWEEN 5 AND 100;
-- SELECT * FROM member WHERE address NOT LIKE '%호';


-- -- IS NULL과 NULL은 다르다
-- -- SELECT * FROM copang_main.member;
-- -- sql에서는 컬럼에 null값이 있으면 산술계산이 되지 않는다.
-- SELECT height, weight, (weight)/((height/100)*(height/100)) AS BMI FROM copang_main.member;


# 영상에서 본 SQL문을 직접 따라해보세요
SELECT
email,
CONCAT(height, 'cm',',',weight,'kg') AS '키와 몸무게',
weight / ((height/100) * (height/100)) BMI, -- AS 대신 space로 대체 가능
(CASE
WHEN weight IS NULL OR height IS NULL THEN '비만여부 알수없음'
WHEN weight / ((height/100) * (height/100)) >= 25 THEN '과체중'
WHEN weight / ((height/100) * (height/100)) >= 18.5 
AND weight / ((height/100) * (height/100)) <25 THEN '정상'
ELSE '저체중'
END) AS obesity_check
FROM copang_main.member;


-- NULL 을 다른 값으로 변환하는 함수들
-- 1. COALESCE (IFNULL에 비해 인자 여러개 대입 가능, sQL 표준 함수)
-- 2. IFNULL 함수 (only mySQl 함수)
-- 3. IF 함수
-- 4. CASE 함수



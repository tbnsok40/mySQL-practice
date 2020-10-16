# mySQL-practice

# Chapter 1. SQL 데이터 분석
<a href = 'https://github.com/tbnsok40/mySQL-practice/blob/master/chapter2.md'> Chapter 2. SQL 데이터 관리 </a>

## 201007
```sql
SELECT * FROM copang_main.member; -- copang_main이라는 db의 member table을 가져온다.
```

### DATETIME에 해당하는 함수
- YEAR
- MONTH
- DAYOFMONTH
- DATEDIFF
- CURDATE
- DATE_ADD
- DATE_SUB
- UNIX_TIMESTAMP
- FROM_UNIXTIME

```sql
SELECT * FROM member WHERE YEAR(birthday)='1992'; 
SELECT * FROM member WHERE MONTH(sign_up_day) IN (1,2,3); 
SELECT * FROM member WHERE DAYOFMONTH(sign_up_day) BETWEEN 16 AND 31;

-- = 등호는 그대로 비교, 
-- IN은 여러 선택지 중에 선택, 
-- BETWEEN은 범위내에서 선택, a AND b (a, b 모두 포함하는 범위)

SELECT email, sign_up_day, DATEDIFF(sign_up_day, '2020-10-07') FROM member;
SELECT email, sign_up_day, CURDATE(), DATEDIFF(sign_up_day, CURDATE()) FROM member; 
SELECT email, sign_up_day, CURDATE(), DATEDIFF(sign_up_day, birthday)/365 FROM member; 
-- SELECT email, sign_up_day, DATE_SUB(sign_up_day, INTERVAL -30 DAY), DATEDIFF(sign_up_day,'2010-01-01') FROM member; 
SELECT email, sign_up_day, UNIX_TIMESTAMP(sign_up_day) FROM member; 
SELECT email, sign_up_day, FROM_UNIXTIME(UNIX_TIMESTAMP(sign_up_day)) FROM member;
```

### WHERE (조건문, if같은 존재)
- %의 사용: 서울%, '서울'뒤에 문자열의 길이는 무관하다.
- "\_" 의 사용: 서울_, '서울'뒤에 문자열의 길이는 1이다.
```sql
-- 조건: gender는 m이면서 주소엔 서울이 들어가야하고, 나이는 20대
SELECT * FROM member
WHERE gender = 'm' AND address LIKE '서울%'
AND age BETWEEN 25 and 29;

-- 봄 또는 가을에 해당하는 조건
SELECT * FROM member
WHERE MONTH(sign_up_day) BETWEEN 3 and 5
OR MONTH(sign_up_day) BETWEEN 9 and 11;

-- 남자 회원중 키가 180 이상, 여자 회원 중 키가 170 이상
SELECT * FROM member
WHERE (gender = 'm' and height >= 180)
OR (gender = 'f' and height >= 170);
```

- AND 는 OR 보다 높은 우선순위를 가지므로 괄호를 적절히 사용해주자.


#### IN과 OR은 맥락이 같다
```sql
-- 아래 둘은 같은 의미: OR로 쓴 것을 IN으로 표현할 수 있다.
SELECT * FROM member WHERE age = 20 OR age = 30 OR age =40;
SELECT * FROM member WHERE age IN (20, 30, 40);
```
### 대소문자 구분 => BINARY 사용: 대문자와 소문자를 이진코드로 구분해버린다.
```sql
SELECT email FROM member WHERE email LIKE BINARY '%M%'
-- 대문자 M이 있는지 확인하는 query
```

```sql
SELECT * FROM member ORDER BY height desc;

SELECT sign_up_day, email FROM member
ORDER BY YEAR(sign_up_day) DESC, email ASC -- 가입년도가 같다면 이메일 기준 오름차순으로 정렬
LIMIT 10;
LIMIT 10, 2; -- 10번 째 부터 시작해서 2 이후까지 출력. 즉, 11,12 번째를 출력

-- CAST (data AS signed)
```

## 201008

#### MIN, AVG, MAX 등 내장함수
``` sql
SELECT MIN(height) FROM member;
SELECT AVG(height) FROM member;
-- AVG는 NULL값을 제외하고 평균을 계산한다.
```

#### COALESCE, NULL값 처리
```sql
SELECT COALESCE(address, '****') FROM member WHERE address IS NULL;
SELECT COALESCE(address, '****') FROM member;
SELECT * FROM member;
```

#### 이상값 처리해주기

``` sql
-- 100살 초과(AND 5살 미만) 이상값은 제외하고 평균을 구하고 싶을 때
SELECT AVG(age) FROM member WHERE age BETWEEN 5 AND 100;
SELECT * FROM member WHERE address NOT LIKE '%호';
```
- IS NULL과 NULL은 다르다
- sql에서는 컬럼에 null값이 있으면 산술계산이 되지 않는다.

``` sql
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
```
``` sql
-- NULL 을 다른 값으로 변환하는 함수들
-- 1. COALESCE (IFNULL에 비해 인자 여러개 대입 가능, sQL 표준 함수)
-- 2. IFNULL 함수 (only mySQl 함수)
-- 3. IF 함수
-- 4. CASE 함수
```

#### DISTINCT, SUBSTRING
- SUBSTRING: 문자열 슬라이싱
- DISTINCT 는 고유한 값만 추출 : pandas의 unique같은 것
``` sql
SELECT DISTINCT(gender) FROM member; -- 어떤 고유값들이 존재하는지 한번에 확인 가능 -> gender 컬럼이 가진 고유값들을 출력한다.
SELECT DISTINCT(SUBSTRING(address, 1, 2)) FROM member; -- SUBSTRING 함수: 1위치에서 2개의 문자열 읽어들인다.(일종의 슬라이싱)
```

#### LENGTH, UPPER, LOWER, LPAD, RPAD, LTRIM, RTRIM
``` sql
SELECT address, LPAD(age, 5, '!!!') FROM copang_main.member; -- LPAD, RPAD 5자리로 만들어준다('!!!'를 채움으로써) 이미 5자리면 대체 문자가 안들어간다.

-- LTRIM, RTRIM, TRIM
> 추가해줄 것
```

### GROUPING : 그룹화 하여 데이터 조회 / 컬럼에 있는 데이터를 그룹화

#### GROUP BY : WHERE 절과 양립할 수 없다 💥
- GROUP BY를 '사용한 컬럼'과 '집계 함수' 이외에는 SELECT 문에 넣을 수 없다.
- GROUP BY를 count, avg, min, max 등의 집계 함수와 같이 쓰면 더 다양하게 쓸 수 있다.
``` sql
-- GROUPING
SELECT gender, COUNT(*), AVG(height) FROM member GROUP BY gender; -- GROUP BY에 속한 컬럼은 gender뿐이니, SELECT문에도 gender만 가능 + 집계함수(COUNT(), AVG())
SELECT gender, COUNT(*), MIN(weight) FROM copang_main.member GROUP BY gender;
```

``` sql
-- 각 지역별 인원을 구하기 위해 COUNT(*)로 합계 인원을 counting
SELECT SUBSTRING(address, 1, 2) as region,
COUNT(*)
FROM copang_main.member 
GROUP BY SUBSTRING(address, 1, 2);
>>> 각 주소를 앞 2글자만 딴 region으로 재편성 -> 같은 이름(2글자) 끼리 count하여 counting 한다.
```

### HAVING
- HAVING은 그루핑에서 필터링을 할 때만 사용한다.
- WHERE를 쓰면 안된다 => 의미는 비슷해보이지만, 목적이 다르다. 

``` sql
SELECT SUBSTRING(address, 1, 2) as region,
COUNT(*)
FROM member 
GROUP BY SUBSTRING(address, 1, 2),
gender HAVING region = '서울'
AND gender = 'm';
-- region 중 서울인 것과 gender가 m인 것만 필터링. HAVING은 그루핑에서 추려내는 기능


SELECT 
SUBSTRING(address, 1, 2) as region,
gender,
COUNT(*)
FROM member 
GROUP BY SUBSTRING(address, 1, 2), gender
HAVING region IS NOT NULL -- SUBSTRING(address, 1, 2) 대신 region을 써준다.
ORDER BY
region ASC,
gender DESC;

```
## 벡틱과 따옴표
>

### ROLLUP (말아 올리다) : 부분 총계 함수
``` sql
SELECT
SUBSTRING(address, 1, 2) as region,
gender,
COUNT(*)
FROM copang_main.member
GROUP BY 
SUBSTRING(address, 1, 2),
gender
WITH ROLLUP -- 얘가 들어감으로써, null값이 들어간(= 부분총계) 값이 생긴다.
HAVING region IS NOT NULL 
ORDER BY
region ASC,
gender DESC;
```

### ROLLUP 특성
1. GROUP BY 뒤 기준들의 순서에 따라 WITH ROLLUP 의 결과도 달라진다.
``` sql
SELECT
SUBSTRING(address, 1, 2) as region,
gender,
COUNT(*)
FROM member
GROUP BY 
SUBSTRING(address, 1, 2),
gender
WITH ROLLUP -- 얘가 들어감으로써, null값이 들어간(= 부분총계) 값이 생긴다 / ROLLUP이 없었으면, gender간의 총합만 나타날 뿐, gender를 합친 총합은 나타나지 않는다.
HAVING region IS NOT NULL 
ORDER BY 
region ASC,
gender DESC;
```
2. NULL임을 나타내기 위해 쓰인 NULL vs. 부분 총계을 나타내기 위해 쓰인 NULL => GROUPING함수를 써서 해결
``` sql
SELECT 
YEAR(sign_up_day) AS s_year,
gender,
SUBSTRING(address, 1,2),
GROUPING(YEAR(sign_up_day)),
GROUPING(gender),
GROUPING(SUBSTRING(address,1,2)),
COUNT(*)
FROM copang_main.member
GROUP BY YEAR(sign_up_day), gender, SUBSTRING(address,1,2) WITH ROLLUP
ORDER BY s_year DESC;
```

## Foreign Key
(1) 참조를 하는 테이블인 stock 테이블을 ‘자식 테이블’
(2) 참조를 당하는 테이블인 item 테이블을 ‘부모 테이블’

## JOIN : LEFT OUTER JOIN, RIGHT OUTER JOIN, INNER JOIN
> JOIN은 FK를 기준으로 하는 것이 맞지만, FK가 존재하지 않더라도 얼마든지 JOIN 할 수 있다.
``` sql
-- table에 AS 를 활용할 땐, SELECT 문에서도 alias를 써줄 수 있다.
-- FROM 절에서 alias를 사용하는데, 다른 절에서도 alias로만 나타내야 에러가 나지 않는다.
SELECT
i.id,
i.name, 
s.item_id,
s.inventory_count
FROM item AS i RIGHT OUTER JOIN stock s -- alias를 쓸 땐, 의미를 명확히하기 위해 AS를 꼭 써주자
ON i.id = s.item_id;
```

#### QUIZ
>(1) 조인을 통해 생성된 결과 중에서 pizza_price_cost 테이블의 name 컬럼과, sales 테이블의 sales_volume 컬럼만 조회하세요. <br>
>(2) 이때 sales_volume 컬럼에는 '판매량'이라는 alias를 붙이고, sales_volume이 NULL인 row의 경우에는 ‘판매량 정보 없음’으로 표시하세요. 
> ```sql
> SELECT pcc.name, COALESCE(s.sales_volume, '판매량 정보 없음') as '판매량'
> FROM pizza_price_cost as pcc LEFT OUTER JOIN sales as s
> ON pcc.id = s.menu_id
> ```

### UNION
- item 테이블과, new_item 테이블이 있을 때, item table에 있는 상품이 빠짐없이 new_item 에 있을지 확신이 안든다면
- JOIN을 사용한다.
- UNION과 UNION ALL은 두 테이블을 합친다는 공통점은 있지만, 두 테이블의 중복 row를 제거하는지 여부에 따른 차이가 있다.

``` sql
SELECT
old.id AS old_id,
old.name AS old_name,
new.id AS new_id,
new.name AS new_name
FROM item AS old LEFT OUTER JOIN item_new AS new
-- FROM 절에서 alias를 해주었기에, 이걸 select 문에서 가져다 쓴다(JOIN할 때의 문법)
ON old.id = new.id;
-- LEFT OUTER JOIN 으로 누락된 정보들을 확인할 수 있다.
```


-- new table에서 새롭게 추가된 항목 체크해보기
``` sql
SELECT
old.id AS old_id,
old.name AS old_name,
new.id AS new_id,
new.name AS new_name
FROM item AS old RIGHT OUTER JOIN item_new AS new 
ON old.id = new.id; -- ON 대신 USING(id) 사용해도 된다, 조인 조건으로 쓰인 두 컬럼의 이름이 같으면 ON 대신 USING을 쓰는 경우도 있습니다.
-- WHERE old.id IS NULL; -- 새롭게 추가된것만 보기위함
-- INNER JOIN을 쓰면 두 테이블에 모두 존재하는 아이템만 간추린다.
```

``` sql
-- 아예 두 테이블을 합쳐, 전체 상품을 조회
SELECT * FROM item
UNION
SELECT * FROM item_new; -- itemitem겹치는 row는 한번만 보여줌
```


-- 세개의 테이블
-- 각 상품별 평균 평점을 확인 => 몇명이 상품을 샀는지도 확인하여
``` sql
SELECT i.id, i.name, AVG(star), COUNT(*)
FROM
item AS i LEFT OUTER JOIN review AS r
ON r.item_id = i.id
LEFT OUTER JOIN member AS m
ON r.mem_id = m.id
WHERE m.gender = 'f'
GROUP BY i.id, i.name
HAVING COUNT(*) > 1
ORDER BY 
AVG(star) DESC,
COUNT(*) DESC;
```
## QUIZ
``` sql
SELECT 
YEAR(i.registration_date) AS '등록 연도',
COUNT(*) AS '리뷰 개수',
AVG(r.star) AS '별점 평균값'
-- AVG(r.star)

FROM item as i INNER JOIN review as r 
ON r.item_id = i.id
INNER JOIN member as m
ON r.mem_id = m.id
WHERE i.gender = 'u'
GROUP BY YEAR(i.registration_date)
HAVING COUNT(i.registration_date) > 10;
```


## 서브쿼리
- 전체 sql문에서 다른 sql 자체를 서브로 사용
- 괄호로 서브쿼리를 꼭 감싸줄 것, inner query라고도 한다.
``` sql
SELECT 
id,
name,
price,
(SELECT AVG(price) FROM item) AS AVG_price
FROM item;
```

- 서브쿼리를 이용하여, 가격이 평균가보다 높은 row를 탐색
``` sql
SELECT 
id,
name,
price,
(SELECT AVG(price) FROM item) AS avg_price
FROM item
WHERE price > (SELECT AVG(price) FROM item);
```
```sql
IN을 활용한 서브쿼리 생성
SELECT * FROM item
WHERE id IN -- item컬럼의 id값이, IN 이후의 서브쿼리에 존재하는 녀석들만 나타내게 한다 
(
SELECT item_id
FROM review
GROUP BY item_id HAVING COUNT(*) >=3
);
```

- IN, ANY(= SOME), ALL
1. ANY는 서브쿼리 내용의 하나라도 만족하면 되는 것이고
2. ALL은 서브쿼리 내용의 모두를 만족해야하는 것.


## Quiz
- review 테이블에서
- (1) '2018년 12월 31일' 이전에 코팡 사이트에 등록된 상품들에 관한 리뷰들만 추려보겠습니다.
- (2) 그리고 이때 review 테이블의 모든 컬럼들을 조회하세요.
- *조인 말고 서브쿼리를 사용해서 문제를 해결해보세요.

``` sql
SELECT * FROM review
WHERE item_id IN 
(
SELECT id FROM item
WHERE YEAR(registration_date) < 2019
-- WHERE registration_date < '2018-12-31'
);
```
- FROM 절에 있는 쿼리 테이블(=서브 쿼리 자체)을 테이블로 만들어 버리기
- 이 테이블을 derived테이블이라 하는데 꼭 alias를 붙여주어야 한다.
*단일값(1row,1col)을 리턴하는 서브쿼리는 스칼라 서브쿼리라고한다.

``` sql
SELECT
    AVG(review_count),
    MAX(review_count),
    MIN(review_count)
FROM
(SELECT
SUBSTRING(address, 1, 2) AS region,
COUNT(*) AS review_count
FROM review AS r LEFT OUTER JOIN member as m
ON r.mem_id = m.id
GROUP BY SUBSTRING(address, 1, 2)
HAVING region IS NOT NULL
AND region != '안드') AS review_count_summary;
```

- 상관서브쿼리와 비상관 서브쿼리

``` sql
-- 서브쿼리로 더 간결해진 CASE문 사용하기. 아래 sql문을 보면, SELECT절에서 "BMI"로 alias 정한 것은 CASE문에서는 재사용하지 못한다.
SELECT
email,
CONCAT(height, 'cm', ',', weight, 'kg') AS '키와 몸무게',
weight / ((height / 100) * (height / 100)) AS 'BMI',
CASE
WHEN weight IS NULL OR height IS NULL THEN '비만 여부 알 수 없음'
WHEN weight / ((height / 100) * (height / 100)) >= 25 THEN '과체중 또는 비만'
WHEN weight / ((height / 100) * (height / 100)) >= 18
AND weight / ((height / 100) * (height / 100)) < 25 THEN '정상'
ELSE '저체중'
END
FROM copang_main.member;

-- 대신, FROM절에서 (SELECT weight / ((height / 100) * (height / 100)) AS 'BMI' FROM copang_main.member) AS subsequery_BMI
-- 이렇게 BMI로 명명하면, CASE문에서도 BMI를 사용할 수 있게 된다.
SELECT
BMI, -- 여기에 weight / ((height/100) * (height/100)) AS BMI 이렇게 해놔서 에러가 생겼음, AS 구문을 쓸 필요가 없으니 BMI만 남겨준다.
(CASE
	WHEN BMI > 20 AND BMI < 25 THEN '정상'
    ELSE '비정상'
END)
FROM (
SELECT weight / ((height/100) * (height/100)) AS BMI FROM member
) AS subquery;
```

## 뷰
- 서브쿼리 중첩 => 너무길고 중복되는 문제 발생(가독성 떨어져)
- 뷰를 사용하여 해결. 뷰: 결과테이블이 가상으로 저장된 상태 = 가상테이블
- 자주쓰는 서브쿼리가 있다면 뷰로 미리 저장을 해두어 재사용하도록 하자
> 테이블과 뷰의 가장 큰 차이는, 뷰는 물리적으로 컴퓨터에 저장되어 있는 것이 아니다. 문자 그대로 '가상' 테이블이다.
> 뷰의 장점
> 1. 사용자에게 높은 편의성 제공 -> 필요한 테이블 재사용 가능
> 2. 기존 테이블 구조를 변형시키지 않으면서, 다양한 데이터 분석 가능
> 3. 데이터 보안 제공 -> 테이블에 민감정보가 포한된 컬럼은 제외하여 뷰를 만들어 보안 지킬 수 있다.

```sql
CREATE VIEW v_emp AS SELECT
id, name, age, department, phone_num, hire_date FROM employee;
SELECT * FROM v_emp;
```

#### 실무에서 첫번째로 해야 할 
1. 존재하는 DB 파악
> SHOW DATABASES;
> use <DB이름>;

2. 존재하는 Table 파악
> SHOW FULL TABLES IN copang_main;

3. 한 테이블의 컬럼 구조 파악
> DESCRIBE item;
> -- item은 table이름

4. Foreign Key 파익

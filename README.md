# mySQL-practice
> Chapter 1. SQL 데이터 분석

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
SELECT email, sign_up_day, DATEDIFF(sign_up_day, '2020-10-07') FROM member;
SELECT email, sign_up_day, CURDATE(), DATEDIFF(sign_up_day, CURDATE()) FROM member; 
SELECT email, sign_up_day, CURDATE(), DATEDIFF(sign_up_day, birthday)/365 FROM member; 
SELECT email, sign_up_day, DATE_SUB(sign_up_day, INTERVAL 250 DAY), DATEDIFF(sign_up_day, 250) FROM member; 
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
-- 아래 둘은 같은 의미
SELECT * FROM member WHERE age = 20 OR age = 30 OR age =40;
SELECT * FROM member WHERE age IN (20, 30, 40);
```
### 대소문자 구분 => BINARY 사용: 대문자와 소문자를 이진코드로 구분해버린다.
```sql
SELECT email FROM member WHERE email LIKE BINARY '%M%'

SELECT * FROM member ORDER BY height desc;

SELECT sign_up_day, email FROM member
ORDER BY YEAR(sign_up_day) DESC, email ASC -- 가입년도가 같다면 이메일 기준 오름차순으로 정렬
LIMIT 10;
LIMIT 10, 2;

-- CAST (data AS signed)
```

## 201008

#### MIN, AVG, MAX 등 내장함수
``` sql
SELECT MIN(height) FROM member;
SELECT AVG(height) FROM member;
-- AVG는 NULL값을 제외하고 평균을 계산한다.
SELECT * FROM member WHERE MIN(height);
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
``` sql
-- IS NULL과 NULL은 다르다
-- sql에서는 컬럼에 null값이 있으면 산술계산이 되지 않는다.
SELECT height, weight, (weight)/((height/100)*(height/100)) AS BMI FROM copang_main.member;
```

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
``` sql
-- DISTINCT 는 고유한 값만 추출 : pandas의 unique같은 것
SELECT DISTINCT(gender) FROM member; -- 어떤 고유값들이 존재하는지 한번에 확인 가능 -> gender 컬럼이 가진 고유값들을 출력한다.
SELECT DISTINCT(SUBSTRING(address, 1, 2)) FROM member; -- SUBSTRING 함수: 1위치에서 2개의 문자열 읽어들인다.(일종의 슬라이싱)
```

#### LENGTH, UPPER, LOWER, LPAD, RPAD, LTRIM, RTRIM
``` sql
SELECT address, LPAD(age, 5, '!!!') FROM copang_main.member; -- LPAD, RPAD 5자리로 만들어준다('!!!'를 채움으로써) 이미 5자리면 대체 문자가 안들어간다.

-- LTRIM, RTRIM, TRIM
> 추가해줄 것
```

### GROUPING

#### GROUP BY
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
HAVING region IS NOT NULL
ORDER BY
region ASC,
gender DESC;

```
## 벡틱과 따옴표
>
# mySQL-practice
> Chapter 2. SQL 데이터 

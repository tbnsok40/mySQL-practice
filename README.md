# mySQL-practice

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

```sql
-- 아래 둘은 같은 의미
SELECT * FROM member WHERE age = 20 OR age = 30 OR age =40;
SELECT * FROM member WHERE age IN (20, 30, 40);

SELECT email FROM member WHERE email LIKE BINARY '%M%'

SELECT * FROM member ORDER BY height desc;

SELECT sign_up_day, email FROM member
ORDER BY YEAR(sign_up_day) DESC, email ASC -- 가입년도가 같다면 이메일 기준 오름차순으로 정렬
LIMIT 10;
LIMIT 10, 2;

-- CAST (data AS signed)
```

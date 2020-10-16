# CHAPTER 2. SQL로 하는 데이터 관리

<a href = 'https://github.com/tbnsok40/mySQL-practice'> CHAPTER 1 SQL 데이터 분석 </a>

## DB 만들기
``` sql
CREATE DATABASE IF NOT EXISTS course_rating ;
USE coures_rating;
```

* AI: auto increment

### Table 생성
* backtick으로 써주는게 중요

### Table 생성 후 row 삽입
``` sql
INSERT INTO student (name, student_number, major, admission_date)
VALUES('임성후',201313431,'컴공','2014-12-12');
```


### INSERT 예시
``` sql
CREATE TABLE `animal_info` (
`id` INT NOT NULL AUTO_INCREMENT,
`type` VARCHAR(30),
`name` VARCHAR(10),
`age` TINYINT(2),
`sex` CHAR(1),
`weight` DOUBLE,
`feature` VARCHAR(50),
`entry_date` DATE,
PRIMARY KEY (`id`));

INSERT INTO animal_info (type, name, age, sex, weight, feature, entry_date) VALUES ('사자', '리오', 8, 'm', 170.5, '상당히 날렵하고 성격이 유순한 편임', '2015-03-21');
INSERT INTO animal_info (type, name, age, sex, weight, feature, entry_date) VALUES ('코끼리', '조이', 15, 'f', 3000, '새끼 때 무리에서 떨어져 길을 잃고 방황하다가 동물원에 들어와서 적응을 잘 마침', '2007-07-16');
INSERT INTO animal_info (type, name, age, sex, weight, feature, entry_date) VALUES ('치타', '매튜', 20, 'm', 62, '나이가 노령이라 최근 활동량이 현저히 줄어든 모습이 보임', '2003-11-20');

SELECT * FROM animal_info;
```

### UPDATE
> UPDATE 테이블명 SET 컬럼명
- WHERE 절을 작성하지 않으면, 모든 row가 update 된다.

```sql
UPDATE student
SET major = '환공', name = '림성후' WHERE id = 2;

-- 이런것도 가능
UPDATE student SET student_number = student_number + 3;
UPDATE student SET is_canceled = 'Y' WHERE id = 2;
```

### DELETE
- DELETE FROM 테이블 WHERE 조건

```sql
DELETE FROM student WHERE id = 3; -- id 3인 row 물리 삭제, 물삭물삭
```


### 물리 삭제, 논리 삭제
- 물리 삭제: 실제 DB의 table에서 row를 삭제하는 것
- 논리 삭제: 실제 DB에서 데이터를 삭제하는 것이 아닌, 테이블에 별도의 컬럼을 만들어 삭제 여부를 체크하는 것


> ### Quiz
> (1) ‘남성정장 상하의 세트' 중고 물품이 너무 팔리지 않아서인지 판매자가 삭제해버렸습니다. 이 row의 is_deleted 컬럼의 값을 Y로 갱신해주세요. 
> (2) is_deleted 컬럼의 값이 Y이면서, 그 게시글 업로드일이 2020년 7월 5일 기준으로 365일보다 더 오래된 상품들의 row를 물리 삭제하세요. 
> ```sql
> UPDATE item SET is_deleted = 'Y' WHERE name LIKE '남성%';
> DELETE FROM item WHERE is_deleted = 'Y' AND DATEDIFF(upload_date, '2020-7-5') < -365;
> select * from item;
> ```

### DESCRIBE or DESC

``` sql
DESCRIBE student;
-- or
DESC student;
```

### ALTER TABLE : 변경

``` sql
gender라는 컬럼을 추가한다.
ALTER TABLE student ADD gender CHAR(1) null; 

기존 컬럼의 이름을 수정한다.
ALTER TABLE student RENAME COLUMN student_number TO registrations_number;

컬럼 삭제
ALTER TABLE student DROP COLUMN addmission_date;
```

### 컬럼 데이터 타입 변경
- major 컬럼의 속성을 int로 바꿔주기 위해선 위에서 major의 속성을 모두 숫자로 바꿔준 후 에 컬럼 타입을 변경해야한다.

```sql
UPDATE student SET major = 10 WHERE major = '컴퓨터공학과';
UPDATE student SET major = 11 WHERE major = '멀티미디어학과';
UPDATE student SET major = 12 WHERE major = '법학과';

ALTER TABLE student MODIFY major INT;
SELECT * FROM student;
```

### QUIZ
1) name컬럼의 이름을 model로 수정
2) size 컬럼의 type을 double로 바꾸고, NOT NULL 설정해주기
3) brand 컬럼 삭제
4) stock 컬럼 추가, type은 int, NOT NULL 설정
``` sql
ALTER TABLE shoes RENAME COLUMN name to model;
ALTER TABLE shoes MODIFY size double NOT NULL; -- modify를 이용하면, type과 not null 속성을 한번에 바꿀 수 있다.	
ALTER TABLE shoes DROP brand;
ALTER TABLE shoes ADD stock int null NOT NULL;
```

#### NOT NULL 속성에 default 값 부여
``` sql
ALTER TABLE student MODIFY major INT NOT NULL default 101;
INSERT INTO student(name, registrations_number)
Values('김봉주','201313431');
```

``` sql
ALTER TABLE student MODIFY registrations_number INT NOT NULL UNIQUE;
INSERT INTO student (name, registrations_number) VALUES ('최태웅', 201313431);
-- 만약, 201313431 이란 registrations_number의 속성값이 이미 존재한다면, UNIQUE 조건으로 인해 에러가 발생한다.
```

### PRIMARY KEY와 UNIQUE의 차이
- Primary Key는 그 존재 목적과 실무적인 이유 등으로 인해 당연히 NULL이 들어가면 안 되는 것입니다. 
- 이에 반해, Unique 속성은 각 row마다 각자 다른 값을 가지도록 강제하는 것입니다. 그리고 이때 각 row마다 해당 컬럼의 값이 다르다면, NULL도 unique하다고 인정되기 때문에 Unique 속성이 있는 컬럼에는 NULL이 허용되는 것이죠.
- 물론 이러한 내용들은 약간의 의견 차이가 있을 수 있으나 방금 설명드린 내용이 대부분의 DBMS에서 구현된 Primary Key와 Unique 속성 간의 차이입니다. 


### CONSTRAINT : 제약조건 부여

> ADD CONSTRAINT constraint_name CHECK (제약조건)
```sql
ALTER TABLE student ADD CONSTRAINT st_rule CHECK (registration_number < 3000000);

INSERT INTO student (name, registration_number) VALUES ('이대위', 30000000); // 제약조건 위반 에러 발생
ALTER TABLE student DROP CONSTRAINT st_rule; // 제약조건 삭제 (DROP)
INSERT INTO student (name, registration_number) VALUES ('이대위', 30000000); // 정상작동
SELECT * FROM student;
```
* 제약사항을 세심하게 걸어줄 수록 양질의 데이터베이스 만들 수 있다.

#### 다중 제약조건 설정
```sql
ALTER TABLE student
ADD CONSTRAINT st_rule
CHECK (email LIKE '%@%' AND gender IN ('m','f')); 
```


### 테이블 이름 수정/ 테이블 복사, 삭제
``` sql
-- 테이블 이름 바꾸기
RENAME TABLE student TO undergraduate;

-- 테이블 복사
CREATE TABLE copy_of_undergraduate AS SELECT * FROM undergraduate;
SELECT * FROM copy_of_undergraduate;

-- 테이블 삭제
DROP TABLE copy_of_undergraduate;
```
### 테이블 내부 row 삭제
```sql
DELETE FROM student;
TRUNCATE student;
```

### 테이블 구조 복사

```sql
CREATE TABLE copy_of_undergraduate LIKE undergraduate;

SELECT * FROM copy_of_undergraduate;
```

#### 복사한 구조에 row 복사
```sql
INSERT INTO copy_of_undergraduate SELECT * FROM undergraduate; // SELECT 절을 그대로 가져온다

-- major가 101인 row만 가져와 복사하기(조건에 맞는 컬럼만 복사해오기)
INSERT INTO copy_of_undergraduate 
SELECT * FROM undergraduate WHERE major = 101;
```


### Foreign Key와 참조 무결성

- 한 테이블 내에서 다른 테이블의 특정 row를 식별하게 해주는 컬럼이 Foreign Key,
- Foreign Key로 다른 테이블의 Primary Key를 참조(reference)한다라고 표현.

#### 참조 무결성 : FK는 자식테이블의 부모테이블에 대한 참조 무결성을 지키기 위해 설정하는 것
- DBMS 상에서 한 테이블의 컬럼을, '이것이 다른 테이블의 컬럼을 참조하는 Foreign Key다'라고 설정해놓으면 ‘참조 무결성(Referential Integrity)'이라는 것을 지킬 수 있다. <br>
*부모테이블의 pk에 없는 값을 자식테이블에서 생성하려 하면 참조 무결성을 위반하기 때문에 에러가 발생한다.

### 참조 무결성 위반에 대처 : RESTRICT(NO ACTION), CASCADE, SET NULL

1. ON DELETE에 대해
- restrict 정책 : 제한하다 -> 참조하는 로우가 하나라도 있다면 삭제할 수 없다. => NO ACTION과 같은 의미(행동)
- CASCADE 정책 : 부모테이블의 ROW가 없어지면, 참조하는 자식테이블의 ROW도 갈아버린다.
- SET NULL 정책 : 부모테이블의 ROW를 삭제하면, 해당 ROW를 참조하는 자식테이블의 FK는 NULL값으로 SETTING된다.

2. ON UPDATE에 대해
- restrict : PK 변경 시 에러 발생
- cascade : pk 변경 시, fk도 연쇄 변경
- set null : pk 변경 시, fk는 null값으로 변경

#### ON DELETE와 ON UPDATE가 꼭 같은 정책을 설정해야 할 필요는 없다. 상황에 맞는 설정을 해주면 된다.

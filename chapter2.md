# CHAPTER 2. SQL로 하는 데이터 관리
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
- UPDATE 테이블명 SET 컬럼명
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

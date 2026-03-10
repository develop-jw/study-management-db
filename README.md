# 스터디 관리 서비스 DB 설계

> 서비스 흐름을 데이터 구조로 직접 표현한 DB 설계 프로젝트

---

## 프로젝트 개요

데이터베이스 시스템 전공 수업에서 교내 학습 공동체 서비스를
직접 시나리오로 구상하여 DB를 설계하고 구현한 프로젝트입니다.
요구사항 정의부터 ERD 설계, 테이블 구현, 샘플 데이터 삽입,
쿼리 작성, 무결성 검증까지 전 과정을 혼자 수행했습니다.

---

## ERD


<img width="730" height="665" alt="ERD" src="https://github.com/user-attachments/assets/4533140e-2d9f-48b1-bbe8-f5805c2f743a" />

---

## 🏗️ 테이블 설계 의도

### 신청(Application)과 참여(Participation) 분리
신청 상태가 승인으로 확정된 경우에만 참여 기록이 생성되도록
두 테이블을 분리했습니다. 하나의 테이블로 합칠 경우 거절된
신청자와 실제 참여자가 혼재하여 참여자 기준 조회 시마다
별도 필터링이 필요해지는 문제를 구조적으로 방지했습니다.

### 출석(Attendance)과 리뷰(Review)를 참여(Participation)에 종속
출석과 리뷰는 학생 개인의 이력이 아니라 특정 스터디에
참여한 기록에 귀속되어야 한다고 판단했습니다.
동일한 학생이 여러 스터디에 참여해도 스터디별로
독립적으로 관리될 수 있는 구조를 만들었습니다.

### 제약 조건 설정
- 상태값에 CHECK 제약 → 허용되지 않는 값 입력 차단
- 이메일에 UNIQUE 제약 → 중복 가입 방지
- 학년에 CHECK 제약 → 1~4 범위 외 값 차단

---

## 기술 스택

| 분류 | 기술 |
|------|------|
| DB | MySQL |
| 툴 | DBeaver, MySQL Workbench |
| 데이터 생성 | 생성형 AI (시나리오 기반 샘플 데이터) |

---

## 프로젝트 구조
```
study-management-db/
├── docs/
│   └── ERD.png                # ERD 다이어그램
├── sql/
│   ├── create_table.sql       # 테이블 생성
│   ├── insert_data.sql        # 샘플 데이터 삽입
│   ├── query.sql              # 서비스 쿼리
│   └── validation.sql         # 무결성 검증 쿼리
└── docs/
    ├── 요구사항정의서.hwp
    ├── 스키마정의서.hwp
    └── 개발완료보고서.hwp
```

---

## 주요 쿼리

### 스터디별 신청자 수 vs 실제 참여자 수 비교
```sql
SELECT s.study_id, s.title AS 스터디명, COUNT(a.application_id) AS 신청자수
FROM Study s
LEFT JOIN Application a ON s.study_id = a.study_id
GROUP BY s.study_id, s.title;
```

### 평균 출석 횟수 초과 학생 추출
```sql
SELECT name, student_id
FROM Student
WHERE student_id IN (
    SELECT p.student_id
    FROM Participation p
    JOIN Attendance a ON p.participation_id = a.participation_id
    WHERE a.status = '출석'
    GROUP BY p.student_id
    HAVING COUNT(*) > (
        SELECT AVG(출석수) FROM (
            SELECT COUNT(*) AS 출석수
            FROM Attendance a2
            WHERE a2.status = '출석'
            GROUP BY a2.participation_id
        ) AS 출석통계
    )
);
```

---

## 무결성 검증 케이스 6가지

| 케이스 | 내용 |
|--------|------|
| R-7 | 스터디를 한 번도 개설하지 않은 학생 조회 |
| R-8 | 신청 이력이 없는 학생 조회 |
| R-9 | 승인되지 않은 신청자가 참여 테이블에 존재하는지 확인 |
| R-10 | 출석 기록이 없는 참여자 확인 |
| R-11 | 리뷰를 2건 이상 작성한 참여자 확인 |
| R-12 | 존재하지 않는 학생/스터디를 참조하는 데이터 확인 |

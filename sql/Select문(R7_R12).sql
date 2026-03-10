select * from student;
select * from study;
select * from application;
select * from attendance;
select * from participation;
select * from review;

# R-7
-- 스터디를 개설한 학생 수 (스터디 ≥ 1)
SELECT leader_id, COUNT(*) AS 개설스터디수
FROM Study
GROUP BY leader_id;
-- 스터디를 하나도 개설하지 않은 학생 찾기
SELECT student_id, name
FROM Student
WHERE student_id NOT IN (
  SELECT DISTINCT leader_id FROM Study
);


# R-8
-- 특정 학생의 신청 내역
SELECT a.student_id, s.title, a.status
FROM Application a
JOIN Study s ON a.study_id = s.study_id
ORDER BY a.student_id;
-- 신청하지 않은 학생들
SELECT student_id, name
FROM Student
WHERE student_id NOT IN (
  SELECT DISTINCT student_id FROM Application
);


# R-9
-- 참여자 중 신청 상태가 승인인지 확인 (위반이 있다면 이상)
SELECT p.student_id, p.study_id
FROM Participation p
LEFT JOIN Application a
ON p.student_id = a.student_id AND p.study_id = a.study_id
WHERE a.status <> '승인' OR a.status IS NULL;


# R-10
-- 출석 기록이 있는 참여자 목록
SELECT DISTINCT participation_id FROM Attendance;
-- 출석 기록이 아예 없는 참여자
SELECT participation_id
FROM Participation
WHERE participation_id NOT IN (
  SELECT DISTINCT participation_id FROM Attendance
);


# R-11
-- 2건 이상 리뷰 작성한 참여자 (있으면 X)
SELECT participation_id, COUNT(*) AS 리뷰수
FROM Review
GROUP BY participation_id
HAVING COUNT(*) > 1;
-- 1건 이하 리뷰 작성한 참여자 (있으면 X)
SELECT participation_id, COUNT(*) AS 리뷰수
FROM Review
GROUP BY participation_id
HAVING COUNT(*) <= 1;


# R-12
-- 존재하지 않는 student_id가 포함된 신청
SELECT *
FROM Application
WHERE student_id NOT IN (SELECT student_id FROM Student);

-- 존재하지 않는 study_id가 포함된 신청
SELECT *
FROM Application
WHERE study_id NOT IN (SELECT study_id FROM Study);
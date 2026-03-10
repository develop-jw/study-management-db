select * from student;
select * from study;
select * from application;
select * from attendance;
select * from participation;
select * from review;


# 스터디별 신청자 수
SELECT s.study_id, s.title AS 스터디명, COUNT(a.application_id) AS 신청자수
FROM Study s
LEFT JOIN Application a ON s.study_id = a.study_id
GROUP BY s.study_id, s.title;


# 스터디별 실제 참여자 수
SELECT s.study_id, s.title AS 스터디명, COUNT(p.participation_id) AS 참여자수
FROM Study s
LEFT JOIN Participation p ON s.study_id = p.study_id
GROUP BY s.study_id, s.title;


# 평균 출석 횟수보다 더 많이 출석한 학생
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
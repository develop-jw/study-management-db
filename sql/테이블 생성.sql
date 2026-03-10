CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    major VARCHAR(45),
    year INT CHECK (year BETWEEN 1 AND 4)
);

CREATE TABLE Study (
    study_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    max_participants INT CHECK (max_participants BETWEEN 1 AND 20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    leader_id INT,
    FOREIGN KEY (leader_id) REFERENCES Student(student_id)
);

CREATE TABLE Application (
    application_id VARCHAR(10) PRIMARY KEY,
    applied_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(10) CHECK (status IN ('대기', '승인', '거절', '취소')) NOT NULL,
    student_id INT,
    study_id INT,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (study_id) REFERENCES Study(study_id)
);

CREATE TABLE Participation (
    participation_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    study_id INT,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(10) NOT NULL CHECK (status IN ('참여중', '완료', '탈퇴')),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (study_id) REFERENCES Study(study_id)
);

CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    participation_id INT,
    date DATE NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('출석', '지각', '결석')),
    FOREIGN KEY (participation_id) REFERENCES Participation(participation_id)
);

CREATE TABLE Review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    participation_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    content TEXT NOT NULL,
    written_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (participation_id) REFERENCES Participation(participation_id)
);












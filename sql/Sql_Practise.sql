CREATE DATABASE SQL_Practice;
USE SQL_Practice;
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender CHAR(1),
    city VARCHAR(50)
);
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor VARCHAR(50)
);
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
INSERT INTO students VALUES
(1,'Alice','Johnson',20,'F','New York'),
(2,'Bob','Smith',21,'M','Chicago'),
(3,'Charlie','Brown',22,'M','Boston'),
(4,'David','Wilson',20,'M','Seattle'),
(5,'Emma','Thomas',23,'F','Dallas'),
(6,'Frank','Miller',21,'M','Miami'),
(7,'Grace','Taylor',22,'F','Denver'),
(8,'Henry','Anderson',20,'M','Austin'),
(9,'Isabella','Martin',21,'F','Houston'),
(10,'Jack','White',22,'M','Phoenix');
INSERT INTO courses VALUES
(101,'Python','Dr. James'),
(102,'SQL','Dr. Wilson'),
(103,'Machine Learning','Dr. David'),
(104,'Data Analytics','Dr. John'),
(105,'Statistics','Dr. Brown');
INSERT INTO enrollments VALUES
(1,1,101,90,'2024-01-10'),
(2,1,102,85,'2024-01-12'),
(3,2,101,76,'2024-01-10'),
(4,2,103,65,'2024-01-15'),
(5,3,102,95,'2024-01-11'),
(6,3,104,88,'2024-01-13'),
(7,4,105,72,'2024-01-14'),
(8,5,103,91,'2024-01-15'),
(9,6,104,69,'2024-01-16'),
(10,7,105,80,'2024-01-17'),
(11,8,101,55,'2024-01-18'),
(12,9,102,78,'2024-01-19'),
(13,10,104,84,'2024-01-20'),
(14,5,101,93,'2024-01-21'),
(15,7,103,87,'2024-01-22');
SELECT * FROM enrollments;
SELECT * FROM courses;
SELECT * FROM students;

-- Aggregate Functions
SELECT COUNT(*) AS total_students FROM students;
SELECT AVG(marks) AS average_marks FROM enrollments;
SELECT MAX(marks) FROM enrollments;
SELECT MIN(marks) FROM enrollments;
SELECT SUM(marks) FROM enrollments;

-- GROUP BY
SELECT
course_id,
AVG(marks) AS avg_marks
FROM enrollments
GROUP BY course_id;

SELECT
course_id,
COUNT(student_id)
FROM enrollments
GROUP BY course_id;

SELECT
course_id,
AVG(marks)
FROM enrollments
GROUP BY course_id
HAVING AVG(marks)>80;

SELECT
    s.first_name,
    s.last_name,
    e.marks
FROM students s
INNER JOIN enrollments e
ON s.student_id = e.student_id;

SELECT
s.first_name,
    s.last_name,
c.course_name
FROM students s
INNER JOIN enrollments e
ON s.student_id=e.student_id
INNER JOIN courses c
ON e.course_id=c.course_id;

SELECT
s.first_name,
    s.last_name,
e.course_id
FROM students s
LEFT JOIN enrollments e
ON s.student_id=e.student_id;

SELECT
s.first_name,
    s.last_name,
e.course_id
FROM students s
RIGHT JOIN enrollments e
ON s.student_id=e.student_id;

SELECT
student_id,
marks,
CASE
WHEN marks>=90 THEN 'Excellent'
WHEN marks>=75 THEN 'Good'
ELSE 'Needs Improvement'
END AS Performance
FROM enrollments;
SELECT *
FROM enrollments
WHERE marks>(
SELECT AVG(marks)
FROM enrollments
);
SELECT *
FROM enrollments
WHERE marks=(
SELECT MAX(marks)
FROM enrollments
);
WITH AvgMarks AS
(
SELECT AVG(marks) AS average
FROM enrollments
)

SELECT *
FROM AvgMarks;
WITH AvgMarks AS
(
SELECT AVG(marks) avg_mark
FROM enrollments
)

SELECT *
FROM enrollments
WHERE marks>(
SELECT avg_mark
FROM AvgMarks
);
SELECT
student_id,
marks,
ROW_NUMBER() OVER(ORDER BY marks DESC) AS RowNo
FROM enrollments;
SELECT
student_id,
marks,
RANK() OVER(ORDER BY marks DESC) AS RankNo
FROM enrollments;
SELECT
student_id,
marks,
DENSE_RANK() OVER(ORDER BY marks DESC) AS DenseRank
FROM enrollments;
SELECT
student_id,
marks,
LAG(marks) OVER(ORDER BY marks DESC) AS PreviousMarks
FROM enrollments;
SELECT
student_id,
marks,
LEAD(marks) OVER(ORDER BY marks DESC) AS NextMarks
FROM enrollments;
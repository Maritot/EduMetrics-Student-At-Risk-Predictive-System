create database EduMetrics;
use EduMetrics;
CREATE TABLE studentInfo (
    code_module VARCHAR(10),
    code_presentation VARCHAR(10),
    id_student INT,
    gender VARCHAR(10),
    region VARCHAR(100),
    highest_education VARCHAR(100),
    imd_band VARCHAR(20),
    age_band VARCHAR(20),
    num_of_prev_attempts INT,
    studied_credits INT,
    disability VARCHAR(5),
    final_result VARCHAR(20)
);
SELECT * FROM studentInfo LIMIT 10;
CREATE TABLE studentRegistration (
    code_module VARCHAR(10),
    code_presentation VARCHAR(10),
    id_student INT,
    date_registration DATE,
    date_unregistration DATE
);
DROP TABLE IF EXISTS studentRegistration;

CREATE TABLE studentRegistration (
    code_module VARCHAR(10),
    code_presentation VARCHAR(10),
    id_student INT,
    date_registration INT,
    date_unregistration INT
);
SELECT * FROM studentRegistration LIMIT 10;
DROP VIEW IF EXISTS vw_student_demographics;

CREATE VIEW vw_student_demographics AS
SELECT
    si.id_student,
    si.code_module,
    si.code_presentation,
    si.gender,
    si.region,
    si.highest_education,
    si.imd_band,
    si.age_band,
    si.disability,
    si.num_of_prev_attempts,
    si.studied_credits,
    si.final_result,
    sr.date_registration,
    sr.date_unregistration
FROM studentInfo si
LEFT JOIN studentRegistration sr
  ON si.id_student = sr.id_student
  AND si.code_module = sr.code_module
  AND si.code_presentation = sr.code_presentation;
  
  SELECT * FROM vw_student_demographics LIMIT 20;

SELECT
    id_student,
    code_module,
    code_presentation,
    COUNT(*) AS duplicate_count
FROM vw_student_demographics
GROUP BY
    id_student,
    code_module,
    code_presentation
HAVING COUNT(*) > 1;

SELECT *

FROM vw_student_demographics

WHERE gender IS NULL
OR region IS NULL
OR highest_education IS NULL;


CREATE TABLE studentVle (
    code_module VARCHAR(10),
    code_presentation VARCHAR(10),
    id_student INT,
    id_site INT,
    date INT,
    sum_click INT,
    
    PRIMARY KEY (
        code_module,
        code_presentation,
        id_student,
        id_site,
        date
    )
);
select * from studentVle;

CREATE TABLE studentAssessment (
    id_assessment INT,
    id_student INT,
    date_submitted INT,
    is_banked INT,
    score DECIMAL(5,2),

    PRIMARY KEY (id_assessment, id_student)
);

select * from studentAssessment;

CREATE TABLE assessments (
    code_module VARCHAR(10),
    code_presentation VARCHAR(10),
    id_assessment INT PRIMARY KEY,
    assessment_type VARCHAR(20),
    date INT,
    weight DECIMAL(5,2)
);

select * from assessments;

WITH first_exam AS (
    SELECT
        sa.id_student,
        a.code_module,
        a.code_presentation,
        MIN(a.date) AS first_exam_date
    FROM studentAssessment sa
    JOIN assessments a
        ON sa.id_assessment = a.id_assessment
    GROUP BY
        sa.id_student,
        a.code_module,
        a.code_presentation
)

SELECT
    sv.id_student,
    sv.code_module,
    sv.code_presentation,
    SUM(sv.sum_click) AS total_clicks_before_first_exam
FROM studentVle sv
JOIN first_exam fe
    ON sv.id_student = fe.id_student
   AND sv.code_module = fe.code_module
   AND sv.code_presentation = fe.code_presentation
WHERE sv.date < fe.first_exam_date
GROUP BY
    sv.id_student,
    sv.code_module,
    sv.code_presentation
ORDER BY
    total_clicks_before_first_exam DESC;
    
    
    


SELECT
    a.code_module,
    a.code_presentation,
    sa.id_student,

    ROUND(SUM(sa.score * a.weight / 100.0),2) AS total_weighted_score,

    RANK() OVER(
        PARTITION BY
            a.code_module,
            a.code_presentation
        ORDER BY
            SUM(sa.score * a.weight / 100.0) DESC
    ) AS student_rank

FROM studentAssessment sa

JOIN assessments a
ON sa.id_assessment = a.id_assessment

GROUP BY
    a.code_module,
    a.code_presentation,
    sa.id_student

ORDER BY
    a.code_module,
    a.code_presentation,
    student_rank;
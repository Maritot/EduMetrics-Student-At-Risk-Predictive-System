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

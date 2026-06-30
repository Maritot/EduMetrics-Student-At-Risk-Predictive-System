# EduMetrics: Student At-Risk Predictive System

This repository documents and prepares datasets for the EduMetrics student at-risk predictive analytics project. The main project dataset is the Open University Learning Analytics Dataset (OULAD), which contains student demographics, registrations, assessment scores, and learning platform clickstream activity.

## Project Objective

EduMetrics aims to identify students who may fail or withdraw before final assessment by combining:

- Student demographic profile
- Course registration history
- Assessment performance
- Virtual Learning Environment (VLE) engagement
- Final result labels for supervised learning

The expected prediction target is `at_risk`, derived from `final_result`:

| `final_result` | `at_risk` |
| --- | --- |
| `Fail` | `1` |
| `Withdrawn` | `1` |
| `Pass` | `0` |
| `Distinction` | `0` |

## Repository Structure

| Path | Purpose |
| --- | --- |
| `data/raw/` | Store the original CSV files exactly as downloaded. |
| `data/processed/` | Store cleaned, joined, and feature-engineered datasets. |
| `data/external/` | Store optional external reference data. |
| `notebooks/` | Store exploratory analysis and modeling notebooks. |
| `sql/` | Store SQL schema, joins, and transformation scripts. |
| `dashboards/` | Store Power BI, Tableau, and dashboard screenshots. |
| `docs/` | Store supporting documentation. |

## Provided Files

| File | Rows | Size | Project Use |
| --- | ---: | ---: | --- |
| `courses.csv` | 22 | 0.00 MB | OULAD course/module metadata. |
| `assessments.csv` | 206 | 0.01 MB | OULAD assessment definitions. |
| `studentInfo.csv` | 32,593 | 3.30 MB | OULAD student demographics and final results. |
| `studentRegistration.csv` | 32,593 | 1.06 MB | OULAD registration and withdrawal dates. |
| `studentAssessment.csv` | 173,912 | 5.43 MB | OULAD student assessment submissions and scores. |
| `studentVle.csv` | 10,655,280 | 432.81 MB | OULAD student VLE clickstream activity. |
| `vle.csv` | 6,364 | 0.25 MB | OULAD VLE activity/material metadata. |

Recommended raw placement:

| Source File | Repository Location |
| --- | --- |
| `courses.csv` | `data/raw/courses.csv` |
| `assessments.csv` | `data/raw/assessments.csv` |
| `studentInfo.csv` | `data/raw/studentInfo.csv` |
| `studentRegistration.csv` | `data/raw/studentRegistration.csv` |
| `studentAssessment.csv` | `data/raw/studentAssessment.csv` |
| `studentVle.csv` | `data/raw/studentVle.csv` |
| `vle.csv` | `data/raw/vle.csv` |

## OULAD Table Relationships

| Relationship | Join Columns |
| --- | --- |
| `courses` to `studentInfo` | `code_module`, `code_presentation` |
| `courses` to `studentRegistration` | `code_module`, `code_presentation` |
| `courses` to `assessments` | `code_module`, `code_presentation` |
| `courses` to `vle` | `code_module`, `code_presentation` |
| `studentInfo` to `studentRegistration` | `id_student`, `code_module`, `code_presentation` |
| `studentInfo` to `studentVle` | `id_student`, `code_module`, `code_presentation` |
| `assessments` to `studentAssessment` | `id_assessment` |
| `vle` to `studentVle` | `id_site`, `code_module`, `code_presentation` |

## OULAD Data Dictionary

### `courses.csv`

Course/module presentation metadata.

| Column | Type | Description |
| --- | --- | --- |
| `code_module` | String | Module identifier, such as `AAA`. |
| `code_presentation` | String | Presentation identifier, such as `2013J`. |
| `module_presentation_length` | Integer | Length of the module presentation in days. |

### `assessments.csv`

Assessment definitions for each module presentation.

| Column | Type | Description |
| --- | --- | --- |
| `code_module` | String | Module linked to the assessment. |
| `code_presentation` | String | Presentation linked to the assessment. |
| `id_assessment` | Integer | Unique assessment identifier. |
| `assessment_type` | String | Assessment type, such as `TMA`, `CMA`, or `Exam`. |
| `date` | Integer | Assessment due date as days relative to module start. |
| `weight` | Decimal | Assessment weight toward final course result. |

### `studentInfo.csv`

Student demographics and final module outcome.

| Column | Type | Description |
| --- | --- | --- |
| `code_module` | String | Module the student registered for. |
| `code_presentation` | String | Module presentation the student registered for. |
| `id_student` | Integer | Anonymized student identifier. |
| `gender` | String | Student gender category. |
| `region` | String | Student geographic region. |
| `highest_education` | String | Highest education level before enrollment. |
| `imd_band` | String | Index of Multiple Deprivation band. |
| `age_band` | String | Student age band. |
| `num_of_prev_attempts` | Integer | Number of previous attempts for the same module. |
| `studied_credits` | Integer | Total credits studied by the student. |
| `disability` | String | Disability declaration flag, usually `Y` or `N`. |
| `final_result` | String | Final result: `Distinction`, `Pass`, `Fail`, or `Withdrawn`. |

### `studentRegistration.csv`

Student registration and withdrawal timing.

| Column | Type | Description |
| --- | --- | --- |
| `code_module` | String | Module identifier. |
| `code_presentation` | String | Presentation identifier. |
| `id_student` | Integer | Anonymized student identifier. |
| `date_registration` | Integer | Registration day relative to module start. Negative values mean registration before module start. |
| `date_unregistration` | Integer | Withdrawal day relative to module start. Blank means the student did not unregister. |

### `studentAssessment.csv`

Student assessment submissions and scores.

| Column | Type | Description |
| --- | --- | --- |
| `id_assessment` | Integer | Assessment identifier from `assessments.csv`. |
| `id_student` | Integer | Anonymized student identifier. |
| `date_submitted` | Integer | Submission day relative to module start. |
| `is_banked` | Boolean | `1` if the assessment score was transferred from a previous presentation, otherwise `0`. |
| `score` | Decimal | Student assessment score from `0` to `100`. |

### `studentVle.csv`

Student interactions with VLE materials. This is the largest file and should usually be aggregated before joining with other tables.

| Column | Type | Description |
| --- | --- | --- |
| `code_module` | String | Module identifier. |
| `code_presentation` | String | Presentation identifier. |
| `id_student` | Integer | Anonymized student identifier. |
| `id_site` | Integer | VLE material identifier from `vle.csv`. |
| `date` | Integer | Interaction day relative to module start. |
| `sum_click` | Integer | Number of clicks for the student-material-day record. |

### `vle.csv`

VLE activity/material metadata.

| Column | Type | Description |
| --- | --- | --- |
| `id_site` | Integer | VLE material identifier. |
| `code_module` | String | Module identifier. |
| `code_presentation` | String | Presentation identifier. |
| `activity_type` | String | VLE activity category, such as resource, forum, homepage, or quiz. |
| `week_from` | Integer | Starting week for the material, if available. |
| `week_to` | Integer | Ending week for the material, if available. |

## Processed Modeling Dataset

Create the model-ready file as:

`data/processed/student_risk_features.csv`

One row should represent one student in one module presentation:

`id_student` + `code_module` + `code_presentation`

| Column | Type | Source | Description |
| --- | --- | --- | --- |
| `id_student` | Integer | `studentInfo` | Student identifier. |
| `code_module` | String | `studentInfo` | Module identifier. |
| `code_presentation` | String | `studentInfo` | Presentation identifier. |
| `gender` | String | `studentInfo` | Student gender category. |
| `region` | String | `studentInfo` | Student geographic region. |
| `highest_education` | String | `studentInfo` | Highest education level. |
| `imd_band` | String | `studentInfo` | Deprivation band. |
| `age_band` | String | `studentInfo` | Age band. |
| `num_of_prev_attempts` | Integer | `studentInfo` | Previous module attempts. |
| `studied_credits` | Integer | `studentInfo` | Credits studied. |
| `disability` | String | `studentInfo` | Disability declaration flag. |
| `date_registration` | Integer | `studentRegistration` | Registration timing. |
| `date_unregistration` | Integer | `studentRegistration` | Withdrawal timing, if any. |
| `module_presentation_length` | Integer | `courses` | Module duration in days. |
| `total_clicks` | Integer | `studentVle` | Total VLE clicks. |
| `active_days` | Integer | `studentVle` | Number of distinct days with VLE activity. |
| `unique_sites_visited` | Integer | `studentVle` | Number of distinct VLE materials accessed. |
| `avg_clicks_per_active_day` | Decimal | `studentVle` | `total_clicks / active_days`. |
| `pre_first_assessment_clicks` | Integer | `studentVle`, `assessments` | Clicks before the first assessment due date. |
| `assessments_submitted` | Integer | `studentAssessment` | Number of submitted assessments. |
| `avg_assessment_score` | Decimal | `studentAssessment` | Average submitted assessment score. |
| `weighted_assessment_score` | Decimal | `studentAssessment`, `assessments` | Score weighted by assessment weights. |
| `late_submission_count` | Integer | `studentAssessment`, `assessments` | Count of submissions after due date. |
| `on_time_submission_rate` | Decimal | `studentAssessment`, `assessments` | Share of submissions on or before due date. |
| `final_result` | String | `studentInfo` | Original result label. |
| `at_risk` | Boolean | Derived | `1` for `Fail` or `Withdrawn`; `0` for `Pass` or `Distinction`. |
| `risk_score` | Decimal | Model output | Predicted probability of being at risk. |
| `risk_level` | String | Model output | Risk category, such as `Low`, `Medium`, or `High`. |

## Dashboard Metrics

| Metric | Definition |
| --- | --- |
| Average assessment score | Mean of `score` from `studentAssessment.csv`. |
| Student retention rate | Students not marked `Withdrawn` divided by total students. |
| Engagement-to-score correlation | Correlation between aggregated `sum_click` and assessment performance. |
| Completion percentage | Students with `Pass` or `Distinction` divided by total students. |
| At-risk rate | Students marked `Fail` or `Withdrawn` divided by total students. |
| Prediction accuracy | Correct predictions divided by total predictions on labeled validation data. |

## Data Preparation Notes

- Keep all raw files unchanged in `data/raw/`.
- Aggregate `studentVle.csv` before joining because it has more than 10 million rows.
- Use `id_student`, `code_module`, and `code_presentation` as the main student-module keys.
- Use `final_result` for model training and evaluation only.
- Use `risk_score` and `risk_level` only after generating predictions.
- Blank values in `date_unregistration`, `week_from`, and `week_to` should be handled as missing values.
- Avoid storing any non-anonymized student information in processed outputs.


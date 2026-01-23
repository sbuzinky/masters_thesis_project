CREATE TABLE gym_members_exercise_tracking (
    id INT AUTO_INCREMENT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    weight_kg DECIMAL(6,2),
    height_m DECIMAL(5,2),
    max_bpm INT,
    avg_bpm INT,
    resting_bpm INT,
    session_duration_hours DECIMAL(5,2),
    calories_burned DECIMAL(8,2),
    workout_type VARCHAR(50),
    fat_percentage DECIMAL(5,2),
    water_intake_liters DECIMAL(5,2),
    workout_frequency_days_per_week INT,
    experience_level VARCHAR(50),
    bmi DECIMAL(5,2)
);


LOAD DATA LOCAL INFILE '/Users/selenabuzinky/Desktop/MSBA_500/gym_members_exercise_tracking.csv'
INTO TABLE gym_members_exercise_tracking
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  @age,
  @gender,
  @weight_kg,
  @height_m,
  @max_bpm,
  @avg_bpm,
  @resting_bpm,
  @session_duration_hours,
  @calories_burned,
  @workout_type,
  @fat_percentage,
  @water_intake_liters,
  @workout_frequency_days_per_week,
  @experience_level,
  @bmi
)
SET
  age = NULLIF(@age, ''),
  gender = NULLIF(@gender, ''),
  weight_kg = NULLIF(@weight_kg, ''),
  height_m = NULLIF(@height_m, ''),
  max_bpm = NULLIF(@max_bpm, ''),
  avg_bpm = NULLIF(@avg_bpm, ''),
  resting_bpm = NULLIF(@resting_bpm, ''),
  session_duration_hours = NULLIF(@session_duration_hours, ''),
  calories_burned = NULLIF(@calories_burned, ''),
  workout_type = NULLIF(@workout_type, ''),
  fat_percentage = NULLIF(@fat_percentage, ''),
  water_intake_liters = NULLIF(@water_intake_liters, ''),
  workout_frequency_days_per_week = NULLIF(@workout_frequency_days_per_week, ''),
  experience_level = NULLIF(@experience_level, ''),
  bmi = NULLIF(@bmi, '');




  CREATE TABLE income (
    id INT AUTO_INCREMENT PRIMARY KEY,
    age INT,
    workclass VARCHAR(50),
    fnlwgt INT,
    education VARCHAR(50),
    education_num INT,
    marital_status VARCHAR(50),
    occupation VARCHAR(50),
    relationship VARCHAR(50),
    race VARCHAR(50),
    sex VARCHAR(10),
    capital_gain INT,
    capital_loss INT,
    hours_per_week INT,
    native_country VARCHAR(50),
    income VARCHAR(10)
);





LOAD DATA LOCAL INFILE '/Users/selenabuzinky/Desktop/MSBA_500/income.csv'
INTO TABLE income
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@age, @workclass, @fnlwgt, @education, @education_num, @marital_status,
 @occupation, @relationship, @race, @sex, @capital_gain, @capital_loss,
 @hours_per_week, @native_country, @income)
SET
  age = NULLIF(@age, ''),
  workclass = NULLIF(@workclass, ''),
  fnlwgt = NULLIF(@fnlwgt, ''),
  education = NULLIF(@education, ''),
  education_num = NULLIF(@education_num, ''),
  marital_status = NULLIF(@marital_status, ''),
  occupation = NULLIF(@occupation, ''),
  relationship = NULLIF(@relationship, ''),
  race = NULLIF(@race, ''),
  sex = NULLIF(@sex, ''),
  capital_gain = NULLIF(@capital_gain, ''),
  capital_loss = NULLIF(@capital_loss, ''),
  hours_per_week = NULLIF(@hours_per_week, ''),
  native_country = NULLIF(@native_country, ''),
  income = NULLIF(@income, '');



  SET SQL_SAFE_UPDATES = 0;



  -- Add Age_Bucket to the Income table
ALTER TABLE income ADD COLUMN age_bucket VARCHAR(20);

UPDATE income
SET age_bucket = CASE
    WHEN age BETWEEN 18 AND 25 THEN '18–25'
    WHEN age BETWEEN 26 AND 35 THEN '26–35'
    WHEN age BETWEEN 36 AND 50 THEN '36–50'
    ELSE '50+'
END;


-- Add Age_Bucket to the Gym table
ALTER TABLE gym_members_exercise_tracking ADD COLUMN age_bucket VARCHAR(20);

UPDATE gym_members_exercise_tracking
SET age_bucket = CASE
    WHEN age BETWEEN 18 AND 25 THEN '18–25'
    WHEN age BETWEEN 26 AND 35 THEN '26–35'
    WHEN age BETWEEN 36 AND 50 THEN '36–50'
    ELSE '50+'
END;






UPDATE income
SET income = REPLACE(
              REPLACE(
                TRIM(income),
                CHAR(13),  -- remove \r
                ''
              ),
              CHAR(10),    -- remove \n
              ''
            );


CREATE TABLE summary_table AS
SELECT
    i.age_bucket,
    i.sex AS gender,

    -- Income metrics
    ROUND(SUM(CASE WHEN i.income = '<=50K' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_income_le_50k,
    ROUND(SUM(CASE WHEN i.income = '>50K' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_income_gt_50k,
    ROUND(AVG(i.education_num), 2) AS avg_education_level,
    ROUND(AVG(i.hours_per_week), 2) AS avg_hours_worked_per_week,

    -- Gym metrics
    ROUND(AVG(g.calories_burned), 2) AS avg_calories_burned,
    ROUND(AVG(g.session_duration_hours), 2) AS avg_session_duration,
    ROUND(AVG(g.avg_bpm), 2) AS avg_bpm,
    ROUND(AVG(g.max_bpm), 2) AS avg_max_bpm,
    ROUND(AVG(g.resting_bpm), 2) AS avg_resting_bpm,
    ROUND(AVG((g.avg_bpm / g.max_bpm) * 100), 2) AS avg_intensity_pct,
    ROUND(AVG(g.avg_bpm - g.resting_bpm), 2) AS avg_heart_rate_delta,
    ROUND(AVG(g.calories_burned / g.weight_kg), 2) AS avg_calories_per_kg

FROM income i
JOIN gym_members_exercise_tracking g
  ON i.age_bucket = g.age_bucket
 AND i.sex = g.gender

GROUP BY i.age_bucket, i.sex
ORDER BY i.age_bucket, i.sex;










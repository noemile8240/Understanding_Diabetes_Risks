 

/* THE FOLLOWING SCRIPTS ARE FOR GRAPHING DIFFERENCT CORRELATIONS IN TABLEAU */

--Diabetes Prevalence by Glucose and Blood Pressure Groups

/* This SQL script joins the `patients` and `lab_results` tables to calculate the diabetes prevalence
based on grouped blood pressure (BP) and glucose levels. The goal is to observe patterns of diabetes
within different clinical categories for both metrics.
*/

-- Group patients by BP and Glucose, then aggregate diabetes outcome counts
	WITH bp_glucose_group AS (
	    SELECT
	        -- Glucose Group (based on lab results from lab_results table)
	        CASE
	            WHEN l.glucose < 100 THEN 'Normal (<100)'
	            WHEN l.glucose BETWEEN 100 AND 125 THEN 'Prediabetic (100–125)'
	            ELSE 'Diabetic Range (126+)' 
	        END AS glucose_group,
	
	        -- Blood Pressure Group (based on systolic BP)
	        CASE
	            WHEN p.BloodPressure < 120 THEN 'Normal (<120)'
	            WHEN p.BloodPressure BETWEEN 120 AND 129 THEN 'Elevated (120–129)'
	            WHEN p.BloodPressure BETWEEN 130 AND 139 THEN 'High Stage 1 (130–139)'
	            ELSE 'High Stage 2 (140+)' 
	        END AS bp_group,
	
	        -- Count of total patients in each group
	        COUNT(*) AS total_patients,
	
	        -- Count of diabetic patients in each group (outcome = 1)
	        SUM(CASE WHEN p.outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,
	
	        -- Diabetes prevalence as decimal (rounded to 4 decimals)
	        ROUND(SUM(CASE WHEN p.outcome = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS diabetes_rate_decimal
	
	    FROM patients p
	    JOIN lab_results l ON p.PatientID = l.PatientID
	
	    -- Exclude incomplete records
	    WHERE p.BloodPressure IS NOT NULL 
	      AND l.glucose IS NOT NULL 
	      AND p.outcome IS NOT NULL
	
	    -- Group by same logic used in SELECT
	    GROUP BY
	        CASE
	            WHEN l.glucose < 100 THEN 'Normal (<100)'
	            WHEN l.glucose BETWEEN 100 AND 125 THEN 'Prediabetic (100–125)'
	            ELSE 'Diabetic Range (126+)' 
	        END,
	        CASE
	            WHEN p.BloodPressure < 120 THEN 'Normal (<120)'
	            WHEN p.BloodPressure BETWEEN 120 AND 129 THEN 'Elevated (120–129)'
	            WHEN p.BloodPressure BETWEEN 130 AND 139 THEN 'High Stage 1 (130–139)'
	            ELSE 'High Stage 2 (140+)' 
	        END
	)
	
	-- Step 2: Select and display the grouped results
	SELECT *
	FROM bp_glucose_group
	ORDER BY glucose_group, bp_group;






--Diabetes Prevalence by Glucose Level and Age Groups
-- CTE to group patients by age and glucose level
	WITH glucose_age_group AS (
	    SELECT
	        -- Categorize patients into age groups (40+ only)
	        CASE
	            WHEN p.Age BETWEEN 40 AND 49 THEN '40–49'
	            WHEN p.Age BETWEEN 50 AND 59 THEN '50–59'
	            WHEN p.Age BETWEEN 60 AND 69 THEN '60–69'
	            WHEN p.Age >= 70 THEN '70+'
	        END AS age_group,
	
	        -- Categorize glucose levels into diagnostic groups
	        CASE
	            WHEN l.glucose < 100 THEN 'Normal (<100)'
	            WHEN l.glucose BETWEEN 100 AND 125 THEN 'Prediabetic (100–125)'
	            ELSE 'Diabetic Range (126+)' 
	        END AS glucose_group,
	
	        -- Count of total patients in each age/glucose group
	        COUNT(*) AS total_patients,
	
	        -- Count of patients who are diabetic (Outcome = 1)
	        SUM(CASE WHEN p.outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,
	
	        -- Calculate diabetes rate as a percentage
	        ROUND(
	            100.0 * SUM(CASE WHEN p.outcome = 1 THEN 1 ELSE 0 END) / COUNT(*),
	            2
	        ) AS diabetes_rate_percent
	
	    FROM patients p
	    JOIN lab_results l ON p.PatientID = l.PatientID  -- Join patients and lab results
	
	    WHERE p.Age >= 40                  -- Filter for patients aged 40 and older
	      AND l.glucose IS NOT NULL        -- Exclude rows with missing glucose values
	      AND p.outcome IS NOT NULL        -- Exclude rows with unknown outcome
	
	    GROUP BY
	        -- Group by the same expressions used in SELECT
	        CASE
	            WHEN p.Age BETWEEN 40 AND 49 THEN '40–49'
	            WHEN p.Age BETWEEN 50 AND 59 THEN '50–59'
	            WHEN p.Age BETWEEN 60 AND 69 THEN '60–69'
	            WHEN p.Age >= 70 THEN '70+'
	        END,
	        CASE
	            WHEN l.glucose < 100 THEN 'Normal (<100)'
	            WHEN l.glucose BETWEEN 100 AND 125 THEN 'Prediabetic (100–125)'
	            ELSE 'Diabetic Range (126+)' 
	        END
	)
	
	-- Final result: show categorized patient counts and diabetes rates by group
	SELECT
	    glucose_group,
	    age_group,
	    total_patients,
	    diabetic_patients,
	    diabetes_rate_percent
	FROM glucose_age_group
	ORDER BY glucose_group, age_group;
	
	-- Bonus: fetch all data from a related summary table (if exists)
	-- This part assumes you’ve created a separate summary table for blood pressure + glucose + age group combos
	SELECT *
	FROM bp_glucose_age_combo
	ORDER BY age_group, bp_group, glucose_group;






--Diabetes Prevalence by BMI and Age Groups
-- CTE to group patients by BMI and age range
	WITH bmi_age_group AS (
	    SELECT
	 	-- Categorize patients into age groups
	        CASE
	            WHEN Age BETWEEN 40 AND 49 THEN '40–49'
	            WHEN Age BETWEEN 50 AND 59 THEN '50–59'
	            WHEN Age BETWEEN 60 AND 69 THEN '60–69'
	            WHEN Age >= 70 THEN '70+'
	        END AS age_group,
	
	        -- Categorize BMI into health-related groups
	        CASE
	            WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal (18.5–24.9)'
	            WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight (25–29.9)'
	            WHEN BMI BETWEEN 30 AND 34.9 THEN 'Obese (30–34.9)'
	            WHEN BMI >= 35 THEN 'Severely Obese (35+)' 
	        END AS bmi_group,
	
	        -- Count total patients in each BMI + age group
	        COUNT(*) AS total_patients,
	
	        -- Count how many patients in each group are diabetic (outcome = 1)
	        SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,
	
	        -- Calculate diabetes rate as a decimal (e.g., 0.2381 for 23.81%)
	        ROUND(
	            SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) / COUNT(*),
	            4
	        ) AS diabetes_rate_decimal
	
	    FROM patients
	    WHERE Age >= 40                    -- Focus on patients aged 40 and older
	      AND BMI IS NOT NULL             -- Exclude rows with missing BMI
	      AND outcome IS NOT NULL         -- Exclude rows with missing outcome
	
	    GROUP BY
	        -- Group by the same expressions used in SELECT
	        CASE
	            WHEN Age BETWEEN 40 AND 49 THEN '40–49'
	            WHEN Age BETWEEN 50 AND 59 THEN '50–59'
	            WHEN Age BETWEEN 60 AND 69 THEN '60–69'
	            WHEN Age >= 70 THEN '70+'
	        END,
	        CASE
	            WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal (18.5–24.9)'
	            WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight (25–29.9)'
	            WHEN BMI BETWEEN 30 AND 34.9 THEN 'Obese (30–34.9)'
	            WHEN BMI >= 35 THEN 'Severely Obese (35+)' 
	        END
	)
	
	-- Final result: show grouped summary by BMI and age
	SELECT *
	FROM bmi_age_group
	ORDER BY bmi_group, age_group;




-- Diabetes Prevalence by Age + Blood Pressure Groups
-- CTE to group patients by Blood Pressure and Glucose level
	WITH bp_glucose_group AS (
	    SELECT
	        -- Categorize glucose levels into standard diagnostic ranges
	        CASE
	            WHEN l.glucose < 100 THEN 'Normal (<100)'
	            WHEN l.glucose BETWEEN 100 AND 125 THEN 'Prediabetic (100–125)'
	            ELSE 'Diabetic Range (126+)' 
	        END AS glucose_group,
	
	        -- Categorize blood pressure (assumed to be systolic) into clinical stages
	        CASE
	            WHEN p.BloodPressure < 120 THEN 'Normal (<120)'
	            WHEN p.BloodPressure BETWEEN 120 AND 129 THEN 'Elevated (120–129)'
	            WHEN p.BloodPressure BETWEEN 130 AND 139 THEN 'High Stage 1 (130–139)'
	            ELSE 'High Stage 2 (140+)' 
	        END AS bp_group,
	
	        -- Count of total patients in each glucose + BP group
	        COUNT(*) AS total_patients,
	
	        -- Number of diabetic patients in each group
	        SUM(CASE WHEN p.outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,
	
	        -- Diabetes rate as a decimal (e.g., 0.2143 for 21.43%)
	        ROUND(
	            SUM(CASE WHEN p.outcome = 1 THEN 1 ELSE 0 END) / COUNT(*),
	            4
	        ) AS diabetes_rate_decimal
	
	    FROM patients p
	    JOIN lab_results l ON p.PatientID = l.PatientID -- Combine patient data with lab results
	
	    -- Filter out rows with missing data
	    WHERE p.BloodPressure IS NOT NULL 
	      AND l.glucose IS NOT NULL 
	      AND p.outcome IS NOT NULL
	
	    -- Group the data by the same CASE expressions used in SELECT
	    GROUP BY
	        CASE
	            WHEN l.glucose < 100 THEN 'Normal (<100)'
	            WHEN l.glucose BETWEEN 100 AND 125 THEN 'Prediabetic (100–125)'
	            ELSE 'Diabetic Range (126+)' 
	        END,
	        CASE
	            WHEN p.BloodPressure < 120 THEN 'Normal (<120)'
	            WHEN p.BloodPressure BETWEEN 120 AND 129 THEN 'Elevated (120–129)'
	            WHEN p.BloodPressure BETWEEN 130 AND 139 THEN 'High Stage 1 (130–139)'
	            ELSE 'High Stage 2 (140+)' 
	        END
	)
	
	-- Final result: show the grouped data sorted by glucose level and blood pressure category
	SELECT *
	FROM bp_glucose_group
	ORDER BY glucose_group, bp_group;





-- Diabetes Prevalence by  Age + Blood Pressure Group + Glucose
-- Join the two relevant tables to prepare a clean dataset for analysis
	WITH joined_data AS (
	    SELECT
	        p.Age,
	        p.BloodPressure,
	        p.outcome,
	        l.Glucose
	    FROM patients p
	    JOIN lab_results l ON p.patient_id = l.patient_id
	    WHERE p.Age >= 40  -- Focus on patients aged 40 and above
	      AND p.BloodPressure IS NOT NULL
	      AND p.outcome IS NOT NULL
	      AND l.Glucose IS NOT NULL
	),
	
	-- Group patients into age, BP, and glucose categories and calculate metrics
	age_bp_glucose_group AS (
	    SELECT
	        -- Categorize patients by age group
	        CASE
	            WHEN Age BETWEEN 40 AND 49 THEN '40–49'
	            WHEN Age BETWEEN 50 AND 59 THEN '50–59'
	            WHEN Age BETWEEN 60 AND 69 THEN '60–69'
	            WHEN Age >= 70 THEN '70+'
	        END AS age_group,
	
	        -- Categorize patients by blood pressure level
	        CASE
	            WHEN BloodPressure < 120 THEN 'Normal (<120)'
	            WHEN BloodPressure BETWEEN 120 AND 129 THEN 'Elevated (120–129)'
	            WHEN BloodPressure BETWEEN 130 AND 139 THEN 'High Stage 1 (130–139)'
	            ELSE 'High Stage 2 (140+)' 
	        END AS bp_group,
	
	        -- Categorize patients by glucose level
	        CASE
	            WHEN Glucose < 100 THEN 'Normal (<100)'
	            WHEN Glucose BETWEEN 100 AND 125 THEN 'Pre-diabetic (100–125)'
	            ELSE 'Diabetic (126+)' 
	        END AS glucose_group,
	
	        -- Count total patients in the group
	        COUNT(*) AS total_patients,
	
	        -- Count how many patients in the group are diabetic (outcome = 1)
	        SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,
	
	        -- Calculate diabetes prevalence (diabetics / total)
	        ROUND(SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*), 4) AS diabetes_rate
	
	    FROM joined_data
	
	    GROUP BY
	        -- Repeat age group logic for GROUP BY
	        CASE
	            WHEN Age BETWEEN 40 AND 49 THEN '40–49'
	            WHEN Age BETWEEN 50 AND 59 THEN '50–59'
	            WHEN Age BETWEEN 60 AND 69 THEN '60–69'
	            WHEN Age >= 70 THEN '70+'
	        END,
	
	        -- Repeat BP group logic for GROUP BY
	        CASE
	            WHEN BloodPressure < 120 THEN 'Normal (<120)'
	            WHEN BloodPressure BETWEEN 120 AND 129 THEN 'Elevated (120–129)'
	            WHEN BloodPressure BETWEEN 130 AND 139 THEN 'High Stage 1 (130–139)'
	            ELSE 'High Stage 2 (140+)' 
	        END,
	
	        -- Repeat glucose group logic for GROUP BY
	        CASE
	            WHEN Glucose < 100 THEN 'Normal (<100)'
	            WHEN Glucose BETWEEN 100 AND 125 THEN 'Pre-diabetic (100–125)'
	            ELSE 'Diabetic (126+)' 
	        END
	)
	
	-- Return final results ordered for readability
	SELECT *
	FROM age_bp_glucose_group
	ORDER BY age_group, bp_group, glucose_group;
	









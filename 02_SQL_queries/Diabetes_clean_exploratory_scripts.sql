 

/* The following scripts bring in the data,for exploratory analysis */


-- enable the loading of data from local files
	SET GLOBAL local_infile = 1;

-- create DATABASE DIABETES_PROJECT
	CREATE DATABASE DIABETES_PROJECT;

-- Creating 2 tables for diabetes analysis, will be importing data into both tables from CSV files
	CREATE TABLE patients (
	    PatientID INT PRIMARY KEY AUTO_INCREMENT,
	    Age INT,
	    BMI FLOAT,
	    BloodPressure INT,
	    FamilyHistory BOOLEAN,
	    DietType BOOLEAN,
	    Hypertension BOOLEAN,
	    MedicationUse BOOLEAN,
	    Pregnancies INT,
	    Outcome BOOLEAN
	);
	
	CREATE TABLE lab_results (
	    LabID INT PRIMARY KEY AUTO_INCREMENT,
	    PatientID INT,
	    Glucose FLOAT,
	    HbA1c FLOAT,
	    LDL FLOAT,
	    HDL FLOAT,
	    Triglycerides FLOAT,
	    WaistCircumference FLOAT,
	    HipCircumference FLOAT,
	    WHR FLOAT,
	    FOREIGN KEY (PatientID) REFERENCES patients(PatientID)
	);


USE DIABETES_PROJECT;

-- After importing CSV files into table, testing to make sure all data came in properly
	SELECT * FROM lab_results
	LIMIT 10;

	SELECT * FROM patients
	LIMIT 10;



/* DATA CLEANING */


-- Adding a unique id to the table to clean data
	ALTER TABLE orig_diabetes_dataset ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;
	
	 -- checking for dupes, getting a count of how many dupes are in the table 
	SELECT SUM(dup_count - 1) AS total_duplicates
	FROM (
	    SELECT COUNT(*) AS dup_count
	    FROM orig_diabetes_dataset
	    GROUP BY Age, Pregnancies, BMI, Glucose, BloodPressure, HbA1c, LDL, HDL,
	             Triglycerides, WaistCircumference, HipCircumference, WHR,
	             FamilyHistory, DietType, Hypertension, MedicationUse, Outcome
	    HAVING COUNT(*) > 1
	) AS duplicates;


-- script to view the duplicates
	SELECT *
	FROM orig_diabetes_dataset AS d1
	JOIN (
	    SELECT Age, Pregnancies, BMI, Glucose, BloodPressure, HbA1c, LDL, HDL,
	           Triglycerides, WaistCircumference, HipCircumference, WHR,
	           FamilyHistory, DietType, Hypertension, MedicationUse, Outcome,
	           COUNT(*) AS dup_count
	    FROM orig_diabetes_dataset
	    GROUP BY Age, Pregnancies, BMI, Glucose, BloodPressure, HbA1c, LDL, HDL,
	             Triglycerides, WaistCircumference, HipCircumference, WHR,
	             FamilyHistory, DietType, Hypertension, MedicationUse, Outcome
	    HAVING dup_count > 1
	) dupes
	ON d1.Age = dupes.Age
	   AND d1.Pregnancies = dupes.Pregnancies
	   AND d1.BMI = dupes.BMI
	   AND d1.Glucose = dupes.Glucose
	   AND d1.BloodPressure = dupes.BloodPressure
	   AND d1.HbA1c = dupes.HbA1c
	   AND d1.LDL = dupes.LDL
	   AND d1.HDL = dupes.HDL
	   AND d1.Triglycerides = dupes.Triglycerides
	   AND d1.WaistCircumference = dupes.WaistCircumference
	   AND d1.HipCircumference = dupes.HipCircumference
	   AND d1.WHR = dupes.WHR
	   AND d1.FamilyHistory = dupes.FamilyHistory
	   AND d1.DietType = dupes.DietType
	   AND d1.Hypertension = dupes.Hypertension
	   AND d1.MedicationUse = dupes.MedicationUse
	   AND d1.Outcome = dupes.Outcome
	ORDER BY d1.Age, d1.Pregnancies;


-- Delete duplicate and  keeps the first version of each duplicate (lowest id) and deletes the rest
	DELETE d1
	FROM orig_diabetes_dataset As d1
	JOIN orig_diabetes_dataset As d2
	ON d1.Age = d2.Age
	   AND d1.Pregnancies = d2.Pregnancies
	   AND d1.BMI = d2.BMI
	   AND d1.Glucose = d2.Glucose
	   AND d1.BloodPressure = d2.BloodPressure
	   AND d1.HbA1c = d2.HbA1c
	   AND d1.LDL = d2.LDL
	   AND d1.HDL = d2.HDL
	   AND d1.Triglycerides = d2.Triglycerides
	   AND d1.WaistCircumference = d2.WaistCircumference
	   AND d1.HipCircumference = d2.HipCircumference
	   AND d1.WHR = d2.WHR
	   AND d1.FamilyHistory = d2.FamilyHistory
	   AND d1.DietType = d2.DietType
	   AND d1.Hypertension = d2.Hypertension
	   AND d1.MedicationUse = d2.MedicationUse
	   AND d1.Outcome = d2.Outcome
	   AND d1.id > d2.id;


-- checking to see if any invalid ages
	SELECT Age
	FROM orig_diabetes_dataset
	WHERE Age > 90 OR Age < 0;

--checking to see if any invalid numbers on the BMI column
	SELECT BMI
	 FROM orig_diabetes_dataset
	WHERE BMI < 10 OR BMI > 80;


/* EXPLORATORY QUESTIONS TO UNDERSTAND THE DATA */



-- What is the age distribution of the dataset?
	SELECT Age, COUNT(*) AS Patient_Count
	FROM patients
	GROUP BY Age
	ORDER BY Patient_Count desc;




-- How does BMI distribution look in the dataset?
	 SELECT 
	   CASE 
		 WHEN BMI < 18.5 THEN 'Underweight'
		   WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal'
		  WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight'
			ELSE 'Obese'
	   END AS BMI_Category,
	   COUNT(*) AS Count
	 FROM patients
	GROUP BY BMI_Category
	ORDER BY Count DESC;




-- How does the Waist-to-Hip Ratio (WHR) vary across different age groups?
	SELECT 
		CASE 
			WHEN p.Age BETWEEN 18 AND 30 THEN 'Very Young'
			WHEN p.Age BETWEEN 31 AND 42 THEN 'Young'
			WHEN p.Age BETWEEN 43 AND 64 THEN 'Middle Age'
			WHEN p.Age BETWEEN 65 AND 78 THEN 'Senior'
			ELSE 'Senior Old'
		END AS Age_Group,
    ROUND(AVG(l.WHR), 2) AS Avg_WHR
	FROM patients p
	JOIN lab_results l ON p.PatientID = l.PatientID
	GROUP BY Age_Group
	ORDER BY FIELD(Age_Group, 'Very Young', 'Young', 'Middle Age', 'Senior', 'Senior Old');




-- How common is diabetes (Outcome = 1) in the dataset?
		SELECT Outcome, COUNT(*) AS Count
		FROM patients
		GROUP BY Outcome
		HAVING COUNT(*) > 10; -- Using HAVING to filter out small groups




-- Do people with a family history of diabetes have higher glucose levels?
		SELECT p.FamilyHistory, AVG(l.Glucose) AS Avg_Glucose
		FROM patients p
		JOIN lab_results l ON p.PatientID = l.PatientID
		GROUP BY p.FamilyHistory;




-- How do LDL and HDL cholesterol levels differ between those with and without diabetes?
		SELECT p.Outcome, ROUND(AVG(l.LDL),2) AS Avg_LDL, round(AVG(l.HDL),2) AS Avg_HDL
		FROM patients p
		JOIN lab_results l ON p.PatientID = l.PatientID
		GROUP BY p.Outcome;




-- Count of Patients with LDL > 159, Grouped by Diabetes Outcome
		SELECT 
		p.Outcome, 
		COUNT(*) AS Patient_Count
		FROM lab_results l
		JOIN patients p ON l.PatientID = p.PatientID
		WHERE l.LDL > 159
		GROUP BY p.Outcome
		ORDER BY p.Outcome;



-- What percentage of individuals with diabetes take medication?
		SELECT 
			(COUNT(CASE WHEN Outcome = 0 AND MedicationUse = 1 THEN 1 END) * 100.0 /
			 COUNT(CASE WHEN Outcome = 0 THEN 1 END)) AS Percent_On_Meds_NonDiabetic,
			(COUNT(CASE WHEN Outcome = 1 AND MedicationUse = 1 THEN 1 END) * 100.0 /
			 COUNT(CASE WHEN Outcome = 1 THEN 1 END)) AS Percent_On_Meds_Diabetic
		FROM patients;



-- What are the strongest predictors of diabetes?
		SELECT 
			p.Age, 
			p.BMI, 
			l.Glucose, 
			l.HbA1c,
			p.Outcome,
			RANK() OVER (PARTITION BY p.Outcome ORDER BY l.Glucose DESC) AS Rank_Glucose
		FROM patients p
		JOIN lab_results l ON p.PatientID = l.PatientID;



-- Calculate count, mean, standard deviation, min, max, and quartiles 
	SELECT 
    	COUNT(*) AS Total_Records,
    
    -- Age Statistics
		ROUND(AVG(p.Age), 2) AS Avg_Age,
		ROUND(STDDEV(p.Age), 2) AS StdDev_Age,
		MIN(p.Age) AS Min_Age,
		MAX(p.Age) AS Max_Age,
    
    -- BMI Statistics
	    ROUND(AVG(p.BMI), 2) AS Avg_BMI,
	    ROUND(STDDEV(p.BMI), 2) AS StdDev_BMI,
	    MIN(p.BMI) AS Min_BMI,
	    MAX(p.BMI) AS Max_BMI,

    -- Glucose Statistics
	    ROUND(AVG(l.Glucose), 2) AS Avg_Glucose,
	    ROUND(STDDEV(l.Glucose), 2) AS StdDev_Glucose,
	    MIN(l.Glucose) AS Min_Glucose,
	    MAX(l.Glucose) AS Max_Glucose,

    -- HbA1c Statistics
	    ROUND(AVG(l.HbA1c), 2) AS Avg_HbA1c,
	    ROUND(STDDEV(l.HbA1c), 2) AS StdDev_HbA1c,
	    MIN(l.HbA1c) AS Min_HbA1c,
	    MAX(l.HbA1c) AS Max_HbA1c
		FROM patients p
		JOIN lab_results l ON p.PatientID = l.PatientID;



-- How many patients are diabetic (Outcome = 1) and non-diabetic (Outcome = 0).
	SELECT 
		p.Outcome,
		COUNT(*) AS Patient_Count
	FROM patients p
	JOIN lab_results l ON p.PatientID = l.PatientID
	GROUP BY p.Outcome;


-- Average glucose level for diabetics and non-diabetics.
	SELECT 
		p.Outcome,
		ROUND(AVG(l.Glucose), 2) AS Avg_Glucose
	FROM patients p
	JOIN lab_results l ON p.PatientID = l.PatientID
	GROUP BY p.Outcome;


-- Are pregnant individuals more likely to have higher glucose levels?
	SELECT 
		CASE 
			WHEN p.Pregnancies = 0 THEN 'No Pregnancies'
			ELSE 'Had Pregnancies'
		END AS Pregnancy_Status,
		round(AVG(l.Glucose),2) AS Avg_Glucose
	FROM patients p
	JOIN lab_results l ON p.PatientID = l.PatientID
	GROUP BY Pregnancy_Status;



-- 15. Analyzing the relationship between glucose levels, diabetes outcome, and BMI.
	-- Step 1: Create a CTE to Calculate the Average Glucose for Each Outcome
		WITH AvgGlucoseByOutcome AS (
			SELECT 
				p.Outcome, 
				ROUND(AVG(l.Glucose), 2) AS Avg_Glucose
			FROM patients p
			JOIN lab_results l ON p.PatientID = l.PatientID
			GROUP BY p.Outcome)
            
	-- Step 2: Use a Subquery to Identify Patients with Above-Average Glucose
		SELECT 
			p.PatientID, 
			p.Age, 
			p.BMI, 
			l.Glucose, 
			p.Outcome,
			(SELECT Avg_Glucose FROM AvgGlucoseByOutcome WHERE Outcome = p.Outcome) AS Avg_Glucose_For_Group,
			CASE 
				WHEN l.Glucose > (SELECT Avg_Glucose FROM AvgGlucoseByOutcome WHERE Outcome = p.Outcome) 
				THEN 'Above Average' 
				ELSE 'Below Average' 
			END AS Glucose_Category
		FROM patients p
		JOIN lab_results l ON p.PatientID = l.PatientID;




-





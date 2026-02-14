# Understanding Diabetes Risk Through Multi-Factor Analysis

## Executive Summary

This project analyzes anonymized patient health records to identify **biometric and demographic factors most strongly associated with diabetes risk**. Using **SQL for cohort analysis** and **Tableau for visual storytelling**, the study reveals how **glucose, BMI, blood pressure, and age interact to elevate diagnosis likelihood**.

Findings highlight clear **threshold-based risk patterns** and support **targeted screening strategies** that could enable earlier detection, improved preventive care, and more efficient allocation of clinical resources.

---

## Business & Clinical Objective

Healthcare providers and population-health teams require **data-driven methods to identify high-risk patients before diagnosis**.

This analysis was designed to:

* Detect **biometric thresholds** linked to diabetes prevalence
* Quantify **risk escalation across age groups**
* Evaluate **compounding multi-factor risk conditions**
* Provide **actionable screening and intervention guidance**

Primary stakeholders include:

* Preventive care and screening programs
* Population-health analytics teams
* Clinical quality and risk-management leadership

---

## Dataset & Methodology

**Dataset:** Public anonymized diabetes health dataset (~9,500 patients)
**Tools:** SQL, MySQL, Tableau
**Approach:**

* Data cleaning and cohort segmentation in SQL
* Risk-factor threshold analysis
* Comparative prevalence measurement
* Interactive visualization and narrative design in Tableau

---

## Key Insights

### 1. Glucose as the Primary Risk Driver

* Diabetes prevalence rises sharply once glucose levels enter the **diabetic range (≥126 mg/dL)**, making glucose the **strongest standalone predictor** of diagnosis across all age groups.

* Within this range, prevalence increases from approximately **48% in adults aged 40–49** to **over 50% among patients aged 70+**, demonstrating that **age compounds metabolic risk even when glucose levels are already elevated**.

* Importantly, the upward age-related trend persists even among individuals with **normal or prediabetic glucose levels**, indicating that **baseline diabetes susceptibility increases with age independent of glucose classification**.

* These findings reinforce glucose testing as the **most critical early screening signal**, while also highlighting the need for **age-adjusted preventive monitoring** in older populations.
<img src="images/glucose-age.png" alt="Diabetes_By_Age_Glucose" width="800"/>

---

### 2. Age significantly amplifies baseline risk

* Diabetes prevalence increases steadily after **age 40**
* Even with normal vitals, risk rises meaningfully in **60+ populations**

### 3. BMI compounds metabolic risk

* **BMI ≥30** strongly correlates with diabetes prevalence
* Severe obesity combined with older age produces the **highest risk segments**

### 4. Multi-factor interaction drives extreme prevalence

* **High glucose + hypertension + advanced age** produces diabetes prevalence exceeding **85%**
* Demonstrates the importance of **layered screening logic rather than single-metric thresholds**

---

## Recommendations

This analysis supports several **data-driven clinical strategies**:

* Prioritize screening for patients with **glucose >120 mg/dL**
* Target preventive outreach to **BMI ≥30**, especially in older adults
* Implement **multi-factor risk flags** combining glucose, BMI, and blood pressure
* Focus early-intervention resources on **patients aged 60+ with ≥2 elevated biomarkers**

These actions could enable:

* Earlier diagnosis
* Reduced complication risk
* More efficient preventive-care investment

---

## Tableau Dashboard

Interactive visualization of cohort segmentation, prevalence trends, and multi-factor risk interaction:

**View Dashboard:**
https://public.tableau.com/app/profile/noemi.vargas7800/viz/UnderstandingDiabetesRisk/DiabetesRiskAnalysis?publish=yes

---

## Technical Assets

* SQL cleaning & exploration scripts
* Cohort segmentation and prevalence queries
* Tableau risk-analysis dashboard
* Supporting datasets and documentation

(All resources available within this repository.)

---

## Assumptions & Limitations

* Dataset is anonymized and simulated for analytical learning
* Cross-sectional snapshot rather than longitudinal tracking
* Certain biomarkers excluded due to data quality constraints

Despite these limitations, the analysis demonstrates **real-world healthcare analytics methodology and decision-support thinking**.

---

## Portfolio Context

This project is part of a broader analytics portfolio demonstrating:

* **Healthcare risk analysis**
* **Business intelligence storytelling**
* **SQL-driven cohort analytics**
* **Actionable decision support**






![ERD](images/ERD.png)
---


[See Project Dashboard here](https://public.tableau.com/app/profile/noemi.vargas7800/viz/UnderstandingDiabetesRisk/DiabetesRiskAnalysis?publish=yes)



"600"/>

<img src="images/diabetes-by-age-bp.png" alt="Diabetes_By_Age_BloodPressure" width="600"/>


<img src="images/diabetes_bmi_age.png" alt="Diabetes_By_Age_BMI" width="600"/>
  

<img src="images/diabetes_bp-age-glucose.png" alt="Diabetes_By_Age_Glucose" width="500"/> <img src="images/diabetes_by_BP-glucose.png" alt="Diabetes_By_BP_Glucose" width="500"/> 


[See accompanying **Tableau dashboard** for visuals.](https://public.tableau.com/app/profile/noemi.vargas7800/viz/UnderstandingDiabetesRisk/DiabetesRiskAnalysis?publish=yes)





# Diabetes Risk Factor Analysis — Technical Notes

## Project Purpose

This document captures the analytical reasoning, data preparation steps, and design decisions used to evaluate **biometric and demographic risk factors associated with diabetes prevalence**.

The objective was to move beyond basic visualization and produce **structured, decision-support insights** using SQL-based exploration and Tableau-driven storytelling.

---

## Dataset Overview & Preparation

The source dataset originates from a publicly available diabetes study and contains **demographic, biometric, and diagnostic outcome variables** for approximately 9,500 individuals.

Initial preparation included:

* Data quality review and cleaning in SQL
* Documentation of all transformations for traceability
* Validation of variable ranges and missing values
* Segmentation of key risk indicators (age groups, BMI categories, glucose ranges, blood pressure levels)

These steps ensured the dataset was suitable for **risk-factor analysis and cohort comparison**.

---

## Analytical Approach

The analysis followed a structured workflow:

1. **Initial Familiarization**

   * Rapid exploratory review in Excel to understand variable distribution and completeness.

2. **SQL-Based Exploration**

   * Data cleaning and normalization
   * Cohort segmentation by biometric thresholds
   * Comparative prevalence calculations between diabetic and non-diabetic groups
   * Identification of multi-factor interaction patterns

3. **Visualization & Storytelling in Tableau**

   * Development of threshold-based bar charts for interpretability
   * Consistent color encoding to reinforce categorical meaning
   * Layout designed to guide viewers from **single-factor risk → combined biomarker interaction**

---

## Key Analytical Observations

The exploration confirmed several expected relationships:

* Strong association between **elevated glucose, higher BMI, and diabetes prevalence**
* Progressive **risk amplification with age**, even when other biomarkers remain normal
* Significant **compounding effects when multiple elevated biomarkers occur together**

Notably, **age emerged as a dominant risk amplifier**, reshaping assumptions about late-life diabetes susceptibility and reinforcing the need for **age-stratified screening strategies**.

---

## Visualization Design Rationale

Dashboard visuals were intentionally simplified to support **rapid clinical interpretation**:

* **Bar charts** chosen for clarity in prevalence comparison
* **Consistent color mapping** applied across biomarker categories
* Minimalist layout used to prioritize **signal over visual complexity**

This design approach aligns with **healthcare analytics best practices**, where interpretability and decision speed are critical.

---

## Analytical Constraints

Several limitations influenced interpretation:

* Cross-sectional dataset with **no longitudinal tracking**
* Limited biomarker scope compared to full clinical records
* Simulated or study-based population that may not generalize to all demographics

Despite these constraints, the dataset remains effective for demonstrating **risk-factor interaction analysis and population-health insight generation**.

---

## Professional Takeaways

This project reinforced core data-analytics competencies:

* Structured **SQL-based exploration and cohort analysis**
* Translation of statistical relationships into **decision-oriented insights**
* Design of **clear, interpretable healthcare dashboards**
* Recognition of how **multi-factor biometric interaction** drives real-world risk

These capabilities reflect practical readiness for **Data Analyst and Business Intelligence roles** within healthcare and operational analytics environments.

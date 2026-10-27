# Healthcare Insurance Analysis — Capstone 1

Predict patients' hospitalization costs and identify the factors that drive them (2,335 beneficiaries).

| Part | File |
|---|---|
| Data science + machine learning | [`healthcare_insurance.ipynb`](healthcare_insurance.ipynb) (source: [`healthcare_insurance.py`](healthcare_insurance.py)) |
| SQL | [`healthcare_insurance.sql`](healthcare_insurance.sql) — self-contained (data embedded) |

Data: `../Dataset/Capstone _1/` (Hospitalisation details, Medical Examinations, Names).

## Data science (Week 1)
- Collated 3 files on `Customer ID`; removed the 0.5% of rows containing the trivial value `?`
- Ordinal encoding for hospital/city tier, 0/1 for yes/no fields, dummies only for states **R1011, R1012, R1013**
- Cleaned `NumberOfMajorSurgeries` ("No major surgery" → 0), computed **age** from date of birth and **gender** from the salutation (Mr. / Ms. / Mrs.)
- Histogram, box plot, swarm plot, radar chart (median cost per hospital tier), city × hospital tier frequency table and stacked bar chart

| Hypothesis (H0) | Result |
|---|---|
| Hospital tiers have equal mean cost | **Rejected** — tier-1 hospitals cost far more |
| City tiers have equal mean cost | Not rejected (p = 0.23) |
| Smokers and non-smokers have equal mean cost | **Rejected** — 32.9k vs 8.4k |
| Smoking and heart issues are independent | Not rejected (p = 0.77) |

## Machine learning (Week 2)
Stratified 5-fold CV (cost quintiles, with a `fold` column), sklearn pipelines, standardisation, grid-searched regularisation.

| Model | CV R² | CV RMSE |
|---|---|---|
| Linear regression | 0.858 | 4,470 |
| Ridge (tuned, α ≈ 5.6) | 0.858 | 4,470 |
| **Gradient Boosting (tuned)** | **0.916** | **3,431** |

Importance: **smoker 73%**, BMI 12%, age 9%, hospital tier 2%; everything else < 1% (redundant).
**Case scenario — Ms. Jayna Christopher:** predicted hospitalization cost **≈ 27,081** (Gradient Boosting; Ridge ≈ 31,673).

## SQL (Week 2)
Loads both tables, deletes `?` rows, adds **PRIMARY KEY**s on `customer_id`, builds a merged view, then answers:
- Diabetic (HbA1c > 6.5) patients with heart issues: **323 patients**, avg 1.02 children, avg BMI 31.36, avg cost 16,340 (avg age depends on the run date)
- Average cost per hospital tier and city tier
- Patients with major surgery and a cancer history: **391**
- Tier-1 hospital records per state: R1011 (116), R1013 (68), R1012 (62), …

# Employee Turnover Analytics — Portobello Tech

Predict which employees will leave and design retention strategies (14,999 employees, 24% turnover).

**Notebook:** [`employee_turnover.ipynb`](employee_turnover.ipynb) (source: [`employee_turnover.py`](employee_turnover.py)) · **Data:** `../HR_comma_sep.csv`

## What's covered
1. Data quality checks (no missing values)
2. EDA: correlation heatmap, satisfaction/evaluation/hours distributions, project-count bar plot
3. K-Means (3 clusters) of leavers on satisfaction × evaluation
4. `get_dummies` encoding, stratified 80:20 split (random_state=123), **SMOTE** on the training set
5. 5-fold CV + classification reports: Logistic Regression, Random Forest, Gradient Boosting
6. ROC/AUC, confusion matrices, recall vs precision
7. Turnover probability → Safe / Low / Medium / High risk zones with retention strategies

## Key findings
- **Drivers:** low satisfaction, project load at the extremes (2 or 6-7 projects), 5-year tenure, low salary, no promotion
- **Leaver clusters:** burnt-out high performers · disengaged low performers · satisfied high performers who left anyway
- **Best model: Random Forest** — test AUC 0.995, recall 0.98 for leavers. *(With duplicate rows removed, Gradient Boosting and Random Forest tie at AUC ≈ 0.98.)*
- **Recall** is the key metric: missing a leaver costs much more than a false alarm.

# Data Science & Python Projects

Fifteen course-end and capstone projects covering Python programming, SQL, data analysis, machine learning and deep learning.
Each project folder has its own README with the approach and results; notebooks are saved **with outputs**, so they can be read directly on GitHub.

| Week | Project | Type | Highlights |
|---|---|---|---|
| 1 | [Personal Expense Tracker](Week%201/Personal%20Expense%20Tracker) | Python CLI | Categories, monthly budget alerts, CSV save/load |
| 1 | [Task Manager with User Authentication](Week%201/Task%20Manager%20with%20User%20Authentication) | Python CLI | Salted PBKDF2 password hashing, per-user task files |
| 2 | [ScienceQtech Employee Performance Mapping](Week%202/ScienceQtech%20Employee%20Performance%20Mapping) | MySQL | Window functions, views, procedures, functions, indexes, ER diagram |
| 2 | [Air Cargo Analysis](Week%202/Air%20Cargo%20Analysis) | MySQL | Constraints, ROLLUP, error handlers, cursor, ER diagram |
| 3 | [Marketing Campaigns](Week%203/Marketing%20Campaigns) | EDA + statistics | Imputation, encoding, 4 hypothesis tests |
| 3 | [Sales Analysis](Week%203/Sales%20Analysis) | EDA + dashboard | Normalisation, weekly/monthly/quarterly reports, Seaborn dashboard |
| 4 | [Creating Cohorts of Songs](Week%204/Creating%20Cohorts%20of%20Songs) | Clustering | PCA + K-Means song cohorts (Spotify) |
| 4 | [Employee Turnover Analytics](Week%204/Employee%20Turnover%20Analytics) | Classification | SMOTE, 5-fold CV, RF / GB / LR, risk zones (AUC 0.995) |
| 5 | [Lending Club Loan Data Analysis](Week%205/Lending%20Club%20Loan%20Data%20Analysis) | Deep learning | Keras network, class weights (AUC 0.70) |
| 5 | [Home Loan Data Analysis](Week%205/Home%20Loan%20Data%20Analysis) | Deep learning | 307k applicants, balancing, sensitivity (AUC 0.74) |
| 6 | [Healthcare Insurance Analysis](Week%206/Healthcare%20Insurance%20Analysis) | Capstone: DS + ML + SQL | Cost prediction (GB R² 0.92), hypothesis tests |
| 6 | [United States Airlines Analysis](Week%206/United%20States%20Airlines%20Analysis) | Capstone: DS + ML + SQL | Web scraping, 518k flights, voting ensembles |
| 6 | [UAV Propeller Performance Analysis](Week%206/UAV%20Propeller%20Performance%20Analysis) | Capstone: DS + ML + SQL | Blade-area integration, solidity, gradient boosting |

Datasets sit next to the project folders in each week (`Week N/`, `Week 6/Dataset/`).

## Running locally

```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
jupyter lab
```

- **Python apps (Week 1):** `python3 expense_tracker.py`, `python3 task_manager.py` — standard library only.
- **SQL (Weeks 2 & 6):** MySQL 8.0+. Week 2 and the healthcare scripts embed their data; the airline and UAV scripts use `LOAD DATA LOCAL INFILE` (run with `mysql --local-infile=1`).
- **Large dataset:** `Week 5/loan_data-2.csv` (158 MB) exceeds GitHub's 100 MB limit and is git-ignored. Place it back in `Week 5/` to rerun the Home Loan notebook (or track it with Git LFS).

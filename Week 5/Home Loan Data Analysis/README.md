# Home Loan Data Analysis — Deep Learning

Keras/TensorFlow model that predicts whether a home-loan applicant will have repayment difficulties. 307,511 applicants, 122 columns, 8.1% defaults.

**Notebook:** [`home_loan.ipynb`](home_loan.ipynb) (source: [`home_loan.py`](home_loan.py)) · **Data:** `../loan_data-2.csv` (158 MB — not committed to GitHub; see top-level README)

## Steps (from the brief)
1. Load data · 2. Null check (49 columns > 40% missing dropped; median/"Missing" imputation) · 3. Default % (8.07% vs 91.93%)
4. Balance training data (random under-sampling; val/test keep the real distribution) · 5. Plot imbalanced vs balanced data
6. Encode (label encoding for binary, one-hot for multi-class columns → 188 features) · 7. **Sensitivity** · 8. **ROC-AUC**

Model: Dense(256) → Dense(128) → Dense(64) with batch norm, dropout, L2, early stopping and learning-rate reduction.

## Results (test set, 61,503 applicants)
| Metric | Value |
|---|---|
| ROC-AUC | **0.744** |
| Sensitivity (defaulters caught) | **0.67** |
| Specificity | 0.69 |

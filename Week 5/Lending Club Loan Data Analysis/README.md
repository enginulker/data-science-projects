# Lending Club Loan Data Analysis — Deep Learning

Keras/TensorFlow model that predicts whether a LendingClub loan (2007-2015) will not be fully paid. 9,578 loans, 16% defaults.

**Notebook:** [`lending_club.ipynb`](lending_club.ipynb) (source: [`lending_club.py`](lending_club.py)) · **Data:** `../loan_data.csv`

## What's covered
1. **Feature transformation** — one-hot encoding of `purpose`
2. **EDA** — default rate by purpose, FICO, interest rate, inquiries, credit policy
3. **Feature engineering** — dropped `fico` (|r| = 0.71 with `int.rate`, which carries more signal)
4. **Model** — Dense(64) → BatchNorm → Dropout → Dense(32) → Dropout → sigmoid, class weights for imbalance, early stopping on validation AUC

## Results (held-out test set)
| Metric | Value |
|---|---|
| ROC-AUC | **0.70** (logistic-regression baseline 0.69) |
| Recall on defaults | 0.67 |
| Precision on defaults | 0.26 |

Risk signals: low FICO/high interest rate, many recent credit inquiries, not meeting credit policy, small-business loans.

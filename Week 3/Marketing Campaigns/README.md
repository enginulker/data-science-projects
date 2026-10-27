# Marketing Campaigns — EDA & Hypothesis Testing

Exploratory analysis and hypothesis testing of 2,240 customers to understand what drives customer acquisition, organised around the 4 Ps (People, Product, Place, Promotion).

**Notebook:** [`marketing_campaigns.ipynb`](marketing_campaigns.ipynb) (source: [`marketing_campaigns.py`](marketing_campaigns.py)) · **Data:** `../1716985255_marketing_campaign_dataset/marketing_data.csv`

## What's covered
1. Fixing imported types (`Income` stored as `"$84,835.00 "`, `Dt_Customer` as text)
2. Cleaning `Education` / `Marital_Status` (e.g. `YOLO`, `Absurd`, `Together`) and imputing 24 missing incomes with the mean of the same Education × Marital-status group
3. New features: total children, age, total spending, total purchases
4. Box plots/histograms and outlier removal (3 customers aged 114-121, 1 income of 666,666)
5. Ordinal encoding (Education) and one-hot encoding (Marital status, Country)
6. Correlation heatmap
7. Four hypothesis tests (Mann-Whitney / Spearman / Welch t-test)
8. Visual analyses: products, age vs campaign, countries, children vs spend, complaints by education

## Key findings
| Question | Answer |
|---|---|
| Older customers prefer stores? | **No** — store share slightly *falls* with age; older customers lean on catalogs |
| Parents prefer online? | **Yes** — web share 33% vs 26% (p < 0.001) |
| Store sales cannibalised? | **No** by web/catalog purchases (they rise together, ρ ≈ 0.7); but heavy web *browsers* buy less in store (ρ ≈ −0.46) |
| US outperforms rest of world? | **No** (p ≈ 0.07); US buys slightly more per customer but Spain dominates volume |
| Top / bottom products | Wine (~680k) and meat (~373k) top; fruits and sweets lowest |
| Age vs last-campaign acceptance | No meaningful correlation (r ≈ −0.02) |
| Most acceptances | Spain (176 customers) |
| Children vs spending | Customers without children spend 2-4× more |
| Complaints | Mostly Graduation-level customers (14 of 20) |

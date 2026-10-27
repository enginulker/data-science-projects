# AAL Sales Analysis — Q4 2020 (Australia)

State-by-state analysis of an Australian apparel brand's Q4 2020 sales to find the strongest states and design programs for the weaker ones.

**Notebook:** [`sales_analysis.ipynb`](sales_analysis.ipynb) (source: [`sales_analysis.py`](sales_analysis.py)) · **Data:** `../AusApparalSales4thQrt2020.csv`

## What's covered
- **Data wrangling** — `isna()`/`notna()` checks (no missing values), whitespace fixes, date parsing, treatment recommendations, **Min-Max normalisation**, GroupBy chunking vs merging
- **Analysis** — mean/median/mode/std for Sales and Unit, highest/lowest states and groups, ANOVA, weekly/monthly/quarterly reports
- **Dashboard (Seaborn)** — state × group, group × state, time-of-day (peak/off-peak) and daily/weekly/monthly/quarterly charts, plus box and distribution plots

## Key findings
- **Total Q4 revenue: $340.3M**
- **Top states:** VIC ($105.6M, 31%), NSW (22%), SA (17%)
- **Weakest states:** WA ($22.2M), NT and TAS (~6.5% each)
- **Demographic groups** (Kids, Women, Men, Seniors) are almost identical (~25% each; ANOVA p = 0.84)
- **Time of day:** Morning is a marginal peak, Evening the off-peak (gap < 2%)
- **Seasonality:** November dip (−21%) then December surge (+49%)

**Recommendations:** expand in VIC/NSW ahead of December; targeted promotions, loyalty and click-and-collect programs for WA, NT, TAS (and QLD); use evening and November offers to smooth demand.

# UAV Propeller Performance Analysis — Capstone 3

Predict small-UAV propeller performance — **thrust coefficient (CT)**, **power coefficient (CP)** and **efficiency** — from blade geometry and operating conditions with gradient boosting.

| Part | File |
|---|---|
| Data science + machine learning | [`uav_propeller.ipynb`](uav_propeller.ipynb) (source: [`uav_propeller.py`](uav_propeller.py)) |
| SQL | [`uav_propeller.sql`](uav_propeller.sql) — run from this folder with `mysql --local-infile=1 -u root -p < uav_propeller.sql` |

Data: `../Dataset/Capstone_3/` (experiment_vol1-3, geom_vol1-3).

## Data science
- Appended the three volumes, renamed columns to snake_case, removed duplicate rows
- Radius and chord distributions (`r = r/R · R`, `c = c/R · R`), blade area by **trapezoidal integration**, total blade area, disc area (π r²) and **solidity**
- Solidity could be computed for **134 of 240 propellers (56%)** — geometry is missing for 106 blade designs, concentrated in a few brands; all 3/4-blade propellers have geometry
- Bivariate plots, correlation heatmap, model-based imputation of missing solidity

## Machine learning
Trained on **2-blade** propellers (25.6k tests), evaluated on **3- and 4-blade** propellers (880 tests). Test R²:

| Model | CT | CP | Efficiency |
|---|---|---|---|
| 1. Without imputation (NaN kept) | 0.63 | 0.39 | 0.27 |
| 2. With imputation | 0.65 | 0.34 | 0.25 |
| **3. Without solidity** | **0.66** | **0.44** | **0.50** |

**Why solidity doesn't help here:** 3/4-blade propellers have solidity values (median ≈ 0.17) mostly beyond the 2-blade training range (median ≈ 0.08), and tree models can't extrapolate. Advance ratio dominates all three outputs.

## SQL
| Task | Result |
|---|---|
| Exp. 1 propellers with CT > 12% | **42 propellers** (1,002 test points) |
| Exp. 1 ordered by efficiency | top: apce 11.0x10.0 (0.762) |
| 100 lowest power-coefficient records (exp. 1) | CP from 0.0025 to 0.0069 |
| Merged exp. 1-3: propellers with efficiency ≤ 0 | **all 240 propellers** (6,245 test points) — every propeller reaches the windmilling region at high advance ratio |

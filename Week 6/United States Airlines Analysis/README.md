# United States Airlines Analysis — Capstone 2

Find the factors behind avoidable flight delays and predict whether a flight will be delayed (518,556 US flights, 45% delayed).

| Part | File |
|---|---|
| Data science + machine learning | [`us_airlines.ipynb`](us_airlines.ipynb) (source: [`us_airlines.py`](us_airlines.py)) |
| SQL | [`us_airlines.sql`](us_airlines.sql) — run the notebook first (it exports `sql_data/`), then `mysql --local-infile=1 -u root -p < us_airlines.sql` from this folder |
| Scraped data (cached) | `scraped_airline_founding.csv`, `scraped_us_hubs.csv` |

Data: `../Dataset/Capstone_2/` (Airlines, airports, runways). Joins: `AirportFrom/To` ↔ `airports.iata_code`, `airports.ident` ↔ `runways.airport_ident`.

## Data science
- Aggregated airport type/elevation and runway stats (count, length, width, surface, lighting) for source and destination airports
- **Web scraping** (Wikipedia): airline founding years and large/medium hub passenger traffic. Carriers re-coded since the data was collected (XE, OH) or defunct/merged (US Airways, Continental, Comair, Hawaiian…) use historical values.
- Missing-value treatment with justification (non-hubs → 0 passengers; runway gaps → median by airport type)

| Question | Finding |
|---|---|
| Southwest delays vs others | WN ≈ **70%** delayed — the worst; Mesa (24%), Comair (28%), Hawaiian/United (32%) best |
| Safest weekday | **Saturday** (41% delayed vs ~47% midweek) |
| Best airlines by distance | short: Mesa, Comair, US Airways · medium: Comair, Mesa, United · long: Alaska, United, Envoy |
| Long-flight departure times | Early morning and evening/red-eye peaks; delay rate climbs through the day |
| Large vs medium hubs | Large hubs: most delayed flights (~150k departures); medium hubs: highest delay **rate** (~50%) |
| Altitude / runways / length | All statistically significant (n = 518k) but small effects; altitude negligible |

## Machine learning
OneHotEncoder (airline, weekday) + OrdinalEncoder (hub size, airport type) + StandardScaler inside pipelines (no leakage); final predictions by **majority vote of 5 stratified-fold models**.

| Model | Voted test accuracy | Test AUC |
|---|---|---|
| Logistic regression (SGD) | 0.632 | 0.676 |
| Decision tree (pruned: depth 12, min leaf 100) | 0.655 | 0.696 |
| **Gradient boosting** (HistGradientBoosting) | **0.668** | **0.723** |

An unconstrained tree overfits (train 0.82 / test 0.61); pruning fixes it.

## SQL
| Task | Result |
|---|---|
| Delayed flights per weekday | Wed 41,144 (most) … Sat 22,860 (fewest) |
| Delayed flights per airline | WN 65,657, DL 27,452, OO 22,760, … |
| Delayed flights landing at airports with ≥ 10 runways | **0** — no airport in the data has 10+ open runways (O'Hare has the most, 8) |
| Above vs below average elevation | Above-average airports have higher delay rates: source 46.6% vs 44.9%, destination 48.9% vs 44.5% |

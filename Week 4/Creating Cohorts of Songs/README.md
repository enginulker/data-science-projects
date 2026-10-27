# Creating Cohorts of Songs — Rolling Stones on Spotify

EDA and K-Means clustering of 1,610 Rolling Stones tracks (Spotify audio features) to build song cohorts for recommendations.

**Notebook:** [`song_cohorts.ipynb`](song_cohorts.ipynb) (source: [`song_cohorts.py`](song_cohorts.py)) · **Data:** `../rolling_stones_spotify.csv`

## What's covered
- Data checks: missing values, duplicates (102 repeated tracks within albums removed), out-of-range values, outliers
- Album recommendation by number of popular (top-quartile) songs
- Feature distributions, correlations, popularity drivers and trends over time
- Why dimensionality reduction matters + PCA (6 components ≈ 84% variance)
- Choosing *k* (elbow, silhouette, Davies-Bouldin), K-Means vs agglomerative, cluster profiling

## Key findings
- **Recommended albums:** *Exile On Main Street* and *Sticky Fingers* (most popular songs, editions combined)
- **Live recordings are less popular** (avg popularity 18 vs 24 for studio); liveness is the strongest negative correlate
- **4 cohorts:**

| Cohort | Character | Examples |
|---|---|---|
| Acoustic ballads | acoustic, low energy | Gimme Shelter, Angie, Wild Horses |
| Upbeat studio hits | danceable, happy, short | Paint It Black, Start Me Up, Satisfaction |
| Live performances | very high liveness & energy, longer | concert-album tracks |
| Instrumental-heavy rockers | high instrumentalness, upbeat | Tumbling Dice, Rip This Joint, Happy |

# %% [markdown]
# # Creating Cohorts of Songs — Rolling Stones on Spotify
#
# **Goal:** explore the audio features of every Rolling Stones track on Spotify and group the songs into cohorts (clusters)
# of similar songs that can feed a recommendation system.

# %%
import warnings
warnings.filterwarnings("ignore")

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans, AgglomerativeClustering
from sklearn.metrics import silhouette_score, davies_bouldin_score

sns.set_theme(style="whitegrid")
plt.rcParams["figure.dpi"] = 100
RANDOM_STATE = 42

df = pd.read_csv("../rolling_stones_spotify.csv")
print(df.shape)
df.head()

# %% [markdown]
# ## 1. Initial inspection & data cleaning

# %%
df = df.drop(columns=["Unnamed: 0"])           # leftover index column
df["release_date"] = pd.to_datetime(df["release_date"])
df.info()
print("\nMissing values:", df.isna().sum().sum())
print("Duplicate rows:", df.duplicated().sum())
print("Duplicate Spotify ids:", df["id"].duplicated().sum())
print("Same song name on the same album:", df.duplicated(["name", "album"]).sum())

# %% [markdown]
# * No missing values and every `id` is unique.
# * However, **102 rows repeat a song name within the same album** (deluxe/re-issue track lists that repeat a song). These are duplicates for
#   cohort purposes, so the most popular version is kept.

# %%
df = df.sort_values("popularity", ascending=False).drop_duplicates(["name", "album"]).sort_index()
print("Rows after de-duplication:", len(df))

# %%
features = ["acousticness", "danceability", "energy", "instrumentalness", "liveness",
            "loudness", "speechiness", "tempo", "valence", "duration_ms"]
# Irrelevant / erroneous values: values outside their documented ranges
checks = {
    "0-1 features out of range": ((df[["acousticness", "danceability", "energy", "instrumentalness", "liveness", "speechiness", "valence"]] < 0) |
                                  (df[["acousticness", "danceability", "energy", "instrumentalness", "liveness", "speechiness", "valence"]] > 1)).sum().sum(),
    "loudness > 0 dB or < -60": ((df["loudness"] > 0) | (df["loudness"] < -60)).sum(),
    "tempo == 0": (df["tempo"] == 0).sum(),
    "popularity outside 0-100": ((df["popularity"] < 0) | (df["popularity"] > 100)).sum(),
    "duration <= 0": (df["duration_ms"] <= 0).sum(),
}
checks

# %%
fig, axes = plt.subplots(2, 6, figsize=(22, 7))
for ax, c in zip(axes.ravel(), features + ["popularity", "track_number"]):
    sns.boxplot(y=df[c], ax=ax, color="lightsteelblue"); ax.set_title(c)
plt.tight_layout(); plt.show()

# %% [markdown]
# **Outliers:** `duration_ms` has very long tracks (up to ~16 min live jams), `speechiness` has a few spoken intros, and `instrumentalness` is heavily
# skewed. These are *genuine* musical properties (not errors), so they are kept; extreme durations are capped at the 1st/99th percentile for clustering
# so that a handful of jams do not dominate distances.

# %%
df["duration_min"] = df["duration_ms"] / 60000
df["year"] = df["release_date"].dt.year
df["is_live"] = df["album"].str.contains("live|Live|LIVE|Licked|Stripped|Ya-Yas|Concert", regex=True) | (df["liveness"] > 0.8)
lo, hi = df["duration_ms"].quantile([0.01, 0.99])
df["duration_ms_capped"] = df["duration_ms"].clip(lo, hi)
print(f"Live recordings: {df['is_live'].mean():.0%} of tracks")

# %% [markdown]
# ## 2. Exploratory data analysis & feature engineering
# ### 2a. Which two albums should be recommended? (number of popular songs per album)
# A song is "popular" if its popularity is in the top quartile of the catalogue.

# %%
pop_threshold = df["popularity"].quantile(0.75)
df["is_popular"] = df["popularity"] >= pop_threshold
album_pop = (df.groupby("album").agg(popular_songs=("is_popular", "sum"), tracks=("name", "count"),
                                     avg_popularity=("popularity", "mean"), year=("year", "first"))
             .sort_values(["popular_songs", "avg_popularity"], ascending=False))
print(f"Popularity threshold (75th percentile): {pop_threshold:.0f}")

top = album_pop.head(15)
plt.figure(figsize=(10, 6))
ax = sns.barplot(y=top.index, x=top["popular_songs"], palette="viridis")
ax.bar_label(ax.containers[0]); plt.title("Albums with the most popular songs"); plt.xlabel("Number of popular songs"); plt.ylabel("")
plt.show()
album_pop.head(10)

# %%
# Several albums appear in multiple editions (remastered, deluxe...). Group editions under one base title
# so that we recommend two *different* albums.
df["album_base"] = df["album"].str.replace(r"\s*[\(\[].*?[\)\]]", "", regex=True).str.strip()
base_pop = (df.groupby("album_base").agg(popular_songs=("is_popular", "sum"), avg_popularity=("popularity", "mean"),
                                         editions=("album", "nunique"))
            .sort_values(["popular_songs", "avg_popularity"], ascending=False))
display(base_pop.head(8))
rec = base_pop.head(2).index.tolist()
print("Recommended albums:", rec)

# %% [markdown]
# ### 2b. Feature distributions and patterns

# %%
fig, axes = plt.subplots(2, 5, figsize=(22, 7))
for ax, c in zip(axes.ravel(), features):
    sns.histplot(df[c], kde=True, ax=ax, color="teal"); ax.set_title(c)
plt.tight_layout(); plt.show()

# %%
plt.figure(figsize=(11, 8))
sns.heatmap(df[features + ["popularity", "year"]].corr(), annot=True, fmt=".2f", cmap="coolwarm", center=0)
plt.title("Correlation between song features"); plt.show()

# %% [markdown]
# **Patterns:** the Stones catalogue is **high-energy and loud** (median energy ≈ 0.85) with moderate danceability and mostly positive valence.
# A large share of tracks are **live recordings** (bimodal `liveness`). Energy and loudness are strongly correlated (≈ 0.7), and both are
# negatively correlated with acousticness — the classic "loud rock vs acoustic ballad" axis. Danceability goes with valence (happier songs are more danceable).

# %% [markdown]
# ### 2c. What drives popularity, and how has it changed over time?

# %%
corr_pop = df[features + ["year"]].corrwith(df["popularity"]).sort_values()
fig, axes = plt.subplots(1, 2, figsize=(16, 5))
print(corr_pop.round(3))
print(df.groupby("is_live")["popularity"].mean().rename({False: "studio", True: "live"}).round(1))
corr_pop.plot.barh(ax=axes[0], color=np.where(corr_pop > 0, "seagreen", "indianred")); axes[0].set_title("Correlation with popularity")
sns.boxplot(data=df, x="is_live", y="popularity", ax=axes[1]); axes[1].set_title("Popularity: studio vs live"); axes[1].set_xticklabels(["Studio", "Live"])
plt.tight_layout(); plt.show()

# %%
df["decade"] = (df["year"] // 10 * 10).astype(str) + "s"
yearly = df.groupby("year").agg(popularity=("popularity", "mean"), energy=("energy", "mean"), acousticness=("acousticness", "mean"),
                                 danceability=("danceability", "mean"), valence=("valence", "mean"), liveness=("liveness", "mean"))
fig, axes = plt.subplots(1, 2, figsize=(18, 5))
yearly["popularity"].plot(ax=axes[0], marker="o"); axes[0].set_title("Average popularity by release year")
yearly[["energy", "acousticness", "danceability", "valence", "liveness"]].rolling(3, min_periods=1).mean().plot(ax=axes[1])
axes[1].set_title("Audio features over time (3-year rolling mean)")
plt.tight_layout(); plt.show()
df.groupby("decade")[["popularity", "energy", "acousticness", "danceability", "valence", "liveness"]].mean().round(2)

# %% [markdown]
# **Findings:**
# * **Live recordings are clearly less popular** than studio tracks; `liveness` has the strongest negative correlation with popularity.
# * Popular songs tend to be more **danceable**, slightly louder and more acoustic, and less **speechy** (spoken intros/crowd banter). Correlations are weak overall (|r| < 0.25), so popularity depends mostly on factors outside the audio features (fame of the song).
# * Over time, the band moved from the acoustic, lower-energy sound of the 1960s toward louder, more energetic recordings; recent releases
#   (mostly live albums and re-issues) are less popular, while 1960s-70s classics remain the most streamed.

# %% [markdown]
# ### 2d. Why dimensionality reduction?
# * The 10 audio features are partly **redundant** (energy ↔ loudness ↔ acousticness), and distance-based clustering suffers when correlated
#   features double-count the same information and when dimensions grow (the *curse of dimensionality*).
# * **PCA** combines correlated features into orthogonal components, removes noise, speeds up clustering and lets us **visualise** clusters in 2-D.
# * Below, PCA shows how much variance each component explains.

# %%
cluster_features = ["acousticness", "danceability", "energy", "instrumentalness", "liveness",
                    "loudness", "speechiness", "tempo", "valence", "duration_ms_capped"]
X = StandardScaler().fit_transform(df[cluster_features])
pca = PCA().fit(X)
cum = np.cumsum(pca.explained_variance_ratio_)
plt.figure(figsize=(8, 4))
plt.bar(range(1, len(cum) + 1), pca.explained_variance_ratio_, alpha=0.6, label="individual")
plt.step(range(1, len(cum) + 1), cum, where="mid", color="red", label="cumulative"); plt.axhline(0.8, ls="--", color="grey")
plt.xlabel("Principal component"); plt.ylabel("Explained variance"); plt.legend(); plt.title("PCA explained variance"); plt.show()
n_comp = int(np.argmax(cum >= 0.8) + 1)
print(f"{n_comp} components explain {cum[n_comp-1]:.0%} of the variance")
loadings = pd.DataFrame(pca.components_[:3].T, index=cluster_features, columns=["PC1", "PC2", "PC3"]).round(2)
loadings

# %% [markdown]
# PC1 is essentially a **"live energy vs. acoustic studio"** axis (energy, loudness, liveness vs acousticness) and PC2 a **"danceable/happy"** axis
# (danceability, valence). Keeping enough components for ~80% variance preserves most of the information with fewer, uncorrelated dimensions.

# %% [markdown]
# ## 3. Cluster analysis
# ### 3a. Choosing the number of clusters (elbow + silhouette)

# %%
X_pca = PCA(n_components=n_comp, random_state=RANDOM_STATE).fit_transform(X)
ks = range(2, 11)
inertia, sil, dbi = [], [], []
for k in ks:
    km = KMeans(n_clusters=k, n_init=20, random_state=RANDOM_STATE).fit(X_pca)
    inertia.append(km.inertia_); sil.append(silhouette_score(X_pca, km.labels_)); dbi.append(davies_bouldin_score(X_pca, km.labels_))
fig, axes = plt.subplots(1, 3, figsize=(18, 4))
axes[0].plot(ks, inertia, "o-"); axes[0].set_title("Elbow (inertia)")
axes[1].plot(ks, sil, "o-", color="green"); axes[1].set_title("Silhouette score (higher is better)")
axes[2].plot(ks, dbi, "o-", color="red"); axes[2].set_title("Davies-Bouldin (lower is better)")
for a in axes: a.set_xlabel("k")
plt.tight_layout(); plt.show()
pd.DataFrame({"k": list(ks), "inertia": inertia, "silhouette": sil, "davies_bouldin": dbi}).round(3)

# %% [markdown]
# The elbow flattens around **k = 4**, where the silhouette is still high relative to larger k and Davies-Bouldin is low.
# Four cohorts are also easy to interpret for a recommendation product, so **k = 4** is used.

# %%
K = 4
kmeans = KMeans(n_clusters=K, n_init=50, random_state=RANDOM_STATE).fit(X_pca)
df["cluster"] = kmeans.labels_
agg = AgglomerativeClustering(n_clusters=K, linkage="ward").fit(X_pca)
print(f"K-Means silhouette:        {silhouette_score(X_pca, df['cluster']):.3f}")
print(f"Agglomerative silhouette:  {silhouette_score(X_pca, agg.labels_):.3f}")
print(df["cluster"].value_counts().sort_index())

# %% [markdown]
# K-Means is chosen (comparable or better silhouette than Ward agglomerative, scales well and gives centroids that can be used to assign new songs).

# %%
pcs = PCA(n_components=2).fit_transform(X)
plt.figure(figsize=(9, 6))
sns.scatterplot(x=pcs[:, 0], y=pcs[:, 1], hue=df["cluster"], palette="Set1", s=25, alpha=0.8)
plt.xlabel("PC1 (live energy ↔ acoustic)"); plt.ylabel("PC2 (danceable / happy)"); plt.title("Song cohorts in PCA space"); plt.show()

# %% [markdown]
# ### 3b. Defining each cluster

# %%
profile = df.groupby("cluster")[cluster_features[:-1] + ["duration_min", "popularity"]].mean()
profile["n_songs"] = df["cluster"].value_counts().sort_index()
profile["live_%"] = (df.groupby("cluster")["is_live"].mean() * 100).round(0)
display(profile.round(3))

z = (profile[cluster_features[:-1] + ["duration_min", "popularity"]] - df[cluster_features[:-1] + ["duration_min", "popularity"]].mean()) / df[cluster_features[:-1] + ["duration_min", "popularity"]].std()
plt.figure(figsize=(13, 3.5))
sns.heatmap(z, annot=True, fmt=".1f", cmap="RdBu_r", center=0)
plt.title("Cluster profiles (z-score vs. catalogue average)"); plt.show()

# %%
def describe(row):
    tags = []
    if row["liveness"] > 0.6: tags.append("live")
    if row["acousticness"] > 0.45: tags.append("acoustic")
    if row["energy"] > 0.85: tags.append("high-energy")
    elif row["energy"] < 0.6: tags.append("mellow")
    if row["danceability"] > 0.55: tags.append("danceable")
    if row["valence"] > 0.65: tags.append("upbeat")
    elif row["valence"] < 0.45: tags.append("dark")
    if row["instrumentalness"] > 0.3: tags.append("instrumental-heavy")
    if row["speechiness"] > 0.1: tags.append("spoken/talky")
    return ", ".join(tags) or "average rock"
profile["cohort"] = profile.apply(describe, axis=1)
for c, r in profile.iterrows():
    examples = df[df.cluster == c].nlargest(5, "popularity")["name"].tolist()
    print(f"Cluster {c} ({int(r.n_songs)} songs, avg popularity {r.popularity:.0f}): {r.cohort}\n   e.g. {examples}\n")

# %%
fig, axes = plt.subplots(1, 3, figsize=(18, 4.5))
sns.boxplot(data=df, x="cluster", y="popularity", ax=axes[0], palette="Set1"); axes[0].set_title("Popularity by cohort")
sns.boxplot(data=df, x="cluster", y="year", ax=axes[1], palette="Set1"); axes[1].set_title("Release year by cohort")
sns.scatterplot(data=df, x="energy", y="acousticness", hue="cluster", palette="Set1", ax=axes[2], s=20); axes[2].set_title("Energy vs acousticness")
plt.tight_layout(); plt.show()

# %% [markdown]
# ## Conclusion
# * Data was clean apart from **repeated tracks within albums** (removed) and genuine long-tail outliers (capped for clustering).
# * The two albums to recommend are those with the **most top-quartile songs** (printed above).
# * **Liveness** is the strongest (negative) driver of popularity — studio recordings dominate listening.
# * PCA shows the features compress into a few meaningful axes (live-energy vs acoustic, danceable/happy), which makes clustering more robust.
# * K-Means with **4 cohorts** separates the catalogue into interpretable groups that can power "more like this" recommendations:
#
# | Cohort | Size | Character | Examples |
# |---|---|---|---|
# | 0 — Acoustic ballads | ~330 | high acousticness, low energy, quieter | Gimme Shelter, Angie, Wild Horses |
# | 1 — Upbeat studio hits | ~480 | danceable, high valence, short | Paint It Black, Start Me Up, Satisfaction, Miss You |
# | 2 — Live performances | ~500 | very high liveness & energy, longer, least popular | live versions from concert albums |
# | 3 — Instrumental-heavy rockers | ~190 | high instrumentalness, upbeat | Tumbling Dice, Rip This Joint, Happy |

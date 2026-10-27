# %% [markdown]
# # Lending Club Loan Data Analysis — Deep Learning
#
# **Objective:** predict whether a loan will **not be fully paid** (`not.fully.paid = 1`, i.e. default) using LendingClub data from 2007-2015.
# The data is imbalanced (~16% defaults). Steps: feature transformation → EDA → feature engineering (drop highly correlated features) →
# Keras / TensorFlow neural network.

# %%
import os, random, warnings
warnings.filterwarnings("ignore")
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import tensorflow as tf
from tensorflow import keras
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.utils.class_weight import compute_class_weight
from sklearn.metrics import (classification_report, confusion_matrix, ConfusionMatrixDisplay, roc_auc_score,
                             roc_curve, precision_recall_curve, f1_score)

SEED = 42
random.seed(SEED); np.random.seed(SEED); tf.random.set_seed(SEED)
sns.set_theme(style="whitegrid"); plt.rcParams["figure.dpi"] = 100
print("TensorFlow", tf.__version__)

df = pd.read_csv("../loan_data.csv")
print(df.shape)
df.head()

# %%
df.info()
print("Missing values:", df.isna().sum().sum(), "| Duplicates:", df.duplicated().sum())
df.describe().T.round(3)

# %% [markdown]
# ## 1. Feature transformation — categorical to numerical
# `purpose` is the only categorical column. It is nominal (no order), so it is **one-hot encoded** (discrete 0/1 columns).

# %%
print(df["purpose"].value_counts())
df_enc = pd.get_dummies(df, columns=["purpose"], prefix="purpose", dtype=int)
df_enc.columns = df_enc.columns.str.replace(".", "_")
target = "not_fully_paid"
df_enc.head()

# %% [markdown]
# ## 2. Exploratory data analysis

# %%
fig, axes = plt.subplots(1, 2, figsize=(13, 4))
ax = sns.countplot(x=df["not.fully.paid"], ax=axes[0], palette=["seagreen", "indianred"])
ax.bar_label(ax.containers[0]); ax.set_title("Target: fully paid (0) vs not fully paid (1)")
rate = df.groupby("purpose")["not.fully.paid"].mean().sort_values()
rate.plot.barh(ax=axes[1], color="indianred"); axes[1].set_title("Default rate by loan purpose")
plt.tight_layout(); plt.show()
print(f"Default rate: {df['not.fully.paid'].mean():.1%}")

# %%
num_cols = ["int.rate", "installment", "log.annual.inc", "dti", "fico", "days.with.cr.line", "revol.bal", "revol.util", "inq.last.6mths"]
fig, axes = plt.subplots(3, 3, figsize=(18, 12))
for ax, c in zip(axes.ravel(), num_cols):
    sns.histplot(data=df, x=c, hue="not.fully.paid", kde=True, stat="density", common_norm=False, ax=ax, element="step")
    ax.set_title(c)
plt.tight_layout(); plt.show()

# %%
fig, axes = plt.subplots(1, 3, figsize=(19, 4.5))
sns.histplot(data=df, x="fico", hue="credit.policy", ax=axes[0], bins=30, alpha=0.6); axes[0].set_title("FICO by credit policy")
sns.scatterplot(data=df.sample(3000, random_state=SEED), x="fico", y="int.rate", hue="not.fully.paid", alpha=0.5, ax=axes[1]); axes[1].set_title("FICO vs interest rate")
sns.barplot(data=df, x="inq.last.6mths", y="not.fully.paid", errorbar=None, ax=axes[2], color="steelblue"); axes[2].set_title("Default rate by recent credit inquiries")
axes[2].set_xlim(-0.5, 10.5)
plt.tight_layout(); plt.show()
df.groupby("not.fully.paid")[num_cols + ["credit.policy", "delinq.2yrs", "pub.rec"]].mean().T.round(3)

# %% [markdown]
# **EDA insights**
# * Borrowers who did **not** fully pay have **higher interest rates, lower FICO scores, more credit inquiries in the last 6 months** and
#   are more often **outside the credit policy** (`credit.policy = 0`).
# * **Small-business** loans have the highest default rate; **major purchases** and **credit cards** the lowest.
# * Interest rate is set largely from FICO: the two are strongly negatively related.

# %% [markdown]
# ## 3. Additional feature engineering — drop strongly correlated features

# %%
corr = df_enc.drop(columns=[target]).corr()
plt.figure(figsize=(14, 11))
sns.heatmap(corr, annot=True, fmt=".2f", cmap="coolwarm", center=0, annot_kws={"size": 7})
plt.title("Feature correlation"); plt.show()

THRESH = 0.7
upper = corr.abs().where(np.triu(np.ones(corr.shape), k=1).astype(bool))
pairs = upper.stack().loc[lambda s: s > THRESH].sort_values(ascending=False)
print("Strongly correlated pairs (|r| > 0.7):\n", pairs)

# %% [markdown]
# `int.rate` and `fico` are strongly correlated (|r| ≈ 0.71). Interest rate is derived by LendingClub largely from FICO plus other risk factors,
# so it carries redundant information. Of the pair we drop the one **less correlated with the target**.

# %%
target_corr = df_enc.corr()[target].abs()
to_drop = []
for (a, b), _ in pairs.items():
    drop = a if target_corr[a] < target_corr[b] else b
    if drop not in to_drop: to_drop.append(drop)
print("Correlation with target:\n", target_corr[[c for p in pairs.index for c in p]].round(3))
print("Dropping:", to_drop)
data = df_enc.drop(columns=to_drop)
X, y = data.drop(columns=[target]), data[target]
print("Final features:", X.shape[1])

# %% [markdown]
# ## 4. Modeling — Keras neural network
# * Stratified **70 / 15 / 15** train / validation / test split, standardisation fitted on train only.
# * Imbalance handled with **class weights** (keeps every real example; penalises missing a default more).
# * Network: Dense(64) → Dropout → Dense(32) → Dropout → Dense(1, sigmoid), with early stopping on validation AUC.

# %%
X_tmp, X_test, y_tmp, y_test = train_test_split(X, y, test_size=0.15, stratify=y, random_state=SEED)
X_train, X_val, y_train, y_val = train_test_split(X_tmp, y_tmp, test_size=0.15 / 0.85, stratify=y_tmp, random_state=SEED)
scaler = StandardScaler().fit(X_train)
X_train_s, X_val_s, X_test_s = (scaler.transform(a) for a in (X_train, X_val, X_test))
cw = compute_class_weight("balanced", classes=np.array([0, 1]), y=y_train)
class_weight = {0: cw[0], 1: cw[1]}
print("Shapes:", X_train_s.shape, X_val_s.shape, X_test_s.shape, "| class weights:", {k: round(v, 3) for k, v in class_weight.items()})

# %%
def build_model(n_features):
    model = keras.Sequential([
        keras.layers.Input(shape=(n_features,)),
        keras.layers.Dense(64, activation="relu", kernel_regularizer=keras.regularizers.l2(1e-4)),
        keras.layers.BatchNormalization(),
        keras.layers.Dropout(0.3),
        keras.layers.Dense(32, activation="relu", kernel_regularizer=keras.regularizers.l2(1e-4)),
        keras.layers.Dropout(0.3),
        keras.layers.Dense(1, activation="sigmoid"),
    ])
    model.compile(optimizer=keras.optimizers.Adam(1e-3), loss="binary_crossentropy",
                  metrics=[keras.metrics.AUC(name="auc"), keras.metrics.Recall(name="recall"),
                           keras.metrics.Precision(name="precision"), "accuracy"])
    return model

model = build_model(X_train_s.shape[1])
model.summary()

# %%
early = keras.callbacks.EarlyStopping(monitor="val_auc", mode="max", patience=15, restore_best_weights=True)
history = model.fit(X_train_s, y_train, validation_data=(X_val_s, y_val), epochs=200, batch_size=128,
                    class_weight=class_weight, callbacks=[early], verbose=0)
print("Epochs trained:", len(history.history["loss"]))

hist = pd.DataFrame(history.history)
fig, axes = plt.subplots(1, 2, figsize=(14, 4))
hist[["loss", "val_loss"]].plot(ax=axes[0], title="Loss"); hist[["auc", "val_auc"]].plot(ax=axes[1], title="AUC")
plt.tight_layout(); plt.show()

# %% [markdown]
# ### Evaluation on the held-out test set

# %%
proba = model.predict(X_test_s, verbose=0).ravel()
pred = (proba >= 0.5).astype(int)
auc = roc_auc_score(y_test, proba)
print(f"Test ROC-AUC: {auc:.4f}\n")
print(classification_report(y_test, pred, target_names=["Fully paid", "Not fully paid"], digits=3))

fig, axes = plt.subplots(1, 3, figsize=(19, 4.5))
ConfusionMatrixDisplay(confusion_matrix(y_test, pred), display_labels=["Fully paid", "Not fully paid"]).plot(ax=axes[0], cmap="Blues", colorbar=False)
axes[0].set_title("Confusion matrix (threshold 0.5)")
fpr, tpr, _ = roc_curve(y_test, proba)
axes[1].plot(fpr, tpr, label=f"Neural network (AUC = {auc:.3f})"); axes[1].plot([0, 1], [0, 1], "k--")
axes[1].set_xlabel("False positive rate"); axes[1].set_ylabel("True positive rate"); axes[1].set_title("ROC curve"); axes[1].legend()
prec, rec, thr = precision_recall_curve(y_test, proba)
axes[2].plot(rec, prec); axes[2].axhline(y_test.mean(), ls="--", color="grey", label="baseline (default rate)")
axes[2].set_xlabel("Recall"); axes[2].set_ylabel("Precision"); axes[2].set_title("Precision-recall curve"); axes[2].legend()
plt.tight_layout(); plt.show()

# %%
# Baseline comparison: logistic regression on the same features
from sklearn.linear_model import LogisticRegression
lr = LogisticRegression(max_iter=2000, class_weight="balanced").fit(X_train_s, y_train)
print(f"Logistic regression baseline test AUC: {roc_auc_score(y_test, lr.predict_proba(X_test_s)[:, 1]):.4f}")
print(f"Neural network test AUC:              {auc:.4f}")

# %% [markdown]
# ## Conclusion
# * `fico` was dropped because it is strongly correlated with `int.rate` (|r| ≈ 0.71) and `int.rate` carries more signal about default.
# * The **neural network** (class weights + early stopping) reaches a test **ROC-AUC ≈ 0.70** and catches **≈ 67% of defaulted loans**
#   (recall), at the cost of many false alarms (precision ≈ 0.26). It slightly outperforms a logistic-regression baseline (AUC ≈ 0.69).
#   The modest AUC reflects the dataset: the available features only weakly separate good and bad loans.
# * Key risk signals: **low FICO / high interest rate, many recent credit inquiries, not meeting credit policy, small-business purpose**.
# * For a lender, recall on defaults matters more than precision (a missed default costs far more than a declined good loan); the decision
#   threshold can be moved along the precision-recall curve to match the business's risk appetite.

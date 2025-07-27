# Exploratory Analysis of Breast Cancer Diagnostic Features

This repository contains an R-based analysis of the **Wisconsin Diagnostic Breast Cancer (WDBC)** dataset. The project uses statistical programming and data visualization techniques to explore which features are most predictive of cancer malignancy.

## Dataset

- **Source**: [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic))
- **Instances**: 569
- **Features**: 30 numerical + diagnosis (Benign or Malignant)

---

## Objectives

1. Identify which tumor features are most associated with malignancy.
2. Compare benign and malignant cases using summary statistics and statistical tests.
3. Visualize the most informative features to aid clinical interpretation.

---

## Required Packages

Before running the analysis, install the required R packages:

```r
install.packages(c("ggplot2", "dplyr", "tidyr", "knitr", "corrplot", "GGally", "effectsize", "pROC", "gridExtra"))

```

## Data Preparation

- Loaded dataset and assigned meaningful column names.
- Removed unnecessary columns (like `ID`).
- Converted `diagnosis` into factor and numeric formats.
- Focused on "_worst" features for predictive power.

---

## Exploratory Data Analysis (EDA)

###  Diagnosis Distribution

The dataset contains:

- **357 Benign cases**
- **212 Malignant cases**

---

### Density & Boxplots

Visualized key features:

- `radius_worst`
- `concave_points_worst`
- `perimeter_worst`

_Example visualizations included in the `figures/` folder._

---

## Top Predictive Features

Based on correlation with `diagnosis_num`, the top 5 features are:

1. `concave_points_worst`
2. `perimeter_worst`
3. `radius_worst`
4. `area_worst`
5. `concavity_worst`

---

### Feature Correlation Heatmap

Visualizes correlations among the top features using a heatmap plot.

---

### Scatter Matrix of Top Features

Pairwise scatterplots of the top predictive features help reveal distribution patterns by diagnosis.

---

### ROC Curve Analysis

ROC curves were plotted for:

- `concave_points_worst`
- `perimeter_worst`
- `radius_worst`

_Example included in the `figures/` directory._

---

## Statistical Analysis

| Feature               | Cohen's d | Adjusted p-value |
|-----------------------|-----------|------------------|
| concave_points_worst  | -2.69     | 9.29e-96         |
| perimeter_worst       | -2.60     | 1.34e-71         |
| radius_worst          | -2.54     | 6.23e-70         |

- All results show **extremely large effect sizes** and **highly significant p-values**.
- Bonferroni correction applied for multiple testing.
- Non-parametric Wilcoxon tests confirm the same findings.

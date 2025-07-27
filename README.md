
# Exploratory Analysis of Breast Cancer Diagnostic Features

This repository contains an R-based analysis of the **Wisconsin Diagnostic Breast Cancer (WDBC)** dataset. The project uses statistical programming and data visualization techniques to explore which features are most predictive of cancer malignancy.

---

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

---

## Data Preparation

- Loaded dataset and assigned meaningful column names.  
- Removed unnecessary columns (like `ID`).  
- Converted `diagnosis` into factor and numeric formats.  
- Focused on "_worst" features for predictive power.  

---

## Exploratory Data Analysis (EDA)

### Diagnosis Distribution

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

### Scatter Matrix of Top Predictive Features

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
|------------------------|-----------|------------------|
| concave_points_worst   | -2.69     | 9.29e-96         |
| perimeter_worst        | -2.60     | 1.34e-71         |
| radius_worst           | -2.54     | 6.23e-70         |

- All results show **extremely large effect sizes** and **highly significant p-values**.  
- Bonferroni correction applied for multiple testing.  
- Non-parametric Wilcoxon tests confirm the same findings.  

---

## Visualizations

This section presents all key plots used in the analysis. Each figure highlights a different aspect of the differences between benign and malignant tumors based on the WDBC dataset.

---

###  Figure 1: Distribution of Mean Radius by Diagnosis

![Figure 1: Distribution of Mean Radius by Diagnosis](figures/distribution_radius_worst.png)

> **Caption**: Malignant tumors have a visibly right-skewed distribution with higher radius values compared to benign ones.

---

###  Figure 2: Boxplot of Concave Points (Worst) by Diagnosis

![Figure 2: Boxplot of Concave Points Worst](figures/boxplot_concave_points_worst.png)

> **Caption**: Malignant cases show significantly higher values and variability in `concave_points_worst`.

---

###  Figure 3: Correlation Heatmap of Top Features

![Figure 3: Feature Correlation Heatmap](figures/feature_correlation_heatmap.png)

> **Caption**: Size-related features (`radius_worst`, `perimeter_worst`, `area_worst`) are strongly correlated. `concave_points_worst` also shows strong correlation with malignancy.

---

### Figure 4: Scatterplot Matrix of Top Predictive Features

![Figure 4: Scatterplot Matrix](figures/scatter_matrix.png)

> **Caption**: Scatterplot matrix of the top 3 predictive features by diagnosis class. Clear separation is visible across feature combinations.

---

### Figure 5: ROC Curves for Top Features

![Figure 5: ROC Curves](figures/roc_curves.png)

> **Caption**: ROC curves for `concave_points_worst`, `perimeter_worst`, and `radius_worst`. All features show strong diagnostic power (AUC close to 1).

---

### Figure 6: Perimeter Distribution by Tumor Type

![Figure 6: Perimeter Distribution](figures/distribution_perimeter_worst.png)

> **Caption**: Malignant tumors show a wider spread and higher values in `perimeter_worst` compared to benign cases.

---

### Figure 7: Multivariate Feature Relationships

![Figure 7: Multivariate Feature Relationships](figures/multivariate_relationships.png)

> **Caption**: Overview of how selected features interact across diagnosis categories. Malignant tumors cluster in higher-value regions for all top predictors.

---

## Repository Structure

```
.
├── README.md
├── wdbc_analysis.R              # Main R script
├── wdbc.data                    # Dataset file
├── wdbc.names                   # Attribute names and description
└── figures/
    ├── distribution_radius_worst.png
    ├── boxplot_concave_points_worst.png
    ├── feature_correlation_heatmap.png
    ├── scatter_matrix.png
    ├── roc_curves.png
    ├── distribution_perimeter_worst.png
    └── multivariate_relationships.png
```

## License

This project is for educational purposes under the Statistical Programming course (CCS2233) at Albukhary International University.

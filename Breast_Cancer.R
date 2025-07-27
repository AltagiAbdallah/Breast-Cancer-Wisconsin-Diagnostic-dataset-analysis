# Load required libraries
# Install required packages (only need to do this once)
install.packages("ggplot2")  # For data visualization
install.packages("dplyr")    # For data manipulation
install.packages("tidyr")    # For data cleaning
install.packages("knitr")     # For creating nice tables
install.packages("corrplot")  # For correlation heatmaps
install.packages("GGally")    # For scatter plot matrices
install.packages("effectsize")
install.packages("pROC")
install.packages("gridExtra")
library(dplyr)   # For data manipulation
library(readr)   # For reading CSV files
library(effectsize)

# Read the dataset
data <- read.csv("C:/Users/User/Desktop/breast+cancer+wisconsin+diagnostic/wdbc.data")

# Print the first few rows
head(data)

# Check the dimensions (number of rows and columns)
dim(data)

# Create proper column names based on the dataset description
column_names <- c(
  "ID", "diagnosis",
  # Mean features
  "radius_mean", "texture_mean", "perimeter_mean", "area_mean", 
  "smoothness_mean", "compactness_mean", "concavity_mean", 
  "concave_points_mean", "symmetry_mean", "fractal_dimension_mean",
  # Standard error features
  "radius_se", "texture_se", "perimeter_se", "area_se", 
  "smoothness_se", "compactness_se", "concavity_se", 
  "concave_points_se", "symmetry_se", "fractal_dimension_se",
  # Worst features
  "radius_worst", "texture_worst", "perimeter_worst", "area_worst", 
  "smoothness_worst", "compactness_worst", "concavity_worst", 
  "concave_points_worst", "symmetry_worst", "fractal_dimension_worst"
)

# Assign the column names to your data frame
colnames(data) <- column_names

# Verify the first few rows
head(data)

# Number of features and sample size
cat("Number of observations (patients):", nrow(data), "\n")
cat("Number of features:", ncol(data), "\n\n")

# Summary information
cat("Dataset structure:\n")
str(data)

cat("\nSummary statistics:\n")
summary(data)

# Diagnosis distribution
cat("\nDiagnosis distribution:\n")
table(data$diagnosis)


# Exploratory Data Analysis

# Load necessary libraries
library(ggplot2)
library(dplyr)
library(tidyr)
# Check distribution of 'radius_mean' (a key feature)
ggplot(data, aes(x = radius_mean, fill = diagnosis)) +
  geom_density(alpha = 0.6) +
  labs(title = "Distribution of Mean Radius by Diagnosis", 
       x = "Mean Radius", y = "Density") +
  theme_minimal()

# Compare 'concave_points_worst' (a strong predictor)
ggplot(data, aes(x = diagnosis, y = concave_points_worst, fill = diagnosis)) +
  geom_boxplot() +
  labs(title = "Worst Concave Points by Diagnosis", 
       x = "Diagnosis", y = "Worst Concave Points") +
  theme_minimal()

# Drop the ID column (not useful for analysis)
data <- subset(data, select = -ID)

# Drop the temporary diagnosis_num if it exists
if("diagnosis_num" %in% names(data)) {
  data <- subset(data, select = -diagnosis_num)
}

worst_features <- grep("_worst$", names(data), value = TRUE)
data <- data[, c("diagnosis", worst_features)]

# Check structure
str(data)

# New summary statistics
summary(data)

# Convert diagnosis to factor with proper labels
data$diagnosis <- factor(data$diagnosis, 
                         levels = c("B", "M"), 
                         labels = c("Benign", "Malignant"))

# Create numeric version (Benign=0, Malignant=1)
data$diagnosis_num <- as.numeric(data$diagnosis) - 1

# Verify conversion
table(data$diagnosis, data$diagnosis_num)

# Get numeric columns (excluding diagnosis itself)
numeric_cols <- sapply(data, is.numeric)
numeric_data <- data[, numeric_cols & names(data) != "diagnosis_num"]

# Add diagnosis_num back explicitly
numeric_data$diagnosis_num <- data$diagnosis_num

# Compute correlations
correlations <- cor(numeric_data, use = "complete.obs")["diagnosis_num", ]

# Sort by absolute value and remove diagnosis_num itself
sorted_cor <- sort(abs(correlations), decreasing = TRUE)
sorted_cor <- sorted_cor[names(sorted_cor) != "diagnosis_num"]

# Top 5 features
cat("Top 5 predictive features:\n")
print(head(sorted_cor, 5))

# Check for missing values
colSums(is.na(data))

library(GGally)

# Select top 4 features + diagnosis
top_features_4 <- names(head(sorted_cor, 4))
plot_data <- data[, c(top_features_4, "diagnosis")]

# Pairwise scatter plots
ggpairs(plot_data, 
        columns = 1:4, 
        mapping = aes(color = diagnosis, alpha = 0.7),
        title = "Scatter Plot Matrix of Top Predictive Features") +
  theme_minimal()

library(dplyr)

# Manually specify the worst features you want to analyze
selected_features <- c("concave_points_worst", "perimeter_worst", 
                       "radius_worst", "area_worst", "concavity_worst")

data %>%
  group_by(diagnosis) %>%
  summarise(
    across(
      all_of(selected_features),
      list(mean = mean, sd = sd, median = median),
      .names = "{.col}_{.fn}"
    )
  ) %>%
  knitr::kable(digits = 3)

library(dplyr)

# Define top features (from correlation analysis)
top_features <- c("concave_points_worst", "perimeter_worst", 
                  "radius_worst", "area_worst", "concavity_worst")


# Calculate summary statistics

summary_stats <- data %>%
  group_by(diagnosis) %>%
  summarise(
    across(
      all_of(top_features),
      list(
        mean = ~mean(., na.rm = TRUE),
        sd = ~sd(., na.rm = TRUE),
        median = ~median(., na.rm = TRUE),
        IQR = ~IQR(., na.rm = TRUE)
      ),
      .names = "{.col}_{.fn}"
    )
  )

# View results
print(summary_stats)

# Diagnosis distribution
diag_freq <- table(data$diagnosis)
prop.table(diag_freq) * 100

# Output:
# Benign    Malignant 
# 62.7%     37.3%

# Initialize results dataframe
test_results <- data.frame(
  Feature = character(),
  p_value = numeric(),
  stringsAsFactors = FALSE
)

# Perform t-tests for each feature
for(feature in top_features) {
  test <- t.test(data[[feature]] ~ data$diagnosis)
  test_results <- rbind(test_results, 
                        data.frame(Feature = feature, 
                                   p_value = test$p.value))
}

# Apply Bonferroni correction for multiple testing
test_results$adj_p_value <- p.adjust(test_results$p_value, method = "bonferroni")

print(test_results)

effect_sizes <- data.frame(
  Feature = character(),
  Cohens_d = numeric(),
  stringsAsFactors = FALSE
)

for(feature in top_features) {
  d <- cohens_d(data[[feature]] ~ data$diagnosis)
  effect_sizes <- rbind(effect_sizes,
                        data.frame(Feature = feature,
                                   Cohens_d = d$Cohens_d))
}

print(effect_sizes)

wilcox.test(concave_points_worst ~ diagnosis, data = data)

#Data Visualization

# 1. Boxplots of Key Features by Diagnosis
library(ggplot2)

for(feature in top_features) {
  print(
    ggplot(data, aes_string(x = "diagnosis", y = feature, fill = "diagnosis")) +
      geom_boxplot(alpha = 0.7) +
      labs(title = paste("Distribution of", feature, "by Diagnosis"),
           x = "Diagnosis",
           y = feature) +
      theme_minimal() +
      scale_fill_manual(values = c("Benign" = "#1b9e77", "Malignant" = "#d95f02"))
  )
}

# 2. Density Plots of Top Predictive Features
for(feature in top_features[1:3]) {
  print(
    ggplot(data, aes_string(x = feature, fill = "diagnosis")) +
      geom_density(alpha = 0.6) +
      labs(title = paste("Density of", feature, "by Diagnosis"),
           x = feature,
           y = "Density") +
      theme_minimal() +
      scale_fill_manual(values = c("Benign" = "#1b9e77", "Malignant" = "#d95f02"))
  )
}

# 3. Scatterplot Matrix of Top Features
library(GGally)

ggpairs(data[, c(top_features[1:3], "diagnosis")], 
        columns = 1:3,
        mapping = aes(color = diagnosis, alpha = 0.7),
        upper = list(continuous = wrap("cor", size = 4)),
        lower = list(continuous = wrap("points", size = 1.5))) +
  theme_minimal() +
  scale_color_manual(values = c("Benign" = "#1b9e77", "Malignant" = "#d95f02"))

# 4. ROC Curves for Key Features
library(pROC)

roc_plots <- list()
for(feature in top_features[1:3]) {
  roc_obj <- roc(response = data$diagnosis, 
                 predictor = data[[feature]],
                 levels = c("Benign", "Malignant"))
  roc_plots[[feature]] <- ggroc(roc_obj) + 
    ggtitle(paste("ROC for", feature)) +
    geom_abline(slope = 1, intercept = 1, linetype = "dashed")
}

# Display plots
library(gridExtra)
grid.arrange(grobs = roc_plots, ncol = 2)

# 5. Heatmap of Feature Correlations
library(corrplot)

cor_matrix <- cor(data[, top_features])
corrplot(cor_matrix,
         method = "color",
         type = "upper",
         tl.col = "black",
         addCoef.col = "black",
         number.cex = 0.7,
         title = "Correlation Between Top Features",
         mar = c(0,0,2,0))

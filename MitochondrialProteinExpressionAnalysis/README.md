# Mitochondrial Protein Expression Analysis

This README provides an overview of the steps involved in analysing mitochondrial protein expression data, focusing on two separate pipelines: one for quantifying NDUFB8 (Complex I) expression and another for MTCO1 (Complex IV) expression. The analysis includes preprocessing steps such as threshold filtering of beta cells, as well as visualising protein expression levels and clustering data based on expression and clinical parameters.

## Prerequisites

Ensure that the following R libraries are installed and loaded:

```R
install.packages("readxl")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("tidyr")
install.packages("lme4")
```

Load the libraries:

```R
library(readxl)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lme4)
```

## Repository Contents

### Scripts
1. **`NDUFB8VDAC1AnalysisScript.R`**: This script quantifies and analyzes the NDUFB8/VDAC1 ratio in beta cells. It handles preprocessing, filtering, and clustering tasks.
2. **`MTCO1VDAC1AnalysisScript.R`**: This script is dedicated to the quantification and analysis of the MTCO1/VDAC1 ratio, following similar preprocessing and clustering steps as the NDUFB8 script.

### Data Preprocessing
1. **Filtering Beta Cells**: Includes filtering beta cells based on donor-specific thresholds to ensure accurate analysis.
2. **Threshold Assignment**: Applies thresholds to filter beta cells per donor, facilitating focused and reliable quantification.

### K-Means Clustering
The analysis utilises K-means clustering to group beta cells based on several parameters:
- **Parameters**: Sex, BMI, age, and OXPHOS protein intensity (e.g., MTCO1 and NDUFB8) normalised against mitochondrial mass.
- **Elbow Plots**: To determine the number of clusters approporiate, elbow plots were produced. 
- **Clusters**: Beta cells are grouped into clusters based on these parameters to uncover patterns and relationships.

### Plots and Visualisation
The repository includes various plots to help visualise and interpret the data:
- **Bar Chart of Beta Cell Counts by Diabetes Status**: Identifies the significantly lower amount of beta-cells quantified in T2D group compared to those without diabetes. 
- **Violin Plots by Sex and Diabetes Status**: Illustrates the distribution of OXPHOS Protein/VDAC1 ratios across different expression levels, stratified by sex and diabetes status.
- - **Proportional Stacked Bar Charts**: Displays the distribution of beta cells across OXPHOS Protein/VDAC1 ratio expression clusters, grouped by sex and diabetes status.
- **Residual Analysis by Cell Type**: Boxplots of residuals from a linear model predicting NDUFB8/VDAC1 ratios, categorized by cell type.
- **Scatter Plots by BMI and Age**: Shows the relationship between BMI, age, and XPHOS Protein/VDAC1 ratios, including linear regression lines.




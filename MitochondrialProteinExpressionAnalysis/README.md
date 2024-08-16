# Mitochondrial Protein Expression Analysis

This README provides an overview of the steps involved in analysing mitochondrial protein expression data, focusing on two separate pipelines: one for quantifying NDUFB8 (Complex I) expression and another for MTCO1 (Complex IV) expression. The analysis includes preprocessing steps such as threshold filtering of beta cells, as well as visualising protein expression levels and clustering data based on expression and clinical parameters.

## Prerequisites

## Prerequisites

- R (version 4.0 or higher)
- Required R packages: `readr`, `readxl`, `dplyr`, `ggplot2`, `lmerTest`

Install the necessary packages using the following commands:

```R
install.packages(c("readr", "readxl", "dplyr", "ggplot2", "tidyr", "lmerTest"))
``

Load the libraries:

```R
library(readr)
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(lme4)
```

## Repository Contents

### Scripts
1. **`NDUFB8VDAC1AnalysisScript.R`**: This script quantifies and analyzes the NDUFB8/VDAC1 ratio in beta cells. It handles preprocessing, filtering, and clustering tasks.
2. **`MTCO1VDAC1AnalysisScript.R`**: This script is dedicated to the quantification and analysis of the MTCO1/VDAC1 ratio, following similar preprocessing and clustering steps as the NDUFB8 script.

## Script Components

### Data Filtering and Processing

1. **Filtering Data**:
   - Subsets data to retain only the relevant columns for insulin intensity, MTCO1 intensity, NDUFB8 intensity and VDAC1 intensity.
   - Applies donor-specific thresholds to filter cells based on insulin intensity.

2. **Merging Data**:
   - Merges filtered data for 'Donor_ID and `ImageNumber`.

## Analysis

### K-Means Clustering
The analysis utilises K-means clustering to group beta cells based on several parameters:
- **Parameters**: Sex, BMI, age, and OXPHOS protein intensity (e.g., MTCO1 and NDUFB8) normalised against mitochondrial mass (VDAC1).
- **Elbow Plots**: To determine the number of clusters approporiate, elbow plots were produced. 
- **Clusters**: Beta cells are grouped into clusters based on these parameters to uncover patterns and relationships.

### Visualization

The repository includes various plots to help visualise and interpret the data:
- Bar Chart of Beta Cell Counts by Diabetes Status.
- Violin Plots by Sex and Diabetes Status.
- Proportional Stacked Bar Charts.
- Residual Analysis by Cell Type.
- Scatter Plots by BMI and Age




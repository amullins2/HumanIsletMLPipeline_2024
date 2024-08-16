# Mitondrial Protein Expression Analysis

This README provides an overview of the steps involved in analysing mitondrial protein expression data, specifically two seperate analysis pipelines, one for NDUFB8 (Complex I) expression and MTCO1 (CompleX IV) expression quantification. The analysis includes threshold filtering beta cells, visualising protein expression levels, and clustering data based on expression and clinical parameters.

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

Certainly! Below is a draft of a README file that explains the plots created in the provided code. This README outlines the purpose of the plots, provides a brief explanation of each one, and offers guidance on how to interpret them.

---

# NDUFB8/VDAC1 Ratio Analysis

This analysis focuses on the ratio of NDUFB8 to VDAC1 across various groups, including by sex, diabetic status, BMI, age, and other factors. The plots generated here offer visual insights into the relationships and differences between these groups.

## Table of Contents
1. [Data Overview](#data-overview)
2. [Plots and Descriptions](#plots-and-descriptions)
   - [Violin Plots by Sex](#violin-plots-by-sex)
   - [Violin Plots by Diabetic Status](#violin-plots-by-diabetic-status)
   - [Scatter Plots by BMI](#scatter-plots-by-bmi)
   - [Scatter Plots by Age](#scatter-plots-by-age)
   - [Grouped Stacked Bar Charts by Diabetic Status](#grouped-stacked-bar-charts-by-diabetic-status)
   - [Grouped Stacked Bar Charts by Sex](#grouped-stacked-bar-charts-by-sex)
   - [Residual Analysis by Cell Type](#residual-analysis-by-cell-type)
   - [Proportional Stacked Bar Charts by Sex and Diabetic Status](#proportional-stacked-bar-charts-by-sex-and-diabetic-status)
   - [Violin Plots by Sex and Diabetic Status](#violin-plots-by-sex-and-diabetic-status)

## Data Overview

The dataset used in this analysis comprises beta cell samples with various attributes, such as donor ID, sex, diabetic status, BMI, age, and NDUFB8/VDAC1 ratio. The dataset is used to generate multiple plots to explore potential patterns and differences in NDUFB8/VDAC1 ratio across different groups.

## Plots and Descriptions

### Violin Plots by Sex
![Violin Plots by Sex](#)
- **Description**: This plot illustrates the distribution of the NDUFB8/VDAC1 ratio across different expression levels (`Low Expression`, `Medium Expression`, `High Expression`) and sexes (`Male`, `Female`). The width of the violin plots indicates the density of the data points, with added points showing the mean values.
- **Interpretation**: The plot can be used to compare the spread and central tendency of NDUFB8/VDAC1 ratios between male and female subjects across different expression levels.

### Violin Plots by Diabetic Status
![Violin Plots by Diabetic Status](#)
- **Description**: Similar to the previous plot, this violin plot displays the distribution of the NDUFB8/VDAC1 ratio by diabetic status (`With T2D`, `Without Diabetes`).
- **Interpretation**: The plot highlights differences in the NDUFB8/VDAC1 ratio between diabetic and non-diabetic subjects.

### Scatter Plots by BMI
![Scatter Plots by BMI](#)
- **Description**: This scatter plot shows the relationship between BMI and the NDUFB8/VDAC1 ratio for each donor. A linear regression line is included to indicate the overall trend.
- **Interpretation**: The plot allows for the examination of how the NDUFB8/VDAC1 ratio varies with BMI across different donors.

### Scatter Plots by Age
![Scatter Plots by Age](#)
- **Description**: This plot is similar to the BMI scatter plot but focuses on the relationship between age and the NDUFB8/VDAC1 ratio.
- **Interpretation**: The plot provides insights into whether age has an impact on the NDUFB8/VDAC1 ratio.

### Grouped Stacked Bar Charts by Diabetic Status
![Grouped Stacked Bar Charts by Diabetic Status](#)
- **Description**: This bar chart shows the proportion of beta cells across different clusters (`Low Expression`, `Medium Expression`, `High Expression`) within diabetic and non-diabetic groups.
- **Interpretation**: The chart helps in understanding the distribution of beta cell expression levels in relation to diabetic status.

### Grouped Stacked Bar Charts by Sex
![Grouped Stacked Bar Charts by Sex](#)
- **Description**: This chart displays the proportion of beta cells across different clusters within male and female groups.
- **Interpretation**: It can be used to compare how beta cell expression levels vary between the sexes.

### Residual Analysis by Cell Type
![Residual Analysis by Cell Type](#)
- **Description**: A boxplot representing the residuals from a linear model predicting the NDUFB8/VDAC1 ratio based on age, BMI, sex, and diabetic status. The residuals are grouped by cell type.
- **Interpretation**: This plot can be used to assess the consistency of the linear model's predictions across different cell types.

### Proportional Stacked Bar Charts by Sex and Diabetic Status
![Proportional Stacked Bar Charts by Sex and Diabetic Status](#)
- **Description**: These stacked bar charts show the proportion of beta cells in each expression cluster for male and female subjects, split by diabetic status.
- **Interpretation**: These plots help in visualizing the combined effect of sex and diabetic status on beta cell expression levels.

### Violin Plots by Sex and Diabetic Status
![Violin Plots by Sex and Diabetic Status](#)
- **Description**: This plot combines sex and diabetic status to show the NDUFB8/VDAC1 ratio distribution across different expression levels.
- **Interpretation**: The plot enables a more granular comparison of NDUFB8/VDAC1 ratios across combined groups.




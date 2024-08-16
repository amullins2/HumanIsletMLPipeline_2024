
# Islet Composition Analysis Script

## Overview

The script processes and filters data, performs statistical analyses, generates visualizations, and outputs results. It involves multiple steps including data loading, filtering, merging, statistical analysis, and visualization.

## Purpose

The primary goals of this script are to:
1. Filter and analyse cellular intensity data for insulin and glucagon.
2. Merge datasets to enrich the data with additional information.
3. Apply thresholds to categorise cells based on their intensity values.
4. Perform statistical analyses and generate plots to visualise the results.

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

## Script Components

### Data Filtering and Processing

1. **Filtering Data**:
   - Subsets data to retain only the relevant columns for insulin and glucagon intensity.
   - Applies donor-specific thresholds to filter cells based on insulin and glucagon intensity.

2. **Merging Data**:
   - Merges filtered data for insulin and glucagon based on `ImageNumber`.
   - Filters merged data to find cells that are both insulin and glucagon positive.

## Analysis

### K-Means Clustering
The analysis utilises K-means clustering to group beta cells based on several parameters:
- **Parameters**: Sex, BMI, age, and OXPHOS protein intensity (e.g., MTCO1 and NDUFB8) normalised against mitochondrial mass (VDAC1).
- **Elbow Plots**: To determine the number of clusters approporiate, elbow plots were produced. 
- **Clusters**: Beta cells are grouped into clusters based on these parameters to uncover patterns and relationships.


### Visualization

1. **Visualizations**:
   - Generates various plots, including:
     - Alpha-beta ratio by diabetes staus.
     - Alpha-beta ratio by sex.
     - Proportions of cell types by diabetic status.
     - Islet area clusters vs. alpha-beta ratio.
     - Age group vs. alpha-beta ratio.
     - BMI vs. alpha-beta ratio.




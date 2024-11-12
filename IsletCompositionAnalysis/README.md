
# Islet Composition Analysis Script

## Overview

This README provides an overview of the steps involved in analysing islet composition data. The analysis includes preprocessing steps such as threshold filtering of beta cells, as well as visualising insulin and glucagon expression levels and clustering data based on islet area and clinical parameters.

## Purpose

The primary goals of this script are to:
1. Filter cellular intensity data for insulin and glucagon.
2. Merge datasets to add contextual information.
3. Apply thresholds to categorise cells based on their intensity values.
4. Perform statistical analyses and generate plots to visualise the results.

## Prerequisites

- R (version 4.0 or higher)
- Required R packages: `readr`, `readxl`, `dplyr`, `ggplot2`, `tidyr`

Install the necessary packages using the following commands:

```R
install.packages(c("readr", "readxl", "dplyr", "ggplot2", "tidyr"))
``

Load the libraries:

```R
library(readr)
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
```

## Script Components

### Data Filtering and Processing

1. **Filtering Data**:
   - Subsets data to retain only the relevant columns for insulin and glucagon intensity.
   - Applies donor-specific thresholds to filter cells based on insulin and glucagon intensity.

2. **Merging Data**:
   - Merges filtered data for insulin and glucagon based on `ImageNumber`.
   - Filters merged data to find cells that are both insulin and glucagon positive.

### Visualisation

Generates various plots, including:
- Alpha-beta ratio by diabetes staus.
- Alpha-beta ratio by sex.
- Proportions of cell types by diabetic status.




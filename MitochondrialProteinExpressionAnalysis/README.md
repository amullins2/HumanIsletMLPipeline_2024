# Mitondrial Protein Expression Analysis

This README provides an overview of the steps involved in analysing mitondrial protein expression data, specifically two seperate analysis pipelines, one for NDUFB8 (Complex I) expression and MTCO1 (CompleX IV) expression quantification. The analysis includes threshold filtering beta cells, visualising protein expression levels, and clustering data based on expression and clinical parameters.

## Prerequisites

Ensure that the following R libraries are installed and loaded:

```R
install.packages("ggplot2")
install.packages("dplyr")
install.packages("tidyr")
```

Load the libraries:

```R
library(ggplot2)
library(dplyr)
library(tidyr)
```

## Data Preparation

1. **Filter Beta Cells:**

   The dataset is filtered to include only beta cells. The data is grouped by donor ID and diabetic status to summarize the total number of beta cells.
   
2. **Data Transformation for Visualization:**

   The table is pivoted to facilitate comparison between donors with and wihtout type 2 diabetes (T2D).
   
3. **Protein Expression Data Filtering:**

   Data is filtered based on specific threshold values for insulin positivity per donor.

## Data Visualization

### Beta Cell Counts Comparison

**Bar Graph of Beta Cell Counts:**

   A bar graph visualizes the total number of beta cells by diabetic status.

   ```R
   ggplot(beta_cell_counts2, aes(x = factor(diabetic_status), y = total_beta_cells, fill = factor(diabetic_status))) +
       geom_bar(stat = "identity") +
       labs(x = "Diabetic Status", y = "Total Beta Cells", fill = "Diabetic Status") +
       theme_minimal()
   ```

### Protein Intensity Analysis

1. **NDUFB8 Intensity by Donor:**

   The average NDUFB8 intensity is plotted for each islet per donor.

2. **MTCO1 Intensity by Donor:**

   The average NDUFB8 intensity is plotted for each islet per donor:

3. **VDAC1 Intensity Analysis by Diabetic Status:**

   Separate plots visualize the VDAC1 intensity for non-diabetic and type 2 diabetic donors:

   ```R
   plot_non_diabetic <- ggplot(subset(merged_data_ndufb8, diabetic_status == 1), aes(x = donor_id, y = Intensity_MeanIntensity_vdac1, color = as.factor(diabetic_status))) +
       geom_point() +
       labs(x = "Donor ID", y = "Intensity of VDAC1", title = "Non-Diabetic") +
       scale_color_manual(values = "blue") +
       theme_minimal() +
       theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

   plot_type_two_diabetic <- ggplot(subset(merged_data_ndufb8, diabetic_status == 2), aes(x = donor_id, y = Intensity_MeanIntensity_vdac1, color = as.factor(diabetic_status))) +
       geom_point() +
       labs(x = "Donor ID", y = "Intensity of VDAC1", title = "Type Two Diabetic") +
       scale_color_manual(values = "red") +
       theme_minimal() +
       theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
   ```

4. **NDUFB8/VDAC1 Ratio Analysis:**

   Violin plots are created to compare the NDUFB8/VDAC1 ratio by diabetic status and sex:

   ```R
   ggplot(combined_data_ndufb9complexI, aes(x = cluster, y = ndufb8_vdac1_ratio, fill = diabetic_status)) +
       geom_violin(position = position_dodge(width = 0.9), scale = "width", alpha = 0.7) +
       stat_summary(fun = "mean", geom = "point", shape = 20, size = 3, color = "black") +
       scale_fill_manual(values = custom_colors) +
       labs(x = "Expression Level", y = "NDUFB8/VDAC1 Ratio", title = "NDUFB8/VDAC1 Ratio by Expression Level and Diabetic Status") +
       theme_minimal()
   ```

### Clustering Analysis

1. **K-means Clustering:**

   K-means clustering is performed based on expression levels and clinical data:

   ```R
   kmeans_result <- kmeans(clustering_data, centers = 3)
   ```

2. **Cluster-Based Analysis:**

## Conclusion

This analysis provides a comprehensive overview of the expression levels of Mitondrila proteins NDUFB8 and VDAC1 in beta cells, taking into account various factors such as diabetic status, donor ID, and clinical parameters. The visualizations and clustering provide insights into the distribution and intensity of these proteins, which can be used for further research and interpretation.



library(dplyr)
library(ggplot2)

# Filter beta cells
 beta_cell_counts2 <- merged_data_ndufb8 %>%
     filter(cell_type == "beta cell") %>%
    group_by(donor_id, diabetic_status) %>%
summarize(total_beta_cells = n())
`summarise()` has grouped output by 'donor_id'. You can override using
the `.groups` argument.
 
 # Pivot the table for better comparison
 beta_cell_counts_pivot <- pivot_wider(beta_cell_counts2, names_from = diabetic_status, values_from = total_beta_cells)
 
 # Plot
 ggplot(beta_cell_counts_pivot, aes(x = `1`, y = `2`)) +
     geom_point() +
     geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +  # Add a diagonal reference line
     labs(x = "Non-Diabetic", y = "Type Two Diabetic", title = "Comparison of Beta Cell Counts") +
     theme_minimal()

 # Filter beta cells and count them
 beta_cell_counts2 <- merged_data_ndufb8 %>%
     filter(cell_type == "beta cell") %>%
     group_by(diabetic_status) %>%
     summarize(total_beta_cells = n())
 
 # Plot the bar graph
 ggplot(beta_cell_counts2, aes(x = factor(diabetic_status), y = total_beta_cells, fill = factor(diabetic_status))) +
     geom_bar(stat = "identity") +
     labs(x = "Diabetic Status", y = "Total Beta Cells", fill = "Diabetic Status") +
     theme_minimal()
 
 View(DonorMetadata)
# Define threshold values for insulin positivity per donor
 thresholds <- c(
     "HP21112012" = 0.5,   
     "23012011" = 0.18,
     "26102010" = 0.2,
     "28052013" = 0.03,
     "29062012" = 0.8,
     "HP10062013" = 0.23,
     "HP13062016" = 0.13,
     "HP19022013" = 0.3,
     "HP20122011" = 0.4,
     "HP27052013" = 0.25,
     "HP28052016" = 0.2,
     "PT0267_0020" = 0.15,
     "PT0267_0021" = 0.3,
     "PT0267_0022" = 0.25,
     "PT0267_0026" = 0.22,
     "PT0267_0030" = 0.2,
     "PT0267_0032" = 0.18,
     "PT0267_0034" = 0.18,
     "PT0267_0042" = 0.2,
     "PT0267_0051" = 0.2,
     "PT0267_0054" = 0.2,
     "PT0267_0058" = 0.015,
     "PT0267_0081" = 0.2,
     "PT0267_0086" = 0.2,
     "PT0267_0090" = 0.2,
     "PT0267_0095" = 0.14
 )
 View(filtered_data_ndufb8)
 filtered_data_ndufb8 <- merged_dataset_ndufb8[merged_dataset_ndufb8$Intensity_MeanIntensity_insulin >= thresholds_ndufb8[as.character(merged_dataset_ndufb8$donor_id)], ] # Columns to keep
 columns_to_keep2 <- c("ImageNumber", "donor_id", "islet_number", 
                      "Intensity_MeanIntensity_insulin", "Intensity_MeanIntensity_vdac1", 
                      "Intensity_MeanIntensity_ndufb8")
 
 # Subset the dataset to keep only the desired columns
 filtered_data_ndufb82 <- subset(filtered_data_ndufb8, select = columns_to_keep2)
 
 # Add a new column named cell_type with all values as "beta cell"
 filtered_data_ndufb82$cell_type <- "beta cell"
 
 # Plot the average ndufb8 intensity for each islet per donor
 ggplot(avg_ndufb8_per_islet, aes(x = donor_id, y = avg_ndufb8, color = islet_number)) +
     geom_point() +
     labs(x = "Donor ID", y = "Average Intensity of ndufb8", color = "Islet Number") +
     theme_minimal() +
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
     ggtitle("Average NDUFB8 Intensity per Islet per Donor") +
     guides(color = FALSE)  # Remove the legend for islet number

 # Calculate the average ndufb8 intensity for each islet per donor
 avg_ndufb8_per_islet <- filtered_data_ndufb8 %>%
     group_by(donor_id, islet_number) %>%
     summarise(avg_ndufb8 = mean(Intensity_MeanIntensity_ndufb8, na.rm = TRUE

 # Plot for diabetic status 1 (Non-diabetic)
 plot_non_diabetic <- ggplot(subset(merged_data_ndufb8, diabetic_status == 1), aes(x = donor_id, y = Intensity_MeanIntensity_ndufb8, color = as.factor(diabetic_status))) +
     geom_point() +
     labs(x = "Donor ID", y = "Intensity of NDUFB8", title = "Non-Diabetic") +
     scale_color_manual(values = "blue") +
     theme_minimal() +     theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))  # Rotate x-axis labels vertically
 
 # Plot for diabetic status 2 (Type Two Diabetic)
 plot_type_two_diabetic <- ggplot(subset(merged_data_ndufb8, diabetic_status == 2), aes(x = donor_id, y = Intensity_MeanIntensity_ndufb8, color = as.factor(diabetic_status))) +
     geom_point() +
     labs(x = "Donor ID", y = "Intensity of NDUFB8", title = "Type Two Diabetic") +
     scale_color_manual(values = "red") +     theme_minimal() +
     theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))  # Rotate x-axis labels vertically
 
 # Arrange plots side by side
 plot_non_diabetic + plot_type_two_diabetic + plot_layout(ncol = 2)
 
 # Plot for diabetic status 1 (Non-diabetic)
 plot_non_diabetic <- ggplot(subset(merged_data_ndufb8, diabetic_status == 1), aes(x = donor_id, y = Intensity_MeanIntensity_vdac1, color = as.factor(diabetic_status))) +
     geom_point() +
     labs(x = "Donor ID", y = "Intensity of VDAC1", title = "Non-Diabetic") +
     scale_color_manual(values = "blue") +
     theme_minimal() +
     theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))  # Rotate x-axis labels vertically
 
 # Plot for diabetic status 2 (Type Two Diabetic) plot_type_two_diabetic <- ggplot(subset(merged_data_ndufb8, diabetic_status == 2), aes(x = donor_id, y = Intensity_MeanIntensity_vdac1, color = as.factor(diabetic_status))) +
     geom_point() +
     labs(x = "Donor ID", y = "Intensity of VDAC1", title = "Type Two Diabetic") +
     scale_color_manual(values = "red") +
     theme_minimal() +
     theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))  # Rotate x-axis labels vertically
 
 # Arrange plots side by side
 plot_non_diabetic + plot_type_two_diabetic + plot_layout(ncol = 2)
 
 # Plot the intensity of ndufb8 per beta cell per donor
 ggplot(filtered_data_ndufb82, aes(x = factor(donor_id), y = Intensity_MeanIntensity_ndufb8, color = donor_id)) +
     geom_point() +
     labs(x = "Donor ID", y = "Intensity of NDUFB8") +
     facet_wrap(~cell_type) +
     theme_minimal() +
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
           strip.text = element_blank()) +
     guides(color = FALSE)  # Remove the color legend

 # Plot the jitter plot
 ggplot(merged_data_ndufb8, aes(x = factor(diabetic_status), y = Intensity_MeanIntensity_ndufb8)) +
     geom_jitter(data = subset(merged_data_ndufb8, cell_type == "beta cell"), aes(color = factor(diabetic_status)), width = 0.3, alpha = 0.5) +
     geom_point(data = beta_cell_counts, aes(y = total_beta_cells), color = "black", size = 3, shape = 18) +
     labs(x = "Diabetic Status", y = "Intensity of ndufb8", color = "Diabetic Status") +
     scale_color_manual(values = c("red", "blue")) +
     theme_minimal()

 # Select relevant columns for clustering
 clustering_data <- merged_data_ndufb8[, c("normalized_intensity_ndufb8", "diabetic_status", "age", "Sex (F=1, M=2)", "bmi")]
 
 # Perform k-means clustering, based on elbow plot analysis
 set.seed(123) # for reproducibility
 k <- 3 # Number of clusters (you can adjust this)
 kmeans_result <- kmeans(clustering_data, centers = k)
 
 # Add cluster assignments to the merged data
 merged_data$cluster <- as.factor(kmeans_result$cluster)
 
 # Count the number of diabetic statuses in each cluster
 cluster_counts <- table(merged_data$cluster, merged_data$diabetic_status)
 
 # Convert to data frame for easier plotting
 cluster_counts_df <- as.data.frame.matrix(cluster_counts)
 cluster_counts_df$cluster <- rownames(cluster_counts_df)
                                                            
# List of donor IDs to remove, based on review of data and images
donor_ids_to_remove <- c("HP13062016", "HP28052016", "HP19022013", "PT0267_0034")

# Filter out rows with the specified donor IDs
updated_data <- combined_data_ndufb9complexI %>%
    filter(!donor_id %in% donor_ids_to_remove)

# Save the updated dataframe to a new variable or overwrite the original
# Assuming you want to overwrite the original dataframe
combined_data_ndufb9complexI <- updated_data

# Optionally, if you want to save the updated dataframe to a new file
# write.csv(updated_data, file = "updated_data.csv", row.names = FALSE)

# Print a summary or check the updated dataframe
summary(combined_data_ndufb9complexI)

# Assuming combined_data_ndufb9complexI is already loaded
# If Sex column is named "Sex (F=1, M=2)", rename it for easier handling
combined_data_ndufb9complexI <- combined_data_ndufb9complexI %>%
    rename(Sex = `Sex (F=1, M=2)`)

# Convert Sex to factor for better handling in ggplot2
combined_data_ndufb9complexI$Sex <- factor(combined_data_ndufb9complexI$Sex, labels = c("Female", "Male"))

# Define custom colors
custom_colors <- c("#1f77b4", "#ff7f0e")

# Create the violin plot
p <- ggplot(combined_data_ndufb9complexI, aes(x = cluster, y = ndufb8_vdac1_ratio, fill = Sex)) +
    geom_violin(aes(fill = Sex), position = position_dodge(width = 0.9), scale = "width", alpha = 0.7) +
    stat_summary(fun = "mean", geom = "point", shape = 20, size = 3, color = "black", position = position_dodge(width = 0.9)) +
    scale_fill_manual(values = custom_colors) +
    labs(x = "Expression Level", y = "NDUFB8/VDAC1 Ratio", title = "NDUFB8/VDAC1 Ratio by Expression Level and Sex") +
    theme_minimal() +
    theme(legend.title = element_blank()) +
    annotate("text", x = 2, y = max(combined_data_ndufb9complexI$ndufb8_vdac1_ratio) + 0.05, label = "***", size = 6) +
    annotate("text", x = 3, y = max(combined_data_ndufb9complexI$ndufb8_vdac1_ratio) + 0.05, label = "***", size = 6)

# Display the plot
print(p)

# Define custom colors
custom_colors <- c("#1f77b4", "#ff7f0e")

# Create the violin plot
p <- ggplot(combined_data_ndufb9complexI, aes(x = cluster, y = ndufb8_vdac1_ratio, fill = diabetic_status)) +
    geom_violin(aes(fill = diabetic_status), position = position_dodge(width = 0.9), scale = "width", alpha = 0.7) +
    stat_summary(fun = "mean", geom = "point", shape = 20, size = 3, color = "black", position = position_dodge(width = 0.9)) +
    scale_fill_manual(values = custom_colors) +
    labs(x = "Expression Level", y = "NDUFB8/VDAC1 Ratio", title = "NDUFB8/VDAC1 Ratio by Expression Level and Diabetic Status") +
    theme_minimal() +
    theme(legend.title = element_blank()) +
    annotate("text", x = 1, y = max(combined_data_ndufb9complexI$ndufb8_vdac1_ratio) + 0.05, label = "***", size = 6) +
    annotate("text", x = 2, y = max(combined_data_ndufb9complexI$ndufb8_vdac1_ratio) + 0.05, label = "***", size = 6) +
    annotate("text", x = 3, y = max(combined_data_ndufb9complexI$ndufb8_vdac1_ratio) + 0.05, label = "***", size = 6)

# Display the plot
print(p)

# Fit the linear model
linear_model <- lm(ndufb8_vdac1_ratio ~ bmi, data = combined_data_ndufb9complexI)

# Print the summary of the linear model to get the slope
summary(linear_model)

# Install necessary packages if not already installed
install.packages("ggplot2")
install.packages("dplyr")

# Load the libraries
library(ggplot2)
library(dplyr)

# Assuming combined_data_ndufb9complexI is already loaded
# Rename columns for easier handling
combined_data_ndufb9complexI <- combined_data_ndufb9complexI %>%
    rename(bmi = bmi, ndufb8_vdac1_ratio = ndufb8_vdac1_ratio, donor_id = donor_id)

# Sort the data by BMI
combined_data_ndufb9complexI <- combined_data_ndufb9complexI %>%
    arrange(bmi)

# Create the scatter plot with smoothing line
p <- ggplot(combined_data_ndufb9complexI, aes(x = bmi, y = ndufb8_vdac1_ratio, color = donor_id)) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE, color = "blue", size = 1) +
    labs(x = "BMI", y = "NDUFB8/VDAC1 Ratio", title = "NDUFB8/VDAC1 Ratio by BMI for Each Donor") +
    theme_minimal() +
    theme(legend.position = "none")  # Hide legend if there are too many donors

# Display the plot
print(p)

# Fit the linear model
linear_model <- lm(ndufb8_vdac1_ratio ~ age, data = combined_data_ndufb9complexI)

# Print the summary of the linear model to get the slope
summary(linear_model)

# Create the scatter plot with smoothing line
p <- ggplot(combined_data_ndufb9complexI, aes(x = age, y = ndufb8_vdac1_ratio, color = donor_id)) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE, color = "blue", size = 1) +
    labs(x = "Age", y = "NDUFB8/VDAC1 Ratio", title = "NDUFB8/VDAC1 Ratio by Age for Each Donor") +
    theme_minimal() +
    theme(legend.position = "none")  # Hide legend if there are too many donors

# Display the plot
print(p)

# Define custom colors for clusters
cluster_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c")  # Blue, Orange, Green

# Calculate total number of beta cells in each diabetes group
beta_cells_total <- combined_data_ndufb9complexI %>%
    group_by(diabetic_status) %>%
    summarize(total_beta_cells = n())

# Calculate proportion of beta cells for each diabetes group within each cluster
beta_cells_proportions <- combined_data_ndufb9complexI %>%
    group_by(diabetic_status, cluster) %>%
    summarize(beta_cells_count = n()) %>%
    left_join(beta_cells_total, by = "diabetic_status") %>%
    mutate(proportion = beta_cells_count / total_beta_cells)

# Reverse the order of levels for the cluster variable
beta_cells_proportions$cluster <- factor(beta_cells_proportions$cluster,
                                         levels = rev(levels(beta_cells_proportions$cluster)))

# Create grouped stacked bar chart
p <- ggplot(beta_cells_proportions, aes(x = factor(diabetic_status), y = proportion, fill = factor(cluster))) +
    geom_bar(stat = "identity", position = "stack", width = 0.7) +
    scale_fill_manual(values = cluster_colors, name = "Expression") +  # Rename fill legend title to "Expression"
    labs(x = "Diabetes Group", y = "Proportion of Beta Cells", 
         title = "Proportional Grouped Stacked Bar Chart of Beta Cells by Diabetes Group and Clusters") +
    theme_minimal() +
    # Add asterisks for significance
    geom_text(aes(label = "***"),
              position = position_stack(vjust = 0.5), size = 5, color = "black")

# Display the plot
print(p)

# Define custom colors for clusters
cluster_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c")  # Blue, Orange, Green

# Calculate total number of beta cells in each sex group
beta_cells_total <- combined_data_ndufb9complexI %>%
    group_by(Sex) %>%
    summarize(total_beta_cells = n())

# Calculate proportion of beta cells for each sex group within each cluster
beta_cells_proportions <- combined_data_ndufb9complexI %>%
    group_by(Sex, cluster) %>%
    summarize(beta_cells_count = n()) %>%
    left_join(beta_cells_total, by = "Sex") %>%
    mutate(proportion = beta_cells_count / total_beta_cells)

# Create grouped stacked bar chart
p <- ggplot(beta_cells_proportions, aes(x = Sex, y = proportion, fill = cluster)) +
    geom_bar(stat = "identity", position = "stack", width = 0.7) +
    scale_fill_manual(values = cluster_colors, name = "Expression") +  # Change legend title here
    labs(x = "Sex", y = "Proportion of Beta Cells", 
         title = "Proportional Grouped Stacked Bar Chart of Beta Cells by Sex and Clusters") +
    theme_minimal()

# Calculate positions for the asterisks in "Medium Expression" and "High Expression" clusters
asterisk_positions <- beta_cells_proportions %>%
    group_by(Sex) %>%
    mutate(
        cumsum_proportion = cumsum(proportion),
        y_position = cumsum_proportion - proportion / 2
    ) %>%
    filter(cluster %in% c("Medium Expression", "High Expression"))

# Add asterisks for significance in "Medium Expression" and "High Expression" clusters
p + geom_text(data = asterisk_positions,
              aes(label = "***", y = y_position),
              size = 5, color = "black")

# Assuming combined_data_ndufb9complexI$donor_id contains the donor IDs
unique_donor_ids <- unique(combined_data_ndufb9complexI$donor_id)

# Print the unique donor IDs
print(unique_donor_ids)

# Assuming combined_data_ndufb9complexI$donor_id contains the donor IDs
unique_donor_ids <- unique(combined_data_ndufb9complexI$donor_id)

# Create a mapping from donor ID to a sequential number
donor_id_mapping <- data.frame(donor_id = unique_donor_ids,
                               donor_number = seq_along(unique_donor_ids))

# Print the mapping (optional)
print(donor_id_mapping)

# Merge the mapping back into the original data frame
combined_data_ndufb9complexI <- merge(combined_data_ndufb9complexI, donor_id_mapping, by = "donor_id", all.x = TRUE)

# Print the updated data frame (optional)
print(combined_data_ndufb9complexI)

library(ggplot2)

# Assuming combined_data_ndufb9complexI$donor_id has been updated with donor_number

# Convert donor_number to factor and reorder levels in ascending order
combined_data_ndufb9complexI$donor_number <- factor(combined_data_ndufb9complexI$donor_number, levels = unique(combined_data_ndufb9complexI$donor_number))

# Plot donor_number vs ndufb8_vdac1_ratio with each donor represented by a unique color
ggplot(combined_data_ndufb9complexI, aes(x = donor_number, y = ndufb8_vdac1_ratio, color = donor_id)) +
    geom_point() +
    labs(x = "Donor Number", y = "NDUFB8:VDAC1 Ratio", title = "Plot of Donor Number vs NDUFB8:VDAC1 Ratio") +
    theme_minimal() +
    guides(color = FALSE)  # Removes the legend for donor_id

library(ggplot2)

# Define custom colors for diabetic_status
custom_colors <- c("Without Diabetes" = "#1f77b4", "With T2D" = "#ff7f0e")

# Assuming donor_number is numeric and ordered correctly in combined_data_ndufb9complexI

# Plot donor_number vs ndufb8_vdac1_ratio with each donor colored by diabetic_status
ggplot(combined_data_ndufb9complexI, aes(x = donor_number, y = ndufb8_vdac1_ratio, color = diabetic_status)) +
    geom_point() +
    labs(x = "Donor Number", y = "NDUFB8:VDAC1 Ratio", title = "Plot of Donor Number vs NDUFB8:VDAC1 Ratio") +
    scale_color_manual(values = custom_colors, guide = guide_legend(title = "Diabetic Status")) +
    theme_minimal()

library(ggplot2)

# Define custom colors for clusters
cluster_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c")  # Blue, Orange, Green

# Assuming combined_data_ndufb9complexI$donor_id has been updated with donor_number

# Convert donor_number to factor and reorder levels in ascending order
combined_data_ndufb9complexI$donor_number <- factor(combined_data_ndufb9complexI$donor_number, levels = unique(combined_data_ndufb9complexI$donor_number))

# Plot donor_number vs ndufb8_vdac1_ratio with each donor colored by cluster
ggplot(combined_data_ndufb9complexI, aes(x = donor_number, y = ndufb8_vdac1_ratio, color = cluster)) +
    geom_point() +
    labs(x = "Donor Number", y = "NDUFB8:VDAC1 Ratio", title = "Plot of Donor Number vs NDUFB8:VDAC1 Ratio") +
    scale_color_manual(values = cluster_colors) +  # Use custom colors for clusters
    theme_minimal() +
    guides(color = guide_legend(title = "Expression"))  # Set legend title for cluster

# Fit a linear model
model <- lm(ndufb8_vdac1_ratio ~ age + bmi + Sex + diabetic_status, data = combined_data_ndufb9complexI)

# Extract residuals
residuals <- residuals(model)

# Add residuals to the dataset
combined_data_ndufb9complexI$residuals <- residuals

# Summarize residual differences by cell_type
summary_stats <- combined_data_ndufb9complexI %>%
    group_by(cell_type) %>%
    summarize(
        mean_residual = mean(residuals),
        sd_residual = sd(residuals),
        min_residual = min(residuals),
        max_residual = max(residuals)
    )

# Display summary statistics
print(summary_stats)

# Boxplot of residuals by cell_type
ggplot(combined_data_ndufb9complexI, aes(x = cell_type, y = residuals, fill = cell_type)) +
    geom_boxplot() +
    labs(x = "Cell Type", y = "Residuals of NDUFB8:VDAC1 Ratio", 
         title = "Residual Differences in NDUFB8:VDAC1 Ratio by Cell Type") +
    theme_minimal()

# Assuming you have summary_stats dataframe with the summary statistics
# Extract necessary summary statistics
mean_residual <- summary_stats$mean_residual
sd_residual <- summary_stats$sd_residual
min_residual <- summary_stats$min_residual
max_residual <- summary_stats$max_residual

# Plotting the histogram of residuals
hist(residuals, breaks = 20, col = "skyblue", main = "Histogram of Residuals for Beta Cells",
     xlab = "Residuals", ylab = "Frequency")

# Add mean, min, and max residuals as vertical lines
abline(v = mean_residual, col = "red", lwd = 2, lty = 2)
abline(v = min_residual, col = "blue", lwd = 2, lty = 2)
abline(v = max_residual, col = "green", lwd = 2, lty = 2)

# Add legend
legend("topright", legend = c("Mean Residual", "Min Residual", "Max Residual"),
       col = c("red", "blue", "green"), lty = 2, lwd = 2, cex = 0.8)

# Optionally add a normal distribution curve
curve(dnorm(x, mean_residual, sd_residual), add = TRUE, col = "black", lwd = 2)

library(dplyr)
library(ggplot2)

# SPLIT SEX BY DIABETES STATUS --> Define vertical offsets for each sex and plot 
vertical_offsets_no_t2d <- c(Female = 0.19, Male = 0.11)
vertical_offsets_with_t2d <- c(Female = 0.15, Male = 0.11)

# Filter data for Without Diabetes
beta_cells_no_t2d <- combined_data_ndufb9complexIUPDATE %>%
    filter(diabetic_status == "Without Diabetes")

# Calculate total number of beta cells in each sex group for Without Diabetes
beta_cells_total_no_t2d <- beta_cells_no_t2d %>%
    group_by(Sex) %>%
    summarize(total_beta_cells = n())

# Calculate proportion of beta cells for each sex group within each cluster for Without Diabetes
beta_cells_proportions_no_t2d <- beta_cells_no_t2d %>%
    group_by(Sex, cluster) %>%
    summarize(beta_cells_count = n()) %>%
    left_join(beta_cells_total_no_t2d, by = "Sex") %>%
    mutate(proportion = beta_cells_count / total_beta_cells) %>%
    group_by(Sex) %>%
    mutate(
        cumulative_proportion = cumsum(proportion),
        y_position = cumulative_proportion - (proportion / 2) + vertical_offsets_no_t2d[Sex]
    )

# Create the plot for Without Diabetes
p_no_t2d <- ggplot(beta_cells_proportions_no_t2d, aes(x = Sex, y = proportion, fill = cluster)) +
    geom_bar(stat = "identity", position = "stack", width = 0.7) +
    scale_fill_manual(values = cluster_colors, name = "Expression") +
    labs(x = "Sex", y = "Proportion of Beta Cells", 
         title = "Proportional Grouped Stacked Bar Chart of Beta Cells by Sex and Clusters (Without Diabetes)") +
    theme_minimal()

# Add asterisks for significance in each cluster for Without Diabetes
p_no_t2d <- p_no_t2d + geom_text(data = beta_cells_proportions_no_t2d,
                                 aes(label = "***", y = y_position),
                                 size = 5, color = "black")

# Repeat the steps for With Diabetes
beta_cells_with_t2d <- combined_data_ndufb9complexIUPDATE %>%
    filter(diabetic_status == "With T2D")

# Calculate total number of beta cells in each sex group for With Diabetes
beta_cells_total_with_t2d <- beta_cells_with_t2d %>%
    group_by(Sex) %>%
    summarize(total_beta_cells = n())

# Calculate proportion of beta cells for each sex group within each cluster for With Diabetes
beta_cells_proportions_with_t2d <- beta_cells_with_t2d %>%
    group_by(Sex, cluster) %>%
    summarize(beta_cells_count = n()) %>%
    left_join(beta_cells_total_with_t2d, by = "Sex") %>%
    mutate(proportion = beta_cells_count / total_beta_cells) %>%
    group_by(Sex) %>%
    mutate(
        cumulative_proportion = cumsum(proportion),
        y_position = cumulative_proportion - (proportion / 2) + vertical_offsets_with_t2d[Sex]
    )

# Create the plot for With Diabetes
p_with_t2d <- ggplot(beta_cells_proportions_with_t2d, aes(x = Sex, y = proportion, fill = cluster)) +
    geom_bar(stat = "identity", position = "stack", width = 0.7) +
    scale_fill_manual(values = cluster_colors, name = "Expression") +
    labs(x = "Sex", y = "Proportion of Beta Cells", 
         title = "Proportional Grouped Stacked Bar Chart of Beta Cells by Sex and Clusters (With T2D)") +
    theme_minimal()

# Add asterisks for significance in each cluster for With Diabetes
p_with_t2d <- p_with_t2d + geom_text(data = beta_cells_proportions_with_t2d,
                                     aes(label = "***", y = y_position),
                                     size = 5, color = "black")

# Print both plots
print(p_no_t2d)
print(p_with_t2d)

library(dplyr)
library(ggplot2)
library(gridExtra)

# Define custom colors
custom_colors <- c(Female = "#1f77b4", Male = "#ff7f0e")

# Ensure cluster levels are ordered
combined_data_ndufb9complexIUPDATE$cluster <- factor(combined_data_ndufb9complexIUPDATE$cluster, 
                                                     levels = c("Low Expression", "Medium Expression", "High Expression"))

# Function to create the violin plot for a subset of data
create_violin_plot <- function(data, title) {
    ggplot(data, aes(x = cluster, y = ndufb8_vdac1_ratio, fill = Sex)) +
        geom_violin(aes(fill = Sex), position = position_dodge(width = 0.9), scale = "width", alpha = 0.7) +
        stat_summary(fun = "mean", geom = "point", shape = 20, size = 3, color = "black", position = position_dodge(width = 0.9)) +
        scale_fill_manual(values = custom_colors) +
        labs(x = "Expression Level", y = "NDUFB8/VDAC1 Ratio", title = title) +
        theme_minimal() +
        theme(legend.title = element_blank()) +
        annotate("text", x = 2, y = max(data$ndufb8_vdac1_ratio, na.rm = TRUE) + 0.05, label = "***", size = 6) +
        annotate("text", x = 3, y = max(data$ndufb8_vdac1_ratio, na.rm = TRUE) + 0.05, label = "***", size = 6) + annotate("text", x = 1, y = max(data$ndufb8_vdac1_ratio, na.rm = TRUE) + 0.05, label = "***", size = 6)
}

# Filter data for each diabetic status
data_no_t2d <- combined_data_ndufb9complexIUPDATE %>%
    filter(diabetic_status == "Without Diabetes")
data_with_t2d <- combined_data_ndufb9complexIUPDATE %>%
    filter(diabetic_status == "With T2D")

# Create violin plots for each diabetic status
p_no_t2d <- create_violin_plot(data_no_t2d, "NDUFB8/VDAC1 Ratio by Expression Level and Sex (Without Diabetes)")
p_with_t2d <- create_violin_plot(data_with_t2d, "NDUFB8/VDAC1 Ratio by Expression Level and Sex (With T2D)")

# Display the plots side by side
grid.arrange(p_no_t2d, p_with_t2d, ncol = 2)


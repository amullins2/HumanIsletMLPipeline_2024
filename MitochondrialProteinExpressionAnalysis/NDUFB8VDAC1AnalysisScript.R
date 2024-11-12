library(dplyr)
library(ggplot2)
library(patchwork)
library(gridExtra)


# Define insulin thresholds per donor
thresholds <- c(
    "HP21112012" = 0.5, "23012011" = 0.18, "26102010" = 0.2,
    "28052013" = 0.03, "29062012" = 0.8, "HP10062013" = 0.23,
    "HP13062016" = 0.13, "HP19022013" = 0.3, "HP20122011" = 0.4,
    "HP27052013" = 0.25, "HP28052016" = 0.2, "PT0267_0020" = 0.15,
    "PT0267_0021" = 0.3, "PT0267_0022" = 0.25, "PT0267_0026" = 0.22,
    "PT0267_0030" = 0.2, "PT0267_0032" = 0.18, "PT0267_0034" = 0.18,
    "PT0267_0042" = 0.2, "PT0267_0051" = 0.2, "PT0267_0054" = 0.2,
    "PT0267_0058" = 0.015, "PT0267_0081" = 0.2, "PT0267_0086" = 0.2,
    "PT0267_0090" = 0.2, "PT0267_0095" = 0.14
)

# Filter for beta cells and counts by donor and diabetic status
beta_cell_counts <- merged_data_ndufb8 %>%
    filter(cell_type == "beta cell") %>%
    group_by(donor_id, diabetic_status) %>%
    summarize(total_beta_cells = n(), .groups = "drop")

# Pivot table for comparison
beta_cell_counts_pivot <- beta_cell_counts %>%
    pivot_wider(names_from = diabetic_status, values_from = total_beta_cells)

# Scatter plot comparing beta cell counts for diabetic vs. non-diabetic
ggplot(beta_cell_counts_pivot, aes(x = `1`, y = `2`)) +
    geom_point() +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
    labs(x = "Non-Diabetic", y = "Type 2 Diabetic", title = "Comparison of Beta Cell Counts") +
    theme_minimal()

# Aggregate beta cell counts by diabetic status
beta_cell_counts_summary <- beta_cell_counts %>%
    group_by(diabetic_status) %>%
    summarize(total_beta_cells = sum(total_beta_cells), .groups = "drop")

# Bar plot for total beta cells by diabetic status
ggplot(beta_cell_counts_summary, aes(x = factor(diabetic_status), y = total_beta_cells, fill = factor(diabetic_status))) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = custom_colors) +
    labs(x = "Diabetic Status", y = "Total Beta Cells", fill = "Diabetic Status") +
    theme_minimal()

# Filter based on insulin threshold
filtered_data_ndufb8 <- merged_data_ndufb8 %>%
    filter(Intensity_MeanIntensity_insulin >= thresholds[as.character(donor_id)])

# Columns to keep and add cell type
filtered_data_ndufb82 <- filtered_data_ndufb8 %>%
    select(ImageNumber, donor_id, islet_number, Intensity_MeanIntensity_insulin,
           Intensity_MeanIntensity_vdac1, Intensity_MeanIntensity_ndufb8) %>%
    mutate(cell_type = "beta cell")

# Average NDUFB8 intensity per islet per donor
avg_ndufb8_per_islet <- filtered_data_ndufb8 %>%
    group_by(donor_id, islet_number) %>%
    summarize(avg_ndufb8 = mean(Intensity_MeanIntensity_ndufb8, na.rm = TRUE), .groups = "drop")

# Plot average NDUFB8 intensity
ggplot(avg_ndufb8_per_islet, aes(x = donor_id, y = avg_ndufb8, color = islet_number)) +
    geom_point() +
    labs(x = "Donor ID", y = "Average Intensity of NDUFB8") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
    ggtitle("Average NDUFB8 Intensity per Islet per Donor") +
    guides(color = "none")

# Non-diabetic and Type 2 diabetic plot functions
plot_by_status <- function(data, status, color) {
    ggplot(subset(data, diabetic_status == status), aes(x = donor_id, y = Intensity_MeanIntensity_ndufb8)) +
        geom_point(color = color) +
        labs(x = "Donor ID", y = "Intensity of NDUFB8", title = ifelse(status == 1, "Non-Diabetic", "Type 2 Diabetic")) +
        theme_minimal() +
        theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
}

# Arrange plots side-by-side
plot_by_status(merged_data_ndufb8, 1, "blue") + plot_by_status(merged_data_ndufb8, 2, "red")

# Final plot for NDUFB8/VDAC1 ratio by cluster and sex
combined_data_ndufb9complexI <- combined_data_ndufb9complexI %>%
    mutate(Sex = factor(`Sex (F=1, M=2)`, labels = c("Female", "Male")))

ggplot(combined_data_ndufb9complexI, aes(x = factor(cluster), y = ndufb8_vdac1_ratio, fill = Sex)) +
    geom_violin(position = position_dodge(width = 0.9), scale = "width", alpha = 0.7) +
    stat_summary(fun = "mean", geom = "point", shape = 20, size = 3, color = "black", position = position_dodge(width = 0.9)) +
    scale_fill_manual(values = custom_colors) +
    labs(x = "Expression Level", y = "NDUFB8/VDAC1 Ratio") +
    theme_minimal() +
    theme(legend.title = element_blank())

# Display summary
summary(combined_data_ndufb9complexI)

# Define custom colors for cluster and sex
cluster_colors <- c("Low Expression" = "#1f77b4", "Medium Expression" = "#ff7f0e", "High Expression" = "#2ca02c")
custom_colors <- c(Female = "#1f77b4", Male = "#ff7f0e")

# Function to create the plot of donor_number vs ndufb8_vdac1_ratio, colored by cluster
create_donor_plot <- function(data, title) {
    ggplot(data, aes(x = donor_number, y = ndufb8_vdac1_ratio, color = cluster)) +
        geom_point() +
        labs(x = "Donor Number", y = "NDUFB8:VDAC1 Ratio", title = title) +
        scale_color_manual(values = cluster_colors) +  # Custom colors for clusters
        theme_minimal() +
        guides(color = guide_legend(title = "Expression"))  # Set legend title for cluster
}

# Function to calculate proportions and create stacked bar plot for each diabetic status
create_proportion_plot <- function(data, vertical_offsets, title) {
    # Calculate total number of beta cells in each sex group
    beta_cells_total <- data %>%
        group_by(Sex) %>%
        summarise(total_beta_cells = n())
    
    # Calculate proportion of beta cells for each sex group within each cluster
    beta_cells_proportions <- data %>%
        group_by(Sex, cluster) %>%
        summarize(beta_cells_count = n()) %>%
        left_join(beta_cells_total, by = "Sex") %>%
        mutate(proportion = beta_cells_count / total_beta_cells) %>%
        group_by(Sex) %>%
        mutate(
            cumulative_proportion = cumsum(proportion),
            y_position = cumulative_proportion - (proportion / 2) + vertical_offsets[Sex]
        )
    
    # Create the plot
    p <- ggplot(beta_cells_proportions, aes(x = Sex, y = proportion, fill = cluster)) +
        geom_bar(stat = "identity", position = "stack", width = 0.7) +
        scale_fill_manual(values = cluster_colors, name = "Expression") +
        labs(x = "Sex", y = "Proportion of Beta Cells", title = title) +
        theme_minimal() +
        geom_text(aes(label = "***", y = y_position), size = 5, color = "black")  # Add significance asterisks
    return(p)
}

# Function to create violin plot for NDUFB8/VDAC1 ratio by cluster and sex
create_violin_plot <- function(data, title) {
    ggplot(data, aes(x = cluster, y = ndufb8_vdac1_ratio, fill = Sex)) +
        geom_violin(aes(fill = Sex), position = position_dodge(width = 0.9), scale = "width", alpha = 0.7) +
        stat_summary(fun = "mean", geom = "point", shape = 20, size = 3, color = "black", position = position_dodge(width = 0.9)) +
        scale_fill_manual(values = custom_colors) +
        labs(x = "Expression Level", y = "NDUFB8/VDAC1 Ratio", title = title) +
        theme_minimal() +
        theme(legend.title = element_blank()) +
        annotate("text", x = 2, y = max(data$ndufb8_vdac1_ratio, na.rm = TRUE) + 0.05, label = "***", size = 6) +
        annotate("text", x = 3, y = max(data$ndufb8_vdac1_ratio, na.rm = TRUE) + 0.05, label = "***", size = 6) +
        annotate("text", x = 1, y = max(data$ndufb8_vdac1_ratio, na.rm = TRUE) + 0.05, label = "***", size = 6)
}

# Apply functions to the data
combined_data_ndufb9complexI <- fit_model(combined_data_ndufb9complexI)

# Residuals
summary_stats <- summarize_residuals(combined_data_ndufb9complexI)

# Plot donor_number vs ndufb8_vdac1_ratio
print(create_donor_plot(combined_data_ndufb9complexI, "Plot of Donor Number vs NDUFB8:VDAC1 Ratio"))

# Plot residual boxplot
print(plot_residual_boxplot(combined_data_ndufb9complexI))

# Plot residual histogram
plot_residual_histogram(combined_data_ndufb9complexI$residuals, summary_stats)

# Filter data for Without Diabetes and With Diabetes
data_no_t2d <- combined_data_ndufb9complexI %>%
    filter(diabetic_status == "Without Diabetes")
data_with_t2d <- combined_data_ndufb9complexI %>%
    filter(diabetic_status == "With T2D")

# Define vertical offsets for each sex
vertical_offsets_no_t2d <- c(Female = 0.19, Male = 0.11)
vertical_offsets_with_t2d <- c(Female = 0.15, Male = 0.11)

# Create proportion plots
p_no_t2d <- create_proportion_plot(data_no_t2d, vertical_offsets_no_t2d, "Proportional Beta Cells by Sex and Clusters (Without Diabetes)")
p_with_t2d <- create_proportion_plot(data_with_t2d, vertical_offsets_with_t2d, "Proportional Beta Cells by Sex and Clusters (With T2D)")

# Print plots
print(p_no_t2d)
print(p_with_t2d)

# Create violin plots for each diabetic status
p_violin_no_t2d <- create_violin_plot(data_no_t2d, "NDUFB8/VDAC1 Ratio by Expression Level and Sex (Without Diabetes)")
p_violin_with_t2d <- create_violin_plot(data_with_t2d, "NDUFB8/VDAC1 Ratio by Expression Level and Sex (With T2D)")

# Display violin plots side by side
grid.arrange(p_violin_no_t2d, p_violin_with_t2d, ncol = 2)


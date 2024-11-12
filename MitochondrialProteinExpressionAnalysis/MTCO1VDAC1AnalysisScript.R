# Load necessary library
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)

# Load Excel files
MyExpt_cellboundaries <- read_excel(file.choose()) # or replace with the file path
ImageInfo_CellProfilerFiles <- read_excel(file.choose(), sheet = "CellProfiler")

# Assign data to new variables for convenience
rawdata <- MyExpt_cellboundaries
cpdata <- ImageInfo_CellProfilerFiles

# Merge datasets based on 'ImageNumber'
merged_dataset <- merge(cpdata, rawdata, by = "ImageNumber", all = TRUE)

# Ensure 'Intensity_MeanIntensity_insulin' is numeric
merged_dataset$Intensity_MeanIntensity_insulin <- as.numeric(as.character(merged_dataset$Intensity_MeanIntensity_insulin))

# Define insulin positivity thresholds
thresholds <- c(
    "21112011" = 0.08, "23012011" = 0.065, "26102010" = 0.15, "28052013" = 0.05,
    "29062012" = 0.09, "HP10062013" = 0.035, "HP13062016" = 0.05, "HP19022013" = 0.05,
    "HP20122011" = 0.07, "HP27052013" = 0.025, "HP28052016" = 0.058, "PT0267_0020" = 0.03,
    "PT0267_022" = 0.06, "PT0267_0026" = 0.06, "PT0267_0030" = 0.04, "PT0267_032" = 0.05,
    "PT0267_0034" = 0.12, "PT0267_0042" = 0.06, "PT0267_0051" = 0.07, "PT0267_0054" = 0.08,
    "PT0267_0058" = 0.055, "PT0267_0081" = 0.05, "PT0267_0086" = 0.04, "PT0267_0090" = 0.09,
    "PT0267_0095" = 0.07
)

# Check for any missing donor IDs in thresholds
missing_thresholds <- setdiff(unique(merged_dataset$donor_id), names(thresholds))
if (length(missing_thresholds) > 0) {
    stop("Thresholds missing for the following donor IDs: ", paste(missing_thresholds, collapse = ", "))
}

# Filter insulin-positive cells based on donor-specific thresholds
filtered_data <- merged_dataset %>%
    filter(Intensity_MeanIntensity_insulin >= thresholds[as.character(donor_id)]) %>%
    mutate(Intensity_MeanIntensity_mtco1 = as.numeric(as.character(Intensity_MeanIntensity_mtco1)))

# Save filtered data to a CSV file
write.csv(filtered_data, "filtered_data.csv", row.names = FALSE)

# Plot mean intensity of MTCO1, color by diabetic status, and fill by age gradient
ggplot(filtered_data, aes(x = donor_id, y = Intensity_MeanIntensity_mtco1, 
                          color = factor(diabetic_status), fill = age)) +
    geom_point(shape = 21, size = 3) +
    labs(x = "Donor ID", y = "Mean Intensity of MTCO1",
         color = "Diabetic Status", fill = "Age") +
    scale_color_manual(values = c("red", "blue"), labels = c("No", "Yes")) +
    scale_fill_gradient(low = "lightblue", high = "darkblue") +
    facet_wrap(~ factor(diabetic_status)) +
    theme_minimal()

# Display the structure of the final dataset
str(filtered_data)

# 1. Reshape and Transform Data
reshaped_data <- tidyr::pivot_longer(
  combined_data_mtco1complexIV,
  cols = starts_with("Intensity"),
  names_to = "Measurement",
  values_to = "Intensity"
)

# islet_id from Measurement column
reshaped_data <- reshaped_data %>%
  mutate(islet_id = gsub("^.*_", "", Measurement))

# 2. Jitter Plot for Donor Intensity (VDAC1)
jitter_plot <- ggplot(reshaped_data, aes(x = donor_id, y = Intensity, color = donor_id)) +
  geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
  labs(x = "Donor ID", y = "Intensity of VDAC1") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  scale_color_discrete(guide = FALSE) # Hide color legend to declutter

jitter_plot

# Normalise mtco1 Intensity
merged_data <- merged_data %>%
  mutate(normalised_intensity_mtco1 = Intensity_MeanIntensity_mtco1 / Intensity_MeanIntensity_vdac1)

# Box Plot for Normalised mtco1 by Diabetic Status
ggplot(merged_data, aes(x = factor(diabetic_status, labels = c("Non-Diabetic", "Type 2 Diabetic")), y = normalised_intensity_mtco1, color = factor(diabetic_status))) +
  geom_boxplot() +
  labs(x = "Diabetic Status", y = "Normalised MTCO1 Intensity") +
  theme_minimal() +
  scale_color_manual(values = c("#4C5988", "#FF7F0E"))

#  K-Means Clustering
clustering_data <- merged_data %>%
  select(normalised_intensity_mtco1, Intensity_MeanIntensity_vdac1, age, bmi, Sex = `Sex (F=1, M=2)`)

set.seed(123)
kmeans_result <- kmeans(clustering_data %>% select(-diabetic_status), centers = 2)
merged_data$cluster <- as.factor(kmeans_result$cluster)

# Cluster Counts for Diabetic Status
cluster_counts <- merged_data %>%
  count(cluster, diabetic_status) %>%
  pivot_wider(names_from = diabetic_status, values_from = n)

# Filter Out Unwanted Donor IDs
donor_ids_to_remove <- c("HP13062016", "HP28052016", "HP19022013", "PT0267_0034")
filtered_data <- combined_data_mtco1complexIV %>%
  filter(!donor_id %in% donor_ids_to_remove)

# Violin Plot by Cluster and Sex
ggplot(filtered_data, aes(x = cluster, y = normalised_intensity_mtco1, fill = Sex)) +
  geom_violin(position = position_dodge(width = 0.9), alpha = 0.7, scale = "width") +
  stat_summary(fun = mean, geom = "point", shape = 20, size = 3, color = "black", position = position_dodge(width = 0.9)) +
  scale_fill_manual(values = c("#1f77b4", "#ff7f0e")) +
  labs(x = "Expression Level", y = "MTCO1/VDAC1 Ratio") +
  theme_minimal() +
  theme(legend.title = element_blank())

# Helper function to calculate beta cell proportions by sex and cluster
calculate_beta_cell_proportions <- function(data, sex_offsets) {
  total_cells <- data %>%
    group_by(Sex) %>%
    summarise(total_beta_cells = n())
  
  data %>%
    group_by(Sex, cluster) %>%
    summarise(beta_cells_count = n()) %>%
    left_join(total_cells, by = "Sex") %>%
    mutate(proportion = beta_cells_count / total_beta_cells) %>%
    group_by(Sex) %>%
    mutate(
      cumulative_proportion = cumsum(proportion),
      y_position = cumulative_proportion - (proportion / 2) + sex_offsets[Sex]
    )
}

# Helper function to create a stacked bar chart with asterisks
create_stacked_bar_chart <- function(data, title) {
  ggplot(data, aes(x = Sex, y = proportion, fill = cluster)) +
    geom_bar(stat = "identity", position = "stack", width = 0.7) +
    scale_fill_manual(values = cluster_colors, name = "Expression") +
    labs(x = "Sex", y = "Proportion of Beta Cells", title = title) +
    geom_text(aes(label = "***", y = y_position), size = 5, color = "black") +
    theme_minimal()
}

# Calculate proportions and plot for each diabetic status
sex_offsets_no_t2d <- c(Female = 0.19, Male = 0.11)
sex_offsets_with_t2d <- c(Female = 0.15, Male = 0.11)

beta_cells_proportions_no_t2d <- calculate_beta_cell_proportions(
  combined_data_mtco1complexIV %>% filter(diabetic_status == "Without Diabetes"),
  sex_offsets_no_t2d
)
beta_cells_proportions_with_t2d <- calculate_beta_cell_proportions(
  combined_data_mtco1complexIV %>% filter(diabetic_status == "With T2D"),
  sex_offsets_with_t2d
)

# Plotting both charts
p_no_t2d <- create_stacked_bar_chart(beta_cells_proportions_no_t2d, "Proportional Grouped Stacked Bar Chart (Without Diabetes)")
p_with_t2d <- create_stacked_bar_chart(beta_cells_proportions_with_t2d, "Proportional Grouped Stacked Bar Chart (With Type 2 Diabetes)")

# Print plots
print(p_no_t2d)
print(p_with_t2d)

# Define function for creating violin plots by cluster and sex
create_violin_plot <- function(data, title) {
  ggplot(data, aes(x = cluster, y = mtco1_vdac1_ratio, fill = Sex)) +
    geom_violin(position = position_dodge(width = 0.9), scale = "width", alpha = 0.7) +
    stat_summary(fun = "mean", geom = "point", shape = 20, size = 3, color = "black", position = position_dodge(width = 0.9)) +
    scale_fill_manual(values = custom_colors) +
    labs(x = "Expression Level", y = "MTCO1/VDAC1 Ratio", title = title) +
    theme_minimal() +
    theme(legend.title = element_blank())
}

# Create and print violin plots
p_violin <- create_violin_plot(combined_data_mtco1complexIV, "MTCO1/VDAC1 Ratio by Cluster and Sex")
print(p_violin)


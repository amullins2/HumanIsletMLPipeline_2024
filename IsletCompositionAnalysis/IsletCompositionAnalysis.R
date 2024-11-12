# Load libraries
library(readr)
library(readxl)
library(dplyr)
library(ggplot2)
library(lmerTest)

# Load datasets
MyExpt_cells_ecadherin <- read_csv("OneDrive - Newcastle University/PhD//Data/MyExpt_cells_ecadherin.csv")
CellProfilerImageList <- read_excel("OneDrive - Newcastle University/PhD/Data/CellProfilerImageList.xlsx")

# Filter columns for each dataset
select_columns <- function(df, columns) {
  df[, columns]
}

filtered_data_all <- select_columns(MyExpt_cells_ecadherin, c("ImageNumber", "ObjectNumber", "Intensity_MeanIntensity_insulin", "Intensity_MeanIntensity_glucagon"))
filtered_data_beta <- select_columns(MyExpt_cells_ecadherin, c("ImageNumber", "ObjectNumber", "Intensity_MeanIntensity_insulin"))
filtered_data_alpha <- select_columns(MyExpt_cells_ecadherin, c("ImageNumber", "ObjectNumber", "Intensity_MeanIntensity_glucagon"))

# Merge data with additional columns
filtered_data_beta <- merge(filtered_data_beta, CellProfilerImageList[, c("image_number", "islet_number", "donor_id")],
                            by.x = "ImageNumber", by.y = "image_number", all.x = TRUE)

# Thresholds for filtering insulin and glucagon positivity
insulinthresholds <- c(
  "21112011" = 0.055, "23012011" = 0.055, "26102010" = 0.055, "28052013" = 0.015, "29062012" = 0.055, "HP10062013" = 0.015,
  "HP13062016" = 0.03, "HP19022013" = 0.03, "HP20122011" = 0.055, "HP27052013" = 0.03, "HP28052016" = 0.015,
  "PT0267_0020" = 0.04, "PT0267_0021" = 0.04, "PT0267_0022" = 0.04, "PT0267_0026" = 0.04, "PT0267_0030" = 0.04,
  "PT0267_0032" = 0.04, "PT0267_0034" = 0.04, "PT0267_0042" = 0.04, "PT0267_0051" = 0.04, "PT0267_0054" = 0.04,
  "PT0267_0058" = 0.04, "PT0267_0081" = 0.04, "PT0267_0086" = 0.04, "PT0267_0090" = 0.04, "PT0267_0095" = 0.04
)

# Define threshold values for glucagon positivity per donor
glucagonthresholds <- c( "21112011" = 0.04, "23012011" = 0.04, "26102010" = 0.02, "28052013" = 0.015, "29062012" = 0.04, "HP10062013" = 0.04, "HP13062016" = 0.02, "HP19022013" = 0.02, "HP20122011" = 0.04, "HP27052013" = 0.02, \
                        "HP28052016" = 0.02, "PT0267_0021" = 0.04, "PT0267_0020" = 0.04, "PT0267_0022" = 0.04, "PT0267_0026" = 0.04, "PT0267_0030" = 0.02, "PT0267_0032" = 0.04, "PT0267_0034" = 0.04, "PT0267_0042" = 0.04, 
                        "PT0267_0051" = 0.04, "PT0267_0054" = 0.03, "PT0267_0058" = 0.04, "PT0267_0081" = 0.04, "PT0267_0086" = 0.04, "PT0267_0090" = 0.02, "PT0267_0095" = 0.04 )

apply_threshold <- function(df, intensity_col, thresholds) {
  df$donor_id <- as.character(df$donor_id)
  df <- df[df[[intensity_col]] >= thresholds[df$donor_id], ]
  return(df)
}

filtered_data_alpha <- apply_threshold(filtered_data_alpha, "Intensity_MeanIntensity_glucagon", glucagonthresholds)
filtered_data_beta <- apply_threshold(filtered_data_beta, "Intensity_MeanIntensity_insulin", insulinthresholds)

# Identify bihormonal cells
merged_data <- merge(filtered_data_alpha, filtered_data_beta, by = "ImageNumber", suffixes = c("_alpha", "_beta"))
bihormonalcells <- merged_data[merged_data$ObjectNumber_alpha == merged_data$ObjectNumber_beta, ]

# Analyze diabetic status counts
diabetic_status_counts_1_2 <- table(bihormonalcells$diabetic_status)[c("1", "2")]

# Alpha-beta ratio calculation and save
merged_counts <- merge(alpha_counts, beta_counts, by = c("donor_id", "islet_number"), all = TRUE)
merged_counts[is.na(merged_counts)] <- 0
merged_counts$alpha_beta_ratio <- merged_counts$alphacount / merged_counts$betacount

write.csv(merged_counts, "~/Desktop/merged_counts.csv", row.names = FALSE)

# Proportion calculations
merged_counts <- merged_counts %>%
    group_by(donor_id, islet_number) %>%
    mutate(
        total_bonds = alpha_alpha + beta_beta + beta_alpha,
        alpha_alpha_proportion = alpha_alpha / total_bonds,
        beta_beta_proportion = beta_beta / total_bonds,
        beta_alpha_proportion = beta_alpha / total_bonds
    ) %>%
    ungroup()

write.csv(merged_counts, "~/Desktop/merged_counts.csv", row.names = FALSE)

# Load required libraries
library(ggplot2)
library(dplyr)

# DEFINE COLOURS
cluster_colors <- c("Small" = "#1f77b4", "Medium" = "#ff7f0e", "Large" = "#2ca02c")
status_colors <- c("Without Diabetes" = "blue", "With Type 2 Diabetes" = "red")
age_group_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c")

# PLOT PROPORTIONS OF CELL TYPES BY DIABETIC STATUS
ggplot(average_proportions, aes(fill = Cell_Type, y = Proportion, x = diabetic_status)) +
  geom_bar(stat = "identity", width = 0.5) +
  labs(x = "Diabetic Status", y = "Proportion", fill = "Cell Type") +
  scale_fill_manual(values = custom_colors) +
  theme_minimal()

# K-MEANS CLUSTERING AND CLUSTER LABELING
k <- 3
kmeans_model <- kmeans(merged_counts$islet_area, centers = k, nstart = 25)
merged_counts$cluster <- factor(kmeans_model$cluster, labels = c("Small", "Medium", "Large"))

# PLOT CLUSTERS VS. ALPHA-BETA RATIO
ggplot(merged_counts, aes(x = cluster, y = alpha_beta_ratio, fill = cluster)) +
  geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
  geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5, color = "black") +
  labs(x = "Islet Area Clusters", y = "Alpha:Beta Ratio") +
  scale_fill_manual(values = cluster_colors) +
  theme_minimal()

# ANOVA TO TEST SIGNIFICANT DIFFERENCES BETWEEN CLUSTERS
anova_result <- aov(islet_area ~ cluster, data = merged_counts)
summary(anova_result)

# SUBSET AND PRINT CLUSTER ISLET DATA
for (i in 1:3) {
  cat("Cluster", i, "islets:\n")
  print(merged_counts %>% filter(cluster == levels(merged_counts$cluster)[i]))
}

# FILTER AND PRINT SUBSETS BASED ON ALPHA-BETA RATIOS
filter_conditions <- list(
  "Cluster 1, Alpha:Beta < 1" = merged_counts$cluster == "Small" & merged_counts$alpha_beta_ratio < 1,
  "Cluster 2, Alpha:Beta > 3" = merged_counts$cluster == "Medium" & merged_counts$alpha_beta_ratio > 3,
  "Cluster 3, Alpha:Beta < 1" = merged_counts$cluster == "Large" & merged_counts$alpha_beta_ratio < 1
)

for (condition_name in names(filter_conditions)) {
  subset_data <- merged_counts %>% filter(!!filter_conditions[[condition_name]])
  cat("\n", condition_name, "\n")
  print(table(subset_data$diabetic_status))
}

# PLOT AGE GROUPS VS. ALPHA-BETA RATIO WITH DIABETIC STATUS
age_breaks <- c(60, 65, 70, 75)
merged_counts <- merged_counts %>%
  mutate(age_group = cut(age, breaks = age_breaks, labels = c("60-64", "65-69", "70-74")))

ggplot(merged_counts, aes(x = factor(age_group), y = alpha_beta_ratio, color = diabetic_status)) +
  geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA, position = position_dodge(width = 0.75)) +
  geom_jitter(position = position_dodge(width = 0.75), aes(shape = diabetic_status), alpha = 0.5) +
  labs(x = "Age Group", y = "Alpha:Beta Ratio", color = "Diabetic Status", shape = "Diabetic Status") +
  scale_color_manual(values = status_colors) +
  scale_shape_manual(values = c(16, 17)) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "right")

# PLOT ALPHA-BETA RATIO BY AGE GROUP WITH AGE GROUP COLORS
ggplot(merged_counts, aes(x = factor(age_group), y = alpha_beta_ratio, fill = factor(age_group))) +
  geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
  geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5) +
  labs(x = "Age Group", y = "Alpha:Beta Ratio", fill = "Age Group") +
  scale_fill_manual(values = age_group_colors) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "right")

# Load necessary libraries
library(ggplot2)
library(dplyr)

# Define custom colours
custom_colors <- c("#1f77b4", "#ff7f0e")

# Alpha:Beta Ratio by Sex
ggplot(merged_counts, aes(x = Sex, y = alpha_beta_ratio, color = Sex)) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5) +
    labs(
        x = "Sex",
        y = "Alpha:Beta Ratio"
    ) +
    scale_color_manual(values = custom_colors) +
    theme_minimal() +
    theme(
        plot.title = element_blank(),  
        legend.position = "none"
    )

# Alpha:Beta Ratio by Diabetes Status
ggplot(merged_counts, aes(x = diabetic_status, y = alpha_beta_ratio, color = diabetic_status)) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5) +
    labs(
        x = "Diabetes Status",
        y = "Alpha:Beta Ratio"
    ) +
    scale_color_manual(values = custom_colors) +
    theme_minimal() +
    theme(
        plot.title = element_blank(),
        legend.position = "none"
    )

# Cell Connection Proportions by Diabetes Status
summary_data <- summary_data %>%
    mutate(diabetic_status = factor(diabetic_status, levels = c("Without Diabetes", "With T2D")))

ggplot(summary_data, aes(x = diabetic_status, y = proportion, fill = category)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_fill_manual(
        values = custom_colors,
        labels = c("Alpha-Alpha", "Beta-Alpha", "Beta-Beta"),
        name = "Cell Connection Proportions"
    ) +
    labs(
        x = "Diabetes Status",
        y = "Proportion"
    ) +
    theme_minimal() +
    theme(plot.title = element_blank()) +
    geom_text(data = filter(summary_data, !is.na(stack_position)),
              aes(y = stack_position, label = "***"), size = 5, color = "black") +
    ylim(0, 1)

# Alpha:Beta Ratio by Age for Each Donor
filtered_data <- filtered_data %>% arrange(age)

ggplot(filtered_data, aes(x = age, y = alpha_beta_ratio, color = factor(donor_id))) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE, color = "blue") +
    labs(x = "Age", y = "Alpha:Beta Ratio") +
    scale_color_discrete(name = "Donor ID") +
    theme_minimal() +
    theme(legend.position = "none")

# Alpha:Beta Ratio by BMI for Each Donor
filtered_data <- filtered_data %>% arrange(bmi)

ggplot(filtered_data, aes(x = bmi, y = alpha_beta_ratio, color = factor(donor_id))) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE, color = "blue") +
    labs(x = "BMI", y = "Alpha:Beta Ratio") +
    scale_color_discrete(name = "Donor ID") +
    theme_minimal() +
    theme(legend.position = "none")


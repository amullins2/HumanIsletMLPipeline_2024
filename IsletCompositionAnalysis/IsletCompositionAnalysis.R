library(readr)
MyExpt_cells_ecadherin <- read_csv("OneDrive - Newcastle University/PhD/Undergraduate Final Year Project_2024/Data/MyExpt_cells_ecadherin.csv")
View(MyExpt_cells_ecadherin)

# Assuming your data frame is named MyExpt_cells_ecadherin
# Select the columns you want to keep
selected_columns <- c("ImageNumber", "ObjectNumber", "Intensity_MeanIntensity_insulin", "Intensity_MeanIntensity_glucagon")

# Subset your data frame to keep only the selected columns
filtered_data_all <- MyExpt_cells_ecadherin[, selected_columns]

# Assuming your data frame is filtered_data
# Select the columns you want to keep
selected_columns2 <- c("ImageNumber", "ObjectNumber", "Intensity_MeanIntensity_insulin")

# Subset your data frame to keep only the selected columns
filtered_data_beta <- MyExpt_cells_ecadherin[, selected_columns2]

# Assuming your data frame is filtered_data
# Select the columns you want to keep
selected_columns3 <- c("ImageNumber", "ObjectNumber", "Intensity_MeanIntensity_glucagon")

# Subset your data frame to keep only the selected columns
filtered_data_alpha <- MyExpt_cells_ecadherin[, selected_columns3]

library(readxl)
CellProfilerImageList <- read_excel("OneDrive - Newcastle University/PhD/Undergraduate Final Year Project_2024/Data/CellProfilerImageList.xlsx")
View(CellProfilerImageList)

# Perform a left join to retain all rows from filtered_data_beta
# and add islet_number and donor_id from CellProfilerImageList
filtered_data_beta <- merge(filtered_data_beta, CellProfilerImageList[, c("image_number", "islet_number", "donor_id")],
                            by.x = "ImageNumber", by.y = "image_number", all.x = TRUE)

# Define threshold values for insulin positivity per donor
insulinthresholds <- c(
    "21112011" = 0.055,   
    "23012011" = 0.055,
    "26102010" = 0.055,
    "28052013" = 0.015,
    "29062012" = 0.055,
    "HP10062013" = 0.015,
    "HP13062016" = 0.03,
    "HP19022013" = 0.03,
    "HP20122011" = 0.055,
    "HP27052013" = 0.03,
    "HP28052016" = 0.015,
    "PT0267_0020" = 0.04, "PT0267_0021" = 0.04,
    "PT0267_0022" = 0.04,
    "PT0267_0026" = 0.04,
    "PT0267_0030" = 0.04,
    "PT0267_0032" = 0.04,
    "PT0267_0034" = 0.04,
    "PT0267_0042" = 0.04,
    "PT0267_0051" = 0.04,
    "PT0267_0054" = 0.04,
    "PT0267_0058" = 0.04,
    "PT0267_0081" = 0.04,
    "PT0267_0086" = 0.04,
    "PT0267_0090" = 0.04,
    "PT0267_0095" = 0.04
)

# Define threshold values for insulin positivity per donor
glucagonthresholds <- c(
    "21112011" = 0.04,   
    "23012011" = 0.04,
    "26102010" = 0.02,
    "28052013" = 0.015,
    "29062012" = 0.04,
    "HP10062013" = 0.04,
    "HP13062016" = 0.02,
    "HP19022013" = 0.02,
    "HP20122011" = 0.04,
    "HP27052013" = 0.02,
    "HP28052016" = 0.02, "PT0267_0021" = 0.04,
    "PT0267_0020" = 0.04,
    "PT0267_0022" = 0.04,
    "PT0267_0026" = 0.04,
    "PT0267_0030" = 0.02,
    "PT0267_0032" = 0.04,
    "PT0267_0034" = 0.04,
    "PT0267_0042" = 0.04,
    "PT0267_0051" = 0.04,
    "PT0267_0054" = 0.03,
    "PT0267_0058" = 0.04,
    "PT0267_0081" = 0.04,
    "PT0267_0086" = 0.04,
    "PT0267_0090" = 0.02,
    "PT0267_0095" = 0.04
)

# Assuming 'filtered_data_alpha' is your dataframe
# Convert the donor_id column to character type
filtered_data_alpha$donor_id <- as.character(filtered_data_alpha$donor_id)

# Filter out cells that are glucagon-positive based on threshold values
filtered_data_alpha <- filtered_data_alpha[filtered_data_alpha$Intensity_MeanIntensity_glucagon >= glucagonthresholds[as.character(filtered_data_alpha$donor_id)], ]

# Assuming 'filtered_data_beta' is your dataframe
# Convert the donor_id column to character type
filtered_data_beta$donor_id <- as.character(filtered_data_beta$donor_id)

# Filter out cells that are insulin-positive based on threshold values
filtered_data_beta <- filtered_data_beta[filtered_data_beta$Intensity_MeanIntensity_insulin >= insulinthresholds[as.character(filtered_data_beta$donor_id)], ]

# Merge filtered_data_alpha and filtered_data_beta based on ImageNumber
merged_data <- merge(filtered_data_alpha, filtered_data_beta, by = "ImageNumber", suffixes = c("_alpha", "_beta"))

# View the merged data
head(merged_data)

# Find rows where ObjectNumber_alpha and ObjectNumber_beta match
bihormonalcells <- merged_data[merged_data$ObjectNumber_alpha == merged_data$ObjectNumber_beta, ]

# View the matching objects
head(bihormonalcells)

# Count occurrences of each diabetic status
diabetic_status_counts <- table(bihormonalcells$diabetic_status)

# Find the diabetic status with the highest count
predominant_diabetic_status <- names(diabetic_status_counts)[which.max(diabetic_status_counts)]

# Output the result
predominant_diabetic_status

# Get the counts of each diabetic status
diabetic_status_counts <- table(bihormonalcells$diabetic_status)

# Filter diabetic_status_counts to include only "1" or "2"
diabetic_status_counts_1_2 <- diabetic_status_counts[c("1", "2")]

# Output the counts for diabetic status 1 and 2
diabetic_status_counts_1_2

# Assuming you have alpha_counts and beta_counts dataframes with donor_id, islet_number, and counts columns

# Merge alpha_counts and beta_counts by donor_id and islet_number
merged_counts <- merge(alpha_counts, beta_counts, by = c("donor_id", "islet_number"), all = TRUE)

# Replace all NA values with 0 in merged_counts
merged_counts[is.na(merged_counts)] <- 0

# Calculate alpha to beta cell ratio for each islet
merged_counts$alpha_beta_ratio <- merged_counts$alphacount / merged_counts$betacount

# Save merged_counts dataframe to desktop
write.csv(merged_counts, file = "~/Desktop/merged_counts.csv", row.names = FALSE)

library(dplyr)

# Group by donor_id and islet_number
merged_counts <- merged_counts %>%
    group_by(donor_id, islet_number) %>%
    mutate(
        total_bonds = alpha_alpha + beta_beta + beta_alpha,
        alpha_alpha_proportion = alpha_alpha / total_bonds,
        beta_beta_proportion = beta_beta / total_bonds,
        beta_alpha_proportion = beta_alpha / total_bonds
    ) %>%
    ungroup()

# Save merged_counts dataframe to desktop
write.csv(merged_counts, file = "~/Desktop/merged_counts.csv", row.names = FALSE)

# Convert numeric Sex to factor with meaningful labels
merged_counts$Sex <- ifelse(merged_counts$"Sex (F=1, M=2)" == 1, "Female", "Male")

# Plot the alpha-beta ratio for males and females 
combined_plot <- ggplot(data = merged_counts, aes(x = factor(1), y = alpha_beta_ratio, color = Sex)) +
    geom_jitter(position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.5), alpha = 0.5) +  # Add jittered points with dodge
    geom_smooth(method = "lm", se = FALSE) +  # Add trend line without confidence interval
    theme_minimal() +
    labs(title = "Alpha:Beta Ratio by Sex",
         x = "",  # Remove x-axis label
         y = "Alpha:Beta Ratio",
         color = "Sex") +
    scale_color_manual(values = sex_colors, name = "Sex") +  # Set manual colors for Male and Female with legend
    theme(axis.text.x = element_blank())  # Remove x-axis labels

# Display the combined plot
combined_plot

# Add a small offset to alpha_beta_ratio to avoid zeros and negative values
offset <- 0.01
merged_counts$log_alpha_beta_ratio <- log(merged_counts$alpha_beta_ratio + offset)

# Plot the transformed alpha-beta ratio for males and females separately with jitter
combined_plot <- ggplot(data = merged_counts, aes(x = factor(Sex), y = log_alpha_beta_ratio, color = Sex)) +
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5) +  # Add jittered points
    geom_smooth(method = "lm", se = FALSE) +  # Add trend line without confidence interval
    scale_x_discrete(labels = c("Male", "Female")) +  # Set x-axis labels
    theme_minimal() +
    labs(title = "Transformed Alpha:Beta Ratio by Sex",
         x = "Sex",
         y = "Transformed Alpha:Beta Ratio",
         color = "Sex") +
    scale_color_manual(values = sex_colors, name = "Sex")  # Set manual colors for Male and Female with legend

# Display the combined plot
combined_plot

# Load the required library
library(lmerTest)

# Fit the linear mixed model
model <- lmer(log_alpha_beta_ratio ~ age + diabetic_status + Sex + bmi + + islet_area + alpha_alpha_proportion + beta_beta_proportion + beta_alpha_proportion +
                  (1 + islet_area + alpha_alpha_proportion + beta_beta_proportion + beta_alpha_proportion |  
                       donor_id), data = merged_counts)

# Display the summary of the model with p-values
summary(model)

Linear mixed model fit by REML. t-tests use Satterthwaite's method [lmerModLmerTest
]
Formula: log_alpha_beta_ratio ~ diabetic_status + Sex + bmi + (1 + islet_area +  
    alpha_alpha_proportion + beta_beta_proportion + beta_alpha_proportion |  
    donor_id)
   Data: merged_counts

REML criterion at convergence: 1146.3

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-5.8478 -0.4205  0.0288  0.5202  3.2331 

Random effects:
 Groups   Name                   Variance  Std.Dev. Corr                   
 donor_id (Intercept)            1.587e+00 1.259799                        
          islet_area             9.053e-06 0.003009 -0.93                  
          alpha_alpha_proportion 3.203e+00 1.789622 -0.63  0.67            
          beta_beta_proportion   3.164e+00 1.778764  0.06 -0.13 -0.54      
          beta_alpha_proportion  1.164e+01 3.412452 -0.69  0.70  0.82 -0.73
 Residual                        5.439e-01 0.737512                        
Number of obs: 450, groups:  donor_id, 23

Fixed effects:
                                 Estimate Std. Error       df t value Pr(>|t|)  
(Intercept)                      -1.44337    0.60818 13.83162  -2.373   0.0327 *
diabetic_statusType Two Diabetic  0.44253    0.19284 15.49660   0.525   0.0379 *
SexMale                          -0.10128    0.19422 14.85245  -2.278   0.0547 *
bmi                               0.04445    0.02238 13.92172   1.987   0.0670 .
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Correlation of Fixed Effects:
            (Intr) db_TTD SexMal
dbtc_sttTTD  0.135              
SexMale      0.161  0.069       
bmi         -0.966 -0.288 -0.309
optimizer (nloptwrap) convergence code: 0 (OK)
unable to evaluate scaled gradient
Model failed to converge: degenerate  Hessian with 1 negative eigenvalues

# Extract the coefficients and confidence intervals from the model summary
coefficients <- coef(summary(model))

# Extract the coefficient for SexMale and its standard error
male_coef <- coefficients["SexMale", "Estimate"]
male_se <- coefficients["SexMale", "Std. Error"]

# Extract the coefficient for intercept and its standard error
intercept_coef <- coefficients["(Intercept)", "Estimate"]
intercept_se <- coefficients["(Intercept)", "Std. Error"]

# Calculate the mean alpha_beta_ratio for males and females
mean_alpha_beta_male <- exp(male_coef + intercept_coef)
mean_alpha_beta_female <- exp(intercept_coef)

# Calculate the upper and lower bounds of the confidence intervals for males and females
male_ci_upper <- exp(male_coef + 1.96 * male_se + intercept_coef)
male_ci_lower <- exp(male_coef - 1.96 * male_se + intercept_coef)
female_ci_upper <- exp(1.96 * intercept_se + intercept_coef)
female_ci_lower <- exp(-1.96 * intercept_se + intercept_coef)

# Create a data frame for plotting
plot_data <- data.frame(
    Sex = c("Male", "Female"),
    Mean = c(mean_alpha_beta_male, mean_alpha_beta_female),
    Lower = c(male_ci_lower, female_ci_lower),
    Upper = c(male_ci_upper, female_ci_upper)
)

# Plot the bar plot
library(ggplot2)

bar_plot <- ggplot(plot_data, aes(x = Sex, y = Mean)) +
    geom_bar(stat = "identity", fill = "skyblue", alpha = 0.7) +
    geom_errorbar(aes(ymin = Lower, ymax = Upper), width = 0.2, color = "black") +
    labs(
        title = "Mean Alpha:Beta Ratio by Sex",
        y = "Mean Alpha:Beta Ratio",
        caption = "Error bars represent 95% confidence intervals"
    ) +
    theme_minimal()

# Display the plot
bar_plot

# Load the required library
library(lmerTest)

# Fit the linear mixed model
model <- lmer(log_alpha_beta_ratio ~ diabetic_status + Sex + bmi +
                  (1 + islet_area + alpha_alpha_proportion + beta_beta_proportion + beta_alpha_proportion |  
                       donor_id), data = merged_counts)

# Display the summary of the model with p-values
summary(model)

library(dplyr)

# Calculate the average proportions by diabetic status
average_proportions <- merged_counts %>%
    group_by(diabetic_status) %>%
    summarise(
        alpha_alpha = mean(alpha_alpha_proportion),
        beta_beta = mean(beta_beta_proportion),
        beta_alpha = mean(beta_alpha_proportion)
    )

# Normalize the proportions
average_proportions <- average_proportions %>%
    mutate_at(vars(-diabetic_status), ~ . / rowSums(select(average_proportions, starts_with("alpha_alpha"), starts_with("beta_beta"), starts_with("beta_alpha"))))

# Reshape the data for plotting
average_proportions <- tidyr::pivot_longer(average_proportions, cols = -diabetic_status, names_to = "Cell_Type", values_to = "Proportion")

# Plot the stacked bar chart
stacked_bar_chart <- ggplot(average_proportions, aes(x = diabetic_status, y = Proportion, fill = Cell_Type)) +
    geom_bar(stat = "identity", position = "stack", width = 0.5, alpha = 0.7) +
    labs(
        title = "Average Cell Contact Proportions by Diabetic Status",
        x = "Diabetic Status",
        y = "Proportion",
        fill = "Cell Type"
    ) +
    scale_fill_manual(values = custom_palette, labels = c("Alpha:Alpha", "Beta:Beta", "Beta:Alpha")) +
    theme_minimal()

# Display the stacked bar chart
stacked_bar_chart

# Define a custom color palette
custom_palette <- c("Non Diabetic" = "#1f77b4", "Type Two Diabetic" = "#ff7f0e")  # Replace with your color codes

# Plot the box plot with jittered points using the custom palette
enhanced_box_plot <- ggplot(merged_counts, aes(x = diabetic_status, y = alpha_beta_ratio, fill = "diabetic_status")) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA, fill = custom_palette) +  # Use custom palette for fill
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5, color = "black") +  # Add jittered points
    labs(
        title = "Alpha:Beta Ratio by Diabetics Status",
        x = "Diabetic Status",
        y = "Alpha:Beta Ratio"
    ) +
    scale_fill_manual(values = custom_palette) +  # Set custom fill colors
    theme_minimal() +
    theme(legend.position = "none")  # Remove legend for fill color

# Display the enhanced plot
enhanced_box_plot

# Define a custom color palette
custom_palette <- c("Male" = "#1f77b4", "Female" = "#ff7f0e")  # Replace with your color codes

# Plot the box plot with jittered points using the custom palette
enhanced_box_plot <- ggplot(merged_counts, aes(x = Sex, y = alpha_beta_ratio, fill = Sex)) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA, fill = custom_palette) +  # Use custom palette for fill
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5, color = "black") +  # Add jittered points
    labs(
        title = "Alpha:Beta Ratio by Sex",
        x = "Sex",
        y = "Alpha:Beta Ratio"
    ) +
    scale_fill_manual(values = custom_palette) +  # Set custom fill colors
    theme_minimal() +
    theme(legend.position = "none")  # Remove legend for fill color

# Display the enhanced plot
enhanced_box_plot

# Extract the proportions for each cell type in each group
non_diabetic_alpha_alpha <- 0.164
non_diabetic_beta_beta <- 0.597
non_diabetic_beta_alpha <- 0.239

type_two_diabetic_alpha_alpha <- 0.212
type_two_diabetic_beta_beta <- 0.525
type_two_diabetic_beta_alpha <- 0.263

# Sample sizes (assuming equal sample sizes for simplicity)
n1 <- 218
n2 <- 232  # You should replace these with your actual sample sizes
# Perform the t-test for proportions
t_test_alpha_alpha <- prop.test(x = c(non_diabetic_alpha_alpha * n1, type_two_diabetic_alpha_alpha * n2),
                                n = c(n1, n2),
                                correct = FALSE)

t_test_beta_beta <- prop.test(x = c(non_diabetic_beta_beta * n1, type_two_diabetic_beta_beta * n2),
                              n = c(n1, n2),
                              correct = FALSE)

t_test_beta_alpha <- prop.test(x = c(non_diabetic_beta_alpha * n1, type_two_diabetic_beta_alpha * n2),
                               n = c(n1, n2),
                               correct = FALSE)

# Print the results
print(t_test_alpha_alpha)
print(t_test_beta_beta)
print(t_test_beta_alpha)

	2-sample test for equality of proportions without continuity correction

data:  c(non_diabetic_alpha_alpha * n1, type_two_diabetic_alpha_alpha * n2) out of c(n1, n2)
X-squared = 1.6911, df = 1, p-value = 0.1935
alternative hypothesis: two.sided
95 percent confidence interval:
 -0.11998664  0.02398664
sample estimates:
prop 1 prop 2 
 0.164  0.212 

	2-sample test for equality of proportions without continuity correction

data:  c(non_diabetic_beta_beta * n1, type_two_diabetic_beta_beta * n2) out of c(n1, n2)
X-squared = 2.3645, df = 1, p-value = 0.1241
alternative hypothesis: two.sided
95 percent confidence interval:
 -0.01948059  0.16348059
sample estimates:
prop 1 prop 2 
 0.597  0.525 

	2-sample test for equality of proportions without continuity correction

data:  c(non_diabetic_beta_alpha * n1, type_two_diabetic_beta_alpha * n2) out of c(n1, n2)
X-squared = 0.34401, df = 1, p-value = 0.5575
alternative hypothesis: two.sided
95 percent confidence interval:
 -0.10409003  0.05609003
sample estimates:
prop 1 prop 2 
 0.239  0.263 

# Proportional Data Analysis
average_proportions <- data.frame(
    diabetic_status = c("Non Diabetic", "Non Diabetic", "Non Diabetic", "Type Two Diabetic", "Type Two Diabetic", "Type Two Diabetic"),
    Cell_Type = c("alpha_alpha", "beta_beta", "beta_alpha", "alpha_alpha", "beta_beta", "beta_alpha"),
    Proportion = c(0.164, 0.597, 0.239, 0.212, 0.525, 0.263)
)

# DEFINE COLOURS
custom_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c") 

# Plot
ggplot(average_proportions, aes(fill = Cell_Type, y = Proportion, x = diabetic_status)) +
    geom_bar(stat = "identity", width = 0.5) +  # Adjust the width as needed
    labs(
        title = "Proportions of Cell Types by Diabetic Status",
        x = "Diabetic Status",
        y = "Proportion",
        fill = "Cell Type"
    ) +
    scale_fill_manual(values = custom_colors) +
    theme_minimal()

# CLUSTER ANALYSIS

# Perform k-means clustering with k = , based on elbow plot results
k <- 3
kmeans_model <- kmeans(merged_counts$islet_area, centers = k, nstart = 25)

# Assign cluster labels to each data point
cluster_labels <- kmeans_model$cluster

# Add the cluster labels to your original dataframe (merged_counts)
merged_counts$cluster <- as.factor(cluster_labels)

# Load required library
library(ggplot2)

# Plot clusters on x-axis and alpha-beta ratio on y-axis
ggplot(merged_counts, aes(x = cluster, y = alpha_beta_ratio, fill = cluster)) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5, color = "black") +
    labs(
        title = "Clusters vs. Alpha:Beta Ratio",
        x = "Cluster",
        y = "Alpha:Beta Ratio"
    ) +
    scale_fill_manual(values = c("#1f77b4", "#ff7f0e", "#2ca02c")) +  # Adjust colors if needed
    theme_minimal()

# Access cluster means
cluster_means <- kmeans_model$centers

# Display cluster means
print(cluster_means)
       [,1]
1 390.28428
2  50.00757
3 162.01290

# CHECK CLUSTERS ARE SIGNIFICANTLY DIFFERENT - ANOVA
anova_result <- aov(islet_area ~ cluster, data = merged_counts)

# Summarize the ANOVA results
summary(anova_result)

             Df  Sum Sq Mean Sq F value Pr(>F)    
cluster       2 3577279 1788640   970.4 <2e-16 ***
Residuals   447  823882    1843                   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Subset data for islets in cluster 1
cluster_1_islets <- merged_counts[cluster_labels == 1, ]

# View the islets in cluster 1
print(cluster_1_islets)

# Subset data for islets in cluster 2
cluster_2_islets <- merged_counts[cluster_labels == 2, ]

# View the islets in cluster 2
print(cluster_2_islets)

# Subset data for islets in cluster 3
cluster_3_islets <- merged_counts[cluster_labels == 3, ]

# View the islets in cluster 3
print(cluster_3_islets)

# Filter islets in cluster 2 with alpha_beta_ratio above 3
cluster_2_above_3 <- merged_counts[merged_counts$cluster == 2 & merged_counts$alpha_beta_ratio > 3, ]

# Count occurrences of diabetic_status in filtered subset
status_counts2 <- table(cluster_2_above_3$diabetic_status)

# Find the diabetic_status with the highest count
majority_status2 <- names(which.max(status_counts2))

# Print the majority diabetic_status
print(majority_status2)

[1] "Type Two Diabetic"

# Filter islets in cluster 1 with alpha_beta_ratio above 1
cluster_1_below_1 <- merged_counts[merged_counts$cluster == 1 & merged_counts$alpha_beta_ratio < 1, ]

# Count occurrences of diabetic_status in filtered subset
status_counts3 <- table(cluster_1_below_1$diabetic_status)

# Find the diabetic_status with the highest count
majority_status3 <- names(which.max(status_counts3))

# Print the majority diabetic_status
print(majority_status3)

[1] "Non Diabetic"

# Filter islets in cluster 1 with alpha_beta_ratio above 1
cluster_3_below_1 <- merged_counts[merged_counts$cluster == 3 & merged_counts$alpha_beta_ratio < 1, ]

# Count occurrences of diabetic_status in filtered subset
status_counts4 <- table(cluster_3_below_1$diabetic_status)

# Find the diabetic_status with the highest count
majority_status4 <- names(which.max(status_counts4))

# Print the majority diabetic_status
print(majority_status4)

# Filter islets in cluster 1 with alpha_beta_ratio above 1
cluster_1_below_1 <- merged_counts[merged_counts$cluster == 1 & merged_counts$alpha_beta_ratio < 0.2, ]

# Count occurrences of diabetic_status in filtered subset
status_counts5 <- table(cluster_1_below_1$diabetic_status)

# Find the diabetic_status with the highest count
majority_status5 <- names(which.max(status_counts5))

# Print the majority diabetic_status
print(majority_status5)

[1] "Non Diabetic"

# Relabel clusters
cluster_labels_relabelled <- recode(cluster_labels, `1` = 3, `2` = 1, `3` = 2)

# Update cluster labels in the kmeans_model object
kmeans_model$cluster <- factor(cluster_labels_relabelled)

# Update cluster labels in the original dataframe
merged_counts$cluster <- kmeans_model$cluster

# Load required library
library(ggplot2)

# Define labels for clusters
cluster_labels <- c("Small", "Medium", "Large")

# Plot clusters on x-axis and alpha-beta ratio on y-axis
ggplot(merged_counts, aes(x = factor(cluster, labels = cluster_labels), y = alpha_beta_ratio, fill = factor(cluster, labels = cluster_labels))) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5, color = "black") +
    labs(
        title = "Islet Area Clusters vs. Alpha:Beta Ratio",
        x = "Islet Area Clusters",
        y = "Alpha:Beta Ratio"
    ) +
    scale_fill_manual(name = "Islet Area Clusters", values = c("Small" = "#1f77b4", "Medium" = "#ff7f0e", "Large" = "#2ca02c")) +  # Adjust colors and legend title
    theme_minimal()


# Define labels for clusters --> CLUSTER ISLET AREA PLOTS
cluster_labels <- c("Small", "Medium", "Large")

# Calculate positions for annotations (set to a fixed y-coordinate)
annotation_positions <- filtered_data %>%
    group_by(cluster) %>%
    summarize(mean_ratio = mean(alpha_beta_ratio)) %>%
    mutate(annotation_y = 8.5)  # Set to a fixed y-coordinate of 8.5

# Plot clusters on x-axis and alpha-beta ratio on y-axis
ggplot(filtered_data, aes(x = factor(cluster, labels = cluster_labels), y = alpha_beta_ratio, fill = factor(cluster, labels = cluster_labels))) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
    geom_jitter(aes(color = diabetic_status, shape = diabetic_status), position = position_jitter(width = 0.2), alpha = 0.5) +
    labs(
        title = "Islet Area Clusters vs. Alpha:Beta Ratio",
        x = "Islet Area Clusters",
        y = "Alpha:Beta Ratio",
        fill = "Islet Area Clusters",
        color = "Diabetic Status",
        shape = "Diabetic Status"
    ) +
    scale_fill_manual(values = c("Small" = "#1f77b4", "Medium" = "#ff7f0e", "Large" = "#2ca02c")) +  # Adjust colors for clusters
    scale_color_manual(values = c("Without Diabetes" = "blue", "With T2D" = "red")) +  # Set specific colors for diabetic status
    scale_shape_manual(values = c("Without Diabetes" = 16, "With T2D" = 17)) +  # Adjust shape for diabetic status
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5),
        legend.position = "right"
    ) +
    # Adding asterisks at fixed y-coordinate of 8.5
    geom_text(data = annotation_positions, 
              aes(x = factor(cluster, labels = cluster_labels), y = annotation_y, label = "**"),
              size = 5,
              color = "black",
              vjust = -0.5) 

# PLOT AGE GROUP

# Load necessary libraries
library(ggplot2)
library(dplyr)

# Define breaks for age groups (adjust as needed)
age_breaks <- c(60, 65, 70, 75)

# Create a new column with group numbers (1 to 3)
merged_counts <- merged_counts %>%
    mutate(age_group = cut(age, breaks = age_breaks, labels = FALSE))

# Create a new column with group numbers (0 to 3)
merged_counts <- merged_counts %>%
    mutate(age_group = cut(age, breaks = age_breaks, labels = FALSE))

# Count number of unique donor_ids in each age group
unique_donors_by_age <- merged_counts %>%
    group_by(age_group) %>%
    summarize(unique_donors = n_distinct(donor_id))

# Print the result
print(unique_donors_by_age)
# A tibble: 3 × 2
  age_group unique_donors
      <int>         <int>
1         1             9
2         2             9
3         3             8

# Add desired colours
custom_colors <- c("#1f77b4", "#ff7f0e")

# Plot age groups vs. alpha_beta_ratio with diabetic_status
ggplot(merged_counts, aes(x = factor(age_group), y = alpha_beta_ratio, color = diabetic_status)) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA, position = position_dodge(width = 0.75)) +
    geom_jitter(position = position_dodge(width = 0.75), aes(shape = diabetic_status), alpha = 0.5) +
    labs(
        title = "Age Group vs. Alpha:Beta Ratio by Diabetic Status",
        x = "Age Group",
        y = "Alpha:Beta Ratio",
        color = "Diabetic Status",
        shape = "Diabetic Status"
    ) +
    scale_color_manual(values = custom_colors) +  # Use custom colors
    scale_shape_manual(values = c(16, 17)) +  # Adjust shapes for diabetic status
    scale_x_discrete(labels = age_labels) +  # Set custom labels for age groups
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5),
        legend.position = "right"
    )

# Load necessary libraries
library(ggplot2)
library(dplyr)

# Assuming 'merged_counts' has 'age_group' as a factor with levels 1, 2, 3

# Define custom colors for age groups
age_group_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c")

# Define custom labels for age groups
age_labels <- c("60-64", "65-69", "70-74")

# Plot alpha_beta_ratio vs. age_group with custom colors and labels
ggplot(merged_counts, aes(x = factor(age_group), y = alpha_beta_ratio, fill = factor(age_group))) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5) +
    labs(
        title = "Alpha:Beta Ratio vs. Age Group",
        x = "Age Group",
        y = "Alpha:Beta Ratio",
        fill = "Age Group"  # Set legend title for fill aesthetic
    ) +
    scale_fill_manual(values = age_group_colors, labels = age_labels) +  # Assign custom colors and labels to age groups
    scale_x_discrete(labels = age_labels) +  # Set custom labels for age groups on x-axis
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5),
        legend.position = "right"
    )

# Load necessary libraries --> SEX PLOTS
library(ggplot2)
library(dplyr)

# Define custom colors if needed
custom_colors <- c("#1f77b4", "#ff7f0e")

# Recode Sex (F=1, M=2) column to "Female" and "Male"
merged_counts <- merged_counts %>%
    mutate(Sex = case_when(
        `Sex (F=1, M=2)` == 1 ~ "Female",
        `Sex (F=1, M=2)` == 2 ~ "Male",
        TRUE ~ as.character(`Sex (F=1, M=2)`)  # Handle other cases if any
    ))

# Plot alpha_beta_ratio vs. Sex
ggplot(merged_counts, aes(x = Sex, y = alpha_beta_ratio, color = Sex)) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5) +
    labs(
        title = "Alpha:Beta Ratio by Sex",
        x = "Sex",
        y = "Alpha:Beta Ratio",
        color = "Sex"
    ) +
    scale_color_manual(values = custom_colors) +  # Use custom colors if desired
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5),
        legend.position = "none"  # Remove legend for simplicity
    )

# Load necessary libraries --> DIABETES PLOTS
library(ggplot2)
library(dplyr)

# Define custom colors if needed
custom_colors <- c("#1f77b4", "#ff7f0e")

# Plot alpha_beta_ratio vs. diabetes
ggplot(merged_counts, aes(x = diabetic_status, y = alpha_beta_ratio, color = diabetic_status)) +
    geom_boxplot(width = 0.5, alpha = 0.7, outlier.shape = NA) +
    geom_jitter(position = position_jitter(width = 0.2), alpha = 0.5) +
    labs(
        title = "Alpha:Beta Ratio by Diabetes Status",
        x = "diabetic_status",
        y = "Alpha:Beta Ratio",
        color = "diabetic_status"
    ) +
    scale_color_manual(values = custom_colors) +  # Use custom colors if desired
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5),
        legend.position = "none"  # Remove legend for simplicity
    )

# Load necessary libraries
library(ggplot2)
library(dplyr)

# Example data (replace with your actual data)
summary_data <- data.frame(
    diabetic_status = factor(c("Without Diabetes", "Without Diabetes", "Without Diabetes", 
                               "With T2D", "With T2D", "With T2D")),
    category = c("alpha_alpha_proportion", "beta_beta_proportion", "beta_alpha_proportion",
                 "alpha_alpha_proportion", "beta_beta_proportion", "beta_alpha_proportion"),
    proportion = c(0.200, 0.534, 0.266, 0.259, 0.456, 0.285),
    significance = c("***", "***", "", "***", "***", ""),
    stack_position = c(0.875, 0.25, NA, 0.875, 0.25, NA)
)

# Define custom colors
custom_colors <- c("alpha_alpha_proportion" = "#1f77b4", 
                   "beta_beta_proportion" = "#ff7f0e", 
                   "beta_alpha_proportion" = "#2ca02c")

# Filter data for annotation only on specified positions
annotation_data <- summary_data %>%
    filter(!is.na(stack_position))

# Reorder factor levels for diabetic_status
summary_data$diabetic_status <- factor(summary_data$diabetic_status, 
                                       levels = c("Without Diabetes", "With T2D"))

# Plotting
ggplot(summary_data, aes(x = diabetic_status, y = proportion, fill = category)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_fill_manual(values = custom_colors, 
                      labels = c("Alpha-Alpha", "Beta-Alpha", "Beta-Beta"),
                      name = "Cell Connection Proportions") +  # Rename legend title here
    labs(
        title = "Proportions of Cell Connections by Diabetes Status",
        x = "Diabetes Status",
        y = "Proportion"
    ) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5)) +
    geom_text(data = annotation_data, 
              aes(x = diabetic_status, y = stack_position, label = "***"),
              size = 5,
              color = "black",
              vjust = 0.5) +  # Adjust vertical justification to center the text
    ylim(0, 1)  # Ensure y-axis limits are consistent

# Load necessary packages
library(ggplot2)
library(dplyr)

# Assuming merged_countsCLUSTER is already loaded and you want to use alpha_beta_ratio and bmi columns

# Sort the data by BMI (optional)
filtered_data <- filtered_data %>%
    arrange(age)

# Create the scatter plot with unique color for each donor
p <- ggplot(filtered_data, aes(x = age, y = alpha_beta_ratio, color = factor(donor_id))) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE, color = "blue") +  # Add linear regression line in blue
    labs(x = "Age", y = "Alpha:Beta Ratio", title = "Alpha:Beta Ratio by Age for Each Donor") +
    scale_color_discrete(name = "Donor ID") +  # Customize legend title
    theme_minimal() +
    theme(legend.position = "none")  # Remove legend for donor_id

# Display the plot
print(p)

# Load necessary packages
library(ggplot2)
library(dplyr)

# Assuming merged_countsCLUSTER is already loaded and you want to use alpha_beta_ratio and bmi columns

# Sort the data by BMI (optional)
filtered_data <- filtered_data %>%
    arrange(bmi)

# Create the scatter plot with unique color for each donor
p <- ggplot(filtered_data, aes(x = bmi, y = alpha_beta_ratio, color = factor(donor_id))) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE, color = "blue") +  # Add linear regression line in blue
    labs(x = "BMI", y = "Alpha:Beta Ratio", title = "Alpha:Beta Ratio by BMI for Each Donor") +
    scale_color_discrete(name = "Donor ID") +  # Customize legend title
    theme_minimal() +
    theme(legend.position = "none")  # Remove legend for donor_id

# Display the plot
print(p)

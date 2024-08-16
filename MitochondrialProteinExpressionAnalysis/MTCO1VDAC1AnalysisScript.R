
library(readxl)
MyExpt_cellboundaries <- read_excel("Desktop/MyExpt_cellboundaries.xlsx")
View(MyExpt_cellboundaries)                                                 
library(readxl)
ImageInfo_CellProfilerFiles <- read_excel("Desktop/mageInfo_CellProfilerFiles.xlsx", 
+     sheet = "CellProfiler")
View(ImageInfo_CellProfilerFiles)                                           
cpdata <- ImageInfo_CellProfilerFiles
rawdata <- MyExpt_cellboundaries
# Merge datasets based on the common column ImageNumber
merged_dataset <- merge(cpdata, rawdata, by = "ImageNumber", all = TRUE)
 
# 'all = TRUE' ensures that all ImageNumbers from both datasets are included in the merged dataset
 
# Check the structure of the merged dataset
str(merged_dataset)
'data.frame':	402373 obs. of  16 variables:
 $ ImageNumber                      : num  1 1 1 1 1 1 1 1 1 1 ...
 $ islet_number                     : chr  "Islet10" "Islet10" "Islet10" "Islet10" ...
 $ donor_id                         : chr  "21112011" "21112011" "21112011" "21112011" ...
 $ ObjectNumber                     : num  1 2 3 4 5 6 7 8 9 10 ...
 $ Intensity_MaxIntensity_insulin   : chr  "0.030548561364412308" "0.045075152069330215" "0.037308309227228165" "3.7949186000000003E-2" ...
 $ Intensity_MaxIntensity_mtco1     : chr  "3.5294118999999999E-2" "0.048477914184331894" "0.035721369087696075" "4.6173800000000001E-2" ...
 $ Intensity_MaxIntensity_vdac1     : chr  "9.5368880000000003E-3" "0.011642633937299252" "1.1093309000000001E-2" "0.016311895102262497" ...
 $ Intensity_MeanIntensity_insulin  : chr  "0.012052218925991226" "0.013371328997350976" "0.012511508232482111" "1.1853275999999999E-2" ...
 $ Intensity_MeanIntensity_mtco1    : chr  "0.013329672531363253" "0.011994404447462222" "0.012902343526510743" "0.012422721791900581" ...
 $ Intensity_MeanIntensity_vdac1    : chr  "1.996523E-3" "1.9833950000000002E-3" "2.1044050000000002E-3" "2.5771050000000001E-3" ...
 $ Intensity_MedianIntensity_insulin: chr  "1.1779965E-2" "0.012771801091730595" "0.011963073164224625" "1.1078050000000001E-2" ...
 $ Intensity_MedianIntensity_mtco1  : chr  "1.2542915999999999E-2" "0.011062790639698505" "0.012298772111535072" "0.011657892726361752" ...
 $ Intensity_MedianIntensity_vdac1  : chr  "1.5716790000000001E-3" "1.4496069999999999E-3" "1.6632330000000001E-3" "2.1210040000000001E-3" ...
 $ Intensity_MinIntensity_insulin   : chr  "7.47692E-4" "5.7984300000000003E-4" "1.312276E-3" "5.3406600000000003E-4" ...
 $ Intensity_MinIntensity_mtco1     : chr  "1.464866E-3" "4.4251199999999999E-4" "1.2970169999999999E-3" "3.6621700000000001E-4" ...
 $ Intensity_MinIntensity_vdac1     : chr  "3.20439E-4" "2.5940300000000001E-4" "3.20439E-4" "3.0518E-4" ...

 
View(merged_dataset)

# Ensure that the column used for filtering is of numeric type
merged_dataset$Intensity_MeanIntensity_insulin <- as.numeric(as.character(merged_dataset$Intensity_MeanIntensity_insulin))

# Define threshold values for insulin positivity per donor
thresholds <- c(
     "21112011" = 0.08,   
     "23012011" = 0.065,
     "26102010" = 0.15,
     "28052013" = 0.05,
     "29062012" = 0.09,
     "HP10062013" = 0.035,
     "HP13062016" = 0.05,
     "HP19022013" = 0.05,
     "HP20122011" = 0.07,
     "HP27052013" = 0.025,
     "HP28052016" = 0.058,
     "PT0267_0020" = 0.03,
     "PT0267_022" = 0.06,
     "PT0267_0026" = 0.06,
     "PT0267_0030" = 0.04,
     "PT0267_032" = 0.05,
     "PT0267_0034" = 0.12,
     "PT0267_0042" = 0.06,
     "PT0267_0051" = 0.07,
     "PT0267_0054" = 0.08,
     "PT0267_0058" = 0.055,
     "PT0267_0081" = 0.05,
     "PT0267_0086" = 0.04,
     "PT0267_0090" = 0.09,
     "PT0267_0095" = 0.07
)
# Check if donor_id column matches the keys in the thresholds vector
unique_donor_ids <- unique(merged_dataset$donor_id)
missing_thresholds <- setdiff(unique_donor_ids, names(thresholds))
if (length(missing_thresholds) > 0) {
    stop("Thresholds missing for the following donor IDs: ", paste(missing_thresholds, collapse = ", "))
}

 # Filter out cells that are insulin-positive based on threshold values
 filtered_data <- merged_dataset[merged_dataset$Intensity_MeanIntensity_insulin >= thresholds[as.character(merged_dataset$donor_id)], ]
 
 # Reset row names
 rownames(filtered_data) <- NULL
 
 # Check the structure of the filtered data frame
str(filtered_data)
'data.frame':	38065 obs. of  16 variables:
 $ ImageNumber                      : num  1 1 1 1 2 2 2 2 2 2 ...
 $ islet_number                     : chr  "Islet10" "Islet10" "Islet10" "Islet10" ...
 $ donor_id                         : chr  "21112011" "21112011" "21112011" "21112011" ...
 $ ObjectNumber                     : num  43 47 52 56 13 17 18 32 42 53 ...
 $ Intensity_MaxIntensity_insulin   : chr  "0.32903027534484863" "0.28714427399999998" "0.37064164876937866" "0.42319372296333313" ...
 $ Intensity_MaxIntensity_mtco1     : chr  "9.9229418E-2" "7.7470056999999995E-2" "0.1283283680677414" "8.9524678999999996E-2" ...
 $ Intensity_MaxIntensity_vdac1     : chr  "0.031097887083888054" "0.027801938354969025" "0.035629816353321075" "0.030807964503765106" ...
 $ Intensity_MeanIntensity_insulin  : num  0.1168 0.0874 0.0974 0.0974 0.0707 ...
 $ Intensity_MeanIntensity_mtco1    : chr  "0.031544308828714694" "0.022712986899448485" "0.031643775297867584" "0.024392791100621546" ...
 $ Intensity_MeanIntensity_vdac1    : chr  "6.9970190000000002E-3" "6.0269770000000002E-3" "8.0232680000000001E-3" "5.9475630000000003E-3" ...
 $ Intensity_MedianIntensity_insulin: chr  "0.10598916560411453" "7.9026475999999998E-2" "8.3611808999999995E-2" "6.5148391E-2" ...
 $ Intensity_MedianIntensity_mtco1  : chr  "3.0106051000000002E-2" "2.0874342000000001E-2" "2.9953459000000002E-2" "2.2308689999999999E-2" ...
 $ Intensity_MedianIntensity_vdac1  : chr  "6.3935299999999997E-3" "5.4016940000000003E-3" "7.1869999999999998E-3" "5.1422910000000002E-3" ...
 $ Intensity_MinIntensity_insulin   : chr  "0.010711833834648132" "6.3324940000000001E-3" "7.4464029999999999E-3" "0.010803387500345707" ...
 $ Intensity_MinIntensity_mtco1     : chr  "2.2583350000000002E-3" "1.464866E-3" "1.754788E-3" "1.2054629999999999E-3" ...
 $ Intensity_MinIntensity_vdac1     : chr  "4.27253E-4" "4.27253E-4" "3.35698E-4" "3.0518E-4" ...

 # Optionally, you can write the filtered data frame to a file
 write.csv(filtered_data, "filtered_data.csv", row.names = FALSE)
 # Plot with diabetic status assigned to colors and age represented by color intensity
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_mtco1, 
                         color = factor(diabetic_status), fill = age)) +
     geom_point(shape = 21, color = "black", size = 3) +  
     labs(x = "Donor ID", y = "Mean Intensity of MTCO1", 
          color = "Diabetic Status", fill = "Age") +
     scale_color_manual(values = c("red", "blue"), labels = c("No", "Yes")) +
     scale_fill_gradient(low = "lightblue", high = "darkblue") +  # Adjust color gradient for age
     facet_wrap(~ factor(diabetic_status
                         
 
 # Plot with diabetic status assigned to colors and age represented by color intensity
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_mtco1, 
Error: unexpected symbol in:
"# Plot with diabetic status assigned to colors and age represented by color intensity
ggplot"
 # Plot with diabetic status assigned to colors and age represented by color intensity
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_mtco1, 
                         color = factor(diabetic_status), fill = age)) +
     geom_point(shape = 21, color = "black", size = 3) +  
     labs(x = "Donor ID", y = "Mean Intensity of MTCO1", 
          color = "Diabetic Status", fill = "Age") +
     scale_color_manual(values = c("red", "blue"), labels = c("No", "Yes")) +
     scale_fill_gradient(low = "lightblue", high = "darkblue") +  # Adjust color gradient for age
     facet_wrap(~ factor(diabetic_status
                         
 # Plot with diabetic status assigned to colors and age represented by color intensity
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_mtco1, 
Error: unexpected symbol in:
"# Plot with diabetic status assigned to colors and age represented by color intensity
ggplot"
 # Plot with diabetic status assigned to colors and age represented by color intensity
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_mtco1, 
                         color = factor(diabetic_status), fill = age)) +
     geom_point(shape = 21, color = "black", size = 3) +  
     labs(x = "Donor ID", y = "Mean Intensity of MTCO1", 
          color = "Diabetic Status", fill = "Age") +
     scale_color_manual(values = c("red", "blue"), labels = c("Non-Diabetic", "Diabetic")) +
     scale_fill_gradient(low = "lightblue", high = "darkblue") +  # Adjust color gradient for age
     facet_wrap(~ factor(diabetic_status, labels = c("Non-Diabetic", "Diabetic")), scales = "free_x", ncol = 2) +  
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +  
     theme(strip.background = element_blank(), strip.placement = "outside", 
           strip.text.x = element_text(size = 8, angle = 0)) +  
     guides(color = guide_legend(reverse = TRUE)) +
     scale_shape_manual(values = c(1, 16), labels = c("Non-Diabetic", "Diabetic")) +  
     scale_size_manual(name = "Diabetic Status", values = c(3, 4), labels = c("No", "Yes"))  # Adjust point size for clarity

 # Plot with diabetic status assigned to colors and age represented by color intensity
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_mtco1, 
                         color = factor(diabetic_status), fill = age)) +
     geom_point(shape = 21, color = "black", size = 3) +  
     labs(x = "Donor ID", y = "Mean Intensity of MTCO1", 
          color = "Diabetic Status", fill = "Age") +
     scale_color_manual(values = c("red", "blue"), labels = c("Non-Diabetic", "Diabetic")) +
     scale_fill_gradient(low = "lightblue", high = "darkblue") +  # Adjust color gradient for age
     facet_wrap(~ factor(diabetic_status, labels = c("Non-Diabetic", "Diabetic")), scales = "free_x", ncol = 2) +  
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +  
     theme(strip.background = element_blank(), strip.placement = "outside", 
           strip.text.x = element_text(size = 8, angle = 0)) +  
     guides(color = guide_legend(reverse = TRUE)) +
     scale_shape_manual(values = c(1, 16), labels = c("Non-Diabetic", "Diabetic")) +  
     scale_size_manual(name = "Diabetic Status", values = c(3, 4), labels = c("No", "Yes"))  # Adjust point size for clarity
 
 
 # Plot with diabetic status assigned to colors and age represented by color intensity
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_vdac1, 
                         color = factor(diabetic_status), fill = age)) +
     geom_point(shape = 21, color = "black", size = 3) +  
     labs(x = "Donor ID", y = "Mean Intensity of VDAC1", 
          color = "Diabetic Status", fill = "Age") +
     scale_color_manual(values = c("red", "blue"), labels = c("Non-Diabetic", "Diabetic")) +
     scale_fill_gradient(low = "lightblue", high = "darkblue") +  # Adjust color gradient for age
     facet_wrap(~ factor(diabetic_status, labels = c("Non-Diabetic", "Diabetic")), scales = "free_x", ncol = 2) +  
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +  
     theme(strip.background = element_blank(), strip.placement = "outside", 
           strip.text.x = element_text(size = 8, angle = 0)) +  
     guides(color = guide_legend(reverse = TRUE)) +
     scale_shape_manual(values = c(1, 16), labels = c("Non-Diabetic", "Diabetic")) +  
     scale_size_manual(name = "Diabetic Status", values = c(3, 4), labels = c("No", "Yes"))  # Adjust point size for clarity
 
 # Plot with diabetic status assigned to colors
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_vdac1, 
                         color = factor(diabetic_status))) +
     geom_point(shape = 21, color = "black", size = 3) +  
     labs(x = "Donor ID", y = "Mean Intensity of VDAC1", 
          color = "Diabetic Status") +
     scale_color_manual(values = c("red", "blue"), labels = c("Non-Diabetic", "Diabetic")) +
     facet_wrap(~ factor(diabetic_status, labels = c("Non-Diabetic", "Diabetic")), scales = "free_x", ncol = 2) +  
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +  
     theme(strip.background = element_blank(), strip.placement = "outside", 
           strip.text.x = element_text(size = 8, angle = 0)) +  
     guides(color = guide_legend(reverse = TRUE)) +
     scale_shape_manual(values = c(1, 16), labels = c("Non-Diabetic", "Diabetic")) +  
     scale_size_manual(name = "Diabetic Status", values = c(3, 4), labels = c("No", "Yes"))  # Adjust point size for clarity
 
 # Plot with diabetic status assigned to colors
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_vdac1, 
                         color = factor(diabetic_status))) +
     geom_point(shape = 21, aes(fill = factor(diabetic_status)), color = "black", size = 3) +  
     labs(x = "Donor ID", y = "Mean Intensity of VDAC1") +
     scale_color_manual(values = c("red", "blue"), labels = c("Non-Diabetic", "Diabetic"), name = "Diabetic Status") +
     scale_fill_manual(values = c("red", "blue"), labels = c("Non-Diabetic", "Diabetic"), name = "Diabetic Status") +
     guides(color = guide_legend(reverse = TRUE), fill = FALSE) +
     facet_wrap(~ factor(diabetic_status, labels = c("Non-Diabetic", "Diabetic")), scales = "free_x", ncol = 2) +  
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +  
     theme(strip.background = element_blank(), strip.placement = "outside", 
           strip.text.x = element_text(size = 8, angle = 0))
 
 # Plot with diabetic status assigned to colors
 ggplot(merged_data, aes(x = donor_id, y = Intensity_MeanIntensity_mtco1, 
                         color = factor(diabetic_status))) +
     geom_point(shape = 21, aes(fill = factor(diabetic_status)), color = "black", size = 3) +  
     labs(x = "Donor ID", y = "Mean Intensity of MTCO1") +
     scale_color_manual(values = c("red", "blue"), labels = c("Non-Diabetic", "Diabetic"), name = "Diabetic Status") +
     scale_fill_manual(values = c("red", "blue"), labels = c("Non-Diabetic", "Diabetic"), name = "Diabetic Status") +
     guides(color = guide_legend(reverse = TRUE), fill = FALSE) +
     facet_wrap(~ factor(diabetic_status, labels = c("Non-Diabetic", "Diabetic")), scales = "free_x", ncol = 2) +  
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +  
     theme(strip.background = element_blank(), strip.placement = "outside", 
           strip.text.x = element_text(size = 8, angle = 0))
 # Plot the total number of beta cells by diabetic status
 ggplot(merged_data, aes(x = factor(diabetic_status, labels = c("Non-Diabetic", "Type Two Diabetic")), y = cell_type, fill = factor(diabetic_status))) +
     geom_bar(stat = "identity") +
     labs(x = "Diabetic Status", y = "Total Number of Beta Cells", fill = "Diabetic Status") +
     theme_minimal() +
     scale_fill_manual(values = c("blue", "red")) +
     ggtitle("Total Number of Beta Cells in Diabetic and Non-Diabetic Donors") +
     guides(fill = FALSE)  # Remove the legend
 
 # Jitter plot for mean intensity of vdca1 and mtco1
 ggplot(merged_data, aes(x = factor(diabetic_status, labels = c("Non-Diabetic", "Type Two Diabetic")), 
                         y = Intensity_MeanIntensity_mtco1, 
                         color = factor(diabetic_status), 
                         group = diabetic_status)) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     geom_point(stat = "summary", aes(group = NULL), fun = mean, shape = 18, size = 3, color = "black") +
     labs(x = "Diabetic Status", y = "Mean Intensity", color = "Diabetic Status") +
     facet_wrap(~ "Intensity_MeanIntensity_mtco1", scales = "free_y", ncol = 1) +
     theme_minimal() +
     guides(color = FALSE)
                         
 # Jitter plot for mean intensity of vdca1 and mtco1
 ggplot(merged_data, aes(x = factor(diabetic_status, labels = c("Non-Diabetic", "Type Two Diabetic")), 
                         y = Intensity_MeanIntensity_vdac1, 
                         color = factor(diabetic_status), 
                         group = diabetic_status)) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     geom_point(stat = "summary", aes(group = NULL), fun = mean, shape = 18, size = 3, color = "black") +
     labs(x = "Diabetic Status", y = "Mean Intensity", color = "Diabetic Status") +
     facet_wrap(~ "Intensity_MeanIntensity_vdac1", scales = "free_y", ncol = 1) +
     theme_minimal() +
     guides(color = FALSE) +
 # Jitter plot for mean intensity of vdca1 and mtco1
 ggplot(merged_data, aes(x = factor(diabetic_status, labels = c("Non-Diabetic", "Type Two Diabetic")), 
                         y = Intensity_MeanIntensity_vdac1, 
                         color = factor(diabetic_status), 
                         group = diabetic_status)) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     geom_point(stat = "summary", aes(group = NULL), fun = mean, shape = 18, size = 3, color = "black") +
     labs(x = "Diabetic Status", y = "Mean Intensity", color = "Diabetic Status") +
     facet_wrap(~ "Intensity_MeanIntensity_vdac1", scales = "free_y", ncol = 1) +
     theme_minimal() +
     guides(color = FALSE) +
 # Jitter plot for mean intensity of vdca1 and mtco1
 ggplot(merged_data, aes(x = factor(diabetic_status, labels = c("Non-Diabetic", "Type Two Diabetic")), 
                         y = Intensity_MeanIntensity_vdac1, 
                         color = factor(diabetic_status), 
                         group = diabetic_status)) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     geom_point(stat = "summary", aes(group = NULL), fun = mean, shape = 18, size = 3, color = "black") +
     labs(x = "Diabetic Status", y = "Mean Intensity", color = "Diabetic Status") +
                         facet_wrap(~ "Intensity_MeanIntensity_vdac1", scales = "free_y", ncol = 1) +
     theme_minimal() +
 non_diabetic_plot <- ggplot(non_diabetic_data, aes(x = donor_id, y = Intensity, color = "Non-Diabetic")) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     labs(x = "Donor ID", y = "Intensity of MTCO1", title = "Non-Diabetic") +
     scale_color_manual(values = "blue", guide = FALSE) +  # Specify color for non-diabetic
     theme_minimal() +
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))  # Rotate x-axis labels vertically
 
 # Create a jitter plot for donors with T2D
 type_two_diabetic_plot <- ggplot(type_two_diabetic_data, aes(x = donor_id, y = Intensity, color = "Type Two Diabetic")) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     labs(x = "Donor ID", y = "Intensity of MTCO1", title = "Type Two Diabetic") +
     scale_color_manual(values = "red", guide = FALSE) +  # Specify color for type two diabetic
     theme_minimal() +
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))  # Rotate x-axis labels vertically
 
 # Reshape the data to have one row per observation (beta cell)
 reshaped_data <- tidyr::pivot_longer(merged_data, 
                                      cols = starts_with("Intensity"), 
                                      names_to = "Measurement", 
                                      values_to = "Intensity")
 
 # Split islet_id from the Measurement column
 reshaped_data$islet_id <- gsub("^.*_", "", reshaped_data$Measurement)
 
 # Create a jitter plot with each donor having a different color
 jitter_plot <- ggplot(reshaped_data, aes(x = donor_id, y = Intensity, color = donor_id)) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     labs(x = "Donor ID", y = "Intensity of VDAC1", color = "Donor ID") +
     scale_color_discrete(guide = FALSE) +
     theme_minimal() +
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))  # Rotate x-axis labels vertically
 
 # Display the jitter plot
 jitter_plot
 
 library(ggplot2)
 
 # Reshape the data to have one row per observation (beta cell)
 reshaped_data <- tidyr::pivot_longer(merged_data_ndufb8, 
                                      cols = starts_with("Intensity"), 
                                      names_to = "Measurement", 
                                      values_to = "Intensity")
 
 # Split islet_id from the Measurement column
 reshaped_data$islet_id <- gsub("^.*_", "", reshaped_data$Measurement)
 
 # Create a jitter plot with each donor having a different color
 jitter_plot <- ggplot(reshaped_data, aes(x = donor_id, y = Intensity, color = donor_id)) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     labs(x = "Donor ID", y = "Intensity of NDUFB8", color = "Donor ID") +
     scale_color_discrete(guide = FALSE) +
     theme_minimal() +
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))  # Rotate x-axis labels vertically
 
 # Display the jitter plot
 jitter_plot
                        
View(merged_data)
head(merged_data)
  donor_id ImageNumber islet_number Intensity_MeanIntensity_insulin
1 21112011           1      Islet10                      0.11679555
2 21112011           1      Islet10                      0.08742025
3 21112011           1      Islet10                      0.09737468
4 21112011           1      Islet10                      0.09742168
5 21112011         420       Islet9                      0.10356436
6 21112011         420       Islet9                      0.19300215
  Intensity_MeanIntensity_vdac1 Intensity_MeanIntensity_mtco1 cell_type
1                   0.006997019                    0.03154431 Beta Cell
2                   0.006026977                    0.02271299 Beta Cell
3                   0.008023268                    0.03164378 Beta Cell
4                   0.005947563                    0.02439279 Beta Cell
5                   0.008655194                    0.04139068 Beta Cell
6                   0.008576992                    0.03097731 Beta Cell
  age  bmi Sex (F=1, M=2) diabetic_status
1  68 27.8              2               2
2  68 27.8              2               2
3  68 27.8              2               2
4  68 27.8              2               2
5  68 27.8              2               2
6  68 27.8              2               2
# Calculate normalized intensity
merged_data$normalized_intensity_mtco1 <- merged_data$Intensity_MeanIntensity_mtco1 / merged_data$Intensity_MeanIntensity_vdac1
 
head(merged_data)
  donor_id ImageNumber islet_number Intensity_MeanIntensity_insulin
1 21112011           1      Islet10                      0.11679555
2 21112011           1      Islet10                      0.08742025
3 21112011           1      Islet10                      0.09737468
4 21112011           1      Islet10                      0.09742168
5 21112011         420       Islet9                      0.10356436
6 21112011         420       Islet9                      0.19300215
  Intensity_MeanIntensity_vdac1 Intensity_MeanIntensity_mtco1 cell_type
1                   0.006997019                    0.03154431 Beta Cell
2                   0.006026977                    0.02271299 Beta Cell
3                   0.008023268                    0.03164378 Beta Cell
4                   0.005947563                    0.02439279 Beta Cell
5                   0.008655194                    0.04139068 Beta Cell
6                   0.008576992                    0.03097731 Beta Cell
  age  bmi Sex (F=1, M=2) diabetic_status normalized_intensity_mtco1
1  68 27.8              2               2                   4.508250
2  68 27.8              2               2                   3.768554
3  68 27.8              2               2                   3.944001
4  68 27.8              2               2                   4.101309
5  68 27.8              2               2                   4.782179
6  68 27.8              2               2                   3.611676
 library(ggplot2)
 
 # Plot normalized intensity of mtco1 by diabetic status
 ggplot(merged_data, aes(x = as.factor(diabetic_status), y = normalized_intensity_mtco1, color = as.factor(diabetic_status))) +
     geom_boxplot() +
     labs(x = "Diabetic Status", y = "Normalized Intensity of mtco1", color = "Diabetic Status") +
     theme_minimal()
 
 library(ggplot2)
 
 # Jitter plot for diabetic status against normalized mtco1
 ggplot(merged_data, aes(x = factor(diabetic_status), y = normalized_intensity_mtco1, color = factor(diabetic_status))) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     labs(x = "Diabetic Status", y = "Normalized
 
 
library(ggplot2)

 # Create a jitter plot for diabetic status against normalized mtco1
 ggplot(merged_data, aes(x = factor(diabetic_status), y = normalized_intensity_mtco1)) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     labs(x = "Diabetic Status", y = "Normalized Intensity of mtco1") +
     theme_minimal()

 # Create a jitter plot for diabetic status against normalized mtco1 with different colors
 ggplot(merged_data, aes(x = factor(diabetic_status, labels = c("Non-Diabetic", "Type Two Diabetic")), 
                        y = normalized_intensity_mtco1, color = factor(diabetic_status))) +
     geom_jitter(position = position_jitter(width = 0.3), alpha = 0.5) +
     labs(x = "Diabetic Status", y = "Normalized MTCO1/VDAC1 ratio") +
     theme_minimal() +
     theme(legend.position = "none")

# 1. Prepare the Data
clustering_data <- merged_data[, c("normalized_intensity_mtco1", "Intensity_MeanIntensity_vdac1", "diabetic_status", "age", "bmi", "Sex (F=1, M=2)")]

# 2. Perform K-Means Clustering
 set.seed(123) # for reproducibility
 k <- 2 # Number of clusters (you can adjust this)
 kmeans_result <- kmeans(clustering_data[, -c("diabetic_status")], centers = k) # Exclude 'diabetic_status' for clustering
Error in -c("diabetic_status") : invalid argument to unary operator
> # 1. Prepare the Data
> clustering_data <- merged_data[, c("normalized_intensity_mtco1", "Intensity_MeanIntensity_vdac1", "diabetic_status", "age", "bmi", "Sex (F=1, M=2)")]
> 
> # 2. Normalize the Data (optional)
> # You may skip this step if your data is already normalized.
> 
> # 3. Perform K-Means Clustering
> set.seed(123) # for reproducibility
> k <- 2 # Number of clusters (you can adjust this)
> kmeans_result <- kmeans(clustering_data[, -which(names(clustering_data) == "diabetic_status")], centers = k) # Exclude 'diabetic_status' for clustering
> 
> # View the cluster centers
> kmeans_result$centers
  normalized_intensity_mtco1 Intensity_MeanIntensity_vdac1      age
1                   8.245611                    0.01001174 63.63543
2                   3.054398                    0.01638788 67.94260
       bmi Sex (F=1, M=2)
1 29.02171       1.722936
2 21.88900       1.740280
 
 # Select relevant columns for clustering
 clustering_data <- merged_data[, c("normalized_intensity_mtco1", "diabetic_status", "age", "Sex (F=1, M=2)", "bmi")]
 
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
 
 # Reshape the data for plotting
 library(tidyr)
 cluster_counts_df <- pivot_longer(cluster_counts_df, cols = -cluster, names_to = "diabetic_status", values_to = "count")
 
 # Plotting the bar plot
 ggplot(cluster_counts_df, aes(x = cluster, y = count, fill = diabetic_status)) +
     geom_bar(stat = "identity", position = "dodge") +
     labs(x = "Cluster", y = "Count", fill = "Diabetic Status") +
     theme_minimal()

# Load necessary libraries, to create sex proportion plots
library(dplyr)
library(ggplot2)

# Create the data frame with percentages
data_percent <- data.frame(
    Cluster = factor(rep(c("high", "medium", "low"), each = 2), levels = c("low", "medium", "high")),  # Ensure Cluster levels are ordered
    Sex = factor(rep(c(1, 2), 3), labels = c("Female", "Male")),
    Percentage = c(36.6, 12.4, 42.3, 37.2, 21.1, 50.4)
)

# Define Tableau colors
tableau_colors <- c("#4E79A7", "#F28E2B", "#E15759")

# Add a column for positioning the asterisks
data_percent <- data_percent %>%
    group_by(Sex) %>%
    mutate(ypos = cumsum(Percentage) - 0.5 * Percentage)

# Create the stacked bar plot with asterisks
ggplot(data_percent, aes(x = Sex, y = Percentage, fill = Cluster)) +
    geom_bar(stat = "identity") +
    geom_text(aes(y = ypos, label = "***"), vjust = 0.5, color = "black", size = 5) +
    labs(x = "Sex", y = "Percentage (%)", title = "Beta-Cell Proportions by Cluster and Sex") +
    scale_fill_manual(values = tableau_colors, labels = c("Low", "Medium", "High")) +
    theme_minimal() +
    theme(legend.title = element_blank())
 

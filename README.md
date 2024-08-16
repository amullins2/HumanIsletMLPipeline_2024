# AutomatedSingleCellSegmentationPipeline_2024

# README: Image Analysis Pipeline for Islet Composition and Mitochondrial Protein Expression

## Overview
This image analysis pipeline was developed as part of a study exploring islet composition and mitochondrial function in human pancreatic tissues, specifically comparing older donors (aged >62 years) with and without Type 2 Diabetes (T2D). The pipeline uses a semi-automated approach to segment and analyze immunofluorescent-stained human pancreatic islets at the single-cell level.

## Pipeline Summary

### 1. **Image Acquisition**
   - Human pancreatic islets are imaged using fluorescence microscopy.
   - Images are captured in `.czi` format and then converted to `.tiff` format for processing.

### 2. **Image Preparation**
   - **File Conversion**: Images are split into their respective fluorophore channels.
   - **Ilastik Training**: The images are fed into Ilastik for iterative pixel classification to segment individual islets.

### 3. **Cell Segmentation**
   - **Nuclei Segmentation**: Stardist, a tool within ImageJ/Fiji, is used to segment the nuclei.
   - **Cell Identification**: A custom CellProfiler pipeline is employed to segment the cells based on the previously segmented nuclei.

### 4. **Single-Cell Measurements**
   - The segmented cells are then quantified for various markers, including mitochondrial proteins and islet hormones, to assess islet composition and mitochondrial function.

### 5. **Data Analysis**
   - The data obtained from the segmentation and quantification steps are analyzed statistically using RStudio or other statistical software.

## Key Findings
- **Islet Composition**: Analysis revealed a higher α:β cell ratio in donors with T2D and a reduction in total β-cell count.
- **Mitochondrial Function**: T2D β-cells exhibited altered oxidative phosphorylation (OXPHOS) signatures, including changes in Complex I and IV expression ratios.

## Software and Tools Used
- **Microscopy**: Fluorescence microscopy for image acquisition.
- **Image Conversion**: `.czi` to `.tiff` conversion tools.
- **Pixel Classification**: Ilastik.
- **Nuclei Segmentation**: Stardist in ImageJ/Fiji.
- **Cell Segmentation and Quantification**: CellProfiler.
- **Data Analysis**: RStudio.

## Installation and Setup
1. **Ilastik**: Download and install Ilastik from [here](https://www.ilastik.org/).
2. **ImageJ/Fiji**: Download and install Fiji, which comes bundled with Stardist, from [here](https://imagej.net/software/fiji/).
3. **CellProfiler**: Download and install CellProfiler from [here](https://cellprofiler.org/).
4. **RStudio**: Download and install RStudio for statistical analysis from [here](https://www.rstudio.com/).

## How to Run the Pipeline
1. **Prepare Images**: Convert your images from `.czi` to `.tiff` and split the channels.
2. **Train Pixel Classifier**: Use Ilastik to classify pixels and segment islets.
3. **Segment Nuclei**: Run Stardist in ImageJ/Fiji to segment nuclei.
4. **Run CellProfiler Pipeline**: Use the provided CellProfiler pipeline to segment and quantify cells.
5. **Analyze Data**: Load the output into RStudio for statistical analysis.

## Contact Information
For any questions or further assistance, please contact:
- Alana Mullins (Primary Contact)
- Catherine Arden
- Laura Greaves
- Mark Walker

Biosciences Institute, Newcastle University, Newcastle Upon Tyne, UK

## Acknowledgements
This project was developed as part of a study funded by [Institution/Funding Body]. The images and data generated from this pipeline were instrumental in understanding islet composition and mitochondrial function in the context of aging and Type 2 Diabetes.

---

This README should provide a clear and concise guide for using the image analysis pipeline. Adjustments can be made based on specific needs or additional details.

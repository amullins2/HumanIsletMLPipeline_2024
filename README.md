# IsletAIlytics - Single-Cell Segmentation Image Analysis Pipeline for Islet Composition and Mitochondrial Protein Expression

## Overview
This image analysis pipeline was developed as part of a study exploring islet composition and mitochondrial function in human pancreatic tissues, specifically comparing older donors (aged > 62 years) with and without Type 2 Diabetes (T2D). The pipeline uses a semi-automated approach to segment and analyse immunofluorescent-stained human pancreatic islets at the single-cell level.

## Pipeline Summary

### 1. **Image Acquisition**
   - Formaldehyde-fixed human pancreatic tissue was stained and imaged using the confocal Zeiss LSM800 AiryScan Microscope.
   - Images are captured in `.czi` format and then converted to `.tiff` format for processing.

### 2. **Image Preparation**
   - **File Conversion**: Images are split into their respective fluorophore channels.
   - **Ilastik Training**: The images are delivered into Ilastik for iterative pixel classification to segment individual islets.

### 3. **Cell Segmentation**
   - **Nuclei Segmentation**: Stardist, a tool within ImageJ/Fiji, is used to segment the nuclei (only applicable to the islet composition staining panel).
   - **Cell Identification**: A custom CellProfiler pipeline is utilised to segment the cells based on the previously segmented nuclei (only applicable to the islet composition staining panel).

### 4. **Single-Cell Measurements**
   - The segmented cells are then quantified for various markers, including mitochondrial proteins and islet endocrine hormones, to assess islet composition and mitochondrial function.

### 5. **Data Analysis**
   - The data obtained from the segmentation and quantification steps are analyseed statistically using RStudio and SPSS.

## Key Findings
- **Islet Composition**: Analysis revealed a higher α:β cell ratio in donors with T2D and a reduction in total β-cell count.
- **Mitochondrial Function**: T2D β-cells exhibited altered oxidative phosphorylation (OXPHOS) signatures, including single-cell resolution changes in Complex I and IV expression ratios.

## Software and Tools Used
- **Microscope**: Zeiss LSM800 AiryScan.
- **Image Conversion**: ImageJ/Fiji Macro.
- **Pixel Classification**: Ilastik (ImageJ/Fiji Macro).
- **Nuclei Segmentation**: Stardist in ImageJ/Fiji (ImageJ/Fiji Macro).
- **Cell Segmentation and Quantification**: CellProfiler.
- **Data Analysis**: RStudio and SPSS.

## Installation and Setup
1. **ImageJ/Fiji**: Download and install Fiji, which comes bundled with Stardist, from [here](https://imagej.net/software/fiji/).
2. **Ilastik**: Download and install Ilastik from [here](https://www.ilastik.org/). 
3. **CellProfiler**: Download and install CellProfiler from [here](https://cellprofiler.org/).
4. **RStudio**: Download and install RStudio for statistical analysis from [here](https://www.rstudio.com/).

## How to Run the Pipeline
1. **Prepare Images**: Convert your images from `.czi` to `.tiff` and split the channels, utilsiing the ImageJ/Fiji macro.
2. **Train Pixel Classifier**: Use Ilastik to classify pixels and segment islets.
3. **Segment Nuclei**: Run Stardist in ImageJ/Fiji to segment nuclei.
4. **Run CellProfiler Pipeline**: Use the provided CellProfiler pipeline to segment and quantify cells.
5. **Analyse Data**: Load the output into RStudio for statistical analysis.

## Contact Information
For any questions or further assistance, please contact:
- Alana Mullins (Primary Contact) - a.mullins2@newcastle.ac.uk
- Dr Catherine Arden
- Dr Laura Greaves
- Dr Mark Walker

Biosciences Institute, Newcastle University, Newcastle Upon Tyne, UK

## Acknowledgements
This project was developed as part of a study funded by Newcastle University. We extend our deepest gratitude to the Bioimaging and Image Analysis Units at Newcastle University, particularly to George Merces. His continued training and guidance were instrumental to the project's success. The images and data generated from this pipeline were crucial for understanding islet composition and mitochondrial OXPHOS protein expression in the context of ageing and T2D.



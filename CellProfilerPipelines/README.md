
# Automated Single-Cell Segmentation Image Analysis Pipelines

This repository provides pipelines for automated single-cell segmentation image analysis using CellProfiler. The repository includes both a CellProfiler interface setup and a Python extension for flexibility in different workflows. Below is a detailed outline of the CellProfiler modules used in each pipeline.

## Pipelines Overview

# Islet Composition Staining Panel

In the analysis of the **islet composition staining panel**, after nuclei segmentation in Stardist, islets are further divided into their respective channels: nuclei (DAPI), cell membrane (E-cadherin), glucagon (alpha cells), and insulin (beta cells) using an automated **ImageJ/FIJI macro**. The processing flow is as follows:

1. **RescaleIntensity Module**: This module normalises the intensity of the E-cadherin segmentation marker to enhance contrast for accurate segmentation. 
   - **Parameters**:
     - **Scaling Method**: Linear scaling
     - **Range**: 0 to 255 (standard intensity range for image processing)
   
2. **Smooth Module**: This module is used to remove any artefacts that might be introduced during the E-cadherin segmentation process.
   - **Parameters**:
     - **Smoothing Method**: Gaussian smoothing
     - **Sigma**: 2 pixels for noise removal

3. **IdentifyPrimaryObjects Module**: Applied to recognise segmented nuclei from the Stardist output.
   - **Parameters**:
     - **Thresholding Method**: Otsu's thresholding
     - **Minimum Size**: 10 pixels (to ensure nuclei are not fragmented)
     - **Maximum Size**: 1500 pixels (to exclude large artefacts)

4. **IdentifySecondaryObjects Module**: This module is applied using the nuclei and cell membrane segmentation images to identify individual cells.
   - **Parameters**:
     - **Thresholding Method**: Otsu thresholding
     - **Range for Cell Membrane Segmentation**: Three-class Otsu thresholding within the range of 0.02 - 0.4
     - **Morphological Operations**: Apply dilation followed by erosion to delineate cell boundaries.

5. **MeasureObjectIntensity Module**: This module is used to measure glucagon and insulin intensities within individual cells.
   - **Parameters**:
     - **Intensity Measurements**: Glucagon and insulin staining intensities within cells.
   
6. **MeasureObjectSizeShape Module**: Used to measure the size and shape of objects (cells) to provide additional data about cell morphology.
   - **Parameters**:
     - **Object Size Measurement**: Mean area of segmented objects (cells)

7. **CellProfiler Neighborhood Analysis within Islet Composition Staining Panel**

   To compute inter-islet differences, neighborhood analysis was performed on the **islet composition staining panel** within **CellProfiler**. This analysis provides insights into cellular interactions within islets, focusing on the connections between alpha and beta cells.

   - The **ClassifyObjects** module is applied to assign alpha and beta cell donor-based threshold values, which are used to define the two distinct cell types (alpha and beta cells) within the islets.
   - The **MeasureObjectNeighbours** module quantifies the number of inter-islet cell connections for each donor, providing proportions for alpha-alpha, beta-beta, and beta-alpha inter-islet cell interactions.

8. **ExportToSpreadsheet Module**: This module is used to export the analysis results to a .csv file for further downstream analysis.
   - **Parameters**:
     - **Output Directory**: `/path/to/output/folder`

# Mitochondrial Staining Panel

The mitochondrial staining panels have a slightly modified workflow due to the presence of only one segmentation marker. Here, the **cell membrane** (E-cadherin) marker images are used for segmentation, and the **IdentifyPrimaryObjects** module is applied directly to these images.

1. **RescaleIntensity Module**: This module normalises the intensity values of mitochondrial images to enhance contrast and improve measurement accuracy for mitochondrial staining.
   - **Parameters**:
     - **Scaling Method**: Linear scaling
     - **Range**: 0 to 255 (standard range)
   
2. **IdentifyPrimaryObjects Module**: Applied to identify individual cells using the cell membrane (E-cadherin) marker images.
   - **Parameters**:
     - **Thresholding Method**: Otsu's thresholding
     - **Minimum Size**: 10 pixels
     - **Maximum Size**: 1500 pixels

3. **MeasureObjectIntensity Module**: This module quantifies mitochondrial protein expression within cells. The analysis includes measurements for **Complex I**, **Complex IV**, and **mitochondrial mass** (VDAC1).
   - **Parameters**:
     - **Intensity Measurements**: VDAC1 (mitochondrial mass), NDUFB8 (Complex I), and MTCO1 (Complex IV)
   
4. **ExportToSpreadsheet Module**: This module is used to export mitochondrial protein expression data to a .csv file.
   - **Parameters**:
     - **Output Directory**: `/path/to/output/folder`

## Installation

To set up the environment for using these pipelines, follow the instructions below.

### CellProfiler Interface

1. **Download and Install CellProfiler:**
   - Download CellProfiler from [CellProfiler’s website](https://cellprofiler.org/).
   - Follow the installation instructions provided for your operating system.

2. **Load the Pipeline:**
   - Open CellProfiler and load the pipeline configuration files (`.cpproj`) provided in the `CellProfilerPipelines` directory.

3. **Configure the Pipeline:**
   - Adjust the module settings as needed based on your data and analysis requirements.

### Python Extension

For users preferring to use Python, the repository includes a Python extension for running CellProfiler pipelines programmatically.


## Contact

For any questions or issues, please reach out to Alana Mullins at a.mullins2@newcastle.ac.uk.


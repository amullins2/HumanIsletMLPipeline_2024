
# Automated Single-Cell Segmentation Image Analysis Pipelines

This repository provides pipelines for automated single-cell segmentation image analysis using CellProfiler. The repository includes both a CellProfiler interface setup and a Python extension for flexibility in different workflows. Below is a detailed outline of the CellProfiler modules used in each pipeline.

## Pipelines Overview

### 1. Islet Composite Analysis Pipeline

**Purpose:** Analyse islet composition by integrating multiple cellular markers to provide detailed insights into islet composition and cellular interactions.

**Modules Used:**

- **RescaleIntensity**
  - **Purpose:** Normalise the intensity values of mitochondrial images to enhance contrast and improve measurement accuracy.
  - **Parameters:**
    - `Scaling Method`: Define the method for scaling intensity (e.g., linear, logarithmic).
    - `Range`: Specify the target range for intensity values.
    
- **IdentifyPrimaryObjects**
  - **Purpose:** Identifies individual cells based on the nuclear marker (e.g., DAPI).
  - **Parameters:** 
    - `Thresholding Method`: Select the appropriate thresholding method for nuclear identification.
    - `Minimum/Maximum Size`: Define the expected size range of nuclei.

- **IdentifySecondaryObjects**
  - **Purpose:** Identifies cell membranes using the cell membrane marker (e.g., E-cadherin).
  - **Parameters:** 
    - `Thresholding Method`: Method for detecting cell membranes.
    - `Morphological Operations`: Adjust for accurate membrane delineation.

- **MeasureObjectIntensity**
  - **Purpose:** Measures the intensity of various markers within identified objects.
  - **Parameters:** 
    - `Intensity Measurements`: Specify which markers to measure (e.g., insulin and glucagon).

- **RelateObjects**
  - **Purpose:** Relates nuclei to their corresponding cell membranes to analyze cellular compositions.
  - **Parameters:** 
    - `Relational Criteria`: Define how to link nuclei with membranes.

- **ExportToSpreadsheet**
  - **Purpose:** Export analysis results to a spreadsheet for further analysis.
  - **Parameters:** 
    - `Output Directory`: Specify where to save the results.

### 2. Mitochondria Protein Expression Quantification Pipeline

**Purpose:** Quantify mitochondrial protein expression within cells using a specific marker for segmentation.

**Modules Used:**

- **RescaleIntensity**
  - **Purpose:** Normalise the intensity values of mitochondrial images to enhance contrast and improve measurement accuracy.
  - **Parameters:**
    - `Scaling Method`: Define the scaling method for intensity values.
    - `Range`: Specify the target range for normalized intensity.
    
- **ImageMath**
  - **Purpose:** Perform mathematical operations to preprocess images for better protein quantification.
  - **Parameters:**
    - `Operation`: Choose the mathematical operation suitable for image preprocessing.
    - `Value`: Define the value used in the operation.
    
- **IdentifyPrimaryObjects**
  - **Purpose:** Identifies individual cells using the cell membrane marker (e.g., E-cadherin) for segmentation.
  - **Parameters:** 
    - `Thresholding Method`: Choose the method for detecting cell membranes.
    - `Minimum/Maximum Size`: Define size parameters for cells.

- **MeasureObjectIntensity**
  - **Purpose:** Measures mitochondrial protein expression levels within identified cells.
  - **Parameters:** 
    - `Intensity Measurements`: Specify the mitochondrial marker to quantify (e.g., VDAC1 (Mitochondrial Mass), NDUFB8 (Complex I), and MTCO1 (Complex IV).

- **ExportToSpreadsheet**
  - **Purpose:** Export the quantified protein expression data to a spreadsheet.
  - **Parameters:** 
    - `Output Directory`: Specify where to save the results.

## Installation

To set up the environment for using these pipelines, follow the instructions below.

### CellProfiler Interface

1. **Download and Install CellProfiler:**
   - Download CellProfiler from [CellProfiler’s website](https://cellprofiler.org/).
   - Follow the installation instructions provided for your operating system.

2. **Load the Pipeline:**
   - Open CellProfiler and load the pipeline configuration files (`.cpproj`) provided in the `pipelines` directory.

3. **Configure the Pipeline:**
   - Adjust the module settings as needed based on your data and analysis requirements.

### Python Extension

For users preferring to use Python, the repository includes a Python extension for running CellProfiler pipelines programmatically.


## Contact

For any questions or issues, please reach out to Alana Mullins at a.mullins2@newcastle.ac.uk.


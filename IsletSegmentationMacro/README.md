# ImageJ Macro for Islet Segmentation and Cropping

**Author:** Alana Mullins, Newcastle University  
**Date:** January 2024  

This ImageJ macro is designed for the segmentation, cropping, and scaling of islet images. It uses Bio-Formats for importing, Ilastik for pixel classification, and performs several image processing tasks. Below is a detailed description of how the macro works.

## Overview

1. **Setup and Initialization:**
   - Define the home and raw image folders.
   - Set measurement parameters.
   - Initialize output folders for segmented images, cropped islets, and scaled images.

2. **Processing Raw Images:**
   - Import images using Bio-Formats.
   - Scale and save images.
   - Skip if the output already exists.

3. **Ilastik Probability Mapping:**
   - Define Ilastik project parameters.
   - Process scaled images through Ilastik for probability mapping.
   - Save probability maps.

4. **Rescaling and Saving Results:**
   - Rescale images back to original size.
   - Save segmented images.
   - Crop and save individual islets.

## Detailed Steps

### 1. Setup and Initialization

- **Choose Folders:**
  - Home folder containing all other folders.
  - Raw images folder.

- **Set Measurement Parameters:**
  - Configure measurements for area, mean, standard deviation, and other statistics.

- **Create Output Folders:**
  - Segmented images
  - Cropped islets
  - Scaled images

### 2. Processing Raw Images

- **List Raw Images:**
  - Iterate through raw images in the specified folder.

- **Image Processing:**
  - Use Bio-Formats Importer to open and scale images.
  - Save scaled images to the designated folder.
  - Skip processing if the output file already exists.

### 3. Ilastik Probability Mapping

- **Define Ilastik Parameters:**
  - Set paths for the Ilastik project and specify output types.

- **Probability Mapping:**
  - Iterate through scaled images.
  - Run Ilastik pixel classification to generate probability maps.
  - Save probability maps in the specified folder.

### 4. Rescaling and Saving Results

- **Rescale to Original Size:**
  - Reopen scaled images and rescale to the original size.

- **Save Segmented Images:**
  - Save segmented images in the specified output folder.

- **Crop Islets:**
  - Identify and crop individual islets from the segmented images.
  - Save cropped islets to the appropriate folder.

## Additional Notes

- **Dependencies:**
  - Ensure Bio-Formats and Ilastik plugins are installed in ImageJ.

- **File Formats:**
  - The macro assumes TIFF format for input and output. Modify if using different formats.

- **Scaling Factors:**
  - The macro scales images by 0.5 for processing and then rescales by 2 to revert to original size. Adjust these factors as needed based on your image scaling.

Feel free to modify the macro to suit your specific needs or adjust parameters based on your dataset.

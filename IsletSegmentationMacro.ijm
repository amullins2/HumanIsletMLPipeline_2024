// ImageJ Macro for Islet Segmentation and Cropping
// Developed by Alana Mullins, Newcastle University
// Date: January 2024

// Define Home and Raw Image Folders
homeFolder = getDirectory("Choose The Home Folder Containing All Other Folders");
rawFolder = getDirectory("Choose The Home Folder Containing Your Raw Images");

//Set Measurement Parameters for Measure Function
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack display redirect=None decimal=3");
//Defines the parameter to allow for arrays to be utilised later
setOption("ExpandableArrays", true);

//Allows the Macro to Use BioFormats Importer
run("Input/Output...", "jpeg=85 gif=-1 file=.csv use use_file copy_row save_column save_row");
run("Bio-Formats Macro Extensions");

// Create Output Folders
outputFolder = homeFolder + "Segmented_Islets/";
if (File.isDirectory(outputFolder) < 1) {
    File.makeDirectory(outputFolder);
}

cropFolder = homeFolder + "Cropped_Islets/";
if (File.isDirectory(cropFolder) < 1) {
    File.makeDirectory(cropFolder);
}

scaledFolder = homeFolder + "Scaled_Images/";
if (File.isDirectory(scaledFolder) < 1) {
    File.makeDirectory(scaledFolder);
}

// List Raw Images
list = getFileList(rawFolder);
l = list.length;
for (i = 0; i < l; i++) {
    print("i Number: " + i + " = File name: " + list[i]);
}

// Clear Results and ROI Manager
run("Clear Results");
roiManager("reset");


// Process Each Raw Image
for (i = 0; i < l; i++) {
    // Define Image and Output Names
    fileName = rawFolder + list[i];
    
    baseName = substring(list[i], 0, (lengthOf(list[i]) - 4));
    outputName = outputFolder + baseName + "_Segmented.tif";
    cropName = cropFolder + baseName + "_Islet_";
    scaledName = scaledFolder + baseName + "_Scaled.tif";

    // Check if the output already exists, skip if it does
    if (File.exists(outputName) == 0) {
        // Use BioFormats Importer to open CZI file
        run("Bio-Formats Importer", "open=[" + fileName + "] autoscale color_mode=Default split_channels view=Hyperstack stack_order=XYCZT");

        // Get the title of the opened image
        imgName = getTitle();

        // Save scaled image
        run("Scale...", "x=0.5 y=0.5");
        saveAs("Tiff", scaledName);
        close();
    }
}

// set global variables for Ilastik Project
pixelClassificationProject = homeFolder + "IsletSegmentationsProjectReScale_220124.ilp";
outputType = "Probabilities"; //  or "Segmentation"
inputDataset = "data";
outputDataset = "exported_data";
axisOrder = "tzyxc";
compressionLevel = 0;

//Defines the output location for Ilastik probability maps
foldertoProcess = scaledFolder;
folderforOutput = homeFolder + "Ilastik_Probability_Output/";
if (File.isDirectory(folderforOutput) < 1) {
File.makeDirectory(folderforOutput); 
}

//Creates list of files for analysis
list = getFileList(scaledFolder);
list = Array.sort(list);
l = list.length;
//Performs Ilastik probability mapping based on trained model developed as part of this project
for (i=0; i<l; i++) {
	//Defines the image to be processed
	fileName = foldertoProcess + list[i];
	//Used to confirm if image has already been processed
	testName = folderforOutput + list[i];
	//If a probability map does not already exist for this image...
	if( File.exists(testName) == 0){
		print("Creating New Probability Map");
		//Opens the image to be processed
		open(fileName);
		inputImage = getTitle();
		//Performed Ilastik probability mapping on the image
		pixelClassificationArgs = "projectfilename=[" + pixelClassificationProject + "] saveonly=false inputimage=[" + inputImage + "] pixelclassificationtype=" + outputType;
		run("Run Pixel Classification Prediction", pixelClassificationArgs);
		//Converts to 8-bit format
		run("8-bit");
		//Saves the probability map to the appropriate folder
		saveAs("Tiff", folderforOutput + list[i]);
		close("*");
	}
	//If a probability map already exists...
	else{
		print("Probability Map Already Existed");
	}

    // Rescale Image Back to Original Size
    open(scaledName);
    run("Scale...", "x=2 y=2 interpolation=None create"); // Assumes original scale was 0.5, adjust accordingly
    originalSizeName = baseName + "_OriginalSize.tif";
    saveAs("Tiff", originalSizeName);
    close();

    // Save Segmented Islets
    saveAs("Tiff", outputName);
    close();

    // Process Segmented Image
    open(outputName);
    imgTitle = getTitle();

    // Identify ROIs based on measurements
    run("Analyze Particles...", "size=50-200 add");

    // Save ROIs of interest
    n = roiManager("count");
    for (j = 0; j < n; j++) {
        roiManager("select", j);
        run("Crop");
        saveAs("Tiff", cropFolder + baseName + "_Islet_" + j + ".tif");
        close();
    }
}


// Clear Results and ROI Manager
run("Clear Results");
roiManager("reset");

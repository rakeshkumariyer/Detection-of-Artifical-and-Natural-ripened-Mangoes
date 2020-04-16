# Detection-of-Artifical-and-Natural-ripened-Mangoes
This project used MPEG-7 colour dominant features to detect artifical and naturally ripened fruits.

# Mango Classification
## Steps
1) Upload Image
2) Pre-process image to extract only the image of Fruit 
3) Extract the dominant color using MPEG-& color dominant feature
4) Analyze the extracted colors for artifical and natural ripened fruit to remove uncorrelated color (i.e R,G,B)
5) Cluster the color data points, analyze to create threshold for classification.
6) Run a query image to test the threshold.

## Pre-Processing functions
1) createMask.m - Creates a mask to extract ROI. Have used the L*a*b to extract the Mask.
2) filterRegions.m - Filters unwanted mask, i.e Remove any area less than the area of the fruit.
3) segmentImage.m - Image Segmentation, bounding box. 
Crop the ROI

## MPEG-7 feature
1) Construct a color frequency
2) Extract the 4 dominant frequency
3) Map these frequencies to the color
4) Extract Dominant Color

To extract the above features for multiple images in a folder, use ColorExtract.m file.
Extract the features from both natural and artifical images.(say training dataset)

After Extraction of dominant color, Cluster the dominant color using clustering.m file. Pass the matrix file of the Artifical and Natural Images( i.e Anew and Nnew saved matrix files)

Analyze the clusters to determine the threshold for classification.

Run Query.m for testing dataset. 
## Results
For my dataset, the threshold was set for the Red Color at 200.

For this threshold, an accuracy of ~ 90% was achieved.

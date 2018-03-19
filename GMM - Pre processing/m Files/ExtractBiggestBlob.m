function biggestBlob = ExtractBiggestBlob(binaryImage,numberToExtract)

binaryImage =  imread('472.png');
binaryImage = imfill(binaryImage, 'holes');
numberToExtract = 3;

%Display the image.
subplot(1, 2, 1);
imshow(binaryImage, []);


% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
[labeledImage, numberOfBlobs] = bwlabel(binaryImage);
blobMeasurements = regionprops(labeledImage, 'area', 'Centroid');
% Get all the areas
allAreas = [blobMeasurements.Area]; % No semicolon so it will print to the command window.
menuOptions{1} = '0'; % Add option to extract no blobs.
% Display areas on image

for k = 1 : numberOfBlobs           % Loop through all blobs.
	thisCentroid = [blobMeasurements(k).Centroid(1), blobMeasurements(k).Centroid(2)];
    
	message = sprintf('Area = %d', allAreas(k));
	text(thisCentroid(1), thisCentroid(2), message, 'Color', 'r');
	menuOptions{k+1} = sprintf('%d', k);
    
end


%---------------------------------------------------------------------------
% Extract the largest area using our custom function ExtractNLargestBlobs().
% This is the meat of the demo!
biggestBlob = ExtractNLargestBlobs(binaryImage, numberToExtract);
%---------------------------------------------------------------------------

subplot(1, 2, 2);
imshow(biggestBlob, []);


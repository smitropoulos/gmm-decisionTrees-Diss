function outputImage = resizing (inputImage,desired_size)

%{
------------------------------Resizing Image-------------------------------

This function resizes an image to the specified size.

Inputs:
            inputImage : The image to be resized
            desired_size: A 1x2 matrix with the dimensions of the desired
            image

Outputs:
            outputImage : The resized image

For debugging purposes there are commented out sections.

%}

% inputImage=imread('lenaOriginal.jpg');
%# Initializations:

oldSize = size(inputImage);                   %# Get the size of your image

%Break out of the function if the desired size is the same as the
%inputImage size.
if oldSize(1,2) == desired_size(1,2)
    outputImage=inputImage;
    return;
end

% desired_size = [256 256];       % Height , Width

% Calculate the ratio
height_ratio = desired_size(1)/ oldSize(1);
width_ratio = desired_size(2) / oldSize(2);

scale = [height_ratio,width_ratio];           %# The resolution scale factors: [rows columns]
newSize = max(floor(scale.*oldSize(1:2)),1);  %# Compute the new image size

%# Compute an upsampled set of indices:

rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));

%# Index old image to get new image:

outputImage = inputImage(rowIndex,colIndex,:);

% imshow(inputImage);
% figure
% imshow(outputImage);
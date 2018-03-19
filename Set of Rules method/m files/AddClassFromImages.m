function [ClassificationMatrix,Class]=AddClassFromImages (ImagesFolderPath,NumberOfClass,extension)

filetype = sprintf('*.%s',extension);
filePattern = fullfile(ImagesFolderPath, filetype);
ImageFiles   = dir(filePattern);


baseFileName = ImageFiles(1).name;
fullFileName = fullfile(ImagesFolderPath, baseFileName);
  

warning('off','all')    %Disable the warnings

for k = 1:length(ImageFiles)
    
    baseFileName = ImageFiles(k).name;
    fullFileName = fullfile(ImagesFolderPath, baseFileName);
    fprintf('Now reading %s\n', fullFileName);
    im = imread(fullFileName);  %insert the image into the variable im
    im=ImagePreProcessing(im,500);
    [m,n] = size(im);
    row=reshape(im,[1,m*n]); %reshape the image in a 1 by dimensionX times dimensionY of the image
    ClassificationMatrix(k,:)=row; %in the predefined B array, insert the reshaped image above in the k line (each time it runs it increments)
    Class(k) = NumberOfClass; % 0 = 'human' Categorization of classification matrix
    
end

warning('on','all');
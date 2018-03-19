function ExtractEachBlob(BinaryImage,MinBlobSize,counter,FolderName)


% ------------------------------Blob Extraction----------------------------
% 
% function ExtractEachBlob(BinaryImage,MinBlobArea,counter,FolderName)
% 
% Extracts and writes cropped blobs in an image. The blobs are first labeled
% and then using a threshold some are chosen to be extracted.
%
% Inputs: 
%         BinaryImage: A binary image as an input 
%         MinBlobArea: The threshold the blob must meet to be chosen 
%             counter: A counter for naming purposes
%          FolderName: The name of the folder to write the images in 
% 
% Outputs: N/A
% 
% The true output of the function is the written frames in the FolderName
% folder.
% -------------------------------------------------------------------------


% Identify individual blobs by seeing which pixels are connected to each
% other. Each group of connected pixels will be given a label, a number, to
% identify it and distinguish it from the other blobs. Do connected
% components labeling with either bwlabel() or bwconncomp().

labeledImage = bwlabel(BinaryImage, 8);     % Label each blob so we can make measurements of it


% Get all the blob properties. 
blobMeasurements = regionprops(labeledImage, BinaryImage, 'all');
numberOfBlobs = size(blobMeasurements, 1);

for k = 1 : numberOfBlobs           % Loop through all blobs.
    
    if blobMeasurements(k).Area > MinBlobSize
        
        thisBlobsBoundingBox = blobMeasurements(k).BoundingBox;  % Get list of pixels in current blob.
        SubImage = imcrop(BinaryImage, thisBlobsBoundingBox);
        
        %         figure imshow(subImage);
        BlobName = sprintf('frame %d blob %d' ,counter,k); %Basic naming
        frame_writer(SubImage,BlobName,FolderName,'png');
        
    end
    
    
    
end


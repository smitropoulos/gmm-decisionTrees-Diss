function frame_writer(Image,ImgNaming,OutputDir,Extension)


% -------------------------------Frame Writer-----------------------------
% 
% function frame_writer(Image,ImgNaming,OutputDir,Extension)
% 
%Writes an image of a specified extension to a specified folder as directed
%by the user with a predefined naming for the image based on a string given
%by the user.
% 
% Inputs:
%                 Image: The image to be written
%             ImgNaming: The image naming
%             OutputDir: The folder the images are written in
%             Extension: The extension of the image
% 
% Ouputs:             N/A
% -------------------------------------------------------------------------


%Cast the OutputDir into a character vector

if ~isa(OutputDir,'char')
OutputDir=char(OutputDir);
end

%If there is no such directory, create one
if ~exist(OutputDir, 'dir')
    mkdir(OutputDir);
end


outputBaseFileName = sprintf('%s.%s', ImgNaming,Extension);
outputFullFileName = fullfile(OutputDir, outputBaseFileName);
imwrite(Image, outputFullFileName, Extension);
fprintf('Writing frames to disk');

end
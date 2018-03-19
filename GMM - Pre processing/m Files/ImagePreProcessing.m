function ProcessedImage = ImagePreProcessing (Image,DesiredDimension)

%------------------------Silhouette Pre-Processing-------------------------
% 
% function ProcessedImage = ImagePreProcessing (Image,DesiredDimension)
% 
%This custom method processes the silhouettes extracted from the MoG method
%in order to be fed to the rule based system. 
%Inputs:
%       Image: A binary Image as input
%       DesiredDimension: The desired dimension the image will have after
%       the processing. This simension will apply to both Y and X
%--------------------------------------------------------------------------

% Debugging
%  DesiredDimension = 500;
%  Image=im2bw((imread('guy_silh.png')));

Image = closesilhouette(Image);
Image = cropping(Image);
theta = - auto_angle(Image);
theta = theta*pi/180;
T = [cos(theta), sin(theta), 0; -sin(theta), cos(theta), 0; 0, 0, 1];
Image = imhtrans(Image, T);
Image(isnan(Image))=0; % Replace NaN with 0

[row,col,~] = size(Image);
if row>DesiredDimension || col>DesiredDimension
    
    Image = imresize(Image,[DesiredDimension,DesiredDimension]);
end

Image = centering (Image,DesiredDimension);
ProcessedImage = Image;


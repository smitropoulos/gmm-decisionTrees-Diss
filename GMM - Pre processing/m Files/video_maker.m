function video_maker(Input_Directory,Images_Extension,VideoName,FPS,VideoQuality,DimensionX,DimensionY)

%-------------------------------Video Maker--------------------------------
%A simple video maker which produces an .avi video while composed of images
%in the Input_Directory of the Images_Extension type. The video name, FPS,
%video quality and the option to resize the final video are present.
%
%
%Inputs:
%       Input_Directory: The directory with the images
%      Images_Extension: The type of images to read
%             VIdeoName: The name of the output video
%                   FPS: The framerate of the output video
%          VideoQuality: Ranging from 0-100, the quality of the output
%            DimensionX: The desired X size
%            DimensionY: The desired Y size
%--------------------------------------------------------------------------


Input_Directory= ' D:\OneDrive\MATLAB\BEng\Database Extraction\First Video\ExtractedClosedBW';
Images_Extension = 'jpg';
VideoName = 'Resized Video';
FPS = 30;
VideoQuality = 80;
DimensionX = 256;
DimensionY = 256;

cd(Input_Directory);
%Obtain all the *EXTENSION* format files in the current folder
Files = dir(sprintf('*.%s',Images_Extension));

%Number of *EXTENSION* Files in the current folder
NumberOfFiles= size(Files,1);


%To write Video File
VideoObj = VideoWriter(sprintf('%s.avi',VideoName));
%Number of Frames per Second
VideoObj.FrameRate = FPS;
%Define the Video Quality [ 0 to 100 ]
VideoObj.Quality   = VideoQuality;

%Open the File 'Create_video01.avi'
open(VideoObj);

for i = 1 : NumberOfFiles
    
    %Read the Image from the current Folder
    I = imread(Files(i).name);
    I = imresize(I,[DimensionX DimensionY]);
    I=uint8(I);
    [X, map] = gray2ind(I,2);
    %Convert Image to movie Frame
    frame = im2frame(X,map);
    
    %Each Frame is written five times.
    for j = 1 : 1
        %Write a frame
        writeVideo(VideoObj, frame);
    end
    
end


%Close the File 'Create_Video01.avi
close(VideoObj);


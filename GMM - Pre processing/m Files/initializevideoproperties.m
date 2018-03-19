function [frame,frame_bw,foregroung,background_bw,numberOfFrames] = initializevideoproperties (inputfile)

% Initiliaze video components from a video file. Inputs are a video file,
% outputs are width of the videos' frames, their height, the number of the
% frames in total and two arrays of zeros for the foreground and background
% images.

video_file = VideoReader(inputfile);
frame = read(video_file,1);
frame_bw = rgb2gray(frame);     % convert background to greyscale
[height,width] = size(frame);             
foregroung = zeros(height, width);
background_bw = zeros(height, width);
numberOfFrames = video_file.NumberOfFrames;



end
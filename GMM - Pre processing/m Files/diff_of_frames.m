function [u_diff,frame_bw,frame] = diff_of_frames(source,n,mean,C)

 
% ----------------------------Difference of frames-------------------------
%
%function [u_diff,frame_bw,frame] = diff_of_frames(source,n,mean,C)
%
% Ouputs the difference of a frame and the mean values for the MoG method
% inputs : 
%          source : an input image, or a Videoreader object
%               n: a simple counter
%           mean : the mean of the pixel values of the image
%              C : the number of gaussian components
% 
% -------------------------------------------------------------------------
 


    %Read the source image and a counter, n
    frame=read(source,n);
    frame_bw = rgb2gray(frame);
    
     for m=1:C
        u_diff(:,:,m) = abs(double(frame_bw) - double(mean(:,:,m)));
     end
    
end
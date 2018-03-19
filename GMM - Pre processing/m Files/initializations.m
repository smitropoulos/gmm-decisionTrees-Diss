function [fr_bw,width,height,w,mean,sd,u_diff,rank]=initializations(source,C,alpha,sd_init)


%--------------------------Video Initialization_---------------------------
% 
% function [fr_bw,width,height,w,mean,sd,u_diff,rank]=initializations(source,C,alpha,sd_init)
% 
%Initialization of arrays for better memory management.
%--------------------------------------------------------------------------


fr = read(source, 1);
fr_bw = rgb2gray(fr);     % convert background to greyscale
fr_size = size(fr);             
width = fr_size(2);
height = fr_size(1);
fg = zeros(height, width);
bg_bw = zeros(height, width);

%%Array initialization

%{
--------------------------- Array initiliazitation ------------------------
This function initiliazes the arrays of the pixel means, the weights and
the standard deviation of the pixels. Inputs are the width and height of
the video frames, the learning rate (alpha), the number of gaussian
components (C) and the outputs are the three arrays pixel_mean, weights
and pixel_sd
%}

w = zeros(height,width,C);              % initialize weights array
mean = zeros(height,width,C);           % pixel means
sd = zeros(height,width,C);             % pixel standard deviations
u_diff = zeros(height,width,C);         % difference of each pixel from mean
p = alpha/(1/C);                        % initial p variable (used to update mean and sd)
rank = zeros(1,C);                      % rank of components (w/sd)

%% Means and weights
%{
-----------------Initialize the means and weights arrays-------------------
%}
pixel_depth = 8;                        % 8-bit resolution
pixel_range = 2^pixel_depth -1;         % pixel range (# of possible values)

for i=1:height
    for j=1:width
        for k=1:C
            
            mean(i,j,k) = rand*pixel_range;     % means random (0-255)
            w(i,j,k) = 1/C;                     % weights uniformly dist
            sd(i,j,k) = sd_init;                % initialize to sd_init
            
        end
    end
end


end

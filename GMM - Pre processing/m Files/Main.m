
clear all;

file=('C:\Users\stefm\Downloads\Benchmarks\jump\eli_jump.avi');
source = VideoReader(file);
numberOfFrames = source.numberOfFrames;

dir = 'C:\Users\stefm\Desktop\23';

window1=2;  %Filtering Windows
window2=2;  
blobSize=300;   %The Blobs minimum size to be written by the method

%---------------------------------MOG Variables----------------------------
C = 3;                                  % number of gaussian components (typically 3-5)
M = 3;                                  % number of background components
D = 3;                                  % positive deviation threshold
alpha = 0.01;                           % learning rate (between 0 and 1) (from paper 0.01)
thresh = 0.35;                          % foreground threshold (0.25 or 0.75 in paper)
sd_init = 9;                            % initial standard deviation (for new components) var = 36 
%--------------------------------------------------------------------------

  
function_mogb(C,M,D,alpha,thresh,sd_init,source,numberOfFrames,window1,window2,dir,'Blobs',blobSize)

%Play a sound when it's done

load chirp, sound(y,1*Fs);
function [outputFolder] = naming (dir,C,M,D,alpha,thresh,sd_init,window1)

%------------------------------Naming Funnction----------------------------
% 
% function [outputFolder] = naming (dir,C,M,D,alpha,thresh,sd_init,window1)
% 
% Concatenates multiple strings to form a naming scheme for the ouptput
% folder.
% 

outputFolder = fullfile(dir,'Frames');

Cstring = strcat('C= ',num2str(C));
Dstring = strcat('D= ',num2str(D));
Mstring = strcat('M= ',num2str(M));
Astring = strcat('A= ',num2str(alpha));
Threshstring = strcat('Thresh= ',num2str(thresh));
pixel_sd_initstring = strcat('SD= ',num2str(sd_init));
windowstring = strcat('window= ',num2str(window1));

% Folder naming
outputFolder =strcat(outputFolder,Cstring,Mstring,Dstring,Astring,Threshstring,pixel_sd_initstring,windowstring);

end
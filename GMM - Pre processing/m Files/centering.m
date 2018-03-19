function [centered_image]=centering (image,desired_square_dim)


%------------------------------Image Centering-----------------------------
%
%function [centered_image]=centering (image,desired_square_dim)
%
% Centers  a binary image by padding black borders to the image as shown
% below (2x2 padded)
% 
% ==========
% ==========
% ||      ||
% || img  ||
% ||      ||
% ==========
% ==========
% 
% -------------------------------------------------------------------------



% Debugging
% image=foreground;
% desired_square_dim=512;

[row,col,~]=size(image);
    
if (row>(desired_square_dim) || col>(desired_square_dim))

    message='Dimensions exceed the require padding. Please resize first.';
    error(message);
    
end


paddingrows=desired_square_dim-row;
paddingcols=desired_square_dim-col; 

padtop=logical(zeros(round(paddingrows/2),desired_square_dim));
padbot=logical(zeros(round(paddingrows/2)-mod(desired_square_dim-row,2),desired_square_dim));

padleft=logical(zeros(row,round(paddingcols/2)));
padright=logical(zeros(row,round(paddingcols/2)-mod(desired_square_dim-col,2)));

centered_image=[padtop;padleft,image,padright;padbot];




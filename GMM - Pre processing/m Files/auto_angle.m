function [angle_of_rotation] = auto_angle (image)

% -----------------------------AngleCalculation----------------------------
% 
% function [angle_of_rotation] = auto_angle (image)
% 
% Calculates the angle of rotation needed taking into account that the top 
% pixel of a binary image needs to be aligned with the y'y axis (e.g. apples
% to a human silhouette). The angle is calculated by simulating a right
% triangle, formed by the coordinates of the uppermost pixel of non-zero
% value, the hypothetical origin (mid of height, mid of width of image) and
% the y'y axis.
% 
% Inputs:
%         image : a binary image to calculate the needed angle
% Ouputs
%         angle_of_rotation : the angle in degrees the image needs to be
%         rotated. A negative value indicates clockwise movement, whereas a
%         positive one, clockwise movement.
% -------------------------------------------------------------------------

 image=im2bw((imread('401.png')));

[row,col,~]=size(image);

%Determine the top non-zero pixel index.
flag=0;
for ii=1:row
    for jj=1:col
        
        if image(ii,jj)>0
            top_pixel_position=[jj,ii]; %tradition x,y cartesian coordinates
            flag=1;
            break
        end
    end
    if flag==1
        break
    end
end

%Angle of rotation

y_diff = round(row/2) - top_pixel_position(1);
x_diff = round(col/2) - top_pixel_position(2);
tanofdif=tan( y_diff / x_diff );
angle_of_rotation=atand(tanofdif);
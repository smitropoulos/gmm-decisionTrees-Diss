function [cropped_image] = cropping (image)


%--------------------------------Image Cropping------------------------------
% 
%function [cropped_image] = cropping (image)
%
% Crops a binary image to the first non black pixels all around.
%  
% Inputs:
%         image: The image to be cropped
% 
% Outputs:
%         cropped_image: The cropped image
% 
%--------------------------------------------------------------------------


% calculating size of the image
[row,col] = size(image);

%The criterion is the sum of all the row pixels.
%If all are black, the sum is equal to 0.

% removing black portion on top side of the image
for i = 1:row
    if sum(image(i,:)) > 0
        top = i;
        break
    end
end

% removing black portion on bottom side of the image
for i = row:(-1):1
    if sum(image(i,:)) > 0
        bottom = i;
        break
    end
end

% removing black portion on left side of the image
for i = 1:col
    if sum(image(:,i)) > 0
        left = i;
        break
    end
end

% removing black portion on right side of the image
for i = col:(-1):1
    if sum(image(:,i)) > 0
        right = i;
        break
    end
end

% output image
cropped_image = image(top:bottom, left:right);

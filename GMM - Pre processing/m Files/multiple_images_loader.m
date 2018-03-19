function multiple_images_loader(path,type)


%------------------------------Image Loader--------------------------------
% 
% function multiple_images_loader(path,type)
% 
% function multiple_images_loader(path,type)
%
% Load multiple images and edit them one by one. 
% 
% Inputs:
%         path: the complete path of the folder containing the images
%         type: the type of the images (extension)


    
%     path = 'C:\Users\stefm\Desktop\FramesC=3M=3D=3A=0.01Thresh=0.25SD=6';
%     type = '*.png'; % change based on image type
    images  = dir(path);
    N = length(images);

    % check images
    if( ~exist(path, 'dir') || N<1 )
        display('Directory not found or no matching images found.');
    end
    
    for n=1:N
       
        name=sprintf('%d.%d',n,type);
        image = imread(name);
        
%         image = closesilhouette(image);
%         image = cropping(image);
        theta = auto_angle(image);
        T = [cos(theta), sin(theta), 0; -sin(theta), cos(theta), 0; 0, 0, 1];
        image = imhtrans(image, T);
        image = centering (image,256);

        
          %Resize Image
   % ResizeImg = imresize(I,[600 1000]);
   [X, map] = gray2ind(image,2);
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
    
    %Chirp when it ends    
    load chirp, sound(y,2*Fs);
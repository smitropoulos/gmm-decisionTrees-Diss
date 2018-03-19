function [reshapedImage,Class]=AddClassFromVideo (VideoPath,NumberOfClass)

VideoObject=VideoReader(VideoPath);    %Read a video with humans
nFrames_humans=VideoObject.NumberOfFrames; %read VideoObject_humans number of frames
dimensions=VideoObject.Height*VideoObject.Width;    %Get the 1st video's dimensions
reshapedImage=double(zeros(nFrames_humans,dimensions)); %Create an array filed with zeros
warning('off','all')    %Disable the warnings

for k=1:(nFrames_humans-1) %For all the frames
    
    img=read(VideoObject,k);    %Read the current frame
    
    image=im2bw(img);    %extract the perimeter of the frame
    display_progress=sprintf('Reading first video image number %d', k);
    disp(display_progress)
    row=reshape(image,[1,dimensions]); %reshape the perimeter in a 1 by dimensionX times dimensionY of the image
    reshapedImage(k,:)=row; %in the predefined B array, insert the reshaped image above in the k line (each time it runs it increments)
    Class(k) = NumberOfClass;
              
end

warning('on','all');
function closeBW = closesilhouette(frame)

se = strel('disk',2,8); %Disk Structure Element

closeBW = imclose(frame,se); %Use the morphological operator to fill the silhouette
% silhouette=imcontour(closeBW);
% imshow(closeBW)

end

function function_mogb(C,M,D,a,thresh,sd_init,source,numberOfFrames,window1,window2,dir,mode,blobSize)


%function function_mogb(C,M,D,a,thresh,sd_init,source,numberOfFrames,window1,window2,dir)

%      DEBUG PURPOSES ONLY
% file=('C:\Users\stefm\Downloads\Benchmarks\Crowd_PETS09\S0\Background\View_001\Time_13-06\S0_View_001_time_13-06.avi');
% source = VideoReader(file);
% numberOfFrames = source.numberOfFrames;
% dir='C:\Users\stefm\Downloads\Benchmarks\Crowd_PETS09\S0\Background\View_001\Time_13-06';
%
% % --------------------- MoG Variables -----------------------------------
%
% C = 3;                                  % number of gaussian components (typically 3-5)
% M = 3;                                  % number of background components
% D = 5;                                  % positive deviation threshold
% a = 0.01;                           % learning rate (between 0 and 1) (from paper 0.01)
% thresh = 0.25;                          % foreground threshold (0.25 or 0.75 in paper)
% sd_init = 6;                            % initial standard deviation (for new components) var = 36
% 
% window1=2;
% window2=2;
% dir                                     %The output folder of the processed images

[outputFolder] = naming (dir,C,M,D,a,thresh,sd_init,window1);
Extension = 'png';
%Initializations
[fr_bw,width,height,w,mean,sd,u_diff,rank]=initializations(source,C,a,sd_init);
% MAIN PROCESSING
n=1;
while (n<numberOfFrames)
    % tic
    
    
    [u_diff,fr_bw,fr] = diff_of_frames(source,n,mean,C);
    
    [bg_bw,fg,w,mean,sd] = Mixture_of_Gaussians(height,width,C,u_diff,D,sd,w,a,mean,fr_bw,M,sd_init,thresh,rank,fr);
    
    fgnew = medfilt2(fg,[window1 window2]);
    
    
    if strcmp(mode,'Blobs')
        extract_blobs(fgnew,n,outputFolder,blobSize);
    elseif strcmp(mode,'Frames')
        %Write Frames
        frame_writer(fg,n,outputFolder,Extension);
    elseif strcmp(mode,'Show')
        show_results(fr,fgnew);
    end
    
    
    
    disp(n);
    n=n+1;
    % toc
    
end
end


function show_results(fr,fgnew)

% Show Results
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
subplot(1,2,1)
imshow(fr);
subplot(1,2,2)
imshow(fgnew);
drawnow;

end

function extract_blobs (fgnew,n,outputFolder,blobSize)

% Extract Blobs
ExtractEachBlob(fgnew,blobSize,n,outputFolder);

end


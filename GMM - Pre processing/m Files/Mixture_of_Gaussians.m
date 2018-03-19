function [background_bw,foreground,weights,mean,sd] = Mixture_of_Gaussians (height,width,C,u_diff,D,sd,weights,alpha,mean,fr_bw,M,sd_init,thresh,rank,fr)


%-------------------The main Mixture of Gaussians method-------------------
%
% function [bg_bw,fg,w,mean,sd] = Mixture_of_Gaussians (height,width,C,u_diff,D,sd,w,alpha,mean,fr_bw,M,sd_init,thresh,rank,fr)
%
% Inputs:
%            Changing - Updating
%
%            frame : A black and white frame as input
%            weights : the weights matrix of the filter (updating)
%            mean : the mean of pixels matrix (updating)
%            pixel_sd : the standard deviation of pixels (updating)
%
%             MoG Variables (non-updating)
%
%            pixel_sd_init : the initial standard deviation to start
%                            calculations
%            C : Number of Gaussian components.
%            M : number of background components
%            D : positive deviation threshold
%            alpha : learning rate (between 0 and 1) (from paper 0.01)
%            thresh : foreground threshold (0.25 or 0.75 in paper)
%
%
% Outputs:
%            foreground : The output frame
%            weights : Updated weights
%            mean : the mean of pixels matrix (updating)
%            pixel_sd : the standard deviation of pixels (updating)
%--------------------------------------------------------------------------

% update gaussian components for each pixel
for i=1:height
    for j=1:width
        
        match = 0;      %Declare a match flag
        for k=1:C
            if (abs(u_diff(i,j,k)) <= D*sd(i,j,k))       % pixel matches component
                
                match = 1;                          % variable to signal component match
                
                % update weights, mean, sd, p
                weights(i,j,k) = (1-alpha)*weights(i,j,k) + alpha;
                p = alpha/weights(i,j,k);
                mean(i,j,k) = (1-p)*mean(i,j,k) + p*double(fr_bw(i,j));
                sd(i,j,k) =   sqrt((1-p)*(sd(i,j,k)^2) + p*((double(fr_bw(i,j)) - mean(i,j,k)))^2);
            else                                    % pixel doesn't match Gaussian component
                weights(i,j,k) = (1-alpha)*weights(i,j,k);      % weight slighly decreases
                
            end
        end
        
        weights(i,j,:) = weights(i,j,:)./sum(weights(i,j,:));     %Showing purposes. Not part of the Algorithm
        
        background_bw(i,j)=0;
        for k=1:C
            background_bw(i,j) = background_bw(i,j)+ mean(i,j,k)*weights(i,j,k);
        end
        
        % if no components match, create new component
        if (match == 0)
            [min_w, min_w_index] = min(weights(i,j,:));
            mean(i,j,min_w_index) = double(fr_bw(i,j));
            sd(i,j,min_w_index) = sd_init;
        end
        
        rank = weights(i,j,:)./sd(i,j,:);             % calculate component rank
        rank_ind = [1:1:C];
        
        % sort rank values
        for k=2:C
            for m=1:(k-1)
                
                if (rank(:,:,k) > rank(:,:,m))
                    % swap max values
                    rank_temp = rank(:,:,m);
                    rank(:,:,m) = rank(:,:,k);
                    rank(:,:,k) = rank_temp;
                    
                    % swap max index values
                    rank_ind_temp = rank_ind(m);
                    rank_ind(m) = rank_ind(k);
                    rank_ind(k) = rank_ind_temp;
                    
                end
            end
        end
        
        % calculate foreground
        match = 0;
        k=1;
        
        foreground(i,j) = 0;
        while ((match == 0)&&(k<=M))
            
            if (weights(i,j,rank_ind(k)) >= thresh)           % Background pixel
                if (abs(u_diff(i,j,rank_ind(k))) <= D*sd(i,j,rank_ind(k)))
                    foreground(i,j) = 0;
                    match = 1;
                else
                    foreground(i,j) = fr_bw(i,j);
                end
            end
            k = k+1;
        end
    end
end

%   Debugging purposes

%    figure(1),subplot(3,1,1),imshow(fr)
%    subplot(3,1,2),imshow(uint8(bg_bw))
%    subplot(3,1,3),imshow(uint8(fg))
%    drawnow;
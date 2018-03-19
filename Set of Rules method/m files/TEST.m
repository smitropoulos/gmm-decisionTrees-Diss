
% Add the Heatmaps folder and all its subfolders to the search path.
addpath(genpath('D:\OneDrive\MATLAB\BEng\Heatmaps'));

myFolder = 'D:\OneDrive\MATLAB\BEng\Database Extraction\First Video\ExtractedClosedBW';   % FINAL TEST FOLDER. PROGRAM NEVER SEEN THEM, SLIGHTLY DIFFERENT
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles   = dir(filePattern);

for k = 1:length(jpegFiles)
    
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf('Now reading %s\n', fullFileName);
    im = imread(fullFileName);  %insert the image into the variable im
    
    im = ImagePreProcessing (im,256);
    
    [m,n,~]=size(im);
    row=reshape(im,[1,m*n]); %reshape the image in a 1 by dimensionX times dimensionY of the image
    F(k,:)=row;     %in the predefined B array, insert the reshaped image above in the k line (each time it runs it increments)
    Class_n2(k) = 0; % 0 = 'human'; Categorization of classification matrix
    
end

F=double(F);
%  Test how well my Rule Based System works (on the test dataset)
% Images_test = D(CVO.test,:);
% ClassImages_test = Dclass(CVO.test,1);

Images_test = F;    %TEST WITH THE CURRENT TEST MATRIX

Class_n2=Class_n2.';    %INVERT THE CLASSIFICATION MATRIX
ClassImages_test = Class_n2;    %WITH THIS CURRENT CLASSIFICATION MATRIX


predictions = predict(rules_ctree, Images_test);    %PREDICT USING THE TRAINED SET OF RULES
predictions_result = confusionmat(ClassImages_test, predictions);   

% if predictions==1
%         sprintf('Result = %d', predictions)
% end
% 
% if predictions==0
%         sprintf('Result = %d', predictions)
% end


%Make a bag of classification trees
rules_ctree_bag = fitensemble(Images_train,ClassImages_train,'bag',10,'tree','type','Classification');

% Bag predictions

predictions_bag = predict(rules_ctree_bag,Images_test);
predictions_result_bag = confusionmat(ClassImages_test, predictions_bag);


% clf
% heatmap(predictions_result, 1:3, 1:3, '%.0f', 'TickAngle', 45,'Colorbar', true);
% title('Prediction Results Heatmap');



% figure,
% heatmap(predictions_result, 0:9, 0:9, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
% title('Confusion Matrix: Single Classification Tree')
figure,
heatmap(predictions_result_bag, 0:9, 0:9, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
title('Confusion Matrix: Ensemble of Bagged Classification Trees')


stats=confusionmatStats(predictions_result_bag);
disp(stats.accuracy);
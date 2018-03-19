
clear all;
close all;

%==================================PATHS===================================
% Add the Heatmaps folder and all its subfolders to the search path.
addpath(genpath('D:\OneDrive\MATLAB\BEng\Heatmaps'));
addpath(genpath('D:\Dropbox\Matlab'));
myFolder1 = 'C:\Users\stefm\Desktop\human';
myFolder2 = 'C:\Users\stefm\Desktop\dog';
myFolder3 = 'C:\Users\stefm\Desktop\car';

myFolder4 = 'D:\Dropbox\Matlab\blobwindow2\Human';       % New, completely unseen Video

% addpath(genpath('/Users/stefanosmitropoulos/OneDrive/MATLAB/BEng/Heatmaps'));
% addpath(genpath('/Users/stefanosmitropoulos/Dropbox/Matlab'));
% myFolder1 = '/Users/stefanosmitropoulos/Dropbox/Matlab/blobwindow2/Car';
% myFolder2 = '/Users/stefanosmitropoulos/Dropbox/Matlab/blobwindow2/Human';
%%

[B,Class1]=AddClassFromImages (myFolder1,0,'png');
[C,Class2]=AddClassFromImages (myFolder2,1,'png');
[D,Class3]=AddClassFromImages (myFolder3,2,'png');

[E,Class4]=AddClassFromImages (myFolder4,0,'png');  % New video

% images of human and nhuman, one array on top of the other,in one matrix.
%  Matrix converted to double data type
ConcatenatedMatrix =double([B;C;D]); 

%Class for each image, one array on top of the other
Dclass=[Class1,Class2,Class3]; 
Dclass = Dclass.';

%Partition the data 60% Training, 40% testing
CVO = cvpartition(Dclass, 'holdout', .4);  
% Generate my Rule Based System for classification 
Images_train = ConcatenatedMatrix(CVO.training,:);   % Take CVO (partitioned data) training set
Images_test = ConcatenatedMatrix(CVO.test,:);        %take the CVO (partitioned data) test set

ClassImages_train = Dclass(CVO.training,1); %Take the classes for the training set
ClassImages_test = Dclass(CVO.test,1);   %take the classes for the CVO (partitioned data) test set


%%
%------------------------------------------------------------------
%Make tree
rules_ctree = ClassificationTree.fit(Images_train, ClassImages_train);
%tree Predictions
predictions_tree = predict(rules_ctree, Images_test);
predictions_result_tree = confusionmat(ClassImages_test, predictions_tree);
%stats of predictions
stats_tree = confusionmatStats(predictions_result_tree);

%%
%NEW VIDEO UNSEEN

Images_test = E;
predictions_tree = predict(rules_ctree, Images_test);    %PREDICT USING THE TRAINED SET OF RULES
ClassImages_test = Class4.';
predictions_result_tree = confusionmat(ClassImages_test, predictions_tree);
%stats of predictions
stats_tree = confusionmatStats(predictions_result_tree);

%%
%--------------------------------------
%--------------------------------SHOW THE RESULTS--------------------------



accuracy_percentage=mean(stats_tree.accuracy)*100;
    figure,
    heatmap(predictions_result_tree, 0:9, 0:9, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
    title(sprintf('\n\t\tTree Accuracy: %.2f%% \n' , accuracy_percentage));
    
    disp(' ======== Numerical Results ======== ')
    fprintf('\n\t\tTree Accuracy: %.2f%% \n' , accuracy_percentage);
%     figure
%     view(rules_ctree,'Mode','graph')
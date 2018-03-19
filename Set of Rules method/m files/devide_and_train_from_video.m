function supervised_classification_trees = (path1,path2);

clc;clear all;close all;

% Add the Heatmaps folder and all its subfolders to the search path.
addpath(genpath('D:\OneDrive\MATLAB\BEng\Heatmaps'));
addpath(genpath('D:\Dropbox\Matlab\Set of Rules method'));
addpath(genpath('D:\OneDrive\MATLAB\BEng\Heatmaps'));

% path1=('D:\Dropbox\Matlab\blobwindow2\Car\new\Create_Video01.avi');    %Read a video with humans
% path2=('D:\Dropbox\Matlab\blobwindow2\human\Create_Video01.avi');    %Read a video with not_humans

[B,Class1]=AddClassFromVideo (path1,0);
[C,Class2]=AddClassFromVideo (path2,1);


concatMatrix =double([B;C]); % images of human and nhuman, one array on top of the other,in one matrix. Matrix converted to double data type

Dclass=[Class1,Class2]; % class for each image, one array on top of the other
Dclass = Dclass.';

CVO = cvpartition(Dclass, 'holdout', .4);



% Generate my Rule Based System for classification (training dataset) <-- this
% is called "Supervised Learning"

Images_train = concatMatrix(CVO.training,:);
ClassImages_train = Dclass(CVO.training,1);
rules_ctree = ClassificationTree.fit(Images_train, ClassImages_train);



% Test how well my Rule Based System works (on the test dataset)
Images_test = concatMatrix(CVO.test,:);
ClassImages_test = Dclass(CVO.test,1);

predictions_result_tree = predict(rules_ctree, Images_test);
predictions_result = confusionmat(ClassImages_test, predictions_result_tree);


%Make a bag of classification trees
rules_ctree_bag = fitensemble(Images_train,ClassImages_train,'bag',10,'tree','type','Classification');

% Bag predictions

predictions_bag = predict(rules_ctree_bag,Images_test);
predictions_result_bag = confusionmat(ClassImages_test, predictions_bag);

% clf
% heatmap(predictions_result, 1:3, 1:3, '%.0f', 'TickAngle', 45,'Colorbar', true);
% title('Prediction Results Heatmap');


% figure,
% heatmap(predictions_result_tree, 0:9, 0:9, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
% title('Confusion Matrix: Single Classification Tree')
% figure,
heatmap(predictions_result_bag, 0:9, 0:9, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
title('Confusion Matrix: Ensemble of Bagged Classification Trees')
  
% tree1=rules_ctree_bag.Trained{1};
% tree2=rules_ctree_bag.Trained{2};
% tree3=rules_ctree_bag.Trained{3};
% tree4=rules_ctree_bag.Trained{4};
% tree5=rules_ctree_bag.Trained{5};
% tree6=rules_ctree_bag.Trained{6};
% tree7=rules_ctree_bag.Trained{7};
% tree8=rules_ctree_bag.Trained{8};
% tree9=rules_ctree_bag.Trained{9};
% tree10=rules_ctree_bag.Trained{10};

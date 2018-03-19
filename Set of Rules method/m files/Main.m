
bound = 10;
accuracy_percentage=zeros(bound,1);
predictions_result_tree=zeros(2,2,bound);
rules_ctree = cell(bound,1);
k=1;
for ii=1:1
    
    [accuracy_percentage,predictions_result_tree,rules_ctree]=supervised_classification_trees_images();
    
%     subplot(10,1,k)
figure(ii)
    heatmap(predictions_result_tree, 0:9, 0:9, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
    title(sprintf('Accuracy: %.2f%%',accuracy_percentage));
%     subplot(10,2,k+1)
    view(rules_ctree,'Mode','graph')
    k=ii+2;
    
    
    %Plot the results in heat maps
    
%     figure,
%     heatmap(predictions_result_tree(ii), 0:9, 0:9, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
%     title('Confusion Matrix: Single Classification Tree')
%     
%     disp(' ======== Numerical Results ======== ')
%     fprintf('\n\t\tTree Accuracy: %.2f%% \n' , accuracy_percentage(ii));
%     figure
%     view(rules_ctree(ii),'Mode','graph')
end


predictions_result_tree=[20,3;5,220];

   heatmap(predictions_result_tree, 0:9, 0:9, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
    title(sprintf('Accuracy: %.2f%%',accuracy_percentage));


function [ confusion ] = createConfusionMatrix( actual, predicted )
%CONFUSIONMATRIX Summary of this function goes here
%   Detailed explanation goes here

disp('confusion matrix');
 
confusion = confusionmat(actual, predicted);
plotconfusion(actual, predicted)

end


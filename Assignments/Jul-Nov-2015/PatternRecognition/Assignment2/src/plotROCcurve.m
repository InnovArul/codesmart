function [ ] = plotROCcurve( testData, model)
%PLOTROC Summary of this function goes here
%   Detailed explanation goes here

global titleString;
noOfClasses = size(model, 1);

% determine the posterior regions
[~, classLabels, classLabelsProbability] = getBayesianMaxLikelihood(model, testData(:, 1:end-1)); %getPosterior

figure;
plts = [];
color = 'rgbymc';
for classNumber = 1 : noOfClasses
    % sort the actual labels in the order of sorted probability
    actualLabels = testData(:, end); 

    %figure;
    %[X, Y] = perfcurve(actualLabels, classLabelsProbability(:, classNumber), classNumber);
    %plot(X, Y);
    %figure;
    
    totalEntry = size(classLabels, 1);
    X = zeros(totalEntry + 1, 1);
    Y = zeros(totalEntry + 1, 1);

    %sort the probability
    [sortedProbability, order] = sort(classLabelsProbability(:, classNumber), 'descend');
    actualLabels = actualLabels(order, :);
    % note down total positive & negative cases
    totalTrue = sum(actualLabels==classNumber);    
    totalFalse = sum(actualLabels~=classNumber);   

    % thanks and courtesy: https://www.youtube.com/watch?v=sWAJsiVh1Gg
    hold on;
    
    %% Shift threshold to find the ROC
    for thresIdx = 1:(size(sortedProbability))
        
        % for each Threshold Index, take the current threshold & calculate
        % number of true positives and false positives

        threshold = sortedProbability(thresIdx);
        % count of true positives
        tpCount = sum(sortedProbability >= threshold & actualLabels == classNumber);

        %count of false positives
        fpCount = sum(sortedProbability >= threshold & actualLabels ~= classNumber);

        X(thresIdx + 1) = fpCount/(totalFalse);
        Y(thresIdx + 1) = (tpCount/(totalTrue));
    end

    % Plot the graph in the same figure & note down the handle
    plts(classNumber) = plot(X, Y, color(classNumber));
end

% set the legend and axis titles
title(strcat('ROC curve:    ', titleString{:}));
xlabel('False positive rate');
ylabel('True positive rate');
legend(plts, {'class1', 'class2', 'class3'});
legend show;    

end


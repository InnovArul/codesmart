function [ ROCBuffer ] = plotROCcurve( actualLabels, classLabelsProbability, noOfClasses)
%PLOTROC Summary of this function goes here
%   Detailed explanation goes here

global titleString classPaths;

figure;
plts = [];
color = 'rgbymcrgbymcrgbymcrgbymcrgbymcrgbymc';

ROCBuffer = {};
for classNumber = 1 : noOfClasses

    %figure;
    %[X, Y] = perfcurve(actualLabels, classLabelsProbability(:, classNumber), classNumber);
    %plot(X, Y);
    %figure;
    
    totalEntry = size(actualLabels, 1);
    X = zeros(totalEntry + 1, 1);
    Y = zeros(totalEntry + 1, 1);

    %sort the probability
    [sortedProbability, order] = sort(classLabelsProbability(:, classNumber), 'descend');
    sortedLabels = actualLabels(order, :);
    % note down total positive & negative cases
    totalTrue = sum(sortedLabels==classNumber);    
    totalFalse = sum(sortedLabels~=classNumber);   

    % thanks and courtesy: https://www.youtube.com/watch?v=sWAJsiVh1Gg
    hold on;
    
    %% Shift threshold to find the ROC
    for thresIdx = 1:(size(sortedProbability))
        
        % for each Threshold Index, take the current threshold & calculate
        % number of true positives and false positives

        threshold = sortedProbability(thresIdx);
        % count of true positives
        tpCount = sum(sortedProbability >= threshold & sortedLabels == classNumber);

        %count of false positives
        fpCount = sum(sortedProbability >= threshold & sortedLabels ~= classNumber);

        X(thresIdx + 1) = fpCount/(totalFalse);
        Y(thresIdx + 1) = (tpCount/(totalTrue));
    end

    % Plot the graph in the same figure & note down the handle
    plts(classNumber) = plot(X, Y, color(classNumber));
    ROCBuffer{classNumber, 1} = [X Y];
end

% set the legend and axis titles
title(strcat('ROC curve for GMM:', titleString{:}));
xlabel('False positive rate');
ylabel('True positive rate');
legend(plts, classPaths);
legend show;    

end


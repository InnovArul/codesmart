function [ ] = plotROCcurve_v1( actualLabels, classLabelsProbability, noOfClasses)
%PLOTROC Summary of this function goes here
%   Detailed explanation goes here

h = figure('visible', 'off');
plts = [];
color = 'rgbymcrgbymcrgbymcrgbymcrgbymcrgbymc';

% ROCBuffer = {};
X = [];
Y = [];

for classNumber = 1 : noOfClasses

    %figure;
    %[X, Y] = perfcurve(actualLabels, classLabelsProbability(:, classNumber), classNumber);
    %plot(X, Y);
    %figure;
    
    totalEntry = size(actualLabels, 1);
%     X = zeros(totalEntry + 1);
%     Y = zeros(totalEntry + 1);

    %sort the probability
    [sortedProbability, order] = sort(classLabelsProbability(:, classNumber), 'descend');
    sortedLabels = actualLabels(order, :);
    % note down total positive & negative cases
    totalTrue = sum(sortedLabels==classNumber);    
    totalFalse = sum(sortedLabels~=classNumber);   
    sortedProbability_Idx = 1:-0.05:0;
    % thanks and courtesy: https://www.youtube.com/watch?v=sWAJsiVh1Gg
    hold on;
    
    %% Shift threshold to find the ROC
    for thresIdx = 1:(size(sortedProbability_Idx,2))
        
        % for each Threshold Index, take the current threshold & calculate
        % number of true positives and false positives

        threshold = sortedProbability_Idx(thresIdx);
        
        % count of true positives
        tpCount = sum(sortedProbability >= threshold & sortedLabels == classNumber);

        %count of false positives
        fpCount = sum(sortedProbability >= threshold & sortedLabels ~= classNumber);

        X(thresIdx, classNumber) = fpCount/(totalFalse);
        Y(thresIdx, classNumber) = (tpCount/(totalTrue));
    end

    
end
X = sum(X,2)/noOfClasses;
Y = sum(Y,2)/noOfClasses;
% Plot the graph in the same figure & note down the handle
plot(X, Y);
%     ROCBuffer{classNumber, 1} = [X Y];
% set the legend and axis titles
title('ROC curve');
xlabel('False positive rate');
ylabel('True positive rate');
legend show;    
saveas(h, 'ROC', 'fig');
end


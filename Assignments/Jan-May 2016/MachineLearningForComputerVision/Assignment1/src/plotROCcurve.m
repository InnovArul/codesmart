function [ ] = plotROCcurve( testData, model, prior, prefixString)
%PLOTROC Summary of this function goes here
%   Detailed explanation goes here

global REPORTFOLDER;
noOfClasses = size(model, 1);

% determine the posterior regions
[~, classLabels, classLabelsProbability] = getBayesianMaxLikelihood(model, prior, testData(:, 1:end-1)); %getPosterior

%plot class labels probability for face model and non-face model
for classNumber = 1:noOfClasses

end

figTop = figure('visible', 'off');
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
    isthresholded = 0;
    
    % Shift threshold to find the ROC
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
        
        if( X(thresIdx + 1) >= 0.2 && isthresholded == 0)
            disp(threshold);                
            isthresholded = 1;
        end
    end

    % Plot the graph in the same figure & note down the handle
    plts(classNumber) = plot(X, Y, color(classNumber));
    
    threshold = sortedProbability(size(Y(X<=0.2), 1));
    
    fig = figure;
    scatter(ones(1, sum(testData(:, end) == 1)), classLabelsProbability(testData(:, end) == 1, classNumber)); 
    hold on;
    scatter(ones(1, sum(testData(:, end) == 2)) * 2, classLabelsProbability(testData(:, end) == 2, classNumber), 'd');
    title(strcat('Log likelihood  visualization for best model (FPR <= 0.2) ~ ', num2str(threshold)));
    xlabel('label'); ylabel('log likelihood');
    
    %draw a line for threshold
    hold on;
    plot([1 2], [threshold threshold], 'r--');

    saveas(fig, strcat(REPORTFOLDER, 'class', num2str(classNumber), 'llvisualization.png')); 
    close(fig);    
    
end

% set the legend and axis titles
title(strcat('ROC curve'));
xlabel('False positive rate');
ylabel('True positive rate');
legend(plts, {'face class', 'nonface class'});

%plot 0.2 FPR line
plot([0.2 0.2], [0 1], 'b--');

legend show;    

saveas(figTop, strcat(REPORTFOLDER, prefixString, '_ROC.png'));
close(figTop);

end


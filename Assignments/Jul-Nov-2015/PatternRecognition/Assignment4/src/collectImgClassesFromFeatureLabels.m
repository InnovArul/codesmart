function [ classLogLikelihoods, classAssignments ] = collectImgClassesFromFeatureLabels(testData, labels, numClasses)
%COLLECTIMGCLASSESFROMFEATURELABELS Summary of this function goes here
%   Detailed explanation goes here

classLogLikelihoods = [];

% determine the labels based on majority of labels in a particular test
% data
countSoFar = 0;
for testDataIndex = 1 : numel(testData)
    startCount = countSoFar + 1;
    endCount = countSoFar + size(testData(testDataIndex).contents, 1);

    % collect the labels & their likelihoods for current example image (or)
    % speech
    currentLabels = labels(startCount : endCount);

    classAssignments(testDataIndex, :) = mode(currentLabels);

    % for each class, calculate the class scores from individual points
    for classIndex = 1 : numClasses
       classLogLikelihoods(testDataIndex, classIndex) = sum(currentLabels == classIndex) / size(currentLabels, 1);
    end

    countSoFar = endCount;
end
end


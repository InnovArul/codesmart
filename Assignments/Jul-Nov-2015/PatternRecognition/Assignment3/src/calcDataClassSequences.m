function [classSequences] = calcDataClassSequences( testData, k_means_mu_k )
%CALCTESTDATASEQUENCES Summary of this function goes here
%   Detailed explanation goes here

dataPoints = collectAllDataFromStruct(testData);
numClasses = size(k_means_mu_k, 1);
squaredErrorAllClasses = [];

% get the squared error for each class and store it in buffer
parfor classIndex = 1 : numClasses
   currSquaredError = getSquaredError(dataPoints, k_means_mu_k{classIndex, 1}); 
   squaredErrorAllClasses(:, classIndex) = min(currSquaredError, [], 2);
end

% assign the class with minimum squared error to each data point
[~, classAssignments] = min(squaredErrorAllClasses, [], 2);

totalTestElements = size(testData, 1);

countSoFar = 0;
classSequences  = {};

% for each 'whole' test object, get the sequence of class assignments for
% it's elementary features or rows
for element = 1:totalTestElements
    startIndex = countSoFar + 1;
    endIndex = countSoFar + size(testData(element, 1).contents, 1);
    
    currentLabels = classAssignments(startIndex : endIndex);
    classSequences{element, 1} = currentLabels;
    
    countSoFar = endIndex;
end

end


function [ currentBestModel, currentBestErrorRate ] = getBestModel( modelsBuffer )
%GETBESTMODEL Summary of this function goes here
%   Detailed explanation goes here

summaryArray = [];

digits(3);

for index = 1 : length(modelsBuffer)
    summaryArray(index, 1) = index;
    summaryArray(index, 2) = modelsBuffer(index).totalNodes;
    summaryArray(index, 3) = vpa(modelsBuffer(index).valError);
end

sortedSummary = sortrows(summaryArray, [3 2]);
currentBestModel = modelsBuffer(sortedSummary(1, 1));
currentBestErrorRate = sortedSummary(1, 3);

Output.DEBUG(strcat('the best model hidden layer configuration :', currentBestModel.config, ' , validation error =', num2str(currentBestErrorRate), '\n'));

end


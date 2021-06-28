function [ trainData, testData ] = splitIntoTrainAndTestData( data )
%SPLITINTOTRAINANDTESTDATA Summary of this function goes here
%   Detailed explanation goes here

noOfClasses = size(unique(data(:, end)), 1);

trainData = [];
testData = [];

for classIndex = 1:noOfClasses
    currentData = data(data(:, end) == classIndex, :);
    totalExamples = size(currentData, 1);
    trainSplit = uint16(totalExamples * 0.7);

    trainData = [trainData; currentData(1:trainSplit, :)];
    testData = [testData; currentData(trainSplit + 1 : end, :)];
end

end


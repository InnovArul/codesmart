function [ trainData, testData ] = splitIntoTrainAndTestData( data )
%SPLITINTOTRAINANDTESTDATA Summary of this function goes here
%   Detailed explanation goes here

totalExamples = size(data, 1);
trainSplit = uint16(totalExamples * 0.7);
testSplit = totalExamples - trainSplit;

trainData = data(1:trainSplit, :);
testData = data(trainSplit + 1 : end, :);

end


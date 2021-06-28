function [ classAssignments ] = performTestDTW( trainData, trainClassSequences, testClassSequences )
%PERFORMTESTDTW Summary of this function goes here
%   Detailed explanation goes here

totalTestData = size(testClassSequences, 1);
totalTrainingData = size(trainClassSequences, 1);

testTainingMatch = [];
for testIndex = 1:totalTestData
   testToTrainingDist = [];
   parfor trainIndex = 1:totalTrainingData
       testToTrainingDist(trainIndex, 1) = dtw(trainClassSequences{trainIndex, 1}, testClassSequences{testIndex, 1}, 1);
   end
   [~, testTainingMatch(testIndex, 1)] = min(testToTrainingDist, [], 1);
end

% assign the class of particular training example which has minimum
% distance to the test sample
for testIndex = 1:totalTestData
    classAssignments(testIndex, :) = trainData(testTainingMatch(testIndex, 1)).class;
end
end


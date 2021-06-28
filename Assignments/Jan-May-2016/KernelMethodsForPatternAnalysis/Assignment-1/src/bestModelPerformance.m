function [ output_args ] = bestModelPerformance( dataType, path, decisionType )
%BESTMODELPERFORMANCE Summary of this function goes here
%   Detailed explanation goes here

Output.level(Output.DISP_DEBUG);
clc;

% decisionType:
% 1 = CLASSIFICATION
% 2 = REGRESSION

global REPORTFOLDER CURRENTREPORTDIR FILEPREFIX DATA_TITLE SCATTERPOINTSIZE;
REPORTFOLDER = '../report/pics/'; CURRENTREPORTDIR = REPORTFOLDER;
FILEPREFIX = '';
DATA_TITLE = '';
SCATTERPOINTSIZE = 12;

global REGRESSION CLASSIFICATION;
CLASSIFICATION = 1;
REGRESSION = 2;

global HIDDEN_LAYER_CONFIG;
HIDDEN_LAYER_CONFIG = [];

[trainData, testData, validationData] = loadData(dataType);
rawTrainLabels = trainData(:, end);
rawValidationLabels = validationData(:, end);
rawTestLabels = testData(:, end);


for i = 1:length(unique(rawTrainLabels))
        sum(rawTrainLabels == i) + sum(rawValidationLabels == i) + sum(rawTestLabels == i)
    sum(rawTrainLabels == i)
    sum(rawValidationLabels == i)
    sum(rawTestLabels == i)
    disp('*****');
end

model = [];
outputLayerNodeCount = 0;

% now perform the model configuration
switch(decisionType)
    case CLASSIFICATION
        %determine number of output nodes needed
        outputLayerNodeCount = length(unique(trainData(:, end)));
        
        trainData = prepare1ofKData(trainData);
        testData = prepare1ofKData(testData);
        validationData = prepare1ofKData(validationData);
        
        Output.DEBUG('model created!');
       
    case REGRESSION
        % by default, the lossfunction is MSE, final layer activation
        % function is pure linear. so, just create the network and do
        % nothing else
        outputLayerNodeCount = 1;
        
end

bestModel = load(path); 
bestModel = bestModel.bestModel;
model = bestModel.model;

pred = model(trainData(:, 1:end-outputLayerNodeCount)');
plotconfusion(trainData(:, end-outputLayerNodeCount+1:end)', pred);
title('Confusion matrix for training data');

pred = model(testData(:, 1:end-outputLayerNodeCount)');
plotconfusion(testData(:, end-outputLayerNodeCount+1:end)', pred);
title('Confusion matrix for test data');

pred = model(validationData(:, 1:end-outputLayerNodeCount)');
plotconfusion(validationData(:, end-outputLayerNodeCount+1:end)', pred);
title('Confusion matrix for validation data');

end


function [newModel] = setModelDataDivideConfig(model, trainData, validationData, testData)
    model.divideFcn = 'divideind';
    %model.divideParam.trainRatio = 1;
    %model.divideParam.testRatio = 0;
    %model.divideParam.valRatio = 0;
    
    model.divideParam.trainInd = 1:length(trainData);
    model.divideParam.valInd = length(trainData)+1:length(trainData)+length(validationData);
    model.divideParam.testInd = length(trainData)+length(validationData)+1 : length(trainData)+length(validationData)+length(testData);
    newModel = model;
end
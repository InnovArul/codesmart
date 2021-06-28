function [] = doall_task5()
%DOALL_TASK5 Summary of this function goes here
%   Detailed explanation goes here
addpath('./graphkernels/labeled/');

[trainData, validationData, testData] = loadData(options.GRAPHDATA);
trainLabels = [trainData.label]';
validationLabels = [validationData.label]';
testLabels = [testData.label]';

%[kernelGramTotal, runtime, phi] = spkernel([trainData; validationData; testData]', 0);
[kernelGramTotal, runtime] = WLspdelta([trainData; validationData; testData]', 2, 1, 0);

kernelGram = zeros(size(kernelGramTotal{1}));
for index = 1:length(kernelGramTotal)
   kernelGram = kernelGram + kernelGramTotal{index};
end
kernelGramTotal = kernelGram;
%kernelGramTotal = kernelGramTotal{2};

%[kernelGramTotal, runtime] = l3graphletkernel([trainData; validationData; testData]');

trainCount = size(trainData, 1);
validationCount = size(validationData, 1);
testCount = size(testData, 1);
trainK = [[1:trainCount]' kernelGramTotal(1:trainCount, 1:trainCount)];
validationK = [[1:validationCount]' kernelGramTotal(1+trainCount:trainCount+validationCount, 1:trainCount)];
testK = [[1:testCount]' kernelGramTotal(1+trainCount+validationCount:trainCount+validationCount+testCount, 1:trainCount)];

options = '-s 1 -t 4';
allModels = {};
accuracies = [];

count = 1;

for nu = 0.1 : 0.1: 0.3
    %for nu = 0.1 : 0.05: 0.2        
    currentModel = containers.Map;

    currentOptions1 = strcat(options, {' -n '}, num2str(nu));
    Output.DEBUG(options); disp(currentOptions1{:});

    % train the multi-class SVM
    model = svmtrain(trainLabels, trainK, currentOptions1{:});
    [predictedLabels, currentAccuracy, ~] = svmpredict(validationLabels, validationK, model);
    accuracies(count) = calcStats(validationLabels, predictedLabels, 2, 'validation Data');

    %store the model
    currentModel('nu') = nu;
    currentModel('model') = model;
    currentModel('accuracy') = accuracies(count);
    allModels{count} = currentModel; 
    count = count + 1;
end


%choose best model based on validation accuracy
bestModel = getBestModel(allModels);
model = bestModel('model');
nu = bestModel('nu');
disp(values(bestModel))

% test the testdata
[testPredictedlabels, accuracy, ~] = svmpredict(testLabels, testK, model);
calcStats(testLabels, testPredictedlabels, 2, 'test data');

end


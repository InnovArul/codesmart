function [  ] = doall()
%DOALL 

addpath('libsvm/matlab');
trainingFeaturesFile = 'imageclassification/bestmodels/filt=5-hidden1=5-hidden2=15-hidden3=5-fc1=300-fc2=150/train_filt=5-hidden1=5-hidden2=15-hidden3=5-fc1=300-fc2=150.mat';
validationFeaturesFile = 'imageclassification/bestmodels/filt=5-hidden1=5-hidden2=15-hidden3=5-fc1=300-fc2=150/validation_filt=5-hidden1=5-hidden2=15-hidden3=5-fc1=300-fc2=150.mat';
testFeaturesFile = 'imageclassification/bestmodels/filt=5-hidden1=5-hidden2=15-hidden3=5-fc1=300-fc2=150/test_filt=5-hidden1=5-hidden2=15-hidden3=5-fc1=300-fc2=150.mat';
global REPORTFOLDER DATA_TITLE;

REPORTFOLDER = '../report/pics/imagesvc';
DATA_TITLE = '\nu-SVM Classification using DCNN features'
Output.level(Output.DISP_DEBUG);

% read the features file
traindata = load(trainingFeaturesFile);
traindata = traindata.x;

validationData = load(validationFeaturesFile);
validationData = validationData.x;

testdata = load(testFeaturesFile);
testdata = testdata.x;

classes = length(unique(traindata(:, end)));
model = {};
options = '-s 1 -t 2 -b 1 -h 0 -e 0.001 ';
accuracies = [];
nuRange = 0.01 : 0.05 : 0.5;
gammaRange = 0.005 : 0.005 : 0.06;
trainaccuracies = zeros(length(nuRange), length(gammaRange));
validationaccuracies = zeros(length(nuRange), length(gammaRange));
testaccuracies = zeros(length(nuRange), length(gammaRange));
Output.place(fullfile(REPORTFOLDER, strcat('output.log')), true);

for nuIndex = 1:length(nuRange)
    nu = nuRange(nuIndex);
    
    currentOptions = strcat({options}, {' -n '}, {num2str(nu)});
    gammaIndex = 1;

    for gammaIndex = 1:length(gammaRange)
        gamma = gammaRange(gammaIndex);
        
        currentOptions1 = strcat(currentOptions, {' -g '}, {num2str(gamma)});
        % train the multi-class SVM
        model = svmtrain(traindata(:, end), traindata(:, 1:end-1), currentOptions1{:});
        fileName = strcat('model_nu_', num2str(nu), '_gamma_', num2str(gamma));
        save(fullfile(REPORTFOLDER,  strcat(fileName, '.svm')), 'model');  
        
        Output.DEBUG(fileName);
        trainaccuracies(nuIndex, gammaIndex) = plotConfusionMatrix(traindata, model, 'training', fullfile(REPORTFOLDER, fileName));
        validationaccuracies(nuIndex, gammaIndex) = plotConfusionMatrix(validationData, model, 'validation', fullfile(REPORTFOLDER, fileName));
        testaccuracies(nuIndex, gammaIndex) = plotConfusionMatrix(testdata, model, 'test', fullfile(REPORTFOLDER, fileName));
    end
end

createTablePlot(trainaccuracies, gammaRange, nuRange, 'train');
createTablePlot(validationaccuracies, gammaRange, nuRange, 'validation');
createTablePlot(testaccuracies, gammaRange, nuRange, 'test');

end


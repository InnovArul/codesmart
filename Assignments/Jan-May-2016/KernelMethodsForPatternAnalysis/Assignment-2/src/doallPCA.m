function [ ] = doall( pca_type )
%DOALL Summary of this function goes here
%   Detailed explanation goes here

addpath('libsvm/matlab');
global REPORTFOLDER; 
REPORTFOLDER = '../report/pics/task2';
diary('outputTask2.log')

%load the data and split the data into labels and feature data
data = loadDataForPCA();
data = double(data);
imageIndices = data(:, 1);
pureData = data(:, 2:end-1);
pureLabels = data(:, end);

pureData = normc(pureData);

[trainData, validationData, testData] = splitIntoTrainAndTest(data); %[imageIndices pureData pureLabels]
trainImageIndices = trainData(:, 1);
trainLabels = trainData(:, end);
trainData = trainData(:, 2:end-1);

validationImageIndices = validationData(:, 1);
validationLabels = validationData(:, end);
validationData = validationData(:, 2:end-1);

testImageIndices = testData(:, 1);
testLabels = testData(:, end);
testData = testData(:, 2:end-1);

dimension = size(trainData, 2);
numClasses = length(unique(trainData));

% Principle Component Analysis
%subtract the mean from data
imgMean = mean(trainData, 1);
meanMat = repmat(imgMean, size(trainData, 1), 1);
Y = trainData - meanMat;

% get the basis for eigen space
[sortedEigVals, sortedEigVectors] = getEigenValuesAndVectors(Y);

% reconstruct the images and plot frobenius norm
%reconstructAndCheckError(trainData, Y, sortedEigVectors, meanMat);

numberOfEigenBasis = 20:30:110;

accuracyPercentages = [];
models = {};

Output.place(fullfile(REPORTFOLDER, strcat('task2_output.log')), true);
options = '-s 1 -t 2 -b 1 -h 0 -e 0.00001 -q ';
nuRange = 0.15 : 0.10 : 0.30;
gammaRange = 0.01 : 0.01 : 0.03;
close all;

for basisIndex = 1 : length(numberOfEigenBasis)
    %fix the eigen vector components as 140
    currentEigVectorsCount = numberOfEigenBasis(basisIndex);    
    for nuIndex = 1:length(nuRange)
        nu = nuRange(nuIndex);
    
        currentOptions = strcat({options}, {' -n '}, {num2str(nu)});
        gammaIndex = 1;

        for gammaIndex = 1:length(gammaRange)
            disp('***************************************************************************');
            gamma = gammaRange(gammaIndex);

            currentOptions1 = strcat(currentOptions, {' -g '}, {num2str(gamma)});
        
            eigenBasis = sortedEigVectors(:, 1:currentEigVectorsCount);

            %get the PCA applied features
            pcaTrainFeatures = getPCAFeatures(trainData, imgMean, eigenBasis);
            %SVM classifier
            model = svmtrain(trainLabels, pcaTrainFeatures, currentOptions1{:});

            %get the PCA applied features
            pcaTestFeatures = getPCAFeatures(testData, imgMean, eigenBasis);    
            pcaValidationFeatures = getPCAFeatures(validationData, imgMean, eigenBasis);    
            
            fileName = strcat('model_features_', num2str(currentEigVectorsCount), '_nu_', num2str(nu), '_gamma_', num2str(gamma));
            %save(fullfile(REPORTFOLDER,  strcat(fileName, '.svm')), 'model');  

            disp(fileName);
            trainaccuracies(nuIndex, gammaIndex) = plotConfusionMatrix(pcaTrainFeatures, trainLabels, model, 'TRAINING', fullfile(REPORTFOLDER, fileName));
            disp('-------------------------------------------------------------------------');
            validationaccuracies(nuIndex, gammaIndex) = plotConfusionMatrix(pcaValidationFeatures, validationLabels, model, 'VALIDATION', fullfile(REPORTFOLDER, fileName));
            disp('-------------------------------------------------------------------------');
            testaccuracies(nuIndex, gammaIndex) = plotConfusionMatrix(pcaTestFeatures, testLabels, model, 'TESTING', fullfile(REPORTFOLDER, fileName));
        end
    end
end

end


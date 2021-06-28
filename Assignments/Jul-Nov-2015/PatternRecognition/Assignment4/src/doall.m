function [ output_args ] = doall( nonParMethod, K )
%DOALL Summary of this function goes here
%   Detailed explanation goes here
if(~exist('nonParMethod', 'var'))
    nonParMethod = 1;
end

close all; clc;

global titleString classPaths;
global PARZEN KNN;

PARZEN = 1;
KNN = 2;

trainData = []; testData = []; 
k_means_mu_k = [];
numClasses = 0;

% load the data
classPaths = {'data/image_dataset/coast', 'data/image_dataset/highway', 'data/image_dataset/insidecity', 'data/image_dataset/mountain', ...
                'data/image_dataset/opencountry', 'data/image_dataset/street', 'data/image_dataset/tallbuilding', ...
                'data/image_dataset/forest'};
numClasses = size(classPaths, 2);
wholeData = [];

for classIndex = 1:numClasses
    directory = classPaths{classIndex};

    % print the class name
    disp(directory);

    % load the data from directory
    data = loadDataFromDir(directory, classIndex);
    
    %collect whole data
    wholeData = [wholeData; data];
end

% for different window size
for h=12:2:25
    %for accuracyLevel = 0.5:0.5:0.75

       % apply PCA with particular accuracy level
       pcaFeatures = doDimensionReduction(wholeData, 0.75, 'PCA');

       %collect training and testing data from the pca applied features
       pcaDataStructs = savePcaFeaturesIntoStruct(wholeData, pcaFeatures);
       dataClasses = collectAllClassesFromStruct(pcaDataStructs);

       trainData = [];
       testData = [];

       %calculate priors
       priors = [];
       totalImgsCount = size(pcaDataStructs, 1);

       %for each class split the test and training data
       for classIndex = 1:numClasses
           currentDataScope = (dataClasses == classIndex);
           priors(classIndex) = sum(currentDataScope) / totalImgsCount;
           currentStructs = pcaDataStructs(currentDataScope, :);

           [currTrainData, currTestData] = splitIntoTrainAndTestData(currentStructs);
           trainData = [trainData; currTrainData];
           testData = [testData; currTestData];
       end

       %now, for each class, take training data, apply parzen window for test
       %data, calculate likelihood probabilities
       trainingDataClasses = collectAllClassesFromStruct(trainData);
       trainingDataFeatureClasses = collectAllClassesFromStruct(trainData, 1);
       testingDataClasses = collectAllClassesFromStruct(testData);

       testingFeatures = collectAllDataFromStruct(testData, 0, 'pca');
       likelihoodProbabilities = [];

       if(nonParMethod == PARZEN)
           for classIndex = 1:numClasses
               currentTrainDataScope = (trainingDataClasses == classIndex);
               currentTrainStructs = trainData(currentTrainDataScope, :);
               trainingFeatures = collectAllDataFromStruct(currentTrainStructs, 0, 'pca');

                % start timer
                tic
                disp(strcat('applying parzen window for class-', num2str(classIndex)));
                h = 9.8356e-04;
               % perform parzen window estimation
               likelihoodProbabilities(:, classIndex) = applyParzen(trainingFeatures, testingFeatures, h, 2);       

                %end timer
                toc
           end   
       else
           trainingFeatures = collectAllDataFromStruct(trainData, 0, 'pca');
           likelihoodProbabilities = kNN(trainingFeatures, trainingDataFeatureClasses, testingFeatures, K, numClasses);
       end
       
       %multiply class priors with likelihoods
       posterior = likelihoodProbabilities .* repmat(priors, size(likelihoodProbabilities, 1), 1);
       [~, featureLabelAssignments] = max(posterior, [], 2);
       
       %classify the image based on mode of individual features
       %[classPosteriors, imgClassAssignments] = collectImgClassesFromFeatureLabels(testData, featureLabelAssignments, numClasses);
       classPosteriors = normr(posterior);
       
        % calculate the statistics
        calcStats(testingDataClasses, featureLabelAssignments, numClasses);
        
        %plot ROC and DET
        plotROCcurve(testingDataClasses, classPosteriors, numClasses);
        plotDETcurve(testingDataClasses, classPosteriors, numClasses);
    end
end

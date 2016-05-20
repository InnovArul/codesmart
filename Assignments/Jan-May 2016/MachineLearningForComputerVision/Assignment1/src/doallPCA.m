function [ ] = doall( pca_type )
%DOALL Summary of this function goes here
%   Detailed explanation goes here

global REPORTFOLDER; 
REPORTFOLDER = '../report/pics/';

%load the data and split the data into labels and feature data
[face_train, face_test, nonface_train, nonface_test, width, height] = loadData();

imgData = [face_train nonface_train];
dimension = size(imgData, 1);
numClasses = 2;

% Principle Component Analysis
%subtract the mean from data
imgMean = mean(imgData, 2);
meanMat = repmat(imgMean, 1, size(imgData, 2));
Y = imgData - meanMat;

% get the basis for eigen space
[sortedEigVals, sortedEigVectors] = getEigenValuesAndVectors(Y);

%plot the eigen faces (eigen vectors)
plotEigenFaces(sortedEigVectors, width, height);

% reconstruct the images and plot frobenius norm
%reconstructAndCheckError(imgData, Y, sortedEigVectors, meanMat, width, height);

%test cases
testCases = { [150 150], ... 
              [150 200], ...
              [200 200], ...
              [250 200], ...
              [300 200], ...
              [300 300], ...
              [400 300], ...
              [400 400], ...
              [600 400] };

testCasesStrings  = {};

numberOfEigenBasis = 20:20:160;

accuracyPercentages = [];
models = {};

for basisIndex = 1 : length(numberOfEigenBasis)
    %fix the eigen vector components as 140
    currentEigVectorsCount = numberOfEigenBasis(basisIndex);
    eigenBasis = sortedEigVectors(:, 1:currentEigVectorsCount);
    
    %get the PCA applied features
    pcaTrainFeaturesFace = getPCAFeatures(face_train, imgMean, eigenBasis);
    pcaTrainFeaturesFace(:, end + 1) = ones(size(pcaTrainFeaturesFace, 1), 1);
    pcaTrainFeaturesNonFace = getPCAFeatures(nonface_train, imgMean, eigenBasis);
    pcaTrainFeaturesNonFace(:, end + 1) = ones(size(pcaTrainFeaturesNonFace, 1), 1) * 2;
    
    % get the PCA features of testing data (face and non face)
    pcaTestFeaturesFace = getPCAFeatures(face_test, imgMean, eigenBasis);
    pcaTestFeaturesFace(:, end + 1) = ones(size(pcaTestFeaturesFace, 1), 1);
    pcaTestFeaturesNonFace = getPCAFeatures(nonface_test, imgMean, eigenBasis);    
    pcaTestFeaturesNonFace(:, end + 1) = ones(size(pcaTestFeaturesNonFace, 1), 1) * 2;
    
    % do classification based on PCA features
    % Multivariate Bayes classifier

    for index = 1 : length(testCases)
        dataPartition = testCases{index};        
        
        %if basisIndex = 1, then add testCases string
        if(basisIndex == 1)        
           testCasesStrings(index) = {strcat(num2str(dataPartition(1)), ':', num2str(dataPartition(2)))};
        end        
        
        prefixString = strcat('principle', num2str(currentEigVectorsCount), '_', testCasesStrings{index});
        
        currentTrainData = [pcaTrainFeaturesFace(1:dataPartition(1), :) ;
                            pcaTrainFeaturesNonFace(1:dataPartition(2), :) ];

        currentTestData = [pcaTestFeaturesFace;
                            pcaTestFeaturesNonFace ];

        
        % build maximum likelihood bayesian model
        [model, prior] = BuildBaysianModel(currentTrainData);
        models(basisIndex, index).model= model;
        models(basisIndex, index).prior= prior;
        models(basisIndex, index).trainData= currentTrainData;
        models(basisIndex, index).testData= currentTestData;
        models(basisIndex, index).eigCount= currentEigVectorsCount;
        models(basisIndex, index).partition= dataPartition;
        
        % for each condition in the testcases, evaluate the Bayes classifier based
        % on Maximum likelihood estimation
        classLabels = BayesianClassify(model, prior, currentTestData);

        % plot the graph with test error
        disp(prefixString);
        accuracy = calcStats(currentTestData(:, end), classLabels, length(unique(currentTestData(:, end))));
        accuracyPercentages(basisIndex, index) = accuracy;
        
    end

        
end

createTablePlot(accuracyPercentages, testCasesStrings, numberOfEigenBasis);
plotClassificationAccuracies(accuracyPercentages, testCasesStrings, numberOfEigenBasis);
plotClassificationAccuracies(accuracyPercentages(7, :), testCasesStrings, numberOfEigenBasis(7));

% determine best model
[bestAccuracies, bestTestDataPartitionIndices] = max(accuracyPercentages, [], 2);
[~, bestPrincipleComponentIndex] = max(bestAccuracies, [], 1);
bestTestDataPartitionIndex = bestTestDataPartitionIndices(1);
bestModel = models(bestPrincipleComponentIndex, bestTestDataPartitionIndex);

%plot ROC for best model
prefixString = strcat('principle', num2str(bestModel.eigCount), '_', num2str(bestModel.partition(1)), ':', num2str(bestModel.partition(2)));
plotROCcurve(bestModel.testData, bestModel.model, bestModel.prior, prefixString);

end


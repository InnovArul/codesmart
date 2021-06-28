function [ ] = doallVideo( K, useMatlabGMMmethod )
%DOALLVIDEO Summary of this function goes here
%   Detailed explanation goes here

global titleString classPaths;

titleString = {'Video dataset'};

if(~exist('useMatlabGMMmethod', 'var'))
    useMatlabGMMmethod = 0;
end

% load the data
classPaths = {'data/running', 'data/handclapping', 'data/walking'};

numClasses = size(classPaths, 2);

trainData = []; testData = []; 
gmm_phi_k = cell(K, numClasses);
gmm_mu_k = cell(K, numClasses);
gmm_sigma_k = cell(K, numClasses);
k_means_mu_k = [];


for classIndex = 1:numClasses
    directory = classPaths{classIndex};
    data = loadDataFromDir(directory, classIndex);
    [newTrainData, newTestData] = splitIntoTrainAndTestData(data);
    trainData = [trainData; newTrainData]; testData = [testData; newTestData];

    currentTrainData = collectAllDataFromStruct(newTrainData);

    % pre cluster for this class
    [k_means_mu_k{classIndex, 1}, assignments] = k_means_cluster(currentTrainData, K);  

    %print number of points in each cluster
    for index = 1:K
       disp(strcat('K_means cluster-', num2str(index), ' : ', num2str(sum(assignments==index))));    
    end
end


% determine actual labels
actualLabels = collectAllClassesFromStruct(testData);

%% HMM testing
%Perform DTW test
trainClassSequences = calcDataClassSequences(trainData, k_means_mu_k);
testClassSequences = calcDataClassSequences(testData, k_means_mu_k);

% determine DTW between all test points to all training points & decide the
% class according to the minimum distance between testpoints &
% trainingpoints
%[classAssignments] = performTestDTW(trainData, trainClassSequences, testClassSequences);

[classLogLikelihoods, classAssignments] = performTestHMM(trainData, trainClassSequences, testClassSequences, numClasses, K);

calcStats(actualLabels, classAssignments, numClasses);

% plot ROC and DET curves
ROC{:, 2} = plotROCcurve(actualLabels, classLogLikelihoods, numClasses);
plotDETcurve(actualLabels, classLogLikelihoods, numClasses);



end


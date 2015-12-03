function model = doall(dataOption)
% function doall(option)
%API to carry out all the activites for loading the data, 
% building the bayesian model, classifying the testdata, plotting different curves 
%
% For loading the data, the data file should be present in the folder
% (./data).
%
% parameter : dataOption
% specifies which dataset has to be loaded.
% example:
%   doall(4); % executes the bayesian classifier process for real world
%   dataset
%
% different data options are as follows:
% 1 - Linearly separable dataset
% 2 - Nonlinearly separable dataset
% 3 - Overlapping dataset
% 4 - Real world dataset
%
clc;
close all;

global dataSetNames;
% descriptions for different datasets
dataSetNames = {'Linearly separable, '
                'nonlinearly separable, '
                'overlapping, '
                'Real world data, ' 
                };
           
% suffix for creating pictures
datasetSuffix = {
  'linsep'
  'nonlinsep'
    'overlap'
    'real'
};
            
global bayesType;

% descriotions for different bayes types
bayesType = {
    'Bayes with Covariance same for all classes'
    'Bayes with Covariance different for all classes'
    'Naive Bayes with C = sigma^2'
    'Naive Bayes with C same for all'
    'Naive Bayes with C different for all'
};

% suffix for creating file pictures
bayesSuffix = {
  'samecovar'
  'diffcovar'
  'naivesigma2'
  'naiveCsame'
  'naiveCdiff'

};

global titleString;
global surfUpLiftDelta;
global filesuffix;

% linearly seperable class data
[trainData, testData] = loadData(dataOption);

for caseNumber = 1:5
    titleString = {dataSetNames{dataOption}, bayesType{caseNumber}};
    filesuffix = strcat(datasetSuffix(dataOption), bayesSuffix(caseNumber));
    
    % build the bayesian model for the data
    model = BuildBaysianModel(trainData, [], caseNumber);

    % use bayesian classifier to classify the data
    classLabels = BayesianClassify(model, testData(:, 1:end-1));
    
    %create the confusion matrix
    calcStats(testData(:, end), classLabels);
    
    %calculate the cosine similarity to have the understanding of
    %similarity
    cos_Similarity = dot(classLabels, testData(:, end)) / (norm(classLabels) * norm(testData(:, end)))

    %determine step data width
    h = dataOption;
    if dataOption ~= 4
        h = 0.2;
        surfUpLiftDelta = 0.008;
    else
        h = 20;
        surfUpLiftDelta = 0.00001;
    end
    
    %create the scatter plot with class boundaries
   % plotScatter([trainData], model, h, dataOption, caseNumber);

    %create the surface plot
    %plotSurface([trainData], model, h, dataOption, caseNumber);
    
   
    %disp('Training data has been plotted');
    
    %pause;
    %close all;
    
    %create the scatter plot with class boundaries
    plotScatter(testData, model, h);

    %create the surface plot
    plotSurface(testData, model, h, dataOption, caseNumber);

    %plot the ROC
    plotROCcurve(testData, model);

    %plot the ROC
    plotDETcurve(testData, model);    
    
    disp('Test data has been plotted');
    
    pause;
    close all;
end

end
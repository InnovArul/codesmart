function [model, prior] = BuildBaysianModel(trainData)
% function [model] = BuildBaysianModel(trainData, crossValidationData, caseNumber)
%
% Builds Bayesian model using the given training data and cross validation
% data (optional) for the given case number.
%
% INPUT:
%
% trainData     : m x n+1 matrix, m is num of examples & n is number of
% dimensions. n+1 th column is for class labels (1 -- for class 1, ... k --
% for class k).
%
% crossValidationData     : (Optional) m x n+1 matrix, m is num of examples & n is
% number of dimensions. n+1 th column is for class labels (1 -- for class
% 1, ... , k -- for class k).
%
% caseNumber: -- Bayes with Covariance different for all classes
%
% OUTPUT:
% model    : k x 2 cell, k is num of classes.
%            Each row i is {muHat(mean_vector)_i, C(covariance_matrix)_i}
%
% See Also : BayesianClassify.m
%

m = size(trainData, 1); % number of training examples
n = size(trainData, 2) - 1; % number of feature dimension
k = length(unique(trainData(:, end))); % number of classes

model = cell(k, 2);
prior = [];

% Complete the function
for classNumber = 1:k
    % get the data rows for this particular classNumber
    currentClassData = trainData(trainData(:, end) == classNumber, :);
    
    % eliminate the class label column
    currentClassData = currentClassData(:, 1:n);
    
    % get the mean and store it in 1st column of k
    model{classNumber, 1} = mean(currentClassData);
    
    % get the covariance matrix and store it in 1st column of k
    model{classNumber, 2} = cov(double(currentClassData));
    
    % determine the prior
    prior(classNumber, 1) = size(currentClassData, 1) / size(trainData, 1);
end

end
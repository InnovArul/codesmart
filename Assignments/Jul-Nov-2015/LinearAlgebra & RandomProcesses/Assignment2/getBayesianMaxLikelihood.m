function [ maxlikelihood, classLabels, classLabelsProbability ] = getBayesianMaxLikelihood( model, testData, priors )
% function [classLabels] = getBayesianMaxLikelihood(model, testData)
%
% Gives the max probability of testData according to the given model
%
% INPUT:
%
% model    : k x 2 cell, k is num of classes.
%            Each row i is {muHat(mean_vector)_i, C(covariance_matrix)_i}
%
% testData     : m x n matrix, m is num of examples & n is
% number of dimensions.
%
% priors : prior probility for different classes
%
% OUTPUT:
%
% classLabels: m x 1 matrix, labels of testData, 1 for class 1, ... , k for
% class k.
%
% See Also : BuildBaysianModel.m
%

global priors;

m = size(testData, 1); % number of examples
n = size(testData, 2); % number of feature dimension
k = size(model, 1); % number of classes

MU_INDEX = 1;
SIGMA_INDEX = 2;

% Complete the function
classLabelsProbability = zeros(m, k);

%calculate the likelihood for each class
for classNumber = 1:k
  meandiff = testData - repmat(model{classNumber, MU_INDEX}, [m 1]);
  mahalanobis = sum(0.5 * (meandiff * inv(model{classNumber, SIGMA_INDEX})) .* meandiff, 2);
  classLabelsProbability(:, classNumber) = exp(-mahalanobis)  / (((2 * pi)^(n/2)) * sqrt(det(model{classNumber, SIGMA_INDEX}))) * priors(classNumber);
end

% get the maximum probability of the data point across all classes
[maxlikelihood, classLabels] = max(classLabelsProbability, [], 2);

end


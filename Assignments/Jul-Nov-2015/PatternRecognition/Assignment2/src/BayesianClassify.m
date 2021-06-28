function [classLabels] = BayesianClassify(model, testData)
% function [classLabels] = BayesianClassify(model, testData)
%
% Gives the class labels of testData according to the given model
%
% INPUT:
%
% model    : k x 2 cell, k is num of classes.
%            Each row i is {muHat(mean_vector)_i, C(covariance_matrix)_i}
%
% testData     : m x n matrix, m is num of examples & n is
% number of dimensions.
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
  classLabelsProbability(:, classNumber) = -mahalanobis - 0.5 * log(det(model{classNumber, SIGMA_INDEX})) + log(priors(classNumber));
end

[dummy, classLabels] = max(classLabelsProbability, [], 2);


end
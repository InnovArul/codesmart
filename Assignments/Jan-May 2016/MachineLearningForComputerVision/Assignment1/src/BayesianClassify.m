function [classLabels] = BayesianClassify(model, prior, testData)
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
n = size(testData, 2) - 1; % number of feature dimension
k = size(model, 1); % number of classes

MU_INDEX = 1;
SIGMA_INDEX = 2;

% Complete the function
classLabelsProbability = zeros(m, k);

currentTestData = testData(:, 1:end-1);

%calculate the likelihood for each class
for classNumber = 1:k
  meandiff = currentTestData - repmat(model{classNumber, MU_INDEX}, [m 1]);
  mahalanobis = sum(0.5 * (meandiff * pinv(unSingularify(model{classNumber, SIGMA_INDEX}) + (eye(size(model{classNumber, SIGMA_INDEX}, 1)) * eps))) .* meandiff, 2);
  classLabelsProbability(:, classNumber) = -mahalanobis - 0.5 * log(det(unSingularify(model{classNumber, SIGMA_INDEX})));
end

[dummy, classLabels] = max(classLabelsProbability, [], 2);

end
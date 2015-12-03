function [model] = BuildBaysianModel(trainData, crossValidationData, caseNumber)
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
% caseNumber: 1 -- Bayes with Covariance same for all classes
%             2 -- Bayes with Covariance different for all classes
%             3 -- Naive Bayes with C = \sigma^2*I
%             4 -- Naive Bayes with C same for all
%             5 -- Naive Bayes with C different for all
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

% Complete the function
for classNumber = 1:k
    % get the data rows for this particular classNumber
    currentClassData = trainData(trainData(:, end) == classNumber, :);
    
    % eliminate the class label column
    currentClassData = currentClassData(:, 1:n);
    
    % get the mean and store it in 1st column of k
    model{classNumber, 1} = mean(currentClassData);
    
    % get the covariance matrix and store it in 1st column of k
    model{classNumber, 2} = cov(currentClassData);
end

% based on caseNumber, modify the covariance matrix
switch(caseNumber)
    case 1
        % 1 -- Bayes with Covariance same for all classes
        %take the average of all the covariances
        covMatrices = reshape([model{:, 2}], 2, 2, size(model, 1));
        [model{:, 2}] = deal(mean(covMatrices, 3)); %mean(covMatrices, 3));
        
    case 2
        % 2 -- Bayes with Covariance different for all classes
        % do nothing, as covariance is already different for all
    case 3
        % 3 -- Naive Bayes with C = \sigma^2*I
        covMatrices = reshape([model{:, 2}], 2, 2, size(model, 1));
        
        %keep only the diagonal elements as non zero
        meanCov = mean(covMatrices, 3);
        maxSigma2 = max(covMatrices(:));
        
        [model{:, 2}] = deal(maxSigma2 * eye(size(meanCov))); %mean(covMatrices, 3)); 
        
    case 4
        % 4 -- Naive Bayes with C same for all
        covMatrices = reshape([model{:, 2}], 2, 2, size(model, 1));
        
        %keep only the diagonal elements as non zero
        meanCov = mean(covMatrices, 3);
        
        meanCov = meanCov .* eye(size(meanCov));
        
        [model{:, 2}] = deal(meanCov); %mean(covMatrices, 3));          
    case 5
        % 5 -- Naive Bayes with C different for all
        % make each covariant matrix as diagonally nonzero
        for classNumber = 1 : size(model, 1)
            covariance =  model{classNumber, 2} .* eye(size(model{classNumber, 2}));
            model{classNumber, 2} = covariance;
        end
    otherwise
        disp(strcat('Given caseNumber ', num2str(caseNumber), ' is invalid'));
        
end

end
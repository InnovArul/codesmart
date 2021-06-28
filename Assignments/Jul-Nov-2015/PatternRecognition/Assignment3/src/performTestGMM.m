function [ classLogLikelihoods, classAssignments ] = performTestGMM( testData, gmm_mu_k, gmm_sigma_k, gmm_phi_k, isDiagonalCovariance, dataType )
%PERFORMTEST Summary of this function goes here
%   Detailed explanation goes here

global IMAGEDATASET HWDATASET SPIRALDATASET DIGITDATASET;
if(dataType ~= SPIRALDATASET)
    testDataPoints = collectAllDataFromStruct(testData);
else
    testDataPoints = testData(:, 1:end-1);
end

numClasses = size(gmm_mu_k, 2);
numClusters = size(gmm_mu_k, 1);

LogLikelihoods = [];

for classIndex = 1 : numClasses
    clusterLikelihoods = [];
    for clusterIndex = 1 : numClusters
        covariance = gmm_sigma_k{clusterIndex, classIndex};
        
        if(isDiagonalCovariance)
        	covariance = covariance .* eye(size(covariance));    
        end
        
        clusterLikelihoods(:, clusterIndex) = gmm_phi_k{clusterIndex, classIndex} * normalpdf(testDataPoints, gmm_mu_k{clusterIndex, classIndex}, covariance);
    end
    LogLikelihoods(:, classIndex) = log(sum(clusterLikelihoods, 2));
end

% determine the class assignment based on maximum log likelihood
[maxLikelihoods, labels] = max(LogLikelihoods, [], 2);

if(dataType ~= SPIRALDATASET)
    % determine the labels based on majority of labels in a particular test
    % data
    countSoFar = 0;
    for testDataIndex = 1 : numel(testData)
        startCount = countSoFar + 1;
        endCount = countSoFar + size(testData(testDataIndex).contents, 1);

        % collect the labels & their likelihoods for current example image (or)
        % speech
        currentLabels = labels(startCount : endCount);

        classAssignments(testDataIndex, :) = mode(currentLabels);

        % for each class, calculate the class scores from individual points
        for classIndex = 1 : numClasses
           classLogLikelihoods(testDataIndex, classIndex) = sum(currentLabels == classIndex) / size(currentLabels, 1);
        end

        countSoFar = endCount;    
    end
else
    classLogLikelihoods = LogLikelihoods;
    classAssignments = labels - 1;
end

end


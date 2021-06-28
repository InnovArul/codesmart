function [ output_args ] = doallSpiral( K )
%DOALLSPIRAL Summary of this function goes here
%   Detailed explanation goes here


global titleString classPaths;

classPaths = {'class-0', 'class-1'};
titleString = strcat('Spiral dataset with', {' '}, {num2str(K)}, ' clusters ');

global IMAGEDATASET HWDATASET SPIRALDATASET DIGITDATASET;
IMAGEDATASET = 1;
HWDATASET = 2;
SPIRALDATASET = 3;
DIGITDATASET = 4;

dataType = SPIRALDATASET;

% load the data
data = loadDataSpiralDataset();

classes = unique(data(:, end));
numClasses = size(classes, 1);
gmm_phi_k = cell(K, numClasses);
gmm_mu_k = cell(K, numClasses);
gmm_sigma_k = cell(K, numClasses);

trainData = []; testData = []; 

for classIndex = 1:numClasses
    hold on;
    correctClass = classes(classIndex);
    % take the data for only current class
    currentData = data(data(:, end) == correctClass, :);

    [currentTrainData, currentTestData] = splitIntoTrainAndTestData(currentData);
    trainData = [trainData; currentTrainData]; testData = [testData; currentTestData];

    % pre cluster (eliminate the class indicator(last column))
    [assignments, k_means_mu_k{classIndex, 1}] = kmeans(currentTrainData(:, 1:end-1), K);

%             hold on;
%             scatter3(currentTrainData(:, 1), currentTrainData(:, 2), currentTrainData(:, 3), 1, assignments);

    %print number of points in each cluster
    for index = 1:K
       disp(strcat('cluster-', num2str(index), ' : ', num2str(sum(assignments==index))));    
    end

%     disp('Using Matlab builtin gmdistribution.fit method');
%     options = statset('Display','final');
%     obj = gmdistribution.fit(currentTrainData(:, 1:end-1), K,'Options',options); 
%     phi_k = obj.PComponents';
%     mu_k = obj.mu;
%     sigma_k = num2cell(obj.Sigma, [1 2]);

    %now perform GMM process
    [mu_k, sigma_k, phi_k] = gmm_cluster(currentTrainData(:, 1:end-1), assignments, K, k_means_mu_k{classIndex, 1});
    gmm_phi_k(:, classIndex) = num2cell(phi_k);
    gmm_mu_k(:, classIndex) = num2cell(mu_k, 2);
    gmm_sigma_k(:, classIndex) = sigma_k;
end

actualLabels = testData(:, 3);

%get all class probability (ratio of likelihoods?)
[classLogLikelihoods, classAssignments] = performTestGMM(testData, gmm_mu_k, gmm_sigma_k, gmm_phi_k, 0, dataType);

accuracy(1) = calcStats(actualLabels, classAssignments, numClasses);

end


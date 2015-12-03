function [ features] = doDimensionReduction(wholeData, accuracy, pcaOrFlda)
%DOPCA apply the pca for particular accuracy and return the new feature
%vectors

if(~exist('pcaOrFlda', 'var'))
    pcaOrFlda = 'PCA';
end

global PCA_USING_COVARIANCE PCA_USING_YYbar;
PCA_USING_COVARIANCE = 1;
PCA_USING_YYbar = 2;

if(~exist('pca_type', 'var'))
   pca_type = PCA_USING_COVARIANCE; 
end

% get all the data flattened
data = collectAllDataFromStruct(wholeData);

%subtract the mean from data
dataMean = mean(data, 1);

% predeclare the variables
sortedEigVals = [];
sortOrder = [];
sortedEigVectors = [];

if(strcmp(pcaOrFlda, 'PCA'))
    meanMat = repmat(dataMean, size(data, 1), 1);
    Y = data - meanMat;

    disp('Performing PCA on data');
    
    if(pca_type == PCA_USING_COVARIANCE)
        %% find eigen values and eigen vectors for covariance matrix

        %get the covariance matrix of mean shifted matrix
        covMatrix = cov(Y);

        %perform EVD
        [V, D] = eig(covMatrix);
        %load('data');

        %determine the descending order of eigen values based on magnitude
        eigVals = sum(D, 2); 

        [sortedEigVals, sortOrder] = sort(abs(eigVals), 1, 'descend');
        sortedEigVectors = V(:, sortOrder);

    else
        %% use the trick from cited document to reduce computation in finding eigen values and eigen vectors
        %courtesy: http://www.doc.ic.ac.uk/~dfg/ProbabilisticInference/IDAPILecture15.pdf
        %find eigen decomposition of Y * Y'
        [V_UUt, D_UUt] = eig(Y * Y'); 

        %determine the descending order of eigen values based on magnitude
        eigVals = diag(D_UUt);
        [sortedEigVals, sortOrder] = sort(abs(eigVals), 1, 'descend');

        %find the correct eigen vectors for PCA
        % normalize to get orthonormal vectors from orthogonal vectors
        correctV_UUt = normc(Y' * V_UUt);
        sortedEigVectors = correctV_UUt(:, sortOrder);    
    end

else
    %% perform FLDA
    % there is no change in data for FLDA , like mean subtraction in PCA
    disp('Performing FLDA on data');
    Y = data; meanMat = 0;
    
    % for each class, collect the data separately and calculate the mean
    allClasses = collectAllClassesFromStruct(wholeData);
    numClasses = length(unique(allClasses));
    dimension = size(data, 2);
    
    mu_i = {};
    S_B = zeros(dimension, dimension);
    S_W = zeros(dimension, dimension);;
    
    for classIndex = 1 : numClasses
        currentClassFeatures = collectAllDataFromStruct(wholeData, classIndex);
        mu_i{classIndex, 1} = mean(currentClassFeatures);
        
        N_i = size(currentClassFeatures, 1);
        
        S_W = S_W + ((N_i - 1) * cov(currentClassFeatures));
        S_B = S_B + (N_i * (mu_i{classIndex, 1} - dataMean)' * (mu_i{classIndex, 1} - dataMean));
    end
    
    %perform EVD
    [V, D, ~] = svd(pinv(S_W) * S_B);

    %determine the descending order of eigen values based on magnitude
    eigVals = sum(D, 2); 

    [sortedEigVals, sortOrder] = sort(abs(eigVals), 1, 'descend');
    sortedEigVectors = V(:, sortOrder);    
end

%plot the eigen values to see the variance of eigen values
%plot(sortedEigVals);

%calculate the variance percentage also, which can be plotted
eigValsSum = sum(sortedEigVals);
eigValsVariancePercentage = sortedEigVals * 100 / eigValsSum;
%plot(sortedEigVals * 100 / eigValsSum);

%buffer to collect frobenius norms
frobeniusNorms = [];

%PCA feature vector buffer
features = [];

% accuracy buffer
accuracyCollector = [];

% type top k eigen vectors and calculate the frobenius norm
for k = 1 : size(sortedEigVectors, 2);
    disp(strcat('Processing eigen vector-', num2str(k)));
    %prepare a matrix with only first k eigen vectors
    Q_pca = sortedEigVectors(:, 1:k); 

    %find the projection of each image on the reduced basis set
    projectedData_on_Q_pca = Y * Q_pca;

    %update the pca features buffer only if the variance of a particular
    %eigen vector is more than 'accuracy'%
    if(eigValsVariancePercentage(k) > accuracy)
       features = projectedData_on_Q_pca; 
    else
       disp(strcat('taking top-', num2str(k - 1), ' eigen vectors in PCA for accuracy level of ', num2str(accuracy), '%'));
       break;
    end

    %% Find frobenius norm just to make sure that data is reconstructed properly
    % reconstruct the image and add the mean
    reconstructedData = (projectedData_on_Q_pca * Q_pca') + meanMat;

    %calculate the frobenius norm
    frobeniusNorm = norm(data - reconstructedData, 'fro');
    frobeniusNorms = [frobeniusNorms; frobeniusNorm];
end
end


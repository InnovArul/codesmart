function [ ] = doall( pca_type )
%DOALL Summary of this function goes here
%   Detailed explanation goes here

global PCA_SLOW PCA_FAST;
PCA_FAST = 1;
PCA_SLOW = 2;

if(~exist('pca_type', 'var'))
   pca_type = PCA_FAST; 
end

%load the data and split the data into labels and feature data
[data, width, height] = loadData();

% take the last column as labels
classes = data(:, end);

data = double(data);
imgData = data(:, 1:end-1);
dimension = size(imgData, 2);
numClasses = size(unique(classes), 1);

%subtract the mean from data
imgMean = mean(imgData, 1);
meanMat = repmat(imgMean, size(imgData, 1), 1);
Y = imgData - meanMat;

if(pca_type == PCA_SLOW)
    %% find eigen values and eigen vectors for covariance matrix
    
    %get the covariance matrix of mean shifted matrix
    covMatrix = cov(Y);
    
    %perform EVD
    %[V, D] = eig(covMatrix)
    load('data');
    
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

%plot the eigen values to see the variance of eigen values
%plot(sortedEigVals);

%calculate the variance percentage also, which can be plotted
eigValsSum = sum(sortedEigVals);
eigValsVariancePercentage = sortedEigVals * 100 / eigValsSum;
%plot(sortedEigVals * 100 / eigValsSum);

%buffer to collect frobenius norms
frobeniusNorms = [];

%PCA feature vector buffer
pca_features = [];

% accuracy buffer
accuracy = [];

%create top 5 eigen faces for report
figure;
for i = 1 : 10
    figure;
    close all;
for k = 1 : 10
    subplot(5, 2, k);
    eigenface = sortedEigVectors(:, (i-1) * 10 +k);
    reshaped = reshape(eigenface, width, height);
    imagesc(reshaped);
    title(strcat('Eigenface ', num2str((i-1) * 10 +k)));
    set(gca,'Visible','off')
    set(get(gca,'Title'),'visible','on')
    colormap gray;
end
end

%since there are only 400 examples, there can be only 400 non-zero eigen
%values, so we are going to add atmost 400 eigen vectors
% type top k eigen vectors and calculate the frobenius norm
for k = 1 : 80
    disp(strcat('Processing eigen vector ', num2str(k)));
    %prepare a matrix with only first k eigen vectors
    Q_pca = sortedEigVectors(:, 1:k); 
    
    %find the projection of each image on the reduced basis set
    projectedImgs_on_Q_pca = Y * Q_pca;
    
    %update the pca features buffer only if the variance of a particular
    %eigen vector is more than 1%
    pca_features = projectedImgs_on_Q_pca; 
    
    %if(eigValsVariancePercentage(k) > 0.6)
     %  pca_features = projectedImgs_on_Q_pca; 
    %else
       % break;
    %end
    
    % reconstruct the image and add the mean
    reconstructedImgs = (projectedImgs_on_Q_pca * Q_pca') + meanMat;
    
    %calculate the frobenius norm
    frobeniusNorm = norm(imgData - reconstructedImgs, 'fro');
    frobeniusNorms = [frobeniusNorms; frobeniusNorm];
    
    % take an image (for example) and store it in the appropriate
    % directory
    %tenthOrigImg = imgData(10, :);
    %tenthOrigImg = reshape(tenthOrigImg, width, height);
    
    tenthReconstructedImg = reconstructedImgs(10, :);
    tenthReconstructedImg = reshape(tenthReconstructedImg, width, height);
    
    %imwrite(uint8(tenthOrigImg - tenthReconstructedImg), strcat('rough/10error_eig', num2str(k), '.jpg'));
    imwrite(uint8(tenthReconstructedImg), strcat('rough/10reconstructed_eig', num2str(k), '.jpg'));
    %imwrite(uint8(tenthOrigImg), strcat('rough/10original_eig', num2str(k), '.jpg'));

    featureData = [pca_features classes];

    %do classification based on PCA features
    %% Naive Bayes
    [trainData, testData] = splitIntoTrainAndTestData(featureData);
    trainData = double(trainData);  testData = double(testData);
    testLabels = testData(:, end);
    trainClasses = trainData(:, end);

    %count to save accuracy in correct position
    methodNumber = 1;
    
    localAccuracy = [];
    classifierType = [1, 3, 4];
    for classifierIndex = 1:size(classifierType, 2)
        %disp(strcat('bayesian classifier type : ', num2str(classifierType)))
        model = BuildBaysianModel(trainData, [], classifierType(classifierIndex));
        classLabelsPredicted = BayesianClassify(model, testData);

        localAccuracy(classifierIndex) = calcStats(testLabels, classLabelsPredicted, 40);
    end
    accuracy(k, methodNumber) = max(localAccuracy);


    %% k NN

    trainClasses = trainData(:, end);
    testData = testData(:, 1:end-1);
    trainData = trainData(:, 1:end-1);
    %count to save accuracy in correct position
    methodNumber = 2;
    localAccuracy = [];
    
    % for each test image, calculate the euclidean distance from all training
    % images. then assign the class of majority in K
    classLabelsPredicted = [];

    for K = 1:5 
        for testIndex = 1 : size(testData, 1)
            difference = trainData - repmat(testData(testIndex, :), size(trainData, 1), 1);
            euclidean = sum(difference .* difference, 2);
            [~, sortOrder] = sort(euclidean, 1);

            %select first K labels
            classLabelsPredicted(testIndex) = mode(double(trainClasses(sortOrder(1:K))));
        end

        %disp(strcat(num2str(K), '-NN : '))
        localAccuracy(K) = calcStats(testLabels, classLabelsPredicted, 40);
    end  
    
    accuracy(k, methodNumber) = max(localAccuracy);
end

%plot the frobenius norm
%plot(frobeniusNorms);

%plot accuracy graph
figure;
color = 'gbymc';
for methodIndex = 1:2
    hold on;
    plot(1:size(accuracy(:, methodIndex), 1), accuracy(:, methodIndex), color(methodIndex));
end

end


function [  ] = doallGMM(K, dataType, useMatlabGMMmethod)
%DOALL Summary of this function goes here
%   Detailed explanation goes here

if(~exist('useMatlabGMMmethod', 'var'))
    useMatlabGMMmethod = 0;
end

close all; clc;

global titleString classPaths;
global IMAGEDATASET HWDATASET SPIRALDATASET DIGITDATASET VIDEODATASET;
IMAGEDATASET = 1;
HWDATASET = 2;
SPIRALDATASET = 3;
DIGITDATASET = 4;
VIDEODATASET = 5;

trainData = []; testData = []; 
gmm_phi_k = cell(1, 1);
gmm_sigma_k = cell(1, 1);
gmm_mu_k = cell(1, 1);
k_means_mu_k = [];
numClasses = 0;

switch dataType

    case IMAGEDATASET
        
        titleString = strcat('Image dataset with', {' '}, {num2str(K)}, ' clusters ');
        
        % load the data
        classPaths = {'data/coast', 'data/highway', 'data/insidecity'};
        numClasses = size(classPaths, 2);
        
        gmm_phi_k = cell(K, numClasses);
        gmm_mu_k = cell(K, numClasses);
        gmm_sigma_k = cell(K, numClasses);
        
        for classIndex = 1:numClasses
            directory = classPaths{classIndex};
            data = loadDataFromDir(directory, classIndex);
            [newTrainData, newTestData] = splitIntoTrainAndTestData(data);
            trainData = [trainData; newTrainData]; testData = [testData; newTestData];
            
            currentTrainData = collectAllDataFromStruct(newTrainData);
            
            % pre cluster for this class
            [k_means_mu_k{classIndex, 1}, assignments] = k_means_cluster(currentTrainData, K);  
            
            %print number of points in each cluster
            for index = 1:K
               disp(strcat('K_means cluster-', num2str(index), ' : ', num2str(sum(assignments==index))));    
            end

            %now perform GMM process
            if(useMatlabGMMmethod)
                disp('Using Matlab builtin gmdistribution.fit method');
                options = statset('Display','final');
                obj = gmdistribution.fit(currentTrainData, K,'Options',options); 
                phi_k = obj.PComponents';
                mu_k = obj.mu;
                sigma_k = num2cell(obj.Sigma, [1 2]);
            else
                disp('Using self-written GMM method');
                [mu_k, sigma_k, phi_k] = gmm_cluster(currentTrainData, assignments, K, k_means_mu_k{classIndex, 1}); 
            end
            
            gmm_phi_k(:, classIndex) = num2cell(phi_k);
            gmm_mu_k(:, classIndex) = num2cell(mu_k, 2);
            gmm_sigma_k(:, classIndex) = sigma_k; 
        end

    case DIGITDATASET
        
        titleString = strcat('Digit dataset with', {' '}, {num2str(K)}, ' clusters ');
        
        % load the data
        classPaths = {'data/digit_data/five','data/digit_data/eight',...
            'data/digit_data/seven', 'data/digit_data/nine', 'data/digit_data/four'};
        numClasses = size(classPaths, 2);
        
        gmm_phi_k = cell(K, numClasses);
        gmm_mu_k = cell(K, numClasses);
        gmm_sigma_k = cell(K, numClasses);
        
        for classIndex = 1:numClasses
            directory = classPaths{classIndex};
            data = loadDataFromDir(directory, classIndex);
            [newTrainData, newTestData] = splitIntoTrainAndTestData(data);
            trainData = [trainData; newTrainData]; testData = [testData; newTestData];
            
            currentTrainData = collectAllDataFromStruct(newTrainData);
            
            % pre cluster for this class
            [k_means_mu_k{classIndex, 1}, assignments] = k_means_cluster(currentTrainData, K);  
            
            
            %print number of points in each cluster
            for index = 1:K
               disp(strcat('cluster-', num2str(index), ' : ', num2str(sum(assignments==index))));    
            end
            
            %now perform GMM process
            [mu_k, sigma_k, phi_k] = gmm_cluster(currentTrainData, assignments, K, k_means_mu_k{classIndex, 1}); 
            gmm_phi_k(:, classIndex) = num2cell(phi_k);
            gmm_mu_k(:, classIndex) = num2cell(mu_k, 2);
            gmm_sigma_k(:, classIndex) = sigma_k;
 
        end

    case SPIRALDATASET
        
        classPaths = {'class-0', 'class-1'};
        titleString = strcat('Spiral dataset with', {' '}, {num2str(K)}, ' clusters ');
        
        % load the data
        data = loadDataSpiralDataset();
        
        classes = unique(data(:, end));
        numClasses = size(classes, 1);
        gmm_phi_k = cell(K, numClasses);
        gmm_mu_k = cell(K, numClasses);
        gmm_sigma_k = cell(K, numClasses);
        
%         figure;
        
        for classIndex = 1:numClasses
            hold on;
            correctClass = classes(classIndex);
            % take the data for only current class
            currentData = data(data(:, end) == correctClass, :);

            [currentTrainData, currentTestData] = splitIntoTrainAndTestData(currentData);
            trainData = [trainData; currentTrainData]; testData = [testData; currentTestData];

            % pre cluster (eliminate the class indicator(last column))
            [k_means_mu_k{classIndex, 1}, assignments] = k_means_cluster(currentTrainData(:, 1:end-1), K);

%             hold on;
%             scatter3(currentTrainData(:, 1), currentTrainData(:, 2), currentTrainData(:, 3), 1, assignments);

            %print number of points in each cluster
            for index = 1:K
               disp(strcat('cluster-', num2str(index), ' : ', num2str(sum(assignments==index))));    
            end

            %now perform GMM process
            [mu_k, sigma_k, phi_k] = gmm_cluster(currentTrainData(:, 1:end-1), assignments, K, k_means_mu_k{classIndex, 1});
            gmm_phi_k(:, classIndex) = num2cell(phi_k);
            gmm_mu_k(:, classIndex) = num2cell(mu_k, 2);
            gmm_sigma_k(:, classIndex) = sigma_k;
        end

    case HWDATASET
        
        titleString = strcat('Handwritten characters dataset with', {' '}, {num2str(K)}, ' clusters ');
        
        %files = getAllFiles('data/HWDataset/FeaturesHW/');
        files = {'data/HWDataset/FeaturesHW/a.ldf',  ...
           'data/HWDataset/FeaturesHW/ai.ldf', 'data/HWDataset/FeaturesHW/bA.ldf', ...
           'data/HWDataset/FeaturesHW/chA.ldf', 'data/HWDataset/FeaturesHW/dA.ldf', ...
           'data/HWDataset/FeaturesHW/lA.ldf', 'data/HWDataset/FeaturesHW/tA.ldf',  'data/HWDataset/FeaturesHW/LA.ldf',};
        numClasses = size(files, 2);
          
        gmm_phi_k = cell(K, numClasses);
        gmm_mu_k = cell(K, numClasses);
        gmm_sigma_k = cell(K, numClasses);
        
        for classIndex = 1:numClasses
            filepath = files{classIndex};
            data = loadDataHWdataset(filepath, classIndex);
            [newTrainData, newTestData] = splitIntoTrainAndTestData(data);
            trainData = [trainData; newTrainData]; testData = [testData; newTestData];
            
            currentTrainData = collectAllDataFromStruct(newTrainData);
            max(currentTrainData)
            min(currentTrainData)
            
            % pre cluster for this class
            [k_means_mu_k{classIndex, 1}, assignments] = k_means_cluster(currentTrainData, K);  
            
            
            %print number of points in each cluster
            for index = 1:K
               disp(strcat('cluster-', num2str(index), ' : ', num2str(sum(assignments==index))));    
            end

            %now perform GMM process
            [mu_k, sigma_k, phi_k] = gmm_cluster(currentTrainData, assignments, K, k_means_mu_k{classIndex, 1}); 
            gmm_phi_k(:, classIndex) = num2cell(phi_k);
            gmm_mu_k(:, classIndex) = num2cell(mu_k, 2);
            gmm_sigma_k(:, classIndex) = sigma_k;
            
            sigma_k{:};
 
        end
        
        %plot all data in single picture to clarify low accuracy
        figure;
        color = 'yrgbcmrygb';
        plts = [];
        for classIndex = 1:numClasses
            currDataPoints = collectAllDataFromStruct(trainData, classIndex);
            hold on;
            plts(classIndex) = plot(currDataPoints(:, 1), currDataPoints(:, 2), color(classIndex));
        end
        
        legend(plts, files);
        legend show;
        pause;
        
    case VIDEODATASET
        % define title string for ROC curve plot
        titleString = {'Video dataset'};
        classPaths = {'data/running', 'data/handclapping', 'data/walking'};
        gmm_phi_k = cell(K, numClasses);
        gmm_mu_k = cell(K, numClasses);
        gmm_sigma_k = cell(K, numClasses);

        numClasses = size(classPaths, 2);
        for classIndex = 1:numClasses
            directory = classPaths{classIndex};
            data = loadDataFromDir(directory, classIndex);
            [newTrainData, newTestData] = splitIntoTrainAndTestData(data);
            trainData = [trainData; newTrainData]; testData = [testData; newTestData];

            currentTrainData = collectAllDataFromStruct(newTrainData);

            % pre cluster for this class
            [k_means_mu_k{classIndex, 1}, assignments] = k_means_cluster(currentTrainData, K);  

            %print number of points in each cluster
            for index = 1:K
               disp(strcat('K_means cluster-', num2str(index), ' : ', num2str(sum(assignments==index))));    
            end

            %now perform GMM process
            [mu_k, sigma_k, phi_k] = gmm_cluster(currentTrainData, assignments, K, k_means_mu_k{classIndex, 1}); 
            gmm_phi_k(:, classIndex) = num2cell(phi_k);
            gmm_mu_k(:, classIndex) = num2cell(mu_k, 2);
            gmm_sigma_k(:, classIndex) = sigma_k;            
        end

end

% determine actual labels
if(dataType ~= SPIRALDATASET)
    actualLabels = collectAllClassesFromStruct(testData);
else
    actualLabels = testData(:, 3);
end

%get all class probability (ratio of likelihoods?)
[classLogLikelihoods, classAssignments] = performTestGMM(testData, gmm_mu_k, gmm_sigma_k, gmm_phi_k, 0, dataType);

accuracy(1) = calcStats(actualLabels, classAssignments, numClasses);

% plot ROC and DET curves
ROC{:, 1} = plotROCcurve(actualLabels, classLogLikelihoods, numClasses);
plotDETcurve(actualLabels, classLogLikelihoods, numClasses);

%get all class probability (ratio of likelihoods?)
[classLogLikelihoods, classAssignments] = performTestGMM(testData, gmm_mu_k, gmm_sigma_k, gmm_phi_k, 1, dataType);

accuracy(2) = calcStats(actualLabels, classAssignments, numClasses);

% plot ROC and DET curves
ROC{:, 2} = plotROCcurve(actualLabels, classLogLikelihoods, numClasses);
plotDETcurve(actualLabels, classLogLikelihoods, numClasses);    

%% HMM testing
%Perform DTW test
trainClassSequences = calcDataClassSequences(trainData, k_means_mu_k);
testClassSequences = calcDataClassSequences(testData, k_means_mu_k);

% determine DTW between all test points to all training points & decide the
% class according to the minimum distance between testpoints &
% trainingpoints
%[classAssignments] = performTestDTW(trainData, trainClassSequences, testClassSequences);

[classLogLikelihoods, classAssignments] = performTestHMM(trainData, trainClassSequences, testClassSequences, numClasses, K);

accuracy(3) = calcStats(actualLabels, classAssignments, numClasses);

% plot ROC and DET curves
ROC{:, 3} = plotROCcurve(actualLabels, classLogLikelihoods, numClasses);
plotDETcurve(actualLabels, classLogLikelihoods, numClasses);

close all;

for classIndex = 1: numClasses
    figure;
    GMM_roc_fullcovar = ROC{:, 1}; GMM_roc_fullcovar = GMM_roc_fullcovar{classIndex, :};
    plt(1) = plot(GMM_roc_fullcovar(:, 1), GMM_roc_fullcovar(:, 2), 'r');

    hold on;
    GMM_roc_diagcovar = ROC{:, 2}; GMM_roc_diagcovar = GMM_roc_diagcovar{classIndex, :};
    plt(2) = plot(GMM_roc_diagcovar(:, 1), GMM_roc_diagcovar(:, 2), 'g');        

    hold on;
    HMM_roc = ROC{:, 3}; HMM_roc = HMM_roc{classIndex, :};
    plt(3) = plot(HMM_roc(:, 1), HMM_roc(:, 2), 'b');  

    currTitle = strcat('ROC curve:    ', titleString{:}, '- Class- ', num2str(classIndex));
    title(currTitle);
    xlabel('False positive rate');
    ylabel('True positive rate');
    legend(plt, {strcat('GMM with full covariance(', sprintf('%.2f', accuracy(1)), '%)'), strcat('GMM with diagonal covariance (', sprintf('%.2f', accuracy(2)), '%)'), strcat('HMM(', sprintf('%.2f', accuracy(3)), '%)')});
    legend show;  
end

end



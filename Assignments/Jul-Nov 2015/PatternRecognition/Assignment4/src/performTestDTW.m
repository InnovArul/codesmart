function [ classAssignments ] = performTestDTW( K )
%PERFORMTESTDTW Summary of this function goes here
%   Detailed explanation goes here

classPaths = {'data/mandi/Nagercoil','data/mandi/Namakkal','data/mandi/Nilgiris','data/mandi/Perambalur',...
'data/mandi/Pudukkottai','data/mandi/Ramanathapuram','data/mandi/Salem','data/mandi/Sivaganga',...
'data/mandi/Thanjavur','data/mandi/Theni','data/mandi/Thiruchirappalli','data/mandi/Thirunelveli',...
'data/mandi/Thiruvallur','data/mandi/Thiruvannamalai','data/mandi/Thiruvarur','data/mandi/Tirupur',...
'data/mandi/Tuticorin','data/mandi/utagamandalam','data/mandi/Vellore','data/mandi/Villupuram',...
'data/mandi/Virudhunagar','data/mandi/Nagapattinam','data/mandi/Ariyalur','data/mandi/Chennai',...
'data/mandi/Dindigul','data/mandi/Erode','data/mandi/Kancheepuram','data/mandi/Karur',...
'data/mandi/Krishnagiri','data/mandi/Madurai','data/mandi/Coimbatore','data/mandi/Cuddalore',...
'data/mandi/Dharmapuri'};

trainData = []; testData = []; 
k_means_mu_k = [];
numClasses = 0;

% read the dataset
numClasses = size(classPaths, 2);
                
for classIndex = 1:numClasses
    directory = classPaths{classIndex};
    disp(directory);
    data = loadDataMandi(directory, classIndex);
    [newTrainData, newTestData] = splitIntoTrainAndTestData(data);
    trainData = [trainData; newTrainData]; testData = [testData; newTestData];

    currentTrainData = collectAllDataFromStruct(newTrainData);

    % pre cluster for this class
    [k_means_mu_k{classIndex, 1}, assignments] = k_means_cluster(currentTrainData, K);  


    %print number of points in each cluster
    for index = 1:K
       disp(strcat('cluster-', num2str(index), ' : ', num2str(sum(assignments==index))));    
    end

end


%Perform DTW test
trainClassSequences = calcDataClassSequences(trainData, k_means_mu_k);
testClassSequences = calcDataClassSequences(testData, k_means_mu_k);

totalTestData = size(testClassSequences, 1);
totalTrainingData = size(trainClassSequences, 1);

testTainingMatch = [];
for testIndex = 1:totalTestData
   testToTrainingDist = [];
   parfor trainIndex = 1:totalTrainingData
       testToTrainingDist(trainIndex, 1) = dtw(trainClassSequences{trainIndex, 1}, testClassSequences{testIndex, 1}, 1);
   end
   [~, testTainingMatch(testIndex, 1)] = min(testToTrainingDist, [], 1);
end

% assign the class of particular training example which has minimum
% distance to the test sample
for testIndex = 1:totalTestData
    classAssignments(testIndex, :) = trainData(testTainingMatch(testIndex, 1)).class;
end

actualLabels = collectAllClassesFromStruct(testData);

calcStats(actualLabels, classAssignments, numClasses);
end


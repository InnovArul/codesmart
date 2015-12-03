function [ classLogLikelihoods, classAssignments ] = doallHMM( trainData, trainClassSequences, testClassSequences, numClasses, numClusters )
%DOALLHMM Summary of this function goes here
%   Detailed explanation goes here

%write the training sequences in trainX files
for classIndex = 1:numClasses
    %get the relevant sequences for particular class
    currentData = trainClassSequences([trainData.class]==classIndex); 
    filename = strcat('hmm/train_class', num2str(classIndex), '.txt');
   
    fileID = fopen(filename, 'w');
    for trainIndex = 1 : size(currentData, 1)
        fprintf(fileID, '%d ', currentData{trainIndex, 1});
        fprintf(fileID, '\n');
    end
    
    fclose(fileID);
    
    %call the train_hmm executable to train the HMM
    %prepare the command line string
    commandString = '';
    commandString = strcat(commandString, strcat('hmm/train_class', num2str(classIndex), '.txt'));
    commandString = strcat('./hmm/train_hmm', {' '}, commandString, {' '}, num2str(1000), {' '}, num2str(6), {' '}, num2str(numClasses + 1), {' '}, num2str(0.2));
    system(commandString{1});
end


% write the test sequence to test file
filename = 'hmm/testdata.txt';
fileID = fopen(filename, 'w');
    for testIndex = 1 : size(testClassSequences, 1)
        fprintf(fileID, '%d ', testClassSequences{testIndex, 1});
        fprintf(fileID, '\n');
    end
fclose(fileID);
    
%call test_hmm executable to test each model (remember to rename or read
%the file contents of alphafile before calling test_hmm again with other
%model
%for each class, test the data
classLogLikelihoods = [];

for classIndex = 1:numClasses
    commandString = '';
    commandString = strcat(commandString, strcat('hmm/train_class', num2str(classIndex), '.txt'));
    commandString = strcat('./hmm/test_hmm', {' '}, filename, {' '}, commandString, '.hmm');
    system(commandString{1});
    
    logLikelihood = load('alphaout');
    classLogLikelihoods(:, classIndex) = logLikelihood';    
end

%from the contents of alphaout file class pribabilities, calculate the class
%assignments

[~, classAssignments] = max(classLogLikelihoods, [], 2);

end


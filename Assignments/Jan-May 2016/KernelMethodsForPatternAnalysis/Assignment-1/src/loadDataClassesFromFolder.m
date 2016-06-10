function [ trainData, testData, validationData ] = loadDataClassesFromFolder( classes, path )
%LOADDATACLASSESFROMFOLDER loaded data sets belonging to classes

classNumber = 1;
trainData = [];
testData = [];
validationData = [];

for index = 1:length(classes) 
    % split the current data into train, test, validation parts &
    % store it in corresponding buffers
    classIndex = classes{index};
    filePrefix = strcat(path, 'class', num2str(classIndex), '_');

    trainFile = strcat(filePrefix, 'train.txt');
    currentTrainData = load(trainFile);
    testFile = strcat(filePrefix, 'test.txt');
    currentTestData = load(testFile);
    validationFile = strcat(filePrefix, 'val.txt');
    currentValidationData = load(validationFile);

    currentTrainData(:, end+1) = classNumber;
    currentTestData(:, end+1) = classNumber;
    currentValidationData(:, end+1) = classNumber;

    % store the data into buffer
    trainData = [trainData; currentTrainData];
    testData = [testData; currentTestData];
    validationData = [validationData; currentValidationData];

    %increment the class count
    classNumber = classNumber + 1;
end           
end


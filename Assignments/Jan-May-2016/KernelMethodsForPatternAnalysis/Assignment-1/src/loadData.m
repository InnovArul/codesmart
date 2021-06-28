function [ trainData, testData, validationData ] = loadData( type )
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

global IMAGE_DATA LINEARLY_SEPARABLE NON_LINEARLY_SEPARABLE OVERLAPPING REPORTFOLDER DATA_TITLE BIVARIATE UNIVARIATE;
global BIVARIATE_100 UNIVARIATE_100;

IMAGE_DATA = 1;
LINEARLY_SEPARABLE = 2;
NON_LINEARLY_SEPARABLE = 3;
OVERLAPPING = 4;
BIVARIATE = 5;
UNIVARIATE = 6;
BIVARIATE_100 = 7;
UNIVARIATE_100 = 8;

trainData = [];
testData = [];
validationData = [];

switch(type)
    case IMAGE_DATA
        %update report folder
        REPORTFOLDER = fullfile(REPORTFOLDER, 'imagedata');
        DATA_TITLE = 'image data';
        path = '../data/Classification/imagedata/CompleteData.mat';
        data = load(path);
        data = data.CompleteData;
        
        imageIndices = {14, 2, 17, 20, 11};
        
        classNumber = 1;
        
        for index = 1:length(imageIndices) 
            % split the current data into train, test, validation parts &
            % store it in corresponding buffers
            imageIndex = imageIndices{index};
            currentData = data{imageIndex, 1};
            disp(data{imageIndex, 2})
            [currentTrainData, currentTestData, currentValidationData] = splitDataIntoParts(currentData);
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
        
    case LINEARLY_SEPARABLE
        %update report folder
        REPORTFOLDER = fullfile(REPORTFOLDER, 'linearlyseparable');
        DATA_TITLE = 'linearly separable data';
        
        path = '../data/Classification/linearlyseparable_data/group14/';
        classes = {1, 2, 3};
        [trainData, testData, validationData] = loadDataClassesFromFolder(classes, path);


    case NON_LINEARLY_SEPARABLE
        %update report folder
        REPORTFOLDER = fullfile(REPORTFOLDER, 'nonlinearlyseparable');
        DATA_TITLE = 'non linearly separable data';
        
        path = '../data/Classification/nonlinearlyseparable_data/group14/';
        classes = {1, 2, 3};
        [trainData, testData, validationData] = loadDataClassesFromFolder(classes, path);

    case OVERLAPPING
        %update report folder
        REPORTFOLDER = fullfile(REPORTFOLDER, 'overlapping_data');
        DATA_TITLE = 'overlapping data';
        
        path = '../data/Classification/overlapping_data/group14/';
        classes = {1, 2, 3, 4};
        [trainData, testData, validationData] = loadDataClassesFromFolder(classes, path);
        
    case BIVARIATE
        %update report folder
        REPORTFOLDER = fullfile(REPORTFOLDER, 'bivariate');
        DATA_TITLE = 'bivariate continuous data';
        
        path = '../data/Regression/Bivariate/group14/bivariateData/';
        filePrefix = strcat(path, 'group14_');
            
        trainFile = strcat(filePrefix, 'train.txt');
        trainData = load(trainFile);
        testFile = strcat(filePrefix, 'test.txt');
        testData = load(testFile);
        validationFile = strcat(filePrefix, 'val.txt');
        validationData = load(validationFile);
        
    case UNIVARIATE
        %update report folder
        REPORTFOLDER = fullfile(REPORTFOLDER, 'univariate');
        DATA_TITLE = 'univariate continuous data';
        
        path = '../data/Regression/Univariate/';
        filePrefix = strcat(path, 'FinalUniData.mat');
        
        Data=load(filePrefix);
        trainData=Data.train;
        validationData=Data.val;
        testData=Data.test;
             
        %trainFile = strcat(filePrefix, 'train.txt'); trainData = load(trainFile); 
        trainData = trainData(:, 1:2);
        %testFile = strcat(filePrefix, 'test.txt'); testData = load(testFile); 
        testData = testData(:, 1:2);
        %validationFile = strcat(filePrefix, 'val.txt'); validationData = load(validationFile);  
        validationData = validationData(:, 1:2);     
        
    case BIVARIATE_100
        %update report folder
        REPORTFOLDER = fullfile(REPORTFOLDER, 'bivariate100');
        DATA_TITLE = 'bivariate continuous data (100 points)';
        
        path = '../data/Regression/Bivariate/group14/bivariateData/';
        filePrefix = strcat(path, 'group14_');
            
        trainFile = strcat(filePrefix, 'train100.txt');
        trainData = load(trainFile);
        testFile = strcat(filePrefix, 'test.txt');
        testData = load(testFile);
        validationFile = strcat(filePrefix, 'val.txt');
        validationData = load(validationFile);        
        
    case UNIVARIATE_100
        %update report folder
        REPORTFOLDER = fullfile(REPORTFOLDER, 'univariate100');
        DATA_TITLE = 'univariate continuous data (100 points)';
        
        path = '../data/Regression/Univariate/';
        filePrefix = strcat(path);
            
        trainFile = strcat(filePrefix, 'train100.txt');
        trainData = load(trainFile); trainData = trainData(:, 1:2);
        testFile = strcat(filePrefix, 'test.txt');
        testData = load(testFile); testData = testData(:, 1:2);
        validationFile = strcat(filePrefix, 'val.txt');
        validationData = load(validationFile);  validationData = validationData(:, 1:2);             
        
end

%create the report folder
mkdir(REPORTFOLDER);

end


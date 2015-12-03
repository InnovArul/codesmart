function [trainData, testData, noOfClasses] = loadData(option)
% 1 = linearly separable
% 2 = non-linearly separable
% 3 = overlapping
% 4 = real world data

global priors;

switch(option)
    case 1
        %add a column
        COUNT = 500;
        
        % API to load the dataset
        data = importdata('data/ls_group12_linearlySeparable.txt'); %od_group12_overlapping.txt');

        %calculate the number of classes
        noOfClasses = size(data, 1) / COUNT;
        disp(strcat('total number of classes : ', num2str(noOfClasses)));

        %prepare class content array
        classContents = repmat(1:noOfClasses, [COUNT 1]);

        %assign the class numbers to the last column
        data(:, size(data, 2) + 1) = classContents(:);
    
    case 2
        % API to load the dataset
        folderpath = 'data/nonlinear_separable/'; %od_group12_overlapping.txt');

        %calculate the number of classes
        noOfClasses = 0;
        
        data = [];
        
        while(1)
           noOfClasses = noOfClasses + 1;
           filename = strcat(folderpath, 'Class', num2str(noOfClasses), '.txt');
           
           if(exist(filename, 'file') == 2)
               tempData = importdata(filename);
               tempData(:, size(tempData, 2)+1) = noOfClasses;
               data = [data; tempData];
           else
               noOfClasses = noOfClasses - 1;
               disp(strcat('total number of classes : ', num2str(noOfClasses)));
               break
           end
               
        end
        
    case 3
        %add a column
        COUNT = 500;

        % API to load the dataset
        data = importdata('data/od_group12_overlapping.txt'); %od_group12_overlapping.txt');

        %calculate the number of classes
        noOfClasses = size(data, 1) / COUNT;
        disp(strcat('total number of classes : ', num2str(noOfClasses)));

        %prepare class content array
        classContents = repmat(1:noOfClasses, [COUNT 1]);

        %assign the class numbers to the last column
        data(:, size(data, 2) + 1) = classContents(:);
        
    case 4
          % API to load the dataset
        folderpath = 'data/realworld/'; %od_group12_overlapping.txt');

        %calculate the number of classes
        noOfClasses = 0;
        
        data = [];
        
        while(1)
           noOfClasses = noOfClasses + 1;
           filename = strcat(folderpath, 'Class', num2str(noOfClasses), '.txt');
           
           if(exist(filename, 'file') == 2)
               tempData = importdata(filename);
               tempData(:, size(tempData, 2)+1) = noOfClasses;
               data = [data; tempData];
           else
               noOfClasses = noOfClasses - 1;
               disp(strcat('total number of classes : ', num2str(noOfClasses)));
               break
           end
               
        end
end

noOfRows = size(data, 1);
noOfColumns = size(data, 2);

trainData = [] ; %zeros(noOfClasses * TRAIN_SAMPLES, noOfColumns);
testData = []; % zeros(noOfClasses * TEST_SAMPLES, noOfColumns);

% collect trainData & testData
for classNumber = 1:noOfClasses
   currentData = data(data(:, end) == classNumber, :);
   total = size(currentData, 1);
   testTotal = uint32(total * 0.25);
   trainData = [trainData; currentData(1 : size(currentData, 1) - testTotal, :)];
   testData = [testData; currentData(size(currentData, 1) - testTotal + 1:size(currentData, 1), :)];
end



totalTrainingDataRows = size(trainData, 1);
disp(strcat('total Training Data Rows : ', num2str(totalTrainingDataRows)));
disp(strcat('total Test Data Rows : ', num2str(size(testData, 1))));
priors = zeros(noOfClasses, 1);
% calculate priors
for classNumber = 1:noOfClasses
    currentData = data(data(:, end) == classNumber, :);
    priors(classNumber) = size(currentData, 1) / totalTrainingDataRows;  
end
end
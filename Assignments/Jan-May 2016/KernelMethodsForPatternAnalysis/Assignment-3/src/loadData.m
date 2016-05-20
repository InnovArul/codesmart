function [trainData, validationData, testData] = loadData(dataType)

global REPORTPICSFOLDER;
trainData = [];
validationData = [];
testData = [];

if(dataType == options.DATASET3)
    filepath = '../data/Dataset3/class';
    
    allData = {};
    fig = figure;
    % read all the data and plot them
    for classNumber = 1:4 
        allData{classNumber} = containers.Map;
        filename = strcat(filepath, num2str(classNumber), '_train.txt');
        allData{classNumber}('train') = load(filename);
        filename = strcat(filepath, num2str(classNumber), '_val.txt');
        allData{classNumber}('val') = load(filename);
        filename = strcat(filepath, num2str(classNumber), '_test.txt');
        allData{classNumber}('test') = load(filename); 
        
        trainPoints = allData{classNumber}('train');
        scatter(trainPoints(:,1), trainPoints(:,2), 'fill');
        hold on;
    end
    
    legend('class1', 'class2', 'class3', 'class4');
    legend show;
    saveas(fig, fullfile(REPORTPICSFOLDER, 'dataset3_snap.jpg'));
    close(fig);
    
    %choose class1 for one class SVM
    class1TrainData = allData{1}('train');
    trainData = [class1TrainData ones(size(class1TrainData, 1), 1)];
    
    %get validation, test data from uniform samples of other class data
    % 10% of data from each class for validation and test 
    validationData = getFractionOfData(allData, 'val', 1);
    testData = getFractionOfData(allData, 'test', 1);
elseif(dataType == options.DATASET4)
    filepath = '../data/Dataset4/Breast_benign.mat';
    allData = load(filepath);
    
    features = allData.Data;
    labels = allData.labels;
    labels(labels == 1) = -1;
    labels(labels == 2) = 1;
    features = [features labels];
    
    normalData = features(labels==1, :);
    abnormalData = features(labels==-1, :);
    
    [tempTrain, tempValidation, tempTest] = getPartitionedData(normalData);
    trainData = [trainData; tempTrain]; validationData = [validationData; tempValidation]; testData = [testData; tempTest];
    abnormalCount = size(abnormalData, 1);
    halfAbnormalCount = floor(abnormalCount / 2);
    validationData = [validationData; abnormalData(1:halfAbnormalCount, :)]; testData = [testData; abnormalData(halfAbnormalCount+1:end, :)];
else
    filepath = '../data/graphdata/NCI1.mat';
    allData = load(filepath);
    graphData = allData.NCI1;
        
    for index = 1 : length(graphData)
        graphData(index).label = allData.lnci1(index) + 1;
    end
    
    class1Data = graphData([graphData.label]==1);
    class2Data = graphData([graphData.label]==2);
    
    for index = 1:length(class2Data)
        class2Data(index).label = -1;
    end

    [trainData, validationData, testData] = getPartitionedData(class1Data');
    [temptrainData, tempvalidationData, temptestData] = getPartitionedData(class2Data');
    trainData = [trainData; temptrainData];
    testData = [testData; temptestData];
    validationData = [validationData; tempvalidationData];
    
end

end
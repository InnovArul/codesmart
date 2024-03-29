function [trainData, validationData, testData] = getPartitionedData(data)
    data = data(randperm(size(data,1)),:); 
    totalData = size(data, 1);
    trainDataCount = floor(0.75 * totalData);
    validationDataCount = floor(0.5 * (totalData - trainDataCount));
    
    trainData  = data(1:trainDataCount, :);
    validationData = data(trainDataCount+1:trainDataCount+validationDataCount, :);
    testData = data(trainDataCount+validationDataCount+1 : totalData, :);
    
end
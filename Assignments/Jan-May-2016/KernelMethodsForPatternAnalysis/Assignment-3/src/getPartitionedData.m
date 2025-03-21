function [trainData, validationData, testData] = getPartitionedData(data, limit)
    totalData = size(data, 1);
    if(exist('limit', 'var'))
        totalData = limit;
    end

    data = data(randperm(size(data,1)),:); 
    trainDataCount = floor(0.7 * totalData);
    validationDataCount = floor(0.1 * totalData);
    
    trainData  = data(1:trainDataCount, :);
    validationData = data(trainDataCount+1:trainDataCount+validationDataCount, :);
    testData = data(trainDataCount+validationDataCount+1 : totalData, :);
   
end
function [trainData, validationData, testData] = splitIntoTrainAndTest(data)

classData = containers.Map;

for dataIndex = 1:size(data, 1)
   currentData = data(dataIndex, :);
   currentKey = num2str(currentData(end));
   
   if(~isKey(classData, currentKey))
       classData(currentKey) = [];
   end
   classData(currentKey) = [classData(currentKey); currentData];
end

keyClasses = keys(classData);

trainData = [];
testData = [];
validationData = [];

for classNumber = keyClasses
   [currTrainData, currValidationData, currTestData] = getPartitionedData(classData(classNumber{:}));
    trainData = [trainData; currTrainData];
    validationData = [validationData; currValidationData];
    testData = [testData; currTestData];
end

end
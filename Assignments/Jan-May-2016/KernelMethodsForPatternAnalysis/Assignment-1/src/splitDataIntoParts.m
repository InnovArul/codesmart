function [ trainData, testData, validationData ] = splitDataIntoParts( data )
%SPLITDATAINTOPARTS split the data into 3 parts (train, test, validation)

% determine number of total examples
totalRows = size(data, 1);
permIndices = randperm(totalRows);

% determine counts for train, test, validation sets
trainCount = round(0.7 * totalRows);
remaining = totalRows - trainCount;
testCount = remaining - round(remaining / 2);
validationCount = remaining - testCount;

% split the data sccording to the count determined
trainData = data(1:trainCount, :);
testData = data(trainCount + 1:trainCount + testCount, :);
validationData = data(trainCount + testCount + 1:trainCount + testCount + validationCount, :);

end

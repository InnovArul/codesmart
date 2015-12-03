function [ dataCollector ] = savePcaFeaturesIntoStruct(wholeDataStructs, pcaFeatures)
    
countSoFar = 0;
dataCollector = [];

for dataIndex = 1:numel(wholeDataStructs)
   %get the current structure
   currStruct = wholeDataStructs(dataIndex, 1);
   startIndex = countSoFar + 1;
   
   % get the current structure data
   currStructData = currStruct.contents;
   endIndex = countSoFar + size(currStructData, 1);
   
   %assign the pca features to structure
   currStruct.pca = pcaFeatures(startIndex:endIndex, :);
   dataCollector = [dataCollector; currStruct];
   
   countSoFar = endIndex;
end

end


function [ data ] = collectAllDataFromStruct( structure, classIndex )
%COLLECTALLDATAFROMSTRUCT Summary of this function goes here
%   Detailed explanation goes here

data = [];
if(~exist('classIndex', 'var'))
   classIndex = 0; 
end

for elementIndex = 1 : numel(structure)
    if(classIndex)
        if(structure(elementIndex).class == classIndex)
            data = [data; structure(elementIndex).contents];
        end
    else
        data = [data; structure(elementIndex).contents];
    end
end

end


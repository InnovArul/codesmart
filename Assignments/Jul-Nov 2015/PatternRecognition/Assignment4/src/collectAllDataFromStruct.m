function [ data ] = collectAllDataFromStruct( structure, classIndex, contentField )
%COLLECTALLDATAFROMSTRUCT Summary of this function goes here
%   Detailed explanation goes here

data = [];
if(~exist('classIndex', 'var'))
   classIndex = 0; 
end

if(~exist('contentField', 'var'))
   contentField = 'contents'; 
end

for elementIndex = 1 : numel(structure)
    if(classIndex)
        if(structure(elementIndex).class == classIndex)
            data = [data; getfield(structure(elementIndex), contentField)];
        end
    else
        data = [data; getfield(structure(elementIndex), contentField)];
    end
end

end



function [ classes ] = collectAllClassesFromStruct( structure, isFeatureClasses)
%COLLECTALLCLASSESFROMSTRUCT Summary of this function goes here
%   Detailed explanation goes here

classes = [];

if(~exist('isFeatureClasses', 'var'))
   isFeatureClasses = 0; 
end

for elementIndex = 1 : numel(structure)
    currClasses = [];
    if(isFeatureClasses == 0)
       currClasses = structure(elementIndex).class; 
    else
        count = size(structure(elementIndex).contents, 1);
        currClasses = repmat(structure(elementIndex).class, count, 1);
    end
    
    classes = [classes; currClasses];
end

end



function [ classes ] = collectAllClassesFromStruct( structure )
%COLLECTALLCLASSESFROMSTRUCT Summary of this function goes here
%   Detailed explanation goes here

classes = [];

for elementIndex = 1 : numel(structure)
    classes = [classes; structure(elementIndex).class];
end

end


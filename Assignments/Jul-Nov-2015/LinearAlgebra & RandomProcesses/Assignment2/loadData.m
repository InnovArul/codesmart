function [ data, width, height ] = loadData()
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

files = getAllFiles('ORL');

data = [];

files = sort(files);

for fileIndex = 1 : numel(files)
    % determine the class number
    parentDir = fileparts(files{fileIndex});
    classStr = regexp(parentDir, '\d*$', 'match');
    currClass = str2num(classStr{:});
    
    % read the file
    img = imread(files{fileIndex});
    [width, height] = size(img);
    img = img(:);
    
    % append the data
    data = [data; img' currClass];

end

% assert 40 classes
assert(size(unique(data(:, end)), 1) == 40, 'number of class is not equal to 40 ');

end


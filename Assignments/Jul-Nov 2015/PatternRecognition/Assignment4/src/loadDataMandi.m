function [data] = loadDataMandi( directory, classNumber)
%LOADDATAMANDI load the data from Mandi dataset


filenames = getAllFiles(directory, '*.mfcc');

data = [];

% loop through all the files and read the data
for fileIndex = 1 : numel(filenames)
    %disp(strcat(filenames{fileIndex}));
    
    % read file contents
    filecontents = fileread(filenames{fileIndex});
    
    %parse the string as numbers
    fileNumbers = strread(filecontents, '%f', 'delimiter', sprintf('\n'));
    dimension = fileNumbers(1);
    examples = fileNumbers(2);
    
    %disp(size(fileNumbers));
    
    %remove the length from file contents
    currentData = fileNumbers(3:end);
    currentData = reshape(currentData, examples, dimension);
    
    % insert the class number and collect the data
    data(fileIndex).contents = currentData;
    data(fileIndex).class = classNumber;
    
end

data = data';

end


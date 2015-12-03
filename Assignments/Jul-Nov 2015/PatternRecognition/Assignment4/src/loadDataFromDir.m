function [ data ] = loadDataFromDir( directory, classNumber )
%LOADDATA load the data from the files in given directory

    filelist = getAllFiles(directory);
    data = [];

    % read all the file contents and prepare the dataset
    for fileIndex = 1 : length(filelist)
       fileName = filelist{fileIndex};
       newData = load(fileName); 
       
       %create a structure and store the data
       data(fileIndex).contents = newData(:)';
%        data(fileIndex).contents = newData;
       data(fileIndex).class = classNumber;
    end

    data = data';
end


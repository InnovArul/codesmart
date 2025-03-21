function fileList = getAllFiles(dirName, extn)
%%
% dirName = the directory from which all the filenames to be read
% extn = extension for the filenames to be considered
%

    % predefine the extn if the parameter is not given
    if(~exist('extn', 'var'))
        extn = '';
    end

    dirData = dir(strcat(dirName, '/', extn));      %# Get the data for the current directory
    dirIndex = [dirData.isdir];  %# Find the index for directories
    fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
    if ~isempty(fileList)
        fileList = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
                       fileList,'UniformOutput',false);
    end
    
    subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
    validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
    for iDir = find(validIndex)                  %# Loop over valid subdirectories
        nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
        fileList = [fileList; getAllFiles(nextDir)];  %# Recursively call getAllFiles
    end

end
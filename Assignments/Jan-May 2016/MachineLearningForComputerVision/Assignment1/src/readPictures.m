function [data, width, height] = readPictures(rootFolder, folder)
%readPictures to read all the pictures from the given directory

% read all the filenames from the given folder
fullFoldername = fullfile(rootFolder, folder);
allFiles = getAllFiles(fullFoldername);
data = [];

% read all the files
for index = 1:size(allFiles, 1)
    img = imread(allFiles{index});
   
    %save the width and height
    if(index == 1)
        [width, height] = size(img);
    end
    
    data(:, index) = im2double(img(:));
end

assert(width == 28 && height == 28, 'width and height of the pictures are not 28 x 28');

end
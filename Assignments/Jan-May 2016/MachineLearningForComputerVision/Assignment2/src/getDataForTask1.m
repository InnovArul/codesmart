function [imgData] = getDataForTask1(imageOption)
% get the image based on the option

global DATAFOLDER IMAGEFILE;

rioFile = 'rio.png';
spectrumFile = 'spectrum.png';

% load image based on option
if(imageOption == options.IMAGE_RIO)
    IMAGEFILE = rioFile;
else
    IMAGEFILE = spectrumFile;
end

filepath = fullfile(DATAFOLDER, IMAGEFILE);

%load the image data
imgData = imread(filepath);

end
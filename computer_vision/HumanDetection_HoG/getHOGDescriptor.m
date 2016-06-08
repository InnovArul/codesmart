function [ H ] = getHOGDescriptor( grayimage )
%GETHOGDESCRIPTOR API to calculate the HOG descriptor

% find gradients gradients dx, dy
filterx = [-1 0 1];
filtery = filterx';

% insert a 0 row & column surrounding the picture

%prepend column
grayimage = [zeros(1, length(grayimage))' grayimage];
%append column
grayimage = [grayimage zeros(1, length(grayimage))];

% prepend row
grayimage = [zeros(1, length(grayimage)); grayimage];
%append row
grayimage = [grayimage; zeros(1, length(grayimage));];

imdx = imfilter(grayimage, filterx);
imdy = imfilter(grayimage, filtery);

% now remove appended, prepended rows, columns
imdx = imdx(2:end - 1, 2:end-1);
imdy = imdy(2:end - 1, 2:end-1);

% calculate the magnitude
imGradMagnitude = (imdx .^ 2 + imdy .^ 2) .^ 0.5;

% find orientations
imOrientations = atan2(dy ./ dx);

% number of blocks
cellWidth = 8;
numHorizontalCells = 16;
numVerticalCells = 8;
histPerCell = 9;

histograms = zeros(numHorizontalBlocks, numVerticalBlocks, histPerCell);

for rowIndex = 0 : numVerticalCells
    for columnIndex = 0 : numHorizontalCells
        % get the magnitude and orientation for current cell
        currCellRows = ((rowIndex * cellWidth) + 1) : (rowIndex + 1) * cellWidth;
        currCellColumns = ((columnIndex * cellWidth) + 1) : (columnIndex + 1) * cellWidth;
        magnitudes = imGradMagnitude(currCellRows, currCellColumns);
        orientations = imOrientations(currCellRows, currCellColumns);
        
        histograms(rowIndex + 1, columnIndex + 1, :) = getHistogram(magnitudes, orientations, histPerCell);
    end
end

end


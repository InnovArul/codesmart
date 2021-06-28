function patch = getNeighborhood(img, rowNumber, columnNumber, patchWidth)
% return the patch with neighborhood size of 'B' and centereed at
% 'rowIndex, columnIndex'

[nrows, ncols, depth] = size(img);
patch = zeros(patchWidth, patchWidth, depth);
halfPatchWidth = floor(patchWidth/2);

for rowIndex = rowNumber - halfPatchWidth : rowNumber + halfPatchWidth
    patchRowIndex = rowIndex - (rowNumber - halfPatchWidth) + 1;
    for columnIndex = columnNumber - halfPatchWidth : columnNumber + halfPatchWidth
        patchColumnIndex = columnIndex - (columnNumber - halfPatchWidth) + 1;
        
        %check if the pixel location is valid neighborhood, if so, add the
        %pixel value to patch
        if(rowIndex >= 1 && rowIndex <= nrows && columnIndex >= 1 && columnIndex <= ncols)
            patch(patchRowIndex, patchColumnIndex, :) = img(rowIndex, columnIndex, :);
        end
    end
end

end
function [Dc_L1, Dc_L2] = getDataCost(im0, im1, d_list, patchSize);

    k = length(d_list);
    [nrows, ncols, channels] = size(im0);
    % Initialize data cost matrix
    Dc_L1 = ones(nrows,ncols,k);
    Dc_L2 = ones(nrows,ncols,k);    
    
    parfor rowIndex = 1:nrows
        rowL1error = zeros(ncols, length(d_list));
        rowL2error = zeros(ncols, length(d_list));
        for columnIndex = 1:ncols
                % retrieve source patch
                sourcePatch = getNeighborhood(im0, rowIndex, columnIndex, patchSize);

            for depth = 1:length(d_list)

                if(columnIndex <= ncols)
                    % retrieve target patch
                    targetPatch = getNeighborhood(im1, rowIndex, columnIndex + depth - 1, patchSize);
                    difference = sourcePatch - targetPatch;

                    % determine L1 difference
                    rowL1error(columnIndex, depth) = mean(abs(difference(:)));

                    % determine L2 difference
                    L2difference = difference .* difference;
                    rowL2error(columnIndex, depth) = mean(L2difference(:));
                else
                    %assign 1
                    rowL1error(columnIndex, depth) = 1;
                    rowL2error(columnIndex, depth) = 1;
                end
            end
        end
        Dc_L1(rowIndex, :) = rowL1error(:);
        Dc_L2(rowIndex, :) = rowL2error(:);
    end
end
clc;
clear;
close all;
REPORTPICSFOLDER = '../report/pics/';
IMAGENAME = {'tsukuba', 'ppm'};

% Read stereo images
im0 = double(imread(strcat(IMAGENAME{1}, '0.', IMAGENAME{2}))) / 255;
im1 = double(imread(strcat(IMAGENAME{1}, '1.', IMAGENAME{2}))) / 255;

sz = size(im0);
nrows = sz(1);
ncols = sz(2);

% Read ground truth depth map for im
dm = double(imread('disp0.pgm'));

% Number of depth levels
k = 31;

% Pixel translations for the depth levels
d_list = linspace(0,30,k);

% =========================================================================
% Half patch size  (Patch size P = 2B+1)
patchSizes = [1, 3, 5, 11, 21];
B = 1; % vary the patch size here for example 3X3 patch size, set B=1 and for 5X5 patch size, set B=2, etc.
% =========================================================================

% Initialize data cost matrix
Dc_L1 = ones(nrows,ncols,k);
Dc_L2 = ones(nrows,ncols,k);

L1errorHistory = [];
L2errorHistory = [];

% =========================================================================
% Write code to form the data cost matrix Dc where Dc(i,j,index(d)) is the
% error between the patch at (i,j) in im0 and the patch at
% (i,j+d) in im1 (i = ith row, j = jth column) where d belongs to d_list.
%
% Error can be l1-error (mean absolute error) i.e. mean(abs(x-y))
% or
% squared-l2-error (mean square error) i.e. mean((x-y).^2)
%
% Note: If the patch in im1 goes outside the image coordinates, assign a
% cost of 1 (which is the maximum).
% Return two matrices Dc_L1 and Dc_L2 here.
% =========================================================================
for patchSize = patchSizes
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
    
    %determine the disparity
    [~, dm_est_L1] = min(Dc_L1, [], 3); % estimate dm from Dc_L1 as that Pixel translations giving minimum L1 error
    [~, dm_est_L2] = min(Dc_L2, [], 3); %estimate dm from Dc_L2 as that Pixel translations giving minimum L2 error

    fig = figure;
    subplot(311); imshow(uint8(dm_est_L1*8)); title(strcat(IMAGENAME{1}, '- Patch size : ', num2str(patchSize), ' - L1 error'));
    subplot(312); imshow(uint8(dm_est_L2*8)); title(strcat(IMAGENAME{1}, '- Patch size : ', num2str(patchSize), ' - L2 error'));
    saveas(fig, fullfile(REPORTPICSFOLDER, strcat(IMAGENAME{1}, '_disparity_patchsize_', num2str(patchSize), '.jpg')));
    close(fig);
    
    % note down L1error and L2 error from Ground truth 
    if(strcmp(IMAGENAME{1}, 'map'))
        % scaling is applied as 8 to match the ground truth depth values
        L1error = sqrt(sum( (dm_est_L1(:)*8 - dm(:)).^2 ) / numel(dm_est_L1));
        L2error = sqrt(sum( (dm_est_L2(:)*8 - dm(:)).^2 ) / numel(dm_est_L2));
        fprintf(1, 'L1-Error=%.4f\n', L1error);
        fprintf(1, 'L2-Error=%.4f\n', L2error);

        L1errorHistory = [L1errorHistory L1error];
        L2errorHistory = [L2errorHistory L2error];
    end

end

% create L1error vs L2error plot
if(strcmp(IMAGENAME{1}, 'map'))
    fig = figure;
    plot(patchSizes, L1errorHistory, 'LineWidth', 1.5);
    hold on;
    plot(patchSizes, L2errorHistory, 'LineWidth', 1.5);
    legend('L1 error', 'L2 error'); legend show;
    title(strcat(IMAGENAME{1}, '- L1 error vs. L2 error'));
    xlabel('Patch width'); ylabel('Error magnitude'); 
    saveas(fig, fullfile(REPORTPICSFOLDER, strcat(IMAGENAME{1}, '_error_vs_patchsize.jpg')));
    close(fig);
end


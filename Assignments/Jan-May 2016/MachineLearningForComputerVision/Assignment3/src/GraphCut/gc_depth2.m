clc;
clear all;
close all;
REPORTPICSFOLDER = '../report/pics/';

IMAGENAME = {'tsukuba', 'ppm'};

% Read stereo images
im0 = double(imread(strcat(IMAGENAME{1}, '0.', IMAGENAME{2}))) / 255;
im1 = double(imread(strcat(IMAGENAME{1}, '1.', IMAGENAME{2}))) / 255;

sz = size(im0);
nrows = sz(1);
ncols = sz(2);

% Number of depth levels
k = 31;

% Pixel translations for the depth levels
d_list = linspace(0,30,k);

% Half patch size (Patch size P = 2B+1)
B = 1;

% =========================================================================
% Write code to form the data cost matrix Dc. Use the code from simple_depth.m
patchSize = 5;
[Dc_L1, Dc_L2] = getDataCost(im0, im1, d_list, patchSize);
Dc = {}; Dc{1} = Dc_L1; Dc{2} = Dc_L2;

% =========================================================================

% Smoothness cost
Sc = ones(k) - eye(k);

tradeOffParams = [1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 0.1, 0.5, 1, 2, 10];

% =========================================================================
% Write a loop here to balance the Dc and Sc cost values appropriately
% using a reg parameter p so that the error with respect to the ground
% truth depthmap is minimum. 
LxErrors = {};

for typeOfError = [1, 2]
    currentDc = Dc{typeOfError};

    count = 1;
    for p = tradeOffParams
        gch = GraphCut('open', currentDc, p*Sc);
        [gch, L] = GraphCut('expand',gch);
        gch = GraphCut('close', gch);

        % Map the labels to intensities
        Lest = double(L);
        for i = 1:k
            Lest(L==i) = d_list(i) * 8;
        end

        fig = figure;
        imshow(uint8(Lest));
        title(strcat('L', num2str(typeOfError), '-error : tradeoff parameter = ', num2str(p)));
        saveas(fig, fullfile(REPORTPICSFOLDER, strcat(IMAGENAME{1}, '_L', num2str(typeOfError), '_error_p=', num2str(p), '.jpg')));
        close(fig);
        
        count = count + 1;
    end

end

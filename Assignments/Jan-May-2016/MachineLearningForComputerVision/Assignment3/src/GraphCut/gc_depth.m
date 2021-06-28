clc;
clear all;
close all;
REPORTPICSFOLDER = '../report/pics/';
IMAGENAME = {'map', 'pgm'};

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
    LxErrors{typeOfError} = [];
    est_err = [];
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

        % Calculate the error between the estimated and ground truth depthmap
        est_err(count) = sqrt(sum( (Lest(:) - dm(:)).^2 ) / numel(Lest));
        fprintf('%.1f,%.4f\n',p,est_err(count));
        fig = figure;
        imshow(uint8(Lest));
        title(strcat('L', num2str(typeOfError), '-error : tradeoff parameter = ', num2str(p)));
        saveas(fig, fullfile(REPORTPICSFOLDER, strcat(IMAGENAME{1}, '_L', num2str(typeOfError), '_error_p=', num2str(p), '.jpg')));
        close(fig);
        
        count = count + 1;
    end
    
    LxErrors{typeOfError} = est_err;
end

fig = figure;
plot(1:length(tradeOffParams), LxErrors{1}, 'b', 'LineWidth', 1.5);
hold on;
plot(1:length(tradeOffParams), LxErrors{2}, 'r', 'LineWidth', 1.5);
legend('L1 error', 'L2 error'); legend show;
title(strcat('map - L1 error vs. L2 error'));
set(gca,'XTick',1:length(tradeOffParams));
set(gca,'XTickLabel',tradeOffParams');
xlabel('trade-off parameter (p)'); ylabel('Error magnitude'); 
saveas(fig, fullfile(REPORTPICSFOLDER, strcat('', '_error_vs_tradeoffparams.jpg')));
close(fig);

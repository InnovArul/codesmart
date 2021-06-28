function [ output_args ] = doall( input_args )
%DOALL Summary of this function goes here
%   Detailed explanation goes here

addpath('./Lab9/');
close all;

%% calculate SVD on different images
images = readImages();

imgBuffer = [];

for index = 1 : size(images, 3) 
   currentImg = images(:, :, index);
   imgBuffer = [imgBuffer currentImg(:)];
end

[U, S, V] = svd(imgBuffer, 'econ');

%% load the ambiguity matrix
A = load('./Lab9/A.mat');

% calculat surface normals and light directions
N = U * sqrt(S) * A.A;
L = pinv(A.A) * sqrt(S) * V';

%% calculate the norm
estimatedN_magnitudes = (N(:, 1).^2 + N(:, 2).^2 + N(:, 3).^2).^0.5;
magnitude = uint8(reshape(estimatedN_magnitudes, 256, 256));
imwrite(magnitude, './output/surfaceNormalMagnitude.png');

%% image with new light
newLight = load('./Lab9/Lnew.mat');
lighting = newLight.Lnew;
newImage = N * lighting;
for i = 1:3
    currentImg = uint8(reshape(newImage(:, i), 256, 256));
    %figure,imshow(currentImg);
    imwrite(currentImg, strcat('./output/newImage', num2str(i),'.png'));
end

%% estimate best fit surface of the object
N_x = N(:, 2);
N_y = N(:, 1);
N_z = N(:, 3);
p = reshape(-N_x ./ (N_z + eps), 256, 256);
q = reshape(N_y ./ (N_z + eps), 256, 256);
mask = imread('./Lab9/mask.png');
[u,A,B,weights] = direct_weighted_poisson(p,q, logical(mask));
figure; colormap gray; surf(u);
%figure; colormap gray; surfl(u);

end


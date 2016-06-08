function [ ] = calcGradient( image )
%CALCGRADIENT Summary of this function goes here
%   Detailed explanation goes here

img = imread(image);
imgray = rgb2gray(img);

imdx = imfilter(double(imgray), [-1 0 1]);
scaledImg = uint8(imagesc(imdx));
colormap gray;

imshow(uint8(imagesc(imdx)))

end


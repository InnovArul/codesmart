function [ imgBuffer ] = readImages( )
%READIMAGES Summary of this function goes here
%   Detailed explanation goes here

img1path = './Lab9/Beethoven1.png';
img2path = './Lab9/Beethoven2.png';
img3path = './Lab9/Beethoven3.png';

img1 = imread(img1path);
imgBuffer = zeros([size(img1) 3]);
imgBuffer(:, :, 1) = double(img1);

img2 = imread(img2path);
imgBuffer(:, :, 2) = double(img2);

img3 = imread(img3path);
imgBuffer(:, :, 3) = double(img3);

end


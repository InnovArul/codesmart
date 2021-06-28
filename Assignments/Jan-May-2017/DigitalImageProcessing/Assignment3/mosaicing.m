% add the paths of library available
addpath('../Assignment2/');
addpath('./Lab3/');

% %%
% for index=1:6 
%     infilepath = strcat('./Lab3/', 'st', int2str(index), '.jpg');
%     outfilepath = strcat('./Lab3/', 'img', int2str(index), '-out.jpg');
%     img = imread(infilepath); 
%     img = rgb2gray(img);
%     img = imresize(img, [300 500]);
%     imwrite(img, outfilepath);
% end

folder = './Lab3/own/'; % ./Lab3/ | ./Lab3/own/
fileprefix = 'instigray-'; % set1- | img
filetype = '.jpg'; % .jpg | .pgm
outfile = strcat(folder, fileprefix, '-canvas.jpg');

file1 = strcat(folder, fileprefix, int2str(1), filetype);
file2 = strcat(folder, fileprefix, int2str(2), filetype);
file3 = strcat(folder, fileprefix, int2str(3), filetype);

% read the images
img1 = imread(file1);
img2 = imread(file2);
img3 = imread(file3);

% get the correspondences between images
[imgRefAnd1_corresp1, imgRefAnd1_corresp2] = sift_corresp(file2, file1);
[imgRefAnd3_corresp1, imgRefAnd3_corresp2] = sift_corresp(file2, file3);

% find homography between images
H21 = findGoodHomography(imgRefAnd1_corresp1, imgRefAnd1_corresp2)
H23 = findGoodHomography(imgRefAnd3_corresp1, imgRefAnd3_corresp2)

% get mosaic
img = getCombinedImages(img1, img2, img3, H21, H23);
imwrite(uint8(img), outfile);
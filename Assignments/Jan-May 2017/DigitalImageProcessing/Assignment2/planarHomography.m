%read images
img1 = imread('./Lab2/IMG1.pgm');
img2 = imread('./Lab2/IMG2.pgm');

% correspondences already given in problem statement
img1Points = [125, 30; 373, 158];
img2Points = [249, 94; 400, 329];

% create A matrix in Ax = 0
H = getHomographyMatrixForInplaneRotAndTrans(img1Points, img2Points);

% get the transformed image
transformedImage1to2 = uint8(getHomographedSourceImage(img1, H, size(img2)));
imwrite(transformedImage1to2, './Lab2/matlabtrImg1.png');
transformedImage2to1 = uint8(getHomographedSourceImage(img2, pinv(H), size(img1)));
imwrite(transformedImage2to1, './Lab2/matlabtrInvHImg2.png');

% find the difference between original image and transformed image
% print(type(img1[1, 1]))
diffImage = abs(transformedImage2to1- img1);
imwrite(diffImage, './Lab2/matlabdiffImage1.png')

diffImage = abs(img2 - transformedImage1to2);
imwrite(diffImage, './Lab2/matlabdiffImage2.png');


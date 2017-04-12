function doall()
% read the image
img = double(imread('./Lab7/peppers.pgm'));

% get the 2D DFT
img_DFT = forwardDFT2D(img);

%
% figure, imshow(abs(fftshift(img_DFT)),[24 100000]), colormap gray
% title('fourier_transform DFT Magnitude')
% figure, imshow(angle(fftshift(img_DFT)),[-pi pi]), colormap gray
% title('fourier_transform DFT Phase')
% pause; close all;

% save the recentered DFT image
recenteredDFT = recenterAndScaleDFT(img_DFT);
imwrite(recenteredDFT, './output/peppers_DFT.pgm');

% get the inverse 2D DFT
inverseImg = inverseDFT2D(img_DFT);

imwrite(inverseImg, './output/peppers_reconstruction.pgm');

end
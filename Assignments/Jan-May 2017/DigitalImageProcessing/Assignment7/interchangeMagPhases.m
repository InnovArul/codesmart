function interchangeMagPhases()

%read the imgs
fourier = imread('./Lab7/fourier.pgm');
fourier_transform = imread('./Lab7/fourier_transform.pgm');

fourier_DFT = forwardDFT2D(fourier);

% save the recentered DFT image
recenteredDFT = recenterAndScaleDFT(fourier_DFT);
imwrite(recenteredDFT, './output/fourier_DFT.pgm');

fourier_transform_DFT = forwardDFT2D(fourier_transform);

% save the recentered DFT image
recenteredDFT = recenterAndScaleDFT(fourier_transform_DFT);
imwrite(recenteredDFT, './output/fourier_DFT.pgm');

% extract the magnitude and phases
fourier_DFT_mag = abs(fourier_DFT);
fourier_DFT_phase = angle(fourier_DFT);
fourier_transform_DFT_mag = abs(fourier_transform_DFT);
fourier_transform_DFT_phase = angle(fourier_transform_DFT);

%get the magnitude and phase interchanged DFTs
DFT_fourierMag_fourier_transformPhase = getDFT(fourier_DFT_mag, fourier_transform_DFT_phase);
DFT_fourier_transformMag_fourierPhase = getDFT(fourier_transform_DFT_mag, fourier_DFT_phase);

inverseImg_fourierMag_fourier_transformPhase = inverseDFT2D(DFT_fourierMag_fourier_transformPhase);
inverseImg_fourier_transformMag_fourierPhase = inverseDFT2D(DFT_fourier_transformMag_fourierPhase);

imwrite(inverseDFT2D(fourier_DFT), './output/fourier_reconstruction.pgm');
imwrite(inverseDFT2D(fourier_transform_DFT), './output/fourier_transform_reconstruction.pgm');
imwrite(inverseImg_fourierMag_fourier_transformPhase, './output/fourierMag_fourier_transformPhase.pgm');
imwrite(inverseImg_fourier_transformMag_fourierPhase, './output/fourier_transformMag_fourierPhase.pgm');

end
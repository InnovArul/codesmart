function recenteredDFT = recenterAndScaleDFT(img_DFT)

recenteredDFT = fftshift(img_DFT); % Center FFT

recenteredDFT = abs(recenteredDFT); % Get the magnitude
%recenteredDFT = log(recenteredDFT+1); % Use log, for perceptual scaling, and +1 since log(0) is undefined
recenteredDFT = (255 * mat2gray(recenteredDFT)); % Use mat2gray to scale the image between 0 and 1

end
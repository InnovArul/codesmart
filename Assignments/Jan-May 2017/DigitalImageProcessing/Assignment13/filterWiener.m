% sigma buffer
clear all;
sigmaCombination = [8 0.5; 8 1.0; 8 1.5; 5 1.0; 10 1.0; 15 1.0; ];
kArray = 0.01 : 0.001 : 2.0;
img = double(imread('./Lab13/lena.pgm'));
imgWidth = size(img, 1);
imgHeight = size(img, 2);
outputFolder = './output';

for sigmaIndex = 1:size(sigmaCombination, 1)
    error = zeros(size(kArray));

    sigmaN = sigmaCombination(sigmaIndex, 1);
    sigmaB = sigmaCombination(sigmaIndex, 2);

    widthNoise = getKernelWidthFromSigma(sigmaN);
    widthBlur = getKernelWidthFromSigma(sigmaB);
    
    % Create the gaussian filter with hsize = [5 5] and sigma = 2
    h = fspecial('gaussian', [widthBlur widthBlur], sigmaB);
    n = sigmaN * randn(size(img));

    % g = hf + n
    blurredImg = imfilter(img, h, 'conv', 'circular') + n;  
    imwrite(uint8(blurredImg), fullfile(outputFolder, strcat('blurImage-sigB-', num2str(sigmaB), ...
                                                        '-sigN-', num2str(sigmaN), '.jpg')));
    % apply matlab wiener filter
    matlabWienerImg = wiener2(blurredImg, size(h), sigmaN);
    imwrite(uint8(matlabWienerImg), fullfile(outputFolder, strcat('matlabWiener-sigB-', num2str(sigmaB), ...
                                                        '-sigN-', num2str(sigmaN), '.jpg')));

    for kIndex = 1 : length(kArray)

        kValue = kArray(kIndex);                                             
                                                        
        % own wiener filter
        ownWienerImg = getWienerFilteredImage(blurredImg, h, kValue);
                                                 
        rmseMatlabWiener = getRMSE(matlabWienerImg, img);      
        rmseOwnWiener = getRMSE(ownWienerImg, img);  
        rmseWienerMatlabVsOwn = getRMSE(matlabWienerImg, ownWienerImg);                                           
        error(kIndex) = rmseOwnWiener;
    end
    
    [~, minkIndex] = min(error, [], 2);
    kValue = kArray(minkIndex);
    
    % own wiener filter
    ownWienerImg = getWienerFilteredImage(blurredImg, h, kValue);

    % apply matlab wiener filter
    imwrite(uint8(abs(ownWienerImg)), fullfile(outputFolder, strcat('ownWiener-sigB-', num2str(sigmaB), ...
                                                        '-sigN-', num2str(sigmaN), '-k-', num2str(kValue), '.jpg')));                                                        

end
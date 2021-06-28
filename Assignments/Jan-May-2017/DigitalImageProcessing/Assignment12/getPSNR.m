function [PSNR] = getPSNR(filteredImg, latentImg)
    imgWidth = size(latentImg, 1);
    imgHeight = size(latentImg, 2);

    imgDiffSquare = (filteredImg - latentImg) .^ 2;
    imgDiffSquareSum = sum(imgDiffSquare(:));
    MSE = imgDiffSquareSum / (imgWidth * imgHeight);
    PSNR = 10*log10(1 / MSE);
end
function [rmse] = getRMSE(img1, img2)
    imgWidth = size(img1, 1);
    imgHeight = size(img2, 2);
    imgDifference = (img1 - img2);
    imgDifferenceSquareSum = sum(imgDifference(:).^2);
    rmse = sqrt(imgDifferenceSquareSum / (imgWidth * imgHeight));
end
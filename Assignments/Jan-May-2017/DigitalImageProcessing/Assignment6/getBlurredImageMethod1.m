function [blurredImage, allWarpedImages] = getBlurredImageMethod1(f, d)
    % read cam.xlsx file
    camTrajectory = xlsread('./Lab6/cam.xlsx');
    cleanImage = rgb2gray(imread('./Lab6/pillars.jpg'));

    n = [0; 0; 1];
    
    blurredImage = zeros(size(cleanImage));
    allWarpedImages = zeros([size(camTrajectory, 1) size(cleanImage)]);
    
    for i = 1 : size(camTrajectory, 1)
        %get homography matrix
        %disp(i);
        H = getHomographyMatrix(camTrajectory(i, :), f, n, d);
        warpedImage = getHomographedSourceImage(cleanImage, H, size(cleanImage));
        blurredImage = blurredImage + warpedImage;
        allWarpedImages(i, :, :) = uint8(warpedImage);
    end
    
    blurredImage = blurredImage / size(camTrajectory, 1);
    
    %imshow(uint8(blurredImage));
    imwrite(uint8(blurredImage), strcat('./output/f=', int2str(f), '_d=', int2str(d), '_B1.png'));
    
end
function [blurredImage, allWarpedImages] = getBlurredImageMethod2(f, d)

    % read cam.xlsx file
    camTrajectory = xlsread('./Lab6/cam.xlsx');
    cleanImage = rgb2gray(imread('./Lab6/pillars.jpg'));

    n = [0; 0; 1];
    
    blurredImage = zeros(size(cleanImage));
    [allUniqueRows, ~, indices] = unique(camTrajectory, 'rows'); 
    allWarpedImages = zeros([size(allUniqueRows, 1), size(cleanImage)]);
    
    allUniqueRows = sortrows(allUniqueRows);
    for i = 1 : size(allUniqueRows, 1)
        %get homography matrix
        %disp(i);
        Np = sum(indices == i) / size(camTrajectory, 1);
        H = getHomographyMatrix(allUniqueRows(i, :), f, n, d);
        warpedImage = getHomographedSourceImage(cleanImage, H, size(cleanImage));
        blurredImage = blurredImage + (Np * warpedImage);
        allWarpedImages(i, :, :) = uint8(warpedImage);
    end

    %imshow(uint8(blurredImage));
    imwrite(uint8(blurredImage), strcat('./output/f=', int2str(f), '_d=', int2str(d), '_B2.png'));
end
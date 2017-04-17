function [patchNeighborhood] = getNeighborhood(img, Wsim, x, y)
    imgWidth = size(img, 1);
    imgHeight = size(img, 2);
    imgDepth = size(img, 3);
    patchNeighborhood = img(x - Wsim : x + Wsim, y - Wsim : y + Wsim, :);
    
%     for i = -Wsim : Wsim
%         for j = -Wsim : Wsim
%             currentImgX = x + i;
%             currentImgY = y + j;
%             currentPixelValue = 0;
%             
%             if(currentImgX >= 1 && currentImgX <= imgWidth && ...
%                 currentImgY >= 1 && currentImgY <= imgHeight)
%             
%                 currentPixelValue = img(currentImgX, currentImgY, :);
%             end
%             
%             patchNeighborhood(i + Wsim + 1, j + Wsim + 1, :) = currentPixelValue;
%         end
%     end
end
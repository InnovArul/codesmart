function [mu] = randomMuSelection(img, nMu)
    imgWidth = size(img, 1);
    imgHeight = size(img, 2);
    
    widthPermutation = randperm(imgWidth);
    heightPermutation = randperm(imgHeight);
    
    for index = 1:nMu
       mu(:, index) = img(widthPermutation(index), heightPermutation(index), :); 
    end
end
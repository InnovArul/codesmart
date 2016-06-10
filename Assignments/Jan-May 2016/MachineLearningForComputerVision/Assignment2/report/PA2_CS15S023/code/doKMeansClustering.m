function [mu_i, labels, currentCost] = doKMeansClustering(imgData, mu_i)
    imgRows = size(imgData, 1);
    imgColumns = size(imgData, 2);
    imgMaps =  size(imgData, 3);
    
    % determine mu, distances from each mu_i
    K = size(mu_i, 1);
    distances = zeros(size(imgData, 1), size(imgData, 2), K);
    
    % for all the mu's, find the euclidean distance
    for index = 1 : K
        % find euclidean distances
        identityMap = ones(imgRows, imgColumns);
        replicatedMu = reshape(kron(mu_i(index, :), identityMap), imgRows, imgColumns, imgMaps);
        distances(:, :, index) = sqrt(sum((double(imgData) - replicatedMu).^2, 3));
    end
    
    % find minimum distance to assign mu's (cluster labels)
    [totalCost, labels] = min(distances, [], 3);
    currentCost = sum(totalCost(:));
    
    %calculate new mu_i's
    for index = 1 : K 
       singleMapMask = labels==index;
       mask = repmat(singleMapMask, [1, 1, imgMaps]);
       mu_i(index, :) = sum(sum(double(imgData) .* double(mask), 2), 1) / sum(singleMapMask(:));
       
    end
end
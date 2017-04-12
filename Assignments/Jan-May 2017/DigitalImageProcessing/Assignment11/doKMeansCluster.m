function [ ] = doKMeansCluster(  )
%DOKMEANSCLUSTER cluster the given car.ppm image with given means and
% display the image

imgPath = './Lab11/car.ppm';
img = double(imread(imgPath));
imgWidth = size(img, 1);
imgHeight = size(img, 2);
assignments = zeros(size(img));

mu = zeros(3,3);
muSelection = 'random';

if(strcmp(muSelection, 'fixed'))
    mu(:, 1) = [0 255 0]';
    mu(:, 2) = [0 0 0]';
    mu(:, 3) = [255 255 255]';
else
    mu = randomMuSelection(img, 3);
end

error = [];
prevError = inf;
totalIterations = 10;
lastIteration = 1;
eps = 1;

% do 5 iterations of k-means clustering
for index = 1:totalIterations
    for muIndex = 1:size(mu, 1)
        % find the distance between each point and particular cluster
        % centers
        differences(:, :, muIndex) = sqrt(sum((img - repmat(reshape(mu(:, muIndex), 1, 1, 3), imgWidth, imgHeight)).^2, 3));
    end
    
    % assign points to the cluster centers
    [allErrors, currentAssignments] = min(differences, [], 3);   
    error(index) = sum(allErrors(:)); 
    
    imagesc(currentAssignments);
    %saveas(gcf, strcat('./output/car-iteration-', muSelection, '-', num2str(index), '.png'));

    bChannel = zeros(size(currentAssignments));
    rChannel = zeros(size(currentAssignments));
    gChannel = zeros(size(currentAssignments));
        
    % modify the cluster centers
    for muIndex = 1:size(mu, 1)
        singleChannelMask = (currentAssignments == muIndex);
        
        rChannel(currentAssignments == muIndex) = mu(1, muIndex);
        gChannel(currentAssignments == muIndex) = mu(2, muIndex);
        bChannel(currentAssignments == muIndex) = mu(3, muIndex);        

        totalCount = sum(singleChannelMask(:));
        fullMask = repmat(singleChannelMask, 1, 1, size(img, 3));
        mu(:, muIndex) = sum(sum(img .* fullMask, 2), 1) ./ sum(singleChannelMask(:));
    end

    assignments(:, :, 1) = rChannel;
    assignments(:, :, 2) = gChannel;
    assignments(:, :, 3) = bChannel;    
    imwrite(uint8(assignments), strcat('./output/car-iteration-color-', num2str(index), '.png'));
        
    if(abs(error - prevError) <= eps)
        break
    end
        
    prevError = error(index);
    lastIteration = index;
end

disp('total iterations');
disp(lastIteration);

end


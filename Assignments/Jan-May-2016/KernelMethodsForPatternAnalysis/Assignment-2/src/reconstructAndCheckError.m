function [] = reconstructAndCheckError(imgData, Y, sortedEigVectors, meanMat)
%RECONSTRUCTANDCHECKERROR Summary of this function goes here
%   Detailed explanation goes here

%buffer to collect frobenius norms
frobeniusNorms = [];

% type top k eigen vectors and calculate the frobenius norm
for k = 1 : size(sortedEigVectors, 1)
    disp(strcat('Processing eigen vector ', num2str(k)));
    %prepare a matrix with only first k eigen vectors
    Q_pca = sortedEigVectors(:, 1:k); 
    
    %find the projection of each image on the reduced basis set
    projectedImgs_on_Q_pca = Y * Q_pca;
    
    %update the pca features buffer only if the variance of a particular
    %eigen vector is more than 1%
    pca_features = projectedImgs_on_Q_pca; 
    
    %if(eigValsVariancePercentage(k) > 0.6)
     %  pca_features = projectedImgs_on_Q_pca; 
    %else
       % break;
    %end
    
    % reconstruct the image and add the mean
    reconstructedImgs = (projectedImgs_on_Q_pca * Q_pca') + meanMat;
    
    %calculate the frobenius norm
    frobeniusNorm = norm(imgData - reconstructedImgs, 'fro');
    frobeniusNorms = [frobeniusNorms; frobeniusNorm];

end

plot(frobeniusNorms);

end


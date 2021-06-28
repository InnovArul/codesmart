function [pcaFeatures] = getPCAFeatures(data, imgMean, eigenBasis)

meanMat = repmat(imgMean, 1, size(data, 2));
Y = data - meanMat;
pcaFeatures = Y' * eigenBasis;

end
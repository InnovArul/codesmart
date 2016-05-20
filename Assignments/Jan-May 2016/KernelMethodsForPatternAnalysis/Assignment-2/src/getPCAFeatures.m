function [pcaFeatures] = getPCAFeatures(data, imgMean, eigenBasis)

meanMat = repmat(imgMean, size(data, 1), 1);
Y = data - meanMat;
pcaFeatures = Y * eigenBasis;

end
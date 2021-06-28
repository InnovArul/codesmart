function [sortedEigVals, sortedEigVectors] = getEigenValuesAndVectors(Y)

%% find eigen values and eigen vectors for covariance matrix

%get the covariance matrix of mean shifted matrix
covMatrix = cov(Y);

%perform EVD
[V, D] = eig(covMatrix);

%determine the descending order of eigen values based on magnitude
eigVals = sum(D, 2); 

[sortedEigVals, sortOrder] = sort(abs(eigVals), 1, 'descend');
sortedEigVectors = V(:, sortOrder);

%plot the eigen values to see the variance of eigen values
plot(sortedEigVals);

%calculate the variance percentage also, which can be plotted
eigValsSum = sum(sortedEigVals);
eigValsVariancePercentage = sortedEigVals * 100 / eigValsSum;
plot(sortedEigVals * 100 / eigValsSum);

end
function [ ] = doallMLMAPB( )
%DOALLMLMAPB Summary of this function goes here
%   Detailed explanation goes here

global REPORTFOLDER;
REPORTFOLDER = '../report/pics/';

%load the data
allDetails = load('../data/Problem1_data/data.mat');
rawSigma = allDetails.Sigma;
rawMu = allDetails.mu;
priorSigma1 = allDetails.Sigma01;
priorMu1 = allDetails.mu01;
priorSigma2 = allDetails.Sigma02;
priorMu2 = allDetails.mu02;

data = allDetails.data;
datasets = {};
datasetWidth = 500;

% divide the data into 100 disjoint sets
for index = 1:100
    datasets{index} = data((index-1)*datasetWidth + 1 : index * datasetWidth, :);
end

% vary n from 2 to 500 and estimate Bhattacharya distance d for eacn n

for datasetIndex = 1:100
    currentData = datasets{datasetIndex};
    for n = 2 : 500
        Mu_ml = getMaximumLikelihoodEstimate(currentData(1:n, :));
        Mu_mapWithPrior1 = getMaximumAposterioriEstimate(currentData(1:n, :), rawSigma, priorMu1, priorSigma1);
        Mu_mapWithPrior2 = getMaximumAposterioriEstimate(currentData(1:n, :), rawSigma, priorMu2, priorSigma2);
        [mu_B1, sigma_B1] = getBayesianEstimate(currentData(1:n, :), rawSigma, priorSigma1, priorMu1);
        [mu_B2, sigma_B2] = getBayesianEstimate(currentData(1:n, :), rawSigma, priorSigma2, priorMu2);
        
        dMLwithGD(datasetIndex, n-1) = getBhattacharyaDistance(rawMu, rawSigma, Mu_ml, rawSigma);
        dMAPwithPrior1(datasetIndex, n-1) = getBhattacharyaDistance(rawMu, rawSigma, Mu_mapWithPrior1, rawSigma);
        dMAPwithPrior2(datasetIndex, n-1) = getBhattacharyaDistance(rawMu, rawSigma, Mu_mapWithPrior2, rawSigma);
        
        dBayesianwithPrior1(datasetIndex, n-1) = getBhattacharyaDistance(rawMu, rawSigma, mu_B1, sigma_B1);
        dBayesianwithPrior2(datasetIndex, n-1) = getBhattacharyaDistance(rawMu, rawSigma, mu_B2, sigma_B2);
    end
end

MLperfmean = mean(dMLwithGD);
MAPperfmeanWithPrior1 = mean(dMAPwithPrior1);
MAPperfmeanWithPrior2 = mean(dMAPwithPrior2);
BayesPerfmeanWithPrior1 = mean(dBayesianwithPrior1);
BayesPerfmeanWithPrior2 = mean(dBayesianwithPrior2);

plotPerformance(MLperfmean, MAPperfmeanWithPrior1, {'ML', 'MAP with Prior1', 'ML and MAP for prior-1'});
plotPerformance(MLperfmean, MAPperfmeanWithPrior2, {'ML', 'MAP with Prior2', 'ML and MAP for prior-2'});
plotPerformance(MAPperfmeanWithPrior1, BayesPerfmeanWithPrior1, {'MAP with Prior1', 'Bayesian with Prior1', 'MAP and Bayesian for prior-1'});
plotPerformance(MAPperfmeanWithPrior2, BayesPerfmeanWithPrior2, {'MAP with Prior2', 'Bayesian with Prior2', 'MAP and Bayesian for prior-2'});

end


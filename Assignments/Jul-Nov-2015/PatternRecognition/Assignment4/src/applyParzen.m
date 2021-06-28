function [ likelihood ] = applyParzen( trainingFeatures, testingFeatures, h, windowMethod )
%APPLYPARZEN Summary of this function goes here
%   Detailed explanation goes here

global PARZEN_HYPERSPHERE PARZEN_GAUSSIAN;

PARZEN_HYPERSPHERE = 1;
PARZEN_GAUSSIAN = 2;

if(~exist('windowMethod', 'var'))
   windowMethod = PARZEN_HYPERSPHERE; 
end

likelihood = [];
totalTrainingFeatures = size(trainingFeatures, 1);
dimension = size(trainingFeatures, 2);

for testIndex = 1:size(testingFeatures, 1)
   % apply hypersphere kernel
   effectiveNumPoints = 0;
   currentTestInput = testingFeatures(testIndex, :);

   if(windowMethod == PARZEN_HYPERSPHERE)

       difference = trainingFeatures - repmat(currentTestInput, totalTrainingFeatures, 1); 
       k = sum(difference.^2, 2) - h^2;
       effectiveNumPoints = sum(k < 0);
   else
       covariance = h * eye(dimension);
       k = mvnpdf(trainingFeatures, currentTestInput, covariance);
       effectiveNumPoints = sum(k);
   end

   likelihood(testIndex, 1) = effectiveNumPoints / totalTrainingFeatures;
end
end


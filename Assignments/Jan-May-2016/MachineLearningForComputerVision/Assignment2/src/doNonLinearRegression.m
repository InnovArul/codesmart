function [prediction_error, fitting_error] = doNonLinearRegression(data, x, y, g)

%split into train and test data
totalNumPoints = size(data, 1);
indices = randperm(totalNumPoints);

trainData = data;
trainX = x;
trainY = y;
trainG = g;

% ML extimation
pi_hat = pinv(trainData' * trainData) * trainData' * trainY;

% plot train fitting curve
[prediction_error, fitting_error] = plotModelPrediction(trainX, trainData, pi_hat, trainG, trainY, '_train.jpg');

end
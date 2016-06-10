function [ ] = doall_task4( nonLinearOption)
%DOALL_TASK4 

global REPORT_PICS_FOLDER NONLINEARTYPE;
REPORT_PICS_FOLDER = '../report/pics/task4';

% keep numOfBasisFunctions as 6 , and vary lambda
if(nonLinearOption == options.RBF)
    numOfBasisFunctions = 6;
    nonLinearOptionText = 'RBF basis function';
else
    numOfBasisFunctions = 7;
    nonLinearOptionText = 'ARCTAN basis function';
end

[x, y, g, x_left, x_right] = getDataForTask4();

lambdas = linspace(0.2, 3, 25);
mse_errors = [];

for lambda = lambdas
    [data, NONLINEARTYPE] = getNonLinearData(numOfBasisFunctions, x, x_left, x_right, nonLinearOption, lambda);
    [prediction_error, fitting_error] = doNonLinearRegression(data, x, y, g);
    mse_errors = [mse_errors; [lambda prediction_error fitting_error]; ];
end

% plot the graph
plotGraph(mse_errors(:, 1), mse_errors(:, 2:end), 'lambda', 'prediction and fitting errors', ...
   strcat(nonLinearOptionText, '(lambda vs. errors)'), {'prediction error', 'fitting error'}, strcat(nonLinearOptionText, '_fitting_lambda_errors.jpg'));

% find the lambda
[minTestError, minIndex] = min(mse_errors(:, 3), [], 1)
optimalLambda = lambdas(minIndex);
disp(optimalLambda);


mse_errors = [];
% vary the number of kernel functions
for numFunctions = 2:2:50
    [data, NONLINEARTYPE] = getNonLinearData(numFunctions, x, x_left, x_right, nonLinearOption, optimalLambda);
    [prediction_error, fitting_error] = doNonLinearRegression(data, x, y, g);
    mse_errors = [ mse_errors; [numFunctions prediction_error fitting_error];];    
end

% plot the graph
plotGraph(mse_errors(:, 1), mse_errors(:, 2:end), 'lambda', 'prediction and fitting errors', ...
    strcat(nonLinearOptionText, '(number of kernel functions vs. errors)'), {'prediction error', 'fitting error'}, strcat(nonLinearOptionText, '_numfunctions_errors.jpg'));

end


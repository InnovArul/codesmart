function [ output_args ] = doall_task5( )
%DOALL_TASK5 Summary of this function goes here
%   Detailed explanation goes here

load('../data/Problem-5/data.mat');
global REPORT_PICS_FOLDER;
REPORT_PICS_FOLDER = '../report/pics/task5';
lambda = 0.25007;

numTrainPoints = size(trainX, 1);

for trialIndex = 1:5
    randomIndices = randperm(numTrainPoints);
    totalError = 0;

    mu_i = zeros(10, 2);
    for index = 1:length(mu_i)
       mu_i(index, 1) = trainX(randomIndices(index)); 
       mu_i(index, 2) = trainY(randomIndices(index));
    end

    trainData = getNonLinearDataWithMu(mu_i(:, 1), trainX, lambda);
    testData = getNonLinearDataWithMu(mu_i(:, 1), testX, lambda);

    % ML extimation
    pi_hat = pinv(trainData' * trainData) * trainData' * trainY;

    % plot train fitting curve
    predicted = testData * pi_hat;
    totalError = totalError + (norm(testY - predicted) ^ 2)  / size(testY, 1);
    

    scatter(testX, testY, 7, 'r', 'fill');
    hold on;
    scatter(testX, predicted, 7, 'b', 'fill');
    hold on;

    xlabel('x');
    title(strcat('Non-linear regression for comparing with Relevance vector regression (MSE=', num2str(totalError), ')'));
    plot(mu_i(:, 1), mu_i(:, 2), 'b*', 'MarkerSize', 10);
    legend('given test data','predicted model','Relevent data'); legend show;
    hold off

    saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat('non-linear-regression- rvr-random-', num2str(trialIndex), '.png')));
    close all;
    
end

end


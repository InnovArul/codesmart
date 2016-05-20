function [ output_args ] = doall_task3()
%DOALL_TASK3 
global REPORT_PICS_FOLDER;
dataFilePath = '../data/Problem-3/data_problem3.mat';
REPORT_PICS_FOLDER = '../report/pics/task3';
data = load(dataFilePath);

x = data.x';
y = data.y';
g = data.g';
sigmaSquare = data.sigma2;
sigmapSquare = data.sigma_p2;

%split the data into 50 disjoint sets
numOfPoints = length(x);
numOfTrainingSets = 50;
disjointSets = reshape(x, numOfTrainingSets, numOfPoints / numOfTrainingSets);
disjointY = reshape(y, numOfTrainingSets,  numOfPoints / numOfTrainingSets);

K_all = [10, 20, 40, 100, 150, 200, 250, 300];
errorHistory = zeros(length(K_all), 2);

predictionMethods = [options.LINEAR_REGRESSION, options.BAYESIAN_REGRESSION];

for predictionMethod = predictionMethods
    method = '';

    % for individual K values, calculate phi 
    for kIndex = 1:length(K_all)
        k = K_all(kIndex);
        currentError = 0;

        % from each training set, take k examples and evaluate phi
        for trainingSetIndex = 1:numOfTrainingSets
           X = [ones(1, k); disjointSets(trainingSetIndex, 1:k)];
           currentY = disjointY(trainingSetIndex, 1:k)';

           if(predictionMethod == options.LINEAR_REGRESSION)
               method = 'ML_estimation';

               pi_hat = inv(X * X') * X * currentY;

               % get the total error of all training examples using estimated phi       
               currentError = currentError + getTotalErrorForLinearRegression(x, g, pi_hat);
           else
               method = 'Bayesian_estimation';  

               A = ((X * X') / sigmaSquare) + (eye(2) / sigmapSquare);
               predicted = ([ones(1, length(x))' x] * inv(A) * X * currentY) / sigmaSquare;
               currentError = currentError + (norm(predicted - g')^2);
           end
        end

        errorHistory(kIndex, predictionMethod) = currentError / (numOfTrainingSets * k);
    end
end

% plot E_K vs K plot
plot(K_all', errorHistory(:, 1), '-bo', 'LineWidth', 2, 'MarkerSize', 9, 'MarkerFaceColor', 'r');
xlabel('number of points used for estimation of \phi (K)');
ylabel('Mean squared error E_k');
title('K vs Error(E_k)');
legend('linear regression', 'bayesian regression'); legend show;
saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat('linear_regression', '_error_vs_k.png')));
close all;

% plot E_K vs K plot
plot(K_all', errorHistory(:, 2), '-go', 'LineWidth', 2, 'MarkerSize', 9, 'MarkerFaceColor', 'r');
xlabel('number of points used for estimation of \phi (K)');
ylabel('Mean squared error E_k');
title('K vs Error(E_k)');
legend('linear regression', 'bayesian regression'); legend show;
saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat('bayes_regression', '_error_vs_k.png')));
close all;

% plot E_K vs K plot
plot(K_all', errorHistory(:, 1), '-bo', 'LineWidth', 2, 'MarkerSize', 9, 'MarkerFaceColor', 'r');
hold on;
plot(K_all', errorHistory(:, 2), '-go', 'LineWidth', 2, 'MarkerSize', 9, 'MarkerFaceColor', 'r');
xlabel('number of points used for estimation of \phi (K)');
ylabel('Mean squared error E_k');
title('K vs Error(E_k)');
legend('linear regression', 'bayesian regression'); legend show;
saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat('linear_bayes_regression', '_error_vs_k.png')));
close all;

end


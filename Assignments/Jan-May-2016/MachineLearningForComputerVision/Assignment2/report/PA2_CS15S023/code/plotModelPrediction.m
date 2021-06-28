function [prediction_error, fitting_error] = plotModelPrediction(xData1D, xDataHighDim, pi_hat, gExpected, yExpected, fileName)

global REPORT_PICS_FOLDER NONLINEARTYPE;

predicted = xDataHighDim * pi_hat;
prediction_error = (norm(yExpected - predicted) ^ 2)  / size(xData1D, 1);
fitting_error = (norm(gExpected - predicted) ^ 2) / size(xData1D, 1);

scatter(xData1D, gExpected, 7, 'r', 'fill');
hold on;
scatter(xData1D, yExpected, 7, 'b', 'fill');
hold on;
scatter(xData1D, predicted, 7, 'g', 'fill');
hold on;

xlabel('x');
title(strcat('Non-linear regression - ', NONLINEARTYPE));
legend({'ground truth', 'noise + ground truth', 'predicted'}); legend show;

saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat(NONLINEARTYPE, fileName)));
close all;

end
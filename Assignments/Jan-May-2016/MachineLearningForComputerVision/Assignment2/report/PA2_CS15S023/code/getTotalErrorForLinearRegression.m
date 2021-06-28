function [mse_error] = getTotalErrorForLinearRegression(x, g, pi_hat)
   predicted = pi_hat' * [ones(1, length(x)); x'];
   mse_error = (predicted - g) .^ 2;
   mse_error = sum(mse_error(:));
end
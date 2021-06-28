function [data, nonLinearType] = getNonLinearDataWithMu(mu_i, x, lambda)

numOfFunctions = length(mu_i);

data = [];
alpha_i = mu_i;

for index = 1 : numOfFunctions
    data = [data exp(-((x - alpha_i(index)).^2) / lambda)];
    nonLinearType = strcat('RBF = ', num2str(numOfFunctions), ' - Basis functions (lambda=', num2str(lambda), ')');
end

data = [ones(length(x), 1) data];

end
function [data, nonLinearType] = getNonLinearData(numOfFunctions, x, x_left, x_right, option, lambda)

alpha_i = linspace(x_left, x_right, numOfFunctions);

data = [];

for index = 1 : numOfFunctions
    if(option == options.RBF)
        data = [data exp(-((x - alpha_i(index)).^2) / lambda)];
        nonLinearType = strcat('RBF = ', num2str(numOfFunctions), ' - Basis functions (lambda=', num2str(lambda), ')');
    else
        data = [data atan(lambda * x - alpha_i(index))]; 
        nonLinearType = strcat('arctan = ', num2str(numOfFunctions), ' - Basis functions(lambda=', num2str(lambda), ')');
    end
end

if(option == options.RBF)
    data = [ones(length(x), 1) data];
end

end
function [ squaredError ] = getSquaredError( data, mu_k )
%GETSQUAREDERROR Summary of this function goes here
%   Detailed explanation goes here

K = size(mu_k, 1);
N = size(data, 1);

squaredError = [];

for index = 1:K
    squaredError(:, index) = sqrt(sum((data - repmat(mu_k(index, :), N, 1)) .^ 2, 2)); 
end

end


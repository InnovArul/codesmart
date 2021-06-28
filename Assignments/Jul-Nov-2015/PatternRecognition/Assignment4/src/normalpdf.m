function [ pdf ] = normalpdf( data, mu, sigma )
%NORMALPDF Summary of this function goes here
%   Detailed explanation goes here

[N, P] = size(data);

XminusMu_k = (data - repmat(mu, N, 1));
sigma_inv = pinv(sigma);
mahalanobis_distance = -0.5 * sum((XminusMu_k * sigma_inv) .* XminusMu_k, 2);
denominator = (((2 * pi) .^ (P / 2)) * sqrt(det(sigma)));

pdf = exp(mahalanobis_distance) / denominator;

end


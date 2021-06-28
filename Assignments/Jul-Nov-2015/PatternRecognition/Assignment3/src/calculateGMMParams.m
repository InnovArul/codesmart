function [ mu_k, sigma_k, phi_k ] = calculateGMMParams( data, gamma_nk )
%RECALCULATEGMMPARAMS 

[N, P] = size(data);
K = size(gamma_nk, 2);

mu_k = zeros(K, P);
sigma_k = cell(K, 1);
phi_k = zeros(K, 1);

for clusterIndex = 1:K
    mu_k(clusterIndex, :) = mean(repmat(gamma_nk(:, clusterIndex), 1, P) .* data);
    N_k = sum(gamma_nk(:, clusterIndex));
    phi_k(clusterIndex, 1) = N_k / N;
    
    %calculation of covariance matrix
    XminusMu_k = (data - repmat(mu_k(clusterIndex, :), N, 1));
    sigma_k{clusterIndex, 1} = (((repmat(gamma_nk(:, clusterIndex), 1, P) .* XminusMu_k)' * XminusMu_k)) / N_k; 
end

end


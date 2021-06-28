function [ mu_k, sigma_k, phi_k ] = gmm_cluster( data, assignments, K, mu_k )
%GMM_CLUSTER Summary of this function goes here
%   Detailed explanation goes here

% determine number of examples
[N, P] = size(data);
phi_k = zeros(K, 1);
sigma_k = cell(K, 1);

%initialize the parameters
parfor clusterIndex = 1:K
    N_k = sum(assignments == clusterIndex);
    phi_k(clusterIndex, 1) = N_k / N;
    sigma_k{clusterIndex, 1} = cov(data(assignments == clusterIndex, :));
end


iterations = 0;
UPPERBOUND = 10;
x = zeros(UPPERBOUND, 1);
y = zeros(UPPERBOUND, 1);

while(iterations < UPPERBOUND)

    gamma_nk = zeros(N, K);
    responsibility = zeros(N, K);

    %calculate the new probability gamma-nk
    for clusterIndex = 1:K
        
        responsibility(:, clusterIndex) = phi_k(clusterIndex, 1) * normalpdf(data, mu_k(clusterIndex, :), sigma_k{clusterIndex, 1}); %
    end

    %based on the new probability, calculate new mean and covariance vectors
    parfor clusterIndex = 1:K
        gamma_nk(:, clusterIndex) = responsibility(:, clusterIndex) ./ sum(responsibility, 2); 
    end
    
    %gamma_nk(1:5, :);
    logLikelihood = sum(log(sum(responsibility, 2)), 1);

    %printNumberClusterPoints(data, gamma_nk);
    [mu_k, sigma_k, phi_k] = calculateGMMParams(data, gamma_nk);
    sigma_k{:};

    iterations = iterations + 1;
    x(iterations) = iterations;
    y(iterations) = logLikelihood;    
end
 
plot(x, y);

end 


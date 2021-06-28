function [mu] = getMaximumLikelihoodEstimate(data)
    mu = sum(data) ./ size(data, 1);
    mu = mu';
end
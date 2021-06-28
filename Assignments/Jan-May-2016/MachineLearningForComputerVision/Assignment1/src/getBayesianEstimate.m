function [mu_, sigma_] = getBayesianEstimate(data, likelihoodSigma, priorSigma, priorMu)
    N = size(data, 1);
    sigma_ = likelihoodSigma + pinv(N * pinv(likelihoodSigma) + pinv(priorSigma));
    sum_xi = sum(data', 2);
    mu_ = pinv(N * pinv(likelihoodSigma) + pinv(priorSigma)) * ((pinv(likelihoodSigma) * sum_xi) + (pinv(priorSigma) * priorMu));
end
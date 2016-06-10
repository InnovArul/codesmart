function [mu] = getMaximumAposterioriEstimate(data, likelihoodSigma, priorMu, priorSigma)
    Mu_ml = getMaximumLikelihoodEstimate(data);
    N = size(data, 1);
    mu = pinv(pinv(likelihoodSigma) + pinv(priorSigma) * (1/N)) * ((pinv(likelihoodSigma) * Mu_ml) + (pinv(priorSigma) * (1/N) * priorMu));
end
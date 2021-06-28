function [d] = getBhattacharyaDistance(groundMu, groundSigma, candidateMu, candidateSigma)
    sigmaStar = (groundSigma + candidateSigma) / 2;
    d = 0.125 * (groundMu - candidateMu)' * pinv(sigmaStar) * (groundMu - candidateMu) + 0.5 * log(det(sigmaStar) / sqrt(det(groundSigma) * det(candidateSigma)));
end
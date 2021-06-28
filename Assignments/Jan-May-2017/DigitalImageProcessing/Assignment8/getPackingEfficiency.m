function [PE] = getPackingEfficiency(M)
    diagElements = abs(diag(M));
    PE = cumsum(diagElements) / sum(diagElements);
end
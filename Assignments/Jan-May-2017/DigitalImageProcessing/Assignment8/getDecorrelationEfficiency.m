function [DE] = getDecorrelationEfficiency(M, R)
    % here M is the diagonalized matrix, R is the original matrix
    absM = abs(M);
    allsumM = sum(sum(absM));
    offdiagsumM = allsumM - sum(diag(absM));
    
    absR = abs(R);
    allsumR = sum(sum(absR));
    offdiagsumR = allsumR - sum(diag(absR));
    
    DE = 1 - (offdiagsumM / offdiagsumR);
end
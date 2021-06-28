function [DFT] = getDFT(magnitute, phase)

DFT = magnitute .* exp(1i * phase);

end
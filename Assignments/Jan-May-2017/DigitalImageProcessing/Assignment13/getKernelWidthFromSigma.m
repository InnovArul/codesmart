function [width] = getKernelWidthFromSigma(sigma)
    width = floor(6 * sigma + 1);
    if(mod(width, 2) == 0)
        width = width + 1;
    end
end
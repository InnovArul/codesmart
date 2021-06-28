function [ownWienerImg] = getWienerFilteredImage(blurredImg, h, kValue)
    %H = (fft2(h));
    H = psf2otf(h, [size(blurredImg, 1)  size(blurredImg, 1)]);
    G = (fft2(blurredImg));

    % Generate restored Wiener filter
    W = conj(H)./(abs(H).^2 + kValue);
    F = (W .* G);    
    ownWienerImg = (abs(ifft2(F)));
end
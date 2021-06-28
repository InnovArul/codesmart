function [hC, vC] = SpatialCues(im)
im=double(im);
g = fspecial('gauss', [11 11], 4);

% dx=[-1 0 1;
%     -2 0 2;
%     -1 0 1];
% dy=dx';
dy = fspecial('sobel');
vf = conv2(g, dy, 'valid');
%hf = conv2(g, dx, 'valid');
sz = size(im);

vC = zeros(sz(1:2));
hC = vC;

for b=1:size(im,3)
    vC = max(vC, abs(imfilter(im(:,:,b), vf, 'symmetric')));
    hC = max(hC, abs(imfilter(im(:,:,b), vf', 'symmetric')));
end




end
function [hC, vC] = SpatialCues_new(im)
im=double(im);
g = fspecial('gauss', [10 10], 10);

dx=[-1 0 1;
    -2 0 2;
    -1 0 1];
dy=dx';
%dy = fspecial('sobel');
vf = conv2(g, dy, 'valid');
hf = conv2(g, dx, 'valid');
sz = size(im);

vC = zeros(sz(1:2));
hC = vC;

for b=1:size(im,3)
    vC = max(vC, abs(imfilter(im(:,:,b), vf, 'symmetric')));
    hC = max(hC, abs(imfilter(im(:,:,b), hf, 'symmetric')));
end

Vmax=max(vC(:))*0.8;
Hmax=max(hC(:))*0.8;

Vmin=max(vC(:))*0.2;
Hmin=max(hC(:))*0.2;

vC=(vC-Vmin)/Vmax;
hC=(hC-Hmin)/Hmax;

vC(vC>1)=1;
hC(hC>1)=1;

vC(vC<0.1)=0;
hC(hC<0.1)=0;


vC=(vC>0);
hC=(hC>0);

hC=double(1-hC);
vC=double(1-vC);

end
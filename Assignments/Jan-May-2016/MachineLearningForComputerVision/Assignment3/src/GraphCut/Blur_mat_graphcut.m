function [sigma_mat,blured_image]= Blur_mat_graphcut(im1,im2,sigmaRange,noLevels)
% This function Computes the blur matrix between im1 and im2 ( im2 is more
% blured than im1). ie im2 uses larger aperture. 
%blured_image is the synthetically blured im1 to obtain similar blured
%image that of im2.



im1=double(im1);
im2=double(im2);

% sigmaRange=[0.01 8];
% step=0.05;
step=abs(sigmaRange(2)-sigmaRange(1))/(noLevels-1);
layer=1;
for sigma= sigmaRange(1):step:sigmaRange(2)
    val=6*sigma+1;
    hsize=min(15,round(2.*round((val+1)/2)-1));
    %hsize=max(2,hsize);
    %hsize=3;
    %h = fspecial('gaussian', [hsize hsize], sigma);
    h = fspecial('gaussian', hsize, sigma);
    im_blur=imfilter((im1),h);
    imStack(:,:,:,layer)=im_blur;
    %im_blur= imgaussfilt(im2,sigma);
    blur_diff(:,:,layer)=sum(abs(im2-im_blur).^2,3);
    layer=layer+1;
end

Dc=blur_diff;

for i=1:layer-1
    for j=1:layer-1
      Sc(i,j)=8*(1.01-0.95^(abs(i-j)));
    end
end
tic
gch = GraphCut('open', Dc, Sc);
%gch = GraphCut('open', Dc, Sc);
%[gch] = GraphCut('set', gch, int32(z1-1));
[gch, L] = GraphCut('swap',gch);
gch = GraphCut('close', gch);
toc
% Depth= (double(L))/double(max(max(L)))*255;
% Depth=medfilt2(Depth, [5 5]) ;
sigma_mat=sigmaRange(1)+double((L))*step;
%figure,imshow(uint8(Depth));


for i=1:size(L,1)
    for j=1:size(L,2)
        frame=L(i,j)+1;
        blured_image(i,j,:)=imStack(i,j,:,frame);
    end
end



% figure, subplot(1,2,1), imshow(uint8(im2));
% subplot(1,2,2), imshow(uint8(gen_blur_image));
% 
% diff=abs(im2-gen_blur_image);
% figure,imshow(uint8(abs(diff)));
% 
% sum(sum(sum(diff)))

end
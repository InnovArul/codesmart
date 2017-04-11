function  [threshold_otsu] = otsu_sigma_within( Image)
%Intuition:
%(1)pixels are divided into two groups
%(2)pixels within each group are very similar to each other 
%   Parameters:
%   t : threshold 
%   r : pixel value ranging from 1 to 255
%   q_L, q_H : the number of lower and higher group respectively
%   sigma : group variance
%   miu : group mean

nbins = 256;
counts = imhist(Image,nbins);
p = counts / sum(counts);

for t = 1 : nbins
   q_L = sum(p(1 : t));
   q_H = sum(p(t + 1 : end));
   miu_L = sum(p(1 : t) .* (1 : t)') / q_L;
   miu_H = sum(p(t + 1 : end) .* (t + 1 : nbins)') / q_H;
   sigma_w(t) = sum((((1 : t) - miu_L).^2)' .* p(1 : t))  + sum((((t+1 : nbins) - miu_H).^2)' .* p(t + 1 : end));
end

[~,threshold_otsu] = min(sigma_w(:));
disp('sigma_w');
disp(threshold_otsu);
end
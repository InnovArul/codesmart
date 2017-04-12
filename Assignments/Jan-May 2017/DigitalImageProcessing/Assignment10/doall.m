% load images
palmleaf1 = imread('./Lab10/palmleaf1.pgm');
palmleaf2 = imread('./Lab10/palmleaf2.pgm');

%% for palmleaf1.pgm

thresh = otsu_sigma_between(palmleaf1);
palmBW = im2bw(palmleaf1, thresh / 256);
imwrite(palmBW, './output/palmleaf1-sigmab.png');

thresh = otsu_sigma_within(palmleaf1);
palmBW = im2bw(palmleaf1, thresh / 256);
imwrite(palmBW, './output/palmleaf1-sigmaw.png');

thresh = graythresh(palmleaf1);
palmBW = im2bw(palmleaf1, thresh);
imwrite(palmBW, './output/palmleaf1-graythresh.png');

%% for palmleaf2.pgm

thresh = otsu_sigma_between(palmleaf2);
palmBW = im2bw(palmleaf2, thresh / 256);
imwrite(palmBW, './output/palmleaf2-sigmab.png');

thresh = otsu_sigma_within(palmleaf2);
palmBW = im2bw(palmleaf2, thresh / 256);
imwrite(palmBW, './output/palmleaf2-sigmaw.png');

thresh = graythresh(palmleaf2);
palmBW = im2bw(palmleaf2, thresh);
imwrite(palmBW, './output/palmleaf2-graythresh.png');
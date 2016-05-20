function saveSegmentedImage(imgData, labels, mu_i, filename)

global REPORT_PICS_FOLDER;

K = size(mu_i, 1);
imgRows = size(imgData, 1);
imgColumns = size(imgData, 2);
imgMaps = size(imgData, 3);

% save the segmented image
channel_R = imgData(:, :, 1);
channel_G = imgData(:, :, 2);
channel_B = imgData(:, :, 3);

for index = 1:K
    channel_R(labels==index) = mu_i(index, 1);
    channel_G(labels==index) = mu_i(index, 2);
    channel_B(labels==index) = mu_i(index, 3);
end

fig = imshow(reshape([channel_R channel_G channel_B], imgRows, imgColumns, imgMaps));
saveas(fig, fullfile(REPORT_PICS_FOLDER, filename));
close all;

end
function [x, y, g, x_left, x_right] = getDataForTask4()

global REPORT_PICS_FOLDER;

x_left = -3;
x_right = 4;

x = x_left : 0.01 : x_right;
x = x';

g = sinc(x);
y = awgn(g, 25);

scatter(x, g, 7, 'fill');
xlabel('x'); ylabel('ground truth');
title('Non-linear regression - ground truth');
saveas(gca, fullfile(REPORT_PICS_FOLDER, 'ground_truth.jpg'));
close all;

scatter(x, y, 7, 'fill');
xlabel('x'); ylabel('noise-added data');
title('Non-linear regression - noise added data');
saveas(gca, fullfile(REPORT_PICS_FOLDER, 'noise_added_data.jpg'));
close all;

end
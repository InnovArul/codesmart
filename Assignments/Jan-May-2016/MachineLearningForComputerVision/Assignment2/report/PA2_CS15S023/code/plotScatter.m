function plotScatter(xData, yData, xLabel, yLabel, graphTitle, legends, filename)
% API to plot the given data and legends, save it to appropriate report
% folder

global REPORT_PICS_FOLDER;

% create a figure
fig = figure;

% plot the data with line width of 2
scatter(xData, yData, 7, 'fill');
hold on;

% label the graph
xlabel(xLabel); ylabel(yLabel); title(graphTitle);
legend(legends); legend show;

% save the image in the report/pics directory
saveas(gcf, fullfile(REPORT_PICS_FOLDER, filename));
close(fig);

end
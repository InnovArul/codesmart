function plotGraph(xData, yData, xLabel, yLabel, graphTitle, legends, filename)
% API to plot the given data and legends, save it to appropriate report
% folder

global REPORT_PICS_FOLDER;

% create a figure
fig = figure;

C = {'r','g','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of colros.
for index = 1:size(yData, 2)
    % plot the data with line width of 2
    plot(xData, yData(:, index), 'color', C{index}, 'LineWidth', 1.5);
    hold on;
end

% label the graph
xlabel(xLabel); ylabel(yLabel); title(graphTitle);
legend(legends); legend show;

% save the image in the report/pics directory
saveas(gcf, fullfile(REPORT_PICS_FOLDER, filename));
close(fig);

end
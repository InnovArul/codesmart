function [ ] = createTablePlot( mat, xlabels, ylabels)
%CREATETABLEPLOT Summary of this function goes here
%   Detailed explanation goes here

global REPORTFOLDER;

fig = figure('visible', 'off');

imagesc(mat);            %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

textStrings = num2str(mat(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:length(xlabels), 1:length(ylabels));   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

set(gca,'XTick',1:length(xlabels),...                         %# Change the axes tick marks
        'XTickLabel',xlabels,...  %#   and tick labels
        'YTick',1:length(ylabels),...
        'YTickLabel',ylabels,...
        'TickLength',[0 0]); 

xlabel('face-data-count : non-face-data-count');
ylabel('Number of principal components');

title('Accuracy: Number of Principal components vs. Number of data points');

saveas(fig, fullfile(REPORTFOLDER, strcat('accuracies.jpg')));
close(fig);

end


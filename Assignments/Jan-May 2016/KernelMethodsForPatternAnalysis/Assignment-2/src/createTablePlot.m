function [ ] = createTablePlot( mat, xLabelVector, yLabelVector, prefix)
%CREATETABLEPLOT Summary of this function goes here
%   Detailed explanation goes here

global REPORTFOLDER DATA_TITLE;

fig = figure('visible', 'off');

imagesc(mat);            %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                     %#   black and lower values are white)

textStrings = num2str(mat(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:length(xLabelVector), 1:length(yLabelVector));   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
            'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                         %#   text color of the strings so
                                         %#   they can be easily seen over
                                         %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

set(gca,'XTick',1:length(xLabelVector),...                         %# Change the axes tick marks
    'XTickLabel',xLabelVector,...  %#   and tick labels
    'YTick',1:length(yLabelVector),...
    'YTickLabel',yLabelVector,...
    'TickLength',[0 0]);

ylabel('value of \nu');
xlabel('value of gamma in RBF');

title(DATA_TITLE);

saveas(fig, fullfile(REPORTFOLDER, strcat(DATA_TITLE , prefix, '_accuracy.jpg')));
close(fig);

end


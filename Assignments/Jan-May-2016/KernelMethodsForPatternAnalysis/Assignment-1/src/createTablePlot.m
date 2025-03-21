function [ ] = createTablePlot( mat, labelVector, is1D)
%CREATETABLEPLOT Summary of this function goes here
%   Detailed explanation goes here

if(~exist('is1D', 'var'))
   is1D = 0; 
end

global REPORTFOLDER DATA_TITLE;

fig = figure('visible', 'off');

if(is1D == 0)
    imagesc(mat);            %# Create a colored plot of the matrix values
    colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                             %#   black and lower values are white)

    textStrings = num2str(mat(:),'%0.2f');  %# Create strings from the matrix values
    textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
    [x,y] = meshgrid(1:length(labelVector));   %# Create x and y coordinates for the strings
    hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                    'HorizontalAlignment','center');
    midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
    textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                                 %#   text color of the strings so
                                                 %#   they can be easily seen over
                                                 %#   the background color
    set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

    set(gca,'XTick',1:length(labelVector),...                         %# Change the axes tick marks
            'XTickLabel',labelVector,...  %#   and tick labels
            'YTick',1:length(labelVector),...
            'YTickLabel',labelVector,...
            'TickLength',[0 0]); 

    xlabel('node counts in 2nd hidden layer');
    ylabel('node counts in 1st hidden layer');
else
    bar((mat(:, 1)));
    xlabel('node counts in 1st hidden layer');
    ylabel('validation error');
end
title(DATA_TITLE);

saveas(fig, fullfile(REPORTFOLDER, strcat(DATA_TITLE , '_validationerror.jpg')));
title(DATA_TITLE);
close(fig);

end


function [] = plotDecisionBoundary(data, labels, model, rootDirectory)

global CURRENTREPORTDIR FILEPREFIX DATA_TITLE SCATTERPOINTSIZE;

if(~exist('rootDirectory', 'var'))
    rootDirectory = CURRENTREPORTDIR;
end

if(size(data, 2) <= 2)
    minRange = min(data);
    maxRange = max(data);

    interval = (maxRange - minRange) ./ 300;
    
    if(size(minRange, 2) == 1)
        x = minRange(1):interval(1):maxRange(1);
    else 
        x = combvec(minRange(1):interval(1):maxRange(1), minRange(2):interval(2):maxRange(2));
    end    

    prediction = model(x);
    [~, classes] = max(prediction, [], 1);

    legends = {}; legendIndex = 1;

    fig = figure('visible','on');

    for index = 1: length(unique(labels))
        scatter(x(1, classes == index)', x(2,  classes == index)');
        hold all;
        
        if(sum(classes == index) ~=0)
            legends{legendIndex} = strcat('class', num2str(index));
            legendIndex = legendIndex + 1;
        end
    end
    hold on;
    scatter(data(:, 1), data(:, 2), SCATTERPOINTSIZE, labels, 'filled');
    legend(legends); legend show;
     
    title(strrep(strcat(DATA_TITLE, FILEPREFIX), '_', ':')); xlabel('x'); ylabel('y');
    saveFigureLocal(fig, fullfile(rootDirectory, strcat(FILEPREFIX, 'decisionBoundary')), 1);
    
    close(fig);
end
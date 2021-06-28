function [] = plotData(xAndy, actualData, actualLabels, outputs, sideOfSquare, prefixString, rootDirectory, decisionType, isOutput)

global CURRENTREPORTDIR FILEPREFIX DATA_TITLE SCATTERPOINTSIZE REGRESSION CLASSIFICATION;

if(~exist('rootDirectory', 'var'))
    rootDirectory = CURRENTREPORTDIR;
end

x = reshape(xAndy(:, 1), sideOfSquare, sideOfSquare);
y = reshape(xAndy(:, 2), sideOfSquare, sideOfSquare);

for index = 1 : size(outputs, 2)
    z = reshape(outputs(:, index), sideOfSquare, sideOfSquare);
    fig = figure('visible','off');
    surf(x, y, z, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
    view([-32 30]);
    colormap jet; colorbar;
    
    fileName = strcat(FILEPREFIX, prefixString, num2str(index));
    
    title(strcat(DATA_TITLE, ' : ', prefixString, 'node : ', num2str(index))); xlabel('x'); ylabel('y'); zlabel('output');
    
    saveFigureLocal(fig, fullfile(rootDirectory, strcat(fileName)));
    close(fig);    
end

if(isOutput == 1)

    % create a combined figure output and save the plot
    fig = figure('visible','off');

    for index = 1 : size(outputs, 2)
        z = reshape(outputs(:, index), sideOfSquare, sideOfSquare);
        surf(x, y, z, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
        hold on;   
    end

    if(decisionType == REGRESSION)
        %scatter3(actualData(:, 1), actualData(:, 2), actualLabels, SCATTERPOINTSIZE);
    else
        %[~, labels] = max(actualLabels, [], 2);
        %hold all;
        %scatter(actualData(:, 1), actualData(:, 2), SCATTERPOINTSIZE, 'filled');
    end
    
    colormap jet; colorbar;

    fileName = strcat(FILEPREFIX, prefixString, '_combined');
    title(strrep(strcat(DATA_TITLE, ' : ', fileName), '_', ':')); xlabel('x'); ylabel('y'); zlabel('output');
    view([-50 50]);
    saveFigureLocal(fig, fullfile(rootDirectory, strcat(fileName)));
    close(fig);
end
end
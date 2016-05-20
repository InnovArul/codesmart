function [] = plotTargetAndModelOutput(model, data, metaData, rootDirectory)

global CURRENTREPORTDIR FILEPREFIX DATA_TITLE SCATTERPOINTSIZE;

if(~exist('rootDirectory', 'var'))
    rootDirectory = CURRENTREPORTDIR;
end

minRange = min(data);
maxRange = max(data);

interval = (maxRange - minRange) ./ 100;

if(size(minRange, 2) == 2)
    x = minRange(1):interval(1):maxRange(1);
else
    x = combvec(minRange(1):interval(1):maxRange(1), minRange(2):interval(2):maxRange(2));
    sideOfSquare = size(minRange(1):interval(1):maxRange(1), 2);
end

outputs = getModelOutputs(model, x);

% plot model output & target output
fig = figure();
targetOutput = data(:, end);
modelOutput = model(data(:, 1:end-1)')';

if(size(minRange, 2) > 2)
    x1 = reshape(x(1, :)', sideOfSquare, sideOfSquare);
    y1 = reshape(x(2, :)', sideOfSquare, sideOfSquare);
    z1 = reshape(outputs(:), sideOfSquare, sideOfSquare);
    surf(x1, y1, z1, 'EdgeColor','none');
    hold on;

    scatter3(data(:, 1), data(:, 2), targetOutput, SCATTERPOINTSIZE, 'r', 'filled');
    hold on;
    scatter3(data(:, 1), data(:, 2), modelOutput, SCATTERPOINTSIZE, 'b', 'filled');
    hold on;
    zlabel('output');
    %set(hSurface, 'FaceColor',[0 1 0]);
    legend('model output boundary', 'target output for data', 'model output for data')    
else
    scatter(data(:, 1), targetOutput, SCATTERPOINTSIZE, 'r', 'filled');
    hold on;
    scatter(data(:, 1), modelOutput, SCATTERPOINTSIZE, 'b', 'filled');
    hold on;  
    legend('target output for data', 'model output for data')    
end

fileName = strcat(FILEPREFIX, metaData);
title(strcat(DATA_TITLE, ' : ', metaData)); xlabel('x'); ylabel('y'); 
legend show;
saveFigureLocal(gcf, fullfile(rootDirectory, strcat(fileName , '_scatter3d')));
close(fig);

% scatter plot with target output on x-axis and model output on y-axis
fig = figure();
title(strcat(DATA_TITLE, ' : ', metaData));
scatter(targetOutput, modelOutput, SCATTERPOINTSIZE, 'b', 'filled');
xlabel('target output'); ylabel('model output');
hold on;
fortyfiveDegLinePoints = linspace(min(min([modelOutput, targetOutput], [], 1)), max(max([modelOutput, targetOutput], [], 1)), 100);
plot(fortyfiveDegLinePoints, fortyfiveDegLinePoints);
saveFigureLocal(gcf, fullfile(rootDirectory, strcat(fileName , '_scatter2d')));
close(fig);

end
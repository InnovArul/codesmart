function [] = plotScatter( X, model, h)
%PLOTSCATTER scatter plot of data specific to all classes in different
% colors
%   

global filesuffix;
noOfClasses = size(model, 1);

fig = figure;
global titleString;

subplot(1,2,1);
colors = ['b', 'g', 'r'];

syms x y;

for classNumber = 1:noOfClasses
    hold on;
    currentData = X(X(:, end) == classNumber, :);
    scatter(currentData(:, 1), currentData(:, 2),  25, colors(classNumber), 'o', 'filled');
    covMatrix = model{classNumber, 2};
    meanX = model{classNumber, 1};
    [V, D] = eig(covMatrix);
   
    % plot the eigen vactors in the data clusters
    hold on;
    grap = ezplot(([x y] - meanX) * (V(:, 1) + eps), [min(currentData(:, 1)), max(currentData(:, 1)), min(currentData(:, 2)), max(currentData(:, 2))]);
    set(grap, 'Color', colors(classNumber));
    hold on;
    grap = ezplot(([x y] - meanX) * (V(:, 2) + eps), [min(currentData(:, 1)), max(currentData(:, 1)), min(currentData(:, 2)), max(currentData(:, 2))]);
    set(grap, 'Color', colors(classNumber));
    
end


title({'Eigen vector plot : ', [titleString{:}]});

subplot(1,2,2);

% plot the classification boundaries
xMax = max(X);
xMin = min(X);

[x1Grid,x2Grid] = meshgrid(xMin(1):h:xMax(1),xMin(2):h:xMax(2));

% determine the posterior regions
[PosteriorRegion] = BayesianClassify(model,[x1Grid(:), x2Grid(:)]); 

hold on;
colors = ['b', 'g', 'r'];

gscatter(x1Grid(:), x2Grid(:), PosteriorRegion, 'cyr', 'ooo', 3, 'filled');
legends = [];
for currClass = 1:noOfClasses
    currClassIndex = X(:, end)==currClass;
    %legends(currClass) = plot(X(currClassIndex, 1),  X(currClassIndex, 2),'o', 'MarkerFaceColor', colors(currClass), 'MarkerSize',2);
   legends(currClass) =  scatter(X(currClassIndex, 1), X(currClassIndex, 2), 25, 'o', 'filled');
end

% draw lines between the mean points
meanX = [model{:, 1}];
meanX1s = meanX(1:2:size(meanX, 2));
meanX2s = meanX(2:2:size(meanX, 2));

for index1 = 1 : size(meanX1s, 2)
    for index2 = index1 + 1 : size(meanX2s, 2)
        line([meanX1s(index1) meanX1s(index2)], [meanX2s(index1) meanX2s(index2)], 'Color','k','LineWidth',2);
    end
end

xlabel('X1'), ylabel('X2');
legend ({'class1 region', 'class2  region', 'class3 region', 'class1 points', 'class2 points', 'class3 points', '\mu_i - \mu_j lines'});
title({'2D plot decision boundary: ', [titleString{:}]});
fileN = strcat('scatter', filesuffix, '.jpg');

set(gcf,'units','normalized','outerposition',[0 0 1 1])
drawnow;
saveas(fig, fileN{:});
end


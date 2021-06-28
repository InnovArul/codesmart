function [ ] = plotSurface( X, model, h, dataOption, bayesType)
%PLOTSURFACE Summary of this function goes here
%   Detailed explanation goes here

global titleString;
global surfUpLiftDelta;
noOfClasses = size(model, 1);

%subplot(1,2,1);
figure;
% plot the classification boundaries
xMax = max(X) + 1;
xMin = min(X) - 1;
[x1Grid,x2Grid] = meshgrid(xMin(1):h:xMax(1),xMin(2):h:xMax(2));

% determine the posterior regions
[PosteriorRegion, classLabels] = getBayesianMaxLikelihood(model,[x1Grid(:),x2Grid(:)]); %getPosterior

%plot the dataset one by one
hold on;
surf(x1Grid, x2Grid, (reshape(PosteriorRegion, size(x1Grid))) + surfUpLiftDelta, reshape(classLabels, size(x1Grid)));

%legend(Legend);
%legend show;
contour(x1Grid, x2Grid, reshape(PosteriorRegion, size(x1Grid)));
hold on;
scatter(x1Grid(:), x2Grid(:), 3, classLabels);

% draw lines between the mean points
meanX = [model{:, 1}];
meanX1s = meanX(1:2:size(meanX, 2));
meanX2s = meanX(2:2:size(meanX, 2));

for index1 = 1 : size(meanX1s, 2)
    for index2 = index1 + 1 : size(meanX2s, 2)
        line([meanX1s(index1) meanX1s(index2)], [meanX2s(index1) meanX2s(index2)], 'Color','k','LineWidth',2);
    end
end

title(strcat('3D surfplot decision region: ', titleString{:}));
xLabel('X1'), yLabel('X2');
view(210, 150);

%plot a separate contour with eigen vectors
% figure;
% [C, h] = contour(x1Grid, x2Grid, reshape(PosteriorRegion, size(x1Grid)));
% title(strcat('contour plot of dataset  - ', num2str(dataOption), ' , bayesType = ', num2str(bayesType)));
% 
% for classNumber = 1:noOfClasses
%     covMatrix = model{classNumber, 2};
%     [V, D] = eig(covMatrix);
%     
% end

end


function [  ] = createAccPlotTrainValidation(  )
%CREATEACCURACYPLOTFORTRAINVALIDATION Summary of this function goes here
%   Detailed explanation goes here

modelPaths = {
  'bestmodels/filt=5-hidden1=5-hidden2=15-hidden3=5-fc1=300-fc2=150',
  'bestmodels/filt=5-hidden1=5-hidden2=15-hidden3=15-fc1=150-fc2=150'
};

for index = 1 : length(modelPaths) 
    trainAccFilePath = strcat(modelPaths{index}, '/train.log');
    trainAccuracy = load(trainAccFilePath);
    validationAccFilePath = strcat(modelPaths{index}, '/validation.log');
    valAccuracy = load(validationAccFilePath);
    
    epochs = 1:length(valAccuracy);
    fig = figure;
    plot(epochs, trainAccuracy, 'b');
    hold on;
    plot(epochs, valAccuracy, 'g');
    hold on;
    legend({'training accuracy', 'validation accuracy'});
    xlabel('number of epochs'); ylabel('accuracy');
    hold on;
    legend show;
    
    saveas(gcf, fullfile(modelPaths{index}, 'accuracy_trend.jpg'));
    close(fig);
end



end


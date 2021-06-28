function [currentAccuracy] = plotConfusionMatrix(data, actualClasses, model, suffix, path)

    disp(strcat('*** ', suffix, ' ***'))
    [predictedClasses, currentAccuracy, ~] = svmpredict(actualClasses, data, model, '-q');
    calcStats(actualClasses, predictedClasses, 5, suffix);
    currentAccuracy = currentAccuracy(1);
end
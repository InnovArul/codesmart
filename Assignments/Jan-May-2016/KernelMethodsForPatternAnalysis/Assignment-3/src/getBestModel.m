function bestModel = getBestModel(allModels)
    bestModel = [];
    bestPercentage = 0;
    for index = 1:length(allModels)
        currentModel = allModels{index};
        if(currentModel('accuracy') > bestPercentage)
            bestPercentage = currentModel('accuracy');
            bestModel = currentModel;
        end
    end
end
function [] = doPlotsForBestModel(modelHolder, trainData, validationData, testData, decisionType)
    epochs = {1, 2, 10, 50, 100, inf};
    global FILEPREFIX CLASSIFICATION REGRESSION;
    
    initialModel = modelHolder.initial;
    outputLayerNodeCount = initialModel.layers{end}.size;
    mkdir(modelHolder.reportfolder);
    
    totalData = [trainData(:, 1:end-outputLayerNodeCount);
             validationData(:, 1:end-outputLayerNodeCount);
             testData(:, 1:end-outputLayerNodeCount)
             ];
       
    totalLabels = [trainData(:, end-outputLayerNodeCount+1:end); 
               validationData(:, end-outputLayerNodeCount+1:end); 
               testData(:, end-outputLayerNodeCount+1:end); 
             ];
             
    tempGlobalPrefix = FILEPREFIX;
    
    for epochIndex = 1:length(epochs)  
       epoch = epochs{epochIndex};
       FILEPREFIX = strcat(tempGlobalPrefix, '_epoch_', num2str(epoch), '_');

       %set the number of epochs needed
       if(epoch ~= inf)
           initialModel.trainparam.epochs = epoch;
       end
       
       % train the model
       [currentModel, trainRecord] = train(initialModel, totalData', totalLabels','useParallel','yes');
       
       % validate the model
       currentValidationData = totalData(trainRecord.valInd, :)';
       currentValidationLabels = totalLabels(trainRecord.valInd, :)';
       prediction = currentModel(currentValidationData);
       validationPerformance = perform(currentModel, currentValidationLabels, prediction);

       Output.DEBUG(strcat('validation error: ', num2str(validationPerformance)));
       
       % plots, if needed
       % S-plots
       % plot layer outputs
       if(size(trainData(:, 1:end-outputLayerNodeCount), 2) == 2)
            plotLayerOutputs(trainData(:, 1:end-outputLayerNodeCount), trainData(:, end-outputLayerNodeCount+1:end), currentModel, modelHolder.reportfolder, decisionType);   
       end
        
       switch(decisionType)
           case REGRESSION
               % plot 45 degree plot & model output for the training,
               % testing, validation data
               plotTargetAndModelOutput(currentModel, trainData, 'train-data', modelHolder.reportfolder);
               plotTargetAndModelOutput(currentModel, validationData, 'validation-data', modelHolder.reportfolder);
               plotTargetAndModelOutput(currentModel, testData, 'test-data', modelHolder.reportfolder);
               
           case CLASSIFICATION
               plotconfusion(currentValidationLabels, prediction);
               print(gcf, '-dpng', fullfile(modelHolder.reportfolder, strcat(FILEPREFIX, 'confusion.png')));
               close all;

               % plot the decision boundary
               [~, trainLabels] = max(trainData(:, end-outputLayerNodeCount+1:end), [], 2);
               plotDecisionBoundary(trainData(:, 1:end-outputLayerNodeCount), trainLabels, currentModel, modelHolder.reportfolder);
       end
    end
    
    FILEPREFIX = tempGlobalPrefix;
        
end
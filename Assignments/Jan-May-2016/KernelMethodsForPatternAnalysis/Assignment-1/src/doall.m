function [] = doall(dataType, hiddenLayerCount, decisionType)
% DOALL(type) perform complete training, testing, plotting of given type of
% data
% !!! DONOT FORGET TO ADDPATH('nn') before calling doall()
% types of data:
% 1 = IMAGE DATA
% 2 = 

Output.level(Output.DISP_DEBUG);
clc;

% decisionType:
% 1 = CLASSIFICATION
% 2 = REGRESSION

global REPORTFOLDER CURRENTREPORTDIR FILEPREFIX DATA_TITLE SCATTERPOINTSIZE;
REPORTFOLDER = '../report/pics/'; CURRENTREPORTDIR = REPORTFOLDER;
FILEPREFIX = '';
DATA_TITLE = '';
SCATTERPOINTSIZE = 12;

global REGRESSION CLASSIFICATION;
CLASSIFICATION = 1;
REGRESSION = 2;

global HIDDEN_LAYER_CONFIG;
HIDDEN_LAYER_CONFIG = [];

[trainData, testData, validationData] = loadData(dataType);
rawTrainLabels = trainData(:, end);
rawValidationLabels = validationData(:, end);
rawTestLabels = testData(:, end);

model = [];
outputLayerNodeCount = 0;

% now perform the model configuration
switch(decisionType)
    case CLASSIFICATION
        %determine number of output nodes needed
        outputLayerNodeCount = length(unique(trainData(:, end)));
        %create the model
        model = createModel(hiddenLayerCount);
        % set the needed output layer count
        %model.layers{end}.size = outputLayerNodeCount;
        % set the transfer function of output layer to 'softmax'
        model = setSoftMaxOutput(model);
        model = setCrossEntropyLoss(model);
        model = setModelDataDivideConfig(model, trainData, validationData, testData);
        
        trainData = prepare1ofKData(trainData);
        testData = prepare1ofKData(testData);
        validationData = prepare1ofKData(validationData);
        
        Output.DEBUG('model created!');
       
    case REGRESSION
        % by default, the lossfunction is MSE, final layer activation
        % function is pure linear. so, just create the network and do
        % nothing else
        outputLayerNodeCount = 1;
        model = createModel(hiddenLayerCount);
        
        model = setModelDataDivideConfig(model, trainData, validationData, testData);
        
end

model.outputs{end}.processFcns = {};
model.inputs{1}.processFcns = {};
model.trainFcn = 'trainlm';

% set the hidden layer configuration
singleConfiguration = setHiddenLayerConfig(hiddenLayerCount);


totalData = [trainData(:, 1:end-outputLayerNodeCount);
             validationData(:, 1:end-outputLayerNodeCount);
             testData(:, 1:end-outputLayerNodeCount)
             ];
      
       
totalLabels = [trainData(:, end-outputLayerNodeCount+1:end); 
               validationData(:, end-outputLayerNodeCount+1:end); 
               testData(:, end-outputLayerNodeCount+1:end); 
             ];
         
%plot the data
switch(decisionType)
    case CLASSIFICATION
        if(size(totalData, 2) == 2)
            fig = figure;
            legends = {};
            for classNumber = 1:outputLayerNodeCount
                scatter(totalData(totalLabels(:, classNumber) == 1, 1), totalData(totalLabels(:, classNumber) == 1, 2), 12, ones(sum(totalLabels(:, classNumber) == 1), 1) * classNumber, 'filled');
                hold on;
                legends{classNumber} = strcat('class', num2str(classNumber));
            end
            title(DATA_TITLE); xlabel('x'); ylabel('y')
            legend(legends); legend show;
            saveFigureLocal(fig, fullfile(REPORTFOLDER, 'dataPlot'));
            
            close(fig);
        end
        
    case REGRESSION
        
        if(size(totalData, 2) == 2)
            fig = figure;
            scatter3(trainData(:, 1), trainData(:, 2), trainData(:, 3), 10, 'b', 'filled');  
            title(DATA_TITLE); xlabel('x'); ylabel('y')
            saveFigureLocal(fig, fullfile(REPORTFOLDER, 'dataPlot'));
            
            close(fig)        
        elseif(size(totalData, 2) == 1)
            fig = figure;
            scatter(trainData(:, 1), trainData(:, 2), 10, 'b', 'filled');  
            title(DATA_TITLE); xlabel('x'); ylabel('y')
            saveFigureLocal(fig, fullfile(REPORTFOLDER, 'dataPlot'));
            
            close(fig)        
        
        end
end

CURRENTREPORTDIR = REPORTFOLDER;

%while the next hidden layer configuration available
%for learningRate = 0.1:0.15:1
   % set the layer configuration
   % loop until there is a hidden layer configuration to be tested for this
   % learning rate
   modelsBuffer = [];
   modelCounter = 1;
   
   singleConfigLength = length(singleConfiguration);

   validationLoss = zeros(singleConfigLength, singleConfigLength);
   
   [currentModel, configuration, nodeTotal] = setNextHiddenLayerConfig(model);
   
   rowIndex = 1;
   columnIndex = 1;
   
   while(~isempty(currentModel))
       currentModel.trainParam.showWindow=0;

       %configure the model for input and output
       currentModel = configure(currentModel, totalData', totalLabels');

       % store the initial model
       modelsBuffer(modelCounter).initial = currentModel;
       
       % train the model
       [currentModel, trainRecord] = train(currentModel, totalData', totalLabels');

       % validate the model
       currentValidationData = totalData(trainRecord.valInd, :);
       currentValidationLabels = totalLabels(trainRecord.valInd, :);
       
       prediction = currentModel(currentValidationData');
       
       % determine validation error
       validationErrorRate = 0;

       if(decisionType == CLASSIFICATION)
            [~, actual] = max(currentValidationLabels, [], 2);
            [~, predicted] = max(prediction', [], 2);
            validationErrorRate = 100 - calcStats(actual, predicted, outputLayerNodeCount);
       else   
           validationErrorRate = perform(currentModel, currentValidationLabels', prediction);
       end
       
       validationLoss(rowIndex, columnIndex) = validationErrorRate;
       
       % update row index and column index
       rowIndex = rowIndex + 1;
       if(rowIndex > singleConfigLength)
           rowIndex = 1;
           columnIndex = columnIndex + 1;
       end

       Output.DEBUG(strcat('validation error: ', num2str(validationErrorRate), '\n'));

       %[~, ~, ~, percents] = confusion(currentValidationLabels, prediction);
       %plotconfusion(currentValidationLabels, prediction)

       % store the model and corresponding validation and test accuracy
       %modelsBuffer(modelCounter).percents = percents;
       modelsBuffer(modelCounter).model = currentModel;
       modelsBuffer(modelCounter).trainrecord = trainRecord;
       modelsBuffer(modelCounter).reportfolder = CURRENTREPORTDIR;
       modelsBuffer(modelCounter).valError = validationErrorRate;
       modelsBuffer(modelCounter).config = configuration;
       modelsBuffer(modelCounter).totalNodes = nodeTotal;
       
       Output.DEBUG(strcat('best performance : ', num2str(trainRecord.best_perf)));
       
       [currentModel, configuration, nodeTotal] = setNextHiddenLayerConfig(model);
       modelCounter = modelCounter + 1;        
   end
   
   % plot validation error table plot
   if(hiddenLayerCount == 2)
        createTablePlot(validationLoss, singleConfiguration);
   else
       createTablePlot(validationLoss, singleConfiguration, 1);
   end
   
   % select the model based on validation accuracy
   [bestModel, bestPercentage] = getBestModel(modelsBuffer);
   
   %update file prefix
   FILEPREFIX = bestModel.config;
   save(fullfile(REPORTFOLDER, strcat(FILEPREFIX, 'bestmodel.mat')), 'bestModel');
   
   % plot the things for best model (confusion matrix, hidden layer plots,
   % decision boundarz plots)
   doPlotsForBestModel(bestModel, trainData, validationData, testData, decisionType);
  
%end

end
function [] = plotLayerOutputs(data, labels, model, rootDirectory, decisionType)
%PLOTHIDDENLAYEROUTPUT Summary of this function goes here
%   Detailed explanation goes here

if(size(data, 2) <= 2)
    if(1)
        minRange = min(data);
        maxRange = max(data);

        interval = (maxRange - minRange) ./ 100;

        if(size(minRange, 2) == 1)
            x = minRange(1):interval(1):maxRange(1);
        else 
            x = combvec(minRange(1):interval(1):maxRange(1), minRange(2):interval(2):maxRange(2));
            sideOfSquare = size(minRange(1):interval(1):maxRange(1), 2);
        end
    else
        x = data'; 
        sideOfSquare = length(x);
    end
    
    inputWeights = model.IW{1,1};
    firstLayerOutput = getActivationOutput(model.layers{1}.transferFcn, [ones(1, size(x, 2)); x]' * [model.b{1} inputWeights]'); 
    
    % plot all the outputs
    plotData(x', data, labels, firstLayerOutput, sideOfSquare, 'hidden layer 1 :', rootDirectory, decisionType, 0);
    currentInput = firstLayerOutput;
    
    for hiddenLayerIndex = 1:length(model.layers) - 1
       currentWeight = model.LW{hiddenLayerIndex + 1, hiddenLayerIndex}; 
       outputs = getActivationOutput(model.layers{hiddenLayerIndex + 1}.transferFcn, [ones(size(currentInput, 1), 1) currentInput] * [model.b{hiddenLayerIndex + 1} currentWeight]');
       
       layertype = strcat('hidden layer 2 :', num2str(hiddenLayerIndex + 1));
       isOutput = 0;
       
       if(hiddenLayerIndex + 1 == size(model.layers, 1))
           layertype = 'output layer : ';
           isOutput = 1;
       end
           
       plotData(x', data, labels, outputs, sideOfSquare, strcat(layertype), rootDirectory, decisionType, isOutput);
       
       currentInput = outputs;
    end

end

end


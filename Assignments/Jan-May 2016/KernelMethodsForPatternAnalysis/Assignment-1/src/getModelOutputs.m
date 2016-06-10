function [outputs] = getModelOutputs(model, x)
 
    inputWeights = model.IW{1,1};
    firstLayerOutput = getActivationOutput(model.layers{1}.transferFcn, [ones(1, size(x, 2)); x]' * [model.b{1} inputWeights]'); 
    currentInput = firstLayerOutput;
    
    for hiddenLayerIndex = 1:length(model.layers) - 1
       currentWeight = model.LW{hiddenLayerIndex + 1, hiddenLayerIndex}; 
       outputs = getActivationOutput(model.layers{hiddenLayerIndex + 1}.transferFcn, [ones(size(currentInput, 1), 1) currentInput] * [model.b{hiddenLayerIndex + 1} currentWeight]');
       currentInput = outputs;
    end


end
function [newModel] = setSoftMaxOutput(model)
% sets the perform function of the model as softmax function
    model.layers{end}.transferFcn = 'softmax'; 
    %model.train
    newModel = model;
end
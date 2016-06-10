function [newModel] = setCrossEntropyLoss(model)

model.performFcn = 'crossentropy';
model.performParam.regularization = 0.1;
model.performParam.normalization = 'none';

newModel = model;

end
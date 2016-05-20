function [ net ] = createModel( hiddenLayerCount )
%CREATEMODEL creates a model with specific hidden layer sizes and return
%the model

%create dummy hidden layers according to hiddenLayerCount
net = feedforwardnet(ones(1, hiddenLayerCount));

end


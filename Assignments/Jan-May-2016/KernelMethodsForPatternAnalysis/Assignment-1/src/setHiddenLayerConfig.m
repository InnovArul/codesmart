function [singleConfiguration] = setHiddenLayerConfig( hiddenLayerCount )
%setHiddenLayerConfig Summary of this function goes here
%   Detailed explanation goes here

global HIDDEN_LAYER_CONFIG;

% increase 2 nodes every step
singleConfiguration = 1:3:15;

% setup the configuration for hidden layers
if(hiddenLayerCount == 1)
    HIDDEN_LAYER_CONFIG = [combvec(singleConfiguration)]';
else
    HIDDEN_LAYER_CONFIG = [combvec(singleConfiguration, singleConfiguration)]';
end

end


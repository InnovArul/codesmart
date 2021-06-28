 function [retModel, configuration, nodeTotal] = setNextHiddenLayerConfig( model )
%SETNEXTHIDDENLAYERCONFIG Summary of this function goes here
%   Detailed explanation goes here

persistent HIDDEN_LAYER_CONFIG_COUNTER;
global HIDDEN_LAYER_CONFIG CURRENTREPORTDIR REPORTFOLDER;
nodeTotal = 0;

% if the hidden layer counter is empty, set it to 1
if(isempty(HIDDEN_LAYER_CONFIG_COUNTER))
    HIDDEN_LAYER_CONFIG_COUNTER = 1;
end

% reset the counter, if count is exceeded
if(HIDDEN_LAYER_CONFIG_COUNTER > size(HIDDEN_LAYER_CONFIG, 1))
    HIDDEN_LAYER_CONFIG_COUNTER = 1;
    retModel = [];
    configuration = 'empty';
    return;
end

% get the next hidden layer configuration
nextConfig = HIDDEN_LAYER_CONFIG(HIDDEN_LAYER_CONFIG_COUNTER, :);
Output.DEBUG('hidden layer configuration');
%configuration = evalc(['disp(nextConfig)']);


% set the hidden layer sizes
folderName = '';
for hiddenLayerIndex = 1:length(nextConfig)
    model.layers{hiddenLayerIndex}.size = nextConfig(1, hiddenLayerIndex);
    folderName = strcat(folderName, '_', num2str(nextConfig(1, hiddenLayerIndex)));
end

configuration = folderName;
Output.DEBUG(configuration);

nodeTotal = sum(sum(nextConfig));

%update the current report directory and create the folder
CURRENTREPORTDIR = fullfile(REPORTFOLDER, folderName); 
%mkdir(CURRENTREPORTDIR);
Output.DEBUG(strcat('report folder :', CURRENTREPORTDIR));

% increase the counter
HIDDEN_LAYER_CONFIG_COUNTER = HIDDEN_LAYER_CONFIG_COUNTER + 1;

retModel = model;

end


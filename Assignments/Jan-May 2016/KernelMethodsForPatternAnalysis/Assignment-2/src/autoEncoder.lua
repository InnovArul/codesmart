-- include relevant files
require 'torch'
require 'nn'
require 'cunn'
require 'unsup'
matio = require 'matio'

function create_autoEncoder(numHiddenLayers, hiddenLayerCounts)
  middlePoint = hiddenLayerCounts:size(1) / 2;
  
  --create Encoder
  encoder = nn.Sequential();
  
  for index = 1, middlePoint do
    encoder:add(nn.Linear(hiddenLayerCounts[index], hiddenLayerCounts[index+1]));
    
    if(index == middlePoint) then
      -- do nothing , leave it as a linear layer
    else
      encoder:add(nn.Tanh());
    end
  end
  
  --create decoder
  decoder = nn.Sequential();  
  
  for index = middlePoint+1, hiddenLayerCounts:size(1) do
    decoder:add(nn.Linear(hiddenLayerCounts[index], hiddenLayerCounts[index+1]));
    
    if(index == hiddenLayerCounts:size(1)) then
      -- do nothing , leave it as a linear layer
    else
      decoder:add(nn.Tanh());
    end
  end  
  
  --create auto-associative network
  autoEncoder = unsup.AutoEncoder(encoder, decoder);
  
  --return encoder, decoder, autoencoder
  return encoder, decoder, autoEncoder
  
end

hiddenLayersCount = torch.Tensor({5, 10, 4, 10, 5});
create_autoEncoder(4, hiddenLayersCount);
----------------------------------------------------------------------
-- This script demonstrates how to define a couple of different
-- models:
--   + linear
--   + 2-layer neural network (MLP)
--   + convolutional network (ConvNet)
--
-- It's a good idea to run this script with the interactive mode:
-- $ th -i 2_model.lua
-- this will give you a Torch interpreter at the end, that you
-- can use to play with the model.
--
-- Clement Farabet
----------------------------------------------------------------------

require 'torch'   -- torch
require 'image'   -- for image transforms
require 'nn'      -- provides all sorts of trainable modules/layers
logger = require 'log'
require 'nngraph'

----------------------------------------------------------------------
-- parse command line arguments
if not opt then
   logger.trace '==> processing options'
   cmd = torch.CmdLine()
   cmd:text()
   cmd:text('SVHN Model Definition')
   cmd:text()
   cmd:text('Options:')
   cmd:option('-visualize', true, 'visualize input data and weights during training')
   cmd:text()
   opt = cmd:parse(arg or {})
end

----------------------------------------------------------------------
logger.trace '==> define parameters'

-- 10-class problem
noutputs = 10

-- input dimensions
nfeats = 3
width = 32
height = 32

COLOR_CONV = 'cyan';
COLOR_POOL = 'grey';
COLOR_SOFTMAX = 'green';
COLOR_FC = 'orange';
COLOR_AUGMENTS = 'brown';

TEXTCOLOR = 'black';
NODESTYLE = 'filled';

-- hidden units, filter sizes (for ConvNet only):

poolsize = 2

function createModel(nstates, filtsize)

  ----------------------------------------------------------------------
  logger.trace '==> construct model'

  -- a typical convolutional network, with locally-normalized hidden
  -- units, and L2-pooling
  input = nn.Identity()()
  conv1 = nn.SpatialConvolution(nfeats, nstates[1], filtsize, filtsize, 1, 1, math.floor(filtsize/2), math.floor(filtsize/2))(input):annotate{
            name='Convolution unit(1)',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_CONV}
        };
        
  maxpool1 = nn.SpatialAveragePooling(poolsize,poolsize,poolsize,poolsize)(conv1):annotate{
            name='Average pooling unit(1)',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_POOL}
        };
  
  conv2 = nn.SpatialConvolution(nstates[1], nstates[2], filtsize, filtsize, 1, 1, math.floor(filtsize/2), math.floor(filtsize/2))(maxpool1):annotate{
            name='Convolution unit(2)',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_CONV}
        };
        
  maxpool2 = nn.SpatialAveragePooling(poolsize,poolsize,poolsize,poolsize)(conv2):annotate{
            name='Average pooling unit(2)',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_POOL}
        };
  

  conv3 = nn.SpatialConvolution(nstates[2], nstates[3], filtsize, filtsize, 1, 1, math.floor(filtsize/2), math.floor(filtsize/2))(maxpool2):annotate{
            name='Convolution unit(3)',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_CONV}
        };

  maxpool3 = nn.SpatialAveragePooling(poolsize,poolsize,poolsize,poolsize)(conv3):annotate{
            name='Average pooling unit(3)',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_POOL}
        };

  reshape = nn.Reshape(nstates[3]*4*4)(maxpool3):annotate{
            name='Reshaping unit',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_AUGMENTS}
        };

  lin1 = nn.Linear(nstates[3]*4*4, nstates[4])(reshape):annotate{
            name='Fully connected layer - 1',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_FC}
        };
        
  lin2 = nn.Linear(nstates[4], nstates[5])(lin1):annotate{
            name='Fully connected layer - 2',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_FC}
        };
        
  lin3 = nn.Linear(nstates[5], nstates[6])(lin2):annotate{
            name='output layer',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_FC}
        };

  softmax = nn.LogSoftMax()(lin3):annotate{
            name='Softmax layer',
            graphAttributes = {color = TEXTCOLOR, style = NODESTYLE, fillcolor = COLOR_SOFTMAX}
        };

  model = nn.gModule({input}, {softmax})
  
graph.dot(model.fg, currentTestLabel, paths.concat(rootFolder, currentTestLabel .. '.png'))
io.read()         

  
  ----------------------------------------------------------------------
  logger.trace '==> here is the model:'
  logger.trace(model.modules)
  
  ----------------------------------------------------------------------
  -- Visualization is quite easy, using itorch.image().

  if opt.visualize then
     if opt.model == 'convnet' then
        if itorch then
         logger.trace '==> visualizing ConvNet filters'
         logger.trace('Layer 1 filters:')
         image.display(model:get(1).weight)
         logger.trace('Layer 2 filters:')
         image.display(model:get(5).weight)
        else
          logger.trace '==> To visualize filters, start the script in itorch notebook'
          end
     end
  end

end
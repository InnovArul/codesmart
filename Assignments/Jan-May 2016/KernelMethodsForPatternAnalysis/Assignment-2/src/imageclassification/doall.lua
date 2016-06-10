----------------------------------------------------------------------
-- This tutorial shows how to train different models on the street
-- view house number dataset (SVHN),
-- using multiple optimization techniques (SGD, ASGD, CG), and
-- multiple types of models.
--
-- This script demonstrates a classical example of training 
-- well-known models (convnet, MLP, logistic regression)
-- on a 10-class classification problem. 
--
-- It illustrates several points:
-- 1/ description of the model
-- 2/ choice of a loss function (criterion) to minimize
-- 3/ creation of a dataset as a simple Lua table
-- 4/ description of training and test procedures
--
-- Clement Farabet
----------------------------------------------------------------------
require 'torch'

----------------------------------------------------------------------
print '==> processing options'

cmd = torch.CmdLine()
cmd:text()
cmd:text('SVHN Loss Function')
cmd:text()
cmd:text('Options:')
-- global:
cmd:option('-seed', 1, 'fixed input seed for repeatable experiments')
cmd:option('-threads', 2, 'number of threads')
-- data:
cmd:option('-size', 'full', 'how many samples do we load: small | full | extra')
-- model:
-- loss:
cmd:option('-loss', 'nll', 'type of loss function to minimize: nll | mse | margin')
-- training:
cmd:option('-save', 'results', 'subdirectory to save/log experiments in')
cmd:option('-plot', true, 'live plot')
cmd:option('-optimization', 'SGD', 'optimization method: SGD | ASGD | CG | LBFGS')
cmd:option('-learningRate', 2e-2, 'learning rate at t=0')
cmd:option('-batchSize', 128, 'mini-batch size (1 = pure stochastic)')
cmd:option('-weightDecay', 5e-4, 'weight decay (SGD only)')
cmd:option('-momentum', 0.9, 'momentum (SGD only)')
cmd:option('-t0', 1, 'start averaging at t0 (ASGD only), in nb of epochs')
cmd:option('-maxIter', 2, 'maximum nb of iterations for CG and LBFGS')
cmd:option('-type', 'cuda', 'type: double | float | cuda')
cmd:text()
opt = cmd:parse(arg or {})

opt.augmentData = true

-- nb of threads and fixed seed (for repeatable experiments)
if opt.type == 'float' then
   print('==> switching to floats')
   torch.setdefaulttensortype('torch.FloatTensor')
elseif opt.type == 'cuda' then
   print('==> switching to CUDA')
   require 'cunn'
   torch.setdefaulttensortype('torch.FloatTensor')
end
torch.setnumthreads(opt.threads)
torch.manualSeed(opt.seed)

----------------------------------------------------------------------
print '==> executing all'

-- classes
classes = {'1','2','3','4','5'}

dofile '1_data.lua'
dofile '2_model.lua'
dofile '3_loss.lua'
dofile '4_train.lua'
dofile '5_validate.lua'
dofile '6_test.lua'
logger = require 'log'

matio = require 'matio'

----------------------------------------------------------------------
logger.trace '==> training!'

epoch = 1;
filtsize = 0;
nstates = {}
rootFolder = './results_sample';
paths.mkdir(rootFolder)
accuracyDetails = {}
best_accuracy = 0;
bestEpoch = 0;

for filter = 5, 5, -2 do
  filtsize = filter
  
  for hidden1 = 15,15, 10 do
    nstates[1] = hidden1
    
    for hidden2 = 25, 25, 10 do
      nstates[2] = hidden2
      
      for hidden3 = 20, 20, 10 do  
        nstates[3] = hidden3
        
        currentConvLayerOutput = hidden3 * 4 * 4;
        
        for fc1 = 500, 500, 150 do
          nstates[4] = fc1
          
          for fc2 = 500, 500, 150 do
            nstates[5] = fc2
            nstates[6] = 5 -- 5 classes
          
            --create new folder for current test
            currentTestLabel = 'aug_filt=' .. filter .. '-hidden1=' .. hidden1 .. '-hidden2=' .. hidden2 .. '-hidden3=' .. hidden3 .. '-fc1=' .. fc1 .. '-fc2=' .. fc2;
            opt.save = paths.concat(rootFolder, currentTestLabel);
            paths.mkdir(opt.save);
            
            --log file
            logger.outfile = paths.concat(opt.save, currentTestLabel .. '.log');
            
            --create the model 
            createModel(nstates, filtsize)
            defineLoss()
            
            epoch = 1
            
            -- set the optim parameters and states
            setDefaultStates()          
            
            --run for 1000 epochs
            while epoch <= 500 do
               train()
               validate()
            end
            
            --print accuracy
            logger.trace('best accuracy : ' .. best_accuracy .. ' at the epoch : ' .. bestEpoch);
            accuracyDetails[currentTestLabel] = {
              bestAccuracy = best_accuracy,
              epoch = bestEpoch,
            }
            
            --save accuracy for post-processing
            matio.save(paths.concat('accuracies.mat'), {details = accuracyDetails})
          end          
        end
      end
    end
  end
end

-- create training accuracy , validation accuracy graph to show overfitting

-- after the training is finished, choose the model with best validation accuracy & 
-- test using test data

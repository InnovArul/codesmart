require 'torch'

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
require 'nn'

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
cmd:option('-size', 'small', 'how many samples do we load: small | full | extra')
-- model:
cmd:option('-model', 'convnet', 'type of model to construct: linear | mlp | convnet')
-- loss:
cmd:option('-loss', 'nll', 'type of loss function to minimize: nll | mse | margin')
-- training:
cmd:option('-save', 'results', 'subdirectory to save/log experiments in')
cmd:option('-plot', false, 'live plot')
cmd:option('-optimization', 'SGD', 'optimization method: SGD | ASGD | CG | LBFGS')
cmd:option('-learningRate', 1e-3, 'learning rate at t=0')
cmd:option('-batchSize', 1, 'mini-batch size (1 = pure stochastic)')
cmd:option('-weightDecay', 0, 'weight decay (SGD only)')
cmd:option('-momentum', 0, 'momentum (SGD only)')
cmd:option('-t0', 1, 'start averaging at t0 (ASGD only), in nb of epochs')
cmd:option('-maxIter', 2, 'maximum nb of iterations for CG and LBFGS')
cmd:option('-type', 'double', 'type: double | float | cuda')
cmd:option('-visualize', true, 'visualize input data and weights during training')
cmd:text()
opt = cmd:parse(arg or {})

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

--include SVHN specific modules
dofile '1_data.lua'
dofile '2_model.lua'
dofile '3_loss.lua'
dofile '4_train.lua'
dofile '5_test.lua'


----------------------------------------------------------------------
print '==> training!'
--
--train to 10 epoch's in SVHN data & test with MNIST data
epoch = 1
print('===> starting to train with SVHN dataset & test with MNIST dataset')
while epoch <= 10 do
   train()
   test()
end

--*******************************************************************************
-- Training the model with SVHN dataset for 10 epochs is finished
-- Now load the trained SVHN model and fine tune it with MNIST training dataset
--*******************************************************************************

--include MNIST specific modules
dofile '1_data_mnist.lua'

print('===> loading SVHN model')
model = torch.load('./results/model.net')

--load training data as MNIST data
print('===> changing training data from SVHN dataset to MNIST dataset')

dofile '3_loss.lua'
dofile '4_train.lua'
dofile '5_test.lua'


print('===> starting to train with MNIST dataset & test with MNIST dataset with the previous trained model')

-- after 10 epochs, train and test with MNIST data & notice the behaviour
epoch = 1
while epoch <= 10 do
   train()
   test()
end

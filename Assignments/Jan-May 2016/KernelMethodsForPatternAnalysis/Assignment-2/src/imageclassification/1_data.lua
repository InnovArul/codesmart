----------------------------------------------------------------------
-- This script demonstrates how to load the (SVHN) House Numbers 
-- training data, and pre-process it to facilitate learning.
--
-- The SVHN is a typical example of supervised training dataset.
-- The problem to solve is a 10-class classification problem, similar
-- to the quite known MNIST challenge.
--
-- It's a good idea to run this script with the interactive mode:
-- $ th -i 1_data.lua
-- this will give you a Torch interpreter at the end, that you
-- can use to analyze/visualize the data you've just loaded.
--
-- Clement Farabet
----------------------------------------------------------------------

require 'torch'   -- torch
require 'image'   -- for color transforms
require 'nn'      -- provides a normalization operator
require 'lfs'
matio = require 'matio'
require 'io'
dofile 'utilities.lua'
logger = require 'log'

----------------------------------------------------------------------
-- parse command line arguments
if not opt then
   logger.trace '==> processing options'
   cmd = torch.CmdLine()
   cmd:text()
   cmd:text('SVHN Dataset Preprocessing')
   cmd:text()
   cmd:text('Options:')
   cmd:option('-size', 'small', 'how many samples do we load: small | full | extra')
   cmd:option('-visualize', true, 'visualize input data and weights during training')
   cmd:text()
   opt = cmd:parse(arg or {})
end

----------------------------------------------------------------------
logger.trace '==> loading dataset'


labelsFile = paths.concat(getRootPath(), 'Group_14_data.mat')
matio.use_lua_strings = true

nnConfigFile = paths.concat(getRootPath(), 'nnconfig.mat')
nnconfig = matio.load(nnConfigFile);

trainConfig = nnconfig.train; testConfig = nnconfig.test; validationConfig = nnconfig.validation;

--collect all the indices of images, based on classes
--split into train(75%), test(12.5%) and validation(12.5%)
--store the configuration (train, test, validation)
--load images and labels for train, test, validation and prepare coresponding data strictures trainData, testData

--load train files
loaded = {}
loaded.X, loaded.y = loadImagesAndLabels(trainConfig)
if(opt.augmentData == true) then
  loaded.X, loaded.y = augmentData(loaded.X, loaded.y)
end

trainData = {
   data = loaded.X,
   labels = loaded.y,
   size = loaded.X:size(1)
}

-- we load the validation data.
loaded = {}
loaded.X, loaded.y = loadImagesAndLabels(validationConfig)
validationData = {
   data = loaded.X,
   labels = loaded.y,
   size = loaded.X:size(1)
}

-- Finally we load the test data.
loaded = {}
loaded.X, loaded.y = loadImagesAndLabels(testConfig)
testData = {
   data = loaded.X,
   labels = loaded.y,
   size = loaded.X:size(1)
}

-- load classes
classStrcut = nnconfig.classes;

classes = {}
for index = 6,10 do
  classes[index - 5] = nnconfig.classes[index]
end
 
 --[[
----------------------------------------------------------------------
logger.trace '==> preprocessing data'

-- Preprocessing requires a floating point representation (the original
-- data is stored on bytes). Types can be easily converted in Torch, 
-- in general by doing: dst = src:type('torch.TypeTensor'), 
-- where Type=='Float','Double','Byte','Int',... Shortcuts are provided
-- for simplicity (float(),double(),cuda(),...):

trainData.data = trainData.data:float()
testData.data = testData.data:float()

-- We now preprocess the data. Preprocessing is crucial
-- when applying pretty much any kind of machine learning algorithm.

-- For natural images, we use several intuitive tricks:
--   + images are mapped into YUV space, to separate luminance information
--     from color information
--   + the luminance channel (Y) is locally normalized, using a contrastive
--     normalization operator: for each neighborhood, defined by a Gaussian
--     kernel, the mean is suppressed, and the standard deviation is normalized
--     to one.
--   + color channels are normalized globally, across the entire dataset;
--     as a result, each color component has 0-mean and 1-norm across the dataset.

-- Convert all images to YUV
logger.trace '==> preprocessing data: colorspace RGB -> YUV'
for i = 1,trainData.size do
   trainData.data[i] = image.rgb2yuv(trainData.data[i])
end
for i = 1,validationData.size do
   validationData.data[i] = image.rgb2yuv(validationData.data[i])
end
for i = 1,testData.size do
   testData.data[i] = image.rgb2yuv(testData.data[i])
end

-- Name channels for convenience
channels = {'y','u','v'}

-- Normalize each channel, and store mean/std
-- per channel. These values are important, as they are part of
-- the trainable parameters. At test time, test data will be normalized
-- using these values.
logger.trace '==> preprocessing data: normalize each feature (channel) globally'
mean = {}
std = {}
for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   mean[i] = trainData.data[{ {},i,{},{} }]:mean()
   std[i] = trainData.data[{ {},i,{},{} }]:std()
   trainData.data[{ {},i,{},{} }]:add(-mean[i])
   trainData.data[{ {},i,{},{} }]:div(std[i])
end

-- Normalize validation data, using the training means/stds
for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   validationData.data[{ {},i,{},{} }]:add(-mean[i])
   validationData.data[{ {},i,{},{} }]:div(std[i])
end

-- Normalize test data, using the training means/stds
for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   testData.data[{ {},i,{},{} }]:add(-mean[i])
   testData.data[{ {},i,{},{} }]:div(std[i])
end

-- Local normalization
logger.trace '==> preprocessing data: normalize all three channels locally'

-- Define the normalization neighborhood:
neighborhood = image.gaussian1D(13)

-- Define our local normalization operator (It is an actual nn module, 
-- which could be inserted into a trainable model):
normalization = nn.SpatialContrastiveNormalization(1, neighborhood, 1):float()

-- Normalize all channels locally:
for c in ipairs(channels) do
   for i = 1,trainData.size do
      trainData.data[{ i,{c},{},{} }] = normalization:forward(trainData.data[{ i,{c},{},{} }])
   end
   for i = 1,validationData.size do
      validationData.data[{ i,{c},{},{} }] = normalization:forward(validationData.data[{ i,{c},{},{} }])
   end   
   for i = 1,testData.size do
      testData.data[{ i,{c},{},{} }] = normalization:forward(testData.data[{ i,{c},{},{} }])
   end
end

----------------------------------------------------------------------
logger.trace '==> verify statistics'

-- It's always good practice to verify that data is properly
-- normalized.

for i,channel in ipairs(channels) do
   trainMean = trainData.data[{ {},i }]:mean()
   trainStd = trainData.data[{ {},i }]:std()

   validationMean = validationData.data[{ {},i }]:mean()
   validationStd = validationData.data[{ {},i }]:std()
   
   testMean = testData.data[{ {},i }]:mean()
   testStd = testData.data[{ {},i }]:std()

   logger.trace('training data, '..channel..'-channel, mean: ' .. trainMean)
   logger.trace('training data, '..channel..'-channel, standard deviation: ' .. trainStd)

   logger.trace('validation data, '..channel..'-channel, mean: ' .. validationMean)
   logger.trace('validation data, '..channel..'-channel, standard deviation: ' .. validationStd)
   
   logger.trace('test data, '..channel..'-channel, mean: ' .. testMean)
   logger.trace('test data, '..channel..'-channel, standard deviation: ' .. testStd)
   
end
--]]
----------------------------------------------------------------------
logger.trace '==> visualizing data'

-- Visualization is quite easy, using itorch.image().

if opt.visualize then
   if itorch then
   first256Samples = trainData.data[{ {1,25},{} }]
   --first256Samples_u = trainData.data[{ {1,256},2 }]
   --first256Samples_v = trainData.data[{ {1,256},3 }]
   itorch.image(first256Samples)
  -- itorch.image(first256Samples_u)
  -- itorch.image(first256Samples_v)
   else
      logger.trace("For visualization, run this script in an itorch notebook")
   end
end

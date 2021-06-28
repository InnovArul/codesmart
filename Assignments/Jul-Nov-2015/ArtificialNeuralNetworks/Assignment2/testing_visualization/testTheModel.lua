-- load the saved model
require 'torch'   -- torch
require 'image'   -- for color transforms
require 'nn'      -- provides a normalization operator
require 'xlua'    -- xlua provides useful tools, like progress bars
require 'optim'   -- an optimization package, for online and batch methods

opt = {}
opt.size = 'small'
opt.save = './results/'
opt.optimization = 'SGD'

-- load the data to get mean, std for normalization
dofile '1_data_SVHN_dataset.lua'
require 'image'

-- load the model from already saved .net file
model = torch.load('trained_model_15epochs.net');
model = model:float()

-- load the test image
img = image.load('/home/arul/workspace/Assignment2/testimgs/number2.jpg', 3, 'float');
newTensor = torch.Tensor(1, 3, 32, 32)
newTensor[1] = img:float()

-- set model to evaluate mode (for modules that differ in training and testing, like Dropout)
model:evaluate()

opt = {}
--dofile 'mnist.lua'
test_file = 'test_32x32.t7'

-- load the test file
loaded = torch.load(test_file,'ascii')

-- set the tesize (for a single picture = 1, for SVHN testset = 1 to 10000
tesize = 10

-- Finally we load the test data.
loaded = torch.load(test_file,'ascii')
testData = {
   data = loaded.X:transpose(3,4),
   labels = loaded.y[1],
   size = function() return tesize end
}

--testData = {
--   data = newTensor:float(),
--   size = function() return tesize end
--}

testData.data = testData.data:float();

-- Normalize test data, using the training means/stds
for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   testData.data[{ {},i,{},{} }]:add(-mean[i])
   testData.data[{ {},i,{},{} }]:div(std[i])
end

-- Normalize all channels locally:
for c in ipairs(channels) do
   for i = 1,testData:size() do
      testData.data[{ i,{c},{},{} }] = normalization:forward(testData.data[{ i,{c},{},{} }])
   end
end
--
--testData.data = testData.data:float()
--testData.labels = testData.labels:float()
--print(testData)
 -- estimate f
local output = model:forward(testData.data[1])

print(output)

--print ("\n\nOUTPUT = "..output.."**********\n\n")
-- Visualization is quite easy, using itorch.image().
image.display(testData.data[1])
image.display(model:get(1).output)
image.display(model:get(5).output)

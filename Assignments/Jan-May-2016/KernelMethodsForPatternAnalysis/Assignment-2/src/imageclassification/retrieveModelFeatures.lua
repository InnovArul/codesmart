dofile '1_data.lua'
dofile 'utilities.lua'
dofile 'log.lua'
require 'lfs'
require 'nn'
require 'cutorch'

modelsFolder = './bestmodels'
models = {
  [1] = "filt=5-hidden1=5-hidden2=15-hidden3=15-fc1=150-fc2=150",
  [2] = "filt=5-hidden1=5-hidden2=15-hidden3=5-fc1=300-fc2=150"
}

epoch = {
  [1] = 180,
  [2] = 180
}


function extractFeatures(data, labels, noOfFeatures, modelPath, featuresSaveFilePath)
  features = torch.Tensor(data:size(1), noOfFeatures + 1);
  model = torch.load(modelPath)
  
  --get the reference of fully connected layer
  outputLayer = model:get(9);
  
  currentFeatures = torch.Tensor(noOfFeatures + 1);
  
  for index = 1, data:size(1) do
    --pass the image and extract the features
    pred = model:forward(data[index])
    currentFeatures[{{1, noOfFeatures}}]:copy(outputLayer.output)
    currentFeatures[noOfFeatures+1] = labels[index]
    features[index] = currentFeatures;
  end
  
  matio.save(featuresSaveFilePath, features)
  
end

--for each model, retrieve features for training, validation, test data
for key, value in ipairs(models) do
  folderpath = paths.concat(modelsFolder, value);
  
  --create the folder if it doesn't exist
  if(lfs.attributes(value) == nil) then
    paths.mkdir(folderpath);
  end
  
  --collect training data features and save it in matlab format
  noOfFeatures = string.match(value, "fc2=(%d+)")
  modelPath = paths.concat(modelsFolder, value, 'model#' .. epoch[key] .. '.net')
  
  --create the training features tensor
  extractFeatures(trainData.data:cuda(), trainData.labels:cuda(), noOfFeatures, modelPath, paths.concat(folderpath, 'train_' .. value .. '.mat'))
  
  extractFeatures(validationData.data:cuda(), validationData.labels:cuda(), noOfFeatures, modelPath, paths.concat(folderpath, 'validation_' .. value .. '.mat'))
  
  extractFeatures(testData.data:cuda(), testData.labels:cuda(), noOfFeatures, modelPath, paths.concat(folderpath, 'test_' .. value .. '.mat'))  
  
end
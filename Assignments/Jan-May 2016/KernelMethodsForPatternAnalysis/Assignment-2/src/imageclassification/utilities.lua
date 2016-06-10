--[[
   utilities.lua
   
   Copyright 2015 Arulkumar <arul.csecit@ymail.com>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
]]--

require 'lfs'
require 'image'
require 'torch'
require 'cutorch'
require 'cunn'

-- set the random number seed
math.randomseed( os.time() )

function augmentData(data, labels)
  noOfImages = data:size(1)
  imageInstanceSize = data[1]:size()
  height = data[1]:size(2)
  range = 0.2 * height;
  
  logger.trace('before augmentation : number of images = ' .. noOfImages);
   
  -- 5 translations, 5 horizontal flips, 1 original image & horizontal flip
  augmentedImages = {} --torch.Tensor(noOfImages * (10 + 2), imageInstanceSize[1], imageInstanceSize[2], imageInstanceSize[3]);
  augmentedLabels = {} -- torch.Tensor(noOfImages * (10 + 2)):fill(0)
   
  augmentingIndex = 1;
  
  for index = 1, noOfImages do
     augmentedImages[augmentingIndex] = data[index]
     augmentedLabels[augmentingIndex] = labels[index]
     augmentingIndex = augmentingIndex + 1
     
     --image.display(data[index])
     --print(labels[index])
     
     --image.display(augmentedImages[((index-1) * 12) + 1])
     --print(augmentedLabels[((index-1) * 12) + 1])
     --io.read()
     
     --do hflip on original image
     hflippedImg = image.hflip(data[index])
     augmentedImages[augmentingIndex] = hflippedImg
     augmentedLabels[augmentingIndex] = labels[index]
     augmentingIndex = augmentingIndex + 1
     --image.display(augmentedImages[((index-1) * 12) + 2])
     --print(augmentedLabels[((index-1) * 12) + 2]) 
     --io.read()
       
     --do random translations and rotations
    noOfAugments = 0
    if(labels[index] == 1 or labels[index] == 3 ) then
      noOfAugments = 7
    elseif(labels[index] == 2) then
      noOfAugments = 4
    else
      noOfAugments = 3
    end
    
    for augmentIndex = 1, noOfAugments do
        randomWidth = getRandomNumber(-range, range)
        randomHeight = getRandomNumber(-range, range)

        -- get the random width & random height to translate
        imgTranslated = image.translate(data[index], randomWidth, randomHeight)
        augmentedImages[augmentingIndex] = imgTranslated
        augmentedLabels[augmentingIndex] = labels[index]
        augmentingIndex = augmentingIndex + 1
       --image.display(augmentedImages[baseIndex + (augmentIndex - 1) * 2 + 1])
       --print(augmentedLabels[baseIndex + (augmentIndex - 1) * 2 + 1]) 
       --io.read()
        
        imgFlipped = image.hflip(imgTranslated)
        augmentedImages[augmentingIndex] = imgFlipped
        augmentedLabels[augmentingIndex] = labels[index]
        augmentingIndex = augmentingIndex + 1
       --image.display(augmentedImages[baseIndex + (augmentIndex - 1) * 2 + 2])
       --print(augmentedLabels[baseIndex + (augmentIndex - 1) * 2 + 2])        
       -- io.read()
    end
     
  end
  
  --get all the keys
  allKeys = table.getAllKeys(augmentedLabels)
  finalImgs = torch.Tensor(#allKeys, imageInstanceSize[1], imageInstanceSize[2], imageInstanceSize[3]);
  finalLabels = torch.Tensor(#allKeys):fill(0)
  
  for key, val in ipairs(allKeys) do
    finalImgs[key] = augmentedImages[val]
    finalLabels[key] = augmentedLabels[val]
  end
  
  logger.trace('after augmentation : number of images = ' .. finalImgs:size(1));
  
  return finalImgs, finalLabels
   
end

function setDefaultStates()
  
  optimState = {
      learningRate = opt.learningRate,
      weightDecay = opt.weightDecay,
      momentum = opt.momentum,
      learningRateDecay = 1e-7
  }
  
  optimMethod = optim.sgd               

  -- Log results to files
  trainLogger = optim.Logger(paths.concat(opt.save, 'train.log'))
  trainLogger.showPlot = false; trainLogger.epsfile = paths.concat(opt.save, 'train.eps')
  
  validationLogger = optim.Logger(paths.concat(opt.save, 'validation.log'))
  validationLogger.showPlot = false; validationLogger.epsfile = paths.concat(opt.save, 'validation.eps')
  
  testLogger = optim.Logger(paths.concat(opt.save, 'test.log'))
  testLogger.showPlot = false; validationLogger.epsfile = paths.concat(opt.save, 'test.eps')
 
  best_accuracy = 0
  modelEpoch = 0  
end

function getRootPath()
  rootpath = '/media/arul/envision/jan-may-2016/kernelmethods/Assignment-2/data/task3/imagedata/'
  return rootpath
end

--load the images files and return labels along with corresponding loaded images
function loadImagesAndLabels(imageNameMatrix)
  images = torch.Tensor(imageNameMatrix:size(1), 3, 32, 32)
  labels = torch.Tensor(imageNameMatrix:size(1))
  
  for index = 1, imageNameMatrix:size(1) do
    fileName = paths.concat(getRootPath(), imageNameMatrix[index][1] .. '.jpg')
    currentImage = image.scale(image.load(fileName), 32, 32)
    images[index] = currentImage
    labels[index] = imageNameMatrix[index][2]
  end
  
  return images, labels
  
end


function isFolderExists(strFolderName)
	if lfs.attributes(strFolderName:gsub("\\$",""),"mode") == "directory" then
		return true
	else
		return false
	end
end

--[[
copy the table's first level values
--]]
function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--[[
copy the table with all the internal key and value pairs 
--]]
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--[[
   
   name: loadAllImagesFromFolders
   @param
   @return
   
]]--

function loadAllImagesFromFolders(fileNames, filePaths)
	loadedfiles = {};
    
    for i, foldername in ipairs(fileNames) do
        print(foldername .. ' --> ' .. filePaths[i])
        logger.trace('\tcollecting all Image file paths from '.. filePaths[i])
        allImgNames, allImgPaths = getAllFileNamesInDir(filePaths[i]);
        
        imgTable = {};
        for j, imgname in ipairs(allImgPaths) do 
           img = image.load(imgname)
           imgTable[imgname] = localizeMemory(img); 
        end
        logger.trace('\tNumber of images : '.. #allImgPaths)
        loadedfiles[foldername] = imgTable;
    end
    
    return loadedfiles
end

--[[
   
   name: getAllFiles
   @param
   @return
   
]]--

function getAllFileNamesInDir(directory)

    index = 1;
    filesOrFolderNames = {};
    filesOrFolderPaths = {};
    for file in lfs.dir(directory) do
        --print (file )
        if(file:sub(1,1) ~= '.' and file ~= '..') then
            filesOrFolderNames[index] = file;
            filesOrFolderPaths[index] = directory .. '/' .. file;
            index = index + 1;
        end
    end

    return filesOrFolderNames, filesOrFolderPaths;
end

--[[
   
   name: table.map_length
   @param
   @return the number of keys in the table (i.e., effectively the length of the table)
   
]]--

function table.map_length(t)
    local c = 0
    for k,v in pairs(t) do
         c = c+1
    end
    return c
end


--[[
   
   name: table.getAllKeys
   @param
   @return the number of keys in the table (i.e., effectively the length of the table)
   
]]--

function table.getAllKeys(tbl)
    local keyset={}
    local n=0

    for k,v in pairs(tbl) do
      n=n+1
      keyset[n]=k
    end
    
    table.sort(keyset)
    return keyset;
end


--[[
   
   name: table.getAllKeys
   @param
   @return the number of keys in the table (i.e., effectively the length of the table)
   
]]--

function table.getValues(tbl, keys)
    local values={}
    local n=0

    for index = 1, keys:size(1) do
      values[index]=tbl[keys[index]]
    end
    
    table.sort(values)
    return values;
end


--[[
   
   name: getRandomNumber
   @param
   @return a random number between lowe and upper, but without the number in exclude
   
]]--

function getRandomNumber(lower, upper, exclude)
    randNumber = math.random(lower, upper);
    while(randNumber == exclude) do
        randNumber = math.random(lower, upper);
    end
    return randNumber;
end


--[[
   
   name: localizeMemory
   @param
   @return copies the given tensor to GPU, incase GPU usage is forced
   
]]--
function localizeMemory(tensor)
  if(opt.useCuda) then
     newTensor = tensor:cuda();
  else
    newTensor = tensor;
  end
  
  return newTensor;
end

--[[
   
   name: localizeModel
   @param
   @return copies the given model to GPU, incase GPU usage is forced
   
]]--
function localizeModel(model)
  if(opt.useCuda) then
     model:cuda();
  end
 
 end


--[[
   
   name: allocateTensor
   @param
   @return allocates the tensor of the given size in GPU or CPU based on the option set
   
]]--
function allocateTensor(givenSize)
  if(opt.useCuda) then
     newTensor = torch.CudaTensor(unpack(givenSize));
  else
     newTensor = torch.Tensor(unpack(givenSize));
  end
  
  return newTensor;
end

matio = require 'matio'
dofile '../utilities.lua'

-- gothrough all the accuracies and select the best percentage
--print(accuracies)

bestEpoch = {};
bestAccuracy = 0;
bestTest = {}

function getBestAccuracy(filePath)

  --read the accuracy file
  accuracies = matio.load(filePath)

  for testname, value in pairs(accuracies.details) do
    currentDetails = accuracies.details[testname]
    currentAccuracy = currentDetails.bestAccuracy[1][1]
    currentEpoch = currentDetails.epoch[1][1]
    
    if(currentAccuracy > bestAccuracy) then
      bestTest = {testname}
      bestAccuracy = currentAccuracy
      bestEpoch = {currentEpoch}
    elseif(currentAccuracy >= bestAccuracy) then
      table.insert(bestTest, testname)
      table.insert(bestEpoch, currentEpoch)
    end
  end

  print('\nbest test : \n')
  print(bestTest)
  print('accuracy : ' .. bestAccuracy .. '\n')
  print('epoch : \n')
  print(bestEpoch)

end

getBestAccuracy('../accuracies.mat')


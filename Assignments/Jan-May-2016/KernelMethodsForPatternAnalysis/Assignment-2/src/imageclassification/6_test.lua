----------------------------------------------------------------------
-- This script implements a test procedure, to report accuracy
-- on the test data. Nothing fancy here...
--
-- Clement Farabet
----------------------------------------------------------------------

require 'torch'   -- torch
require 'xlua'    -- xlua provides useful tools, like progress bars
require 'optim'   -- an optimization package, for online and batch methods
dofile 'log.lua'

----------------------------------------------------------------------
logger.trace '==> defining test procedure'

-- validate function
function test()
   -- local vars
   local time = sys.clock()

   -- averaged param use?
   if average then
      cachedparams = parameters:clone()
      parameters:copy(average)
   end

   -- set model to evaluate mode (for modules that differ in training and testing, like Dropout)
   model:evaluate()

   -- test over test data
   logger.trace('==> testing on test set:')
   predictedLabels = torch.Tensor(testData.size)
   
   for t = 1,testData.size do
      -- disp progress
      xlua.progress(t, testData.size)

      -- get new sample
      local input = testData.data[t]
      if opt.type == 'double' then input = input:double()
      elseif opt.type == 'cuda' then input = input:cuda() end
      local target = testData.labels[t]

      -- test sample
      local pred = model:forward(input)
      confusion:add(pred, target)
      max, label = torch.max(pred:double(), 1)
      predictedLabels[t] = label[1]
   end

   -- timing
   time = sys.clock() - time
   time = time / testData.size
   logger.trace("\n==> time to test 1 sample = " .. (time*1000) .. 'ms')

   -- print confusion matrix
   logger.trace(confusion)

   -- update log/plot
   --testLogger:add{['% mean class accuracy (test set)'] = confusion.totalValid * 100}
   if opt.plot then
      --testLogger:style{['% mean class accuracy (test set)'] = '-'}
      --testLogger:plot()
   end

   -- averaged param use?
   if average then
      -- restore parameters
      parameters:copy(cachedparams)
   end
   
   -- next iteration:
   confusion:zero()
   return predictedLabels
end

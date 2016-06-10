----------------------------------------------------------------------
-- This script implements a test procedure, to report accuracy
-- on the test data. Nothing fancy here...
--
-- Clement Farabet
----------------------------------------------------------------------

require 'torch'   -- torch
require 'xlua'    -- xlua provides useful tools, like progress bars
require 'optim'   -- an optimization package, for online and batch methods
logger = require 'log'

----------------------------------------------------------------------
logger.trace '==> defining validation procedure'

-- validate function
function validate()
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
   for t = 1,validationData.size do
      -- disp progress
      xlua.progress(t, validationData.size)

      -- get new sample
      local input = validationData.data[t]
      if opt.type == 'double' then input = input:double()
      elseif opt.type == 'cuda' then input = input:cuda() end
      local target = validationData.labels[t]

      -- test sample
      local pred = model:forward(input)
      confusion:add(pred, target)
   end

   -- timing
   time = sys.clock() - time
   time = time / validationData.size
   logger.trace("\n==> time to validate 1 sample = " .. (time*1000) .. 'ms')

   -- logger.trace confusion matrix
   logger.trace(confusion)
   
  if(confusion.totalValid > best_accuracy) then
    best_accuracy = confusion.totalValid;
    bestEpoch = epoch - 1;
  end

   -- update log/plot
   validationLogger:add{['% mean class accuracy (validation set)'] = confusion.totalValid * 100}
   if opt.plot then
      validationLogger:style{['% mean class accuracy (validation set)'] = '-'}
      validationLogger:plot()
   end

   -- averaged param use?
   if average then
      -- restore parameters
      parameters:copy(cachedparams)
   end
   
   -- next iteration:
   confusion:zero()
end

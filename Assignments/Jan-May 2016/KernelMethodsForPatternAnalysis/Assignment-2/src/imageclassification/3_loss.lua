----------------------------------------------------------------------
-- This script demonstrates how to define a couple of different
-- loss functions:
--   + negative-log likelihood, using log-normalized output units (SoftMax)
--   + mean-square error
--   + margin loss (SVM-like)
--
-- Clement Farabet
----------------------------------------------------------------------

require 'torch'   -- torch
require 'nn'      -- provides all sorts of loss functions
logger = require 'log'

----------------------------------------------------------------------

-- 5-class problem
noutputs = 5

function defineLoss()
  ----------------------------------------------------------------------
  logger.trace '==> define loss'
  
  criterion = nn.ClassNLLCriterion()
     
  ----------------------------------------------------------------------
  logger.trace '==> here is the loss function:'
  logger.trace(criterion)

end
require 'lbp'
require 'torch'
require 'math'

--------------------------------------------------------------
-- SETTINGS
-- 

data = {
    inputs = torch.Tensor(1,7,7):rand(1,7,7),
    targets = 1
}

--- Include your model with the ReQu Layer. 
 ------------------------------------------------------------------------------
  -- MODEL
  ------------------------------------------------------------------------------
  local n_inputs = 4
  local embedding_dim = 2
  local n_classes = 3

  -- MODEL:
  --     linear -> requ -> linear -> softmax
  local model = nn.Sequential()
  model:add(nn.SpatialConvolution(1,1,3,3))
  model:add(nn.View(5,5))
  model:add(nn.lbp())
  model:add(nn.View(9))
  model:add(nn.Linear(9,3))
  model:add(nn.LogSoftMax())

  ------------------------------------------------------------------------------
  -- LOSS FUNCTION
  ------------------------------------------------------------------------------
  local criterion = nn.ClassNLLCriterion()
 
 
 if model then
    parameters,gradParameters = model:getParameters()
 end


-- function that numerically checks gradient of the loss:
-- f is the scalar-valued function
-- g returns the true gradient (assumes input to f is a 1d tensor)
-- returns difference, true gradient, and estimated gradient
local function checkgrad(f, g, x, eps)
  -- compute true gradient
  local grad = g(x)
  
  -- compute numeric approximations to gradient
  local eps = 1e-7
  local grad_est = torch.DoubleTensor(grad:size())
  for i = 1, grad:size(1) do
    -- do something with x[i] and evaluate f twice, and put your estimate of df/dx_i into grad_est[i]
    
    --create a temporary tensor for X to hold the 'eps' in the appropriate position 
    tempX = torch.DoubleTensor(grad:size(1))
    tempX:zero()
    tempX[i] = eps
    
    -- calculate delta parameters for gradient calculation
    x_plus_eps = x + tempX
    x_minus_eps = x - tempX
    
    -- by using delta set of parameters, estimate the gradient for particular parameter 
    gradient = (f(x_plus_eps) - f(x_minus_eps)) / (eps * 2);
    grad_est[i] = gradient
  end

  -- computes (symmetric) relative error of gradient
  local diff = torch.norm(grad - grad_est) / (2 * torch.norm(grad + grad_est))
  return diff, grad, grad_est
end

-- returns loss(params)
local f = function(x)
  if x ~= parameters then
    parameters:copy(x)
  end
  return criterion:forward(model:forward(data.inputs), data.targets)
end


-- returns dloss(params)/dparams
local g = function(x)
  if x ~= parameters then
    parameters:copy(x)
  end
  
  gradParameters:zero()

  local outputs = model:forward(data.inputs)
  criterion:forward(outputs, data.targets)
  model:backward(data.inputs, criterion:backward(outputs, data.targets))

  return gradParameters
end

-- call the checkgrad function to get the actual and estimate of the gradient 
local diff, grad, est = checkgrad(f, g, parameters)

-- print the actual gradient from the predefined criterion
print('actual gradient : \n')
print(grad)

-- print the estimated gradient from the approximation method
print('estimated gradient : \n')
print(est)

--variables to find cosine similarity 
nominator = torch.sum(torch.cmul(grad, est))
denominator =  ((torch.norm(grad)) * torch.norm(grad))

local cosineSimilarity = nominator / denominator
--print the status to console
print('symmetric relative error : ' .. diff .. ' --> cosine similarity : ' .. cosineSimilarity..'\n\n')

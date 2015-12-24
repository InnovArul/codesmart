require 'nn'

local ReQU = torch.class('nn.ReQU', 'nn.Module')

function ReQU:updateOutput(input)
  self.output:resizeAs(input):copy(input)
  
  -- apply ReQU function to all the elements of input
  self.output:apply(function(x)
    if x > 0 then return x*x else return 0 end
  end)
  
  return self.output
end

function ReQU:updateGradInput(input, gradOutput)
  self.gradInput:resizeAs(gradOutput):copy(gradOutput)
  self.gradInput:cmul(input * 2)
  return self.gradInput
end


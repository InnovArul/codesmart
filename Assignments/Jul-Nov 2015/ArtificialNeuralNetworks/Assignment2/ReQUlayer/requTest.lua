-- in this file, we test the dropout module we've defined:
require 'nn'
require 'requ'
require 'image'
 
-- define a requ object:
n = nn.ReQU()
 
-- get a random number matrix
i = torch.rand(5, 10)
i[1] = i[1] * -1 --set the first row to be of negative values
i = i*10
print('\n\ninput to ReQU: \n\n')
print(i)

-- pass the data into the layer object
result = n:forward(i)
criterion = nn.MSECriterion()
criterion.sizeAverage = false
local err = criterion:forward(result, torch.pow(i,2))
--print(err)

-- estimate df/dW
local df_do = criterion:backward(result, torch.pow(i,2))
--print(df_do)

n:backward(i, df_do)

--display parameters
--print(n:parameters())

-- display results:
print('\n\noutput from ReQU: \n\n')
print(result)

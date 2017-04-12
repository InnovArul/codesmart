-- in this file, we test the dropout module we've defined:
require 'nn'
require 'lbp'
require 'image'
 
-- define a requ object:
n = nn.lbp()
 
-- get a random number matrix
i = torch.Tensor(1, 3,3):fill(10)
i[1][2][2] = 5
print('\n\ninput to lbp: \n\n')
print(i)

-- pass the data into the layer object
result = n:forward(i)

criterion = nn.MSECriterion()
criterion.sizeAverage = false
local expected = torch.Tensor({2})
local err = criterion:forward(result, expected)
--print(err)

-- estimate df/dW
local df_do = criterion:backward(result, expected)
--print(df_do)

local gradinput = n:backward(i, df_do)

--display parameters
--print(n:parameters())

-- display results:
print('\n\noutput from lbp: \n\n')  
print(result)
print('\n\nexpected: \n\n')  
print(expected)
print('\n\ndf_do:\n\n')
print(expected)
print('\n\ngrad input: \n\n')
print(gradinput)


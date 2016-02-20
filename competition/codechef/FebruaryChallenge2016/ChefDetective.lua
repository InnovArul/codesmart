--The first line of input contains one integer N.
--Next line has N space-separated integers, the ith integer denotes Ri — the person whom the ith member reports to.

require 'io'
require 'math'

N = io.read()
local gang = {}

for i = 1, N do
    number = io.read('*number')
    gang[number] = 1
end

for i = 1, N do
    if(gang[i] == nil) then
        io.write(i .. ' ')
    end
end

io.write('\n')

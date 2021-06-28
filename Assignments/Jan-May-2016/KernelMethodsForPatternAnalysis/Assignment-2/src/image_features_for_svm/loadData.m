function [data] = loadData()
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

datapath = '../data/imagedata';
files = getAllFiles(datapath);
data = [];

for index = 1:length(files)
   data = [data; featureextraction_task2(files{index})];
end

end


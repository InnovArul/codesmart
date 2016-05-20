function [data] = prepare1ofKData(data)
%PREPARE1OFKDATA assumes that the labels are available in last column

%determine the unique number of classes
classCount = unique(data(:, end));

% 1 of k class representation buffer
dataLabels = zeros(length(data), length(classCount));

% assign labels appropriately
dataLabels(sub2ind(size(dataLabels), [1:size(dataLabels, 1)]', data(:, end))) = 1;

% append the labels with the data
data = [data(:, 1:end-1) dataLabels];

end

 
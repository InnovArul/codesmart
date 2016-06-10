function [mu_i] = selectMeanForClusters(imgData, meanSelectionOption, K)

global MEAN_SELECTION;
rows = size(imgData, 1);
columns = size(imgData, 1);
mu_i = zeros(K, size(imgData, 3));

% select mean randomly
if(meanSelectionOption == options.MU_RANDOM)
    MEAN_SELECTION = strcat('random_', num2str(K), '_');
    
    % randomly permutate the rows and columns numbers
   rowNumberPermutation = randperm(rows);
   columnNumberPermutation = randperm(columns);
   
   % take first K indices for mu_i selection
   for index = 1:K
       mu_i(index, :) = imgData(rowNumberPermutation(index), columnNumberPermutation(index), :);
   end    
else
    MEAN_SELECTION = strcat('mid_equidistant_', num2str(K), '_');
    
   % select mean equidistant in the middle of the picture
   middleRow = floor(rows / 2);
   columns = floor(linspace(1, columns, K));
   
   % select the indices at mid line of the image for mu_i selection
   for index = 1:K
       mu_i(index, :) = imgData(middleRow, columns(index), :);
   end   
end

end
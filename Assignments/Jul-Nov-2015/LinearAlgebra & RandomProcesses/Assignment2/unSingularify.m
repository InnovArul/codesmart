function [ return_matrix ] = unSingularify( matrix )
%UNSINGULARIFY Summary of this function goes here
%   Detailed explanation goes here

return_matrix = matrix + (eye(size(matrix, 1)) * eps);

end


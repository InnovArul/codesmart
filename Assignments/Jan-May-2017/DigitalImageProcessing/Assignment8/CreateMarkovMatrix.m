function [ R ] = CreateMarkovMatrix( decay, dimension )
%CREATEMARKOVMATRIX 
    R = zeros(dimension, dimension);

    for i = 1:dimension 
        for j = 1:dimension 
            R(i, j) = decay ^ abs(i-j);  
        end
    end

end


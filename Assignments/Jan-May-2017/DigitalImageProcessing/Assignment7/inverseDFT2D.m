function img = inverseDFT2D(img_DFT)

%perform row-column decomposition of 1D DFTs
img = zeros(size(img_DFT));

% buffer to hold intermediate result of row based 1D DFTs
A = zeros(size(img_DFT));

% for all the rows, perform the 1D DFT
for i = 1:size(img_DFT, 1)
    A(i, :) = ifft(img_DFT(i, :));
end

% for all the columns, perform the 1D DFT
for j = 1:size(img_DFT, 2)
    img(:, j) = ifft(A(:, j));
end

%normalize the magnitude between 0 and 1
img = mat2gray(abs(img));

end
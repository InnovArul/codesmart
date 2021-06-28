function img_DFT = forwardDFT2D(img)

%perform row-column decomposition of 1D DFTs
img_DFT = zeros(size(img));

% buffer to hold intermediate result of row based 1D DFTs
A = zeros(size(img));

% for all the rows, perform the 1D DFT
for i = 1:size(img, 1)
    A(i, :) = fft(img(i, :));
end

% for all the columns, perform the 1D DFT
for j = 1:size(img, 2)
    img_DFT(:, j) = fft(A(:, j));
end

end
function F = EstimateFundamentalMatrix(x1, x2)
%% EstimateFundamentalMatrix
% Estimate the fundamental matrix from two image point correspondences 
% Inputs:
%     x1 - size (N x 2) matrix of points in image 1
%     x2 - size (N x 2) matrix of points in image 2, each row corresponding
%       to x1
% Output:
%    F - size (3 x 3) fundamental matrix with rank 2


    N = size(x1, 1);
    x1 = cat(2, x1, ones(N, 1));
    x2 = cat(2, x2, ones(N, 1));
    % A = [(x2(:, 1) .* x1(:, 1)) (x2(:, 1) .* x1(:, 2)) (x2(:, 1) .* x1(:, 3)) (x2(:, 2) .* x1(:, 1)) (x2(:, 2) .* x1(:, 2)) (x2(:, 2) .* x1(:, 3))  (x2(:, 3) .* x1(:, 1)) (x2(:, 3) .* x1(:, 2)) (x2(:, 3) .* x1(:, 3))];

    B = [];
    for i = 1:N
        [a, b, c] = deal(x1(i, 1), x1(i, 2), x1(i, 3));
        [x, y, z] = deal(x2(i, 1), x2(i, 2), x2(i, 3));
        b = [(a*x) (a*y) (a*z) (b*x) (b*y) (b*z) (c*x) (c*y) (c*z)];
        B = cat(1, B, b);
    end

    [~, ~, Vb] = svd(B);
    F = reshape(Vb(:, end), 3, 3)';
    [U, D, V] = svd(F);
    D(end, end) = 0;
    F = U * D * V';
    F = F ./ norm(F, "fro");

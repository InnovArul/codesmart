function X = LinearTriangulation(K, C1, R1, C2, R2, x1, x2)
%% LinearTriangulation
% Find 3D positions of the point correspondences using the relative
% position of one camera from another
% Inputs:
%     C1 - size (3 x 1) translation of the first camera pose
%     R1 - size (3 x 3) rotation of the first camera pose
%     C2 - size (3 x 1) translation of the second camera
%     R2 - size (3 x 3) rotation of the second camera pose
%     x1 - size (N x 2) matrix of points in image 1
%     x2 - size (N x 2) matrix of points in image 2, each row corresponding
%       to x1
% Outputs: 
%     X - size (N x 3) matrix whos rows represent the 3D triangulated
%       points

    N = size(x1, 1);
    P1 = K * cat(2, R1, -R1 * C1);
    P2 = K * cat(2, R2, -R2 * C2);

    x1_2d = x1;
    x2_2d = x2;
    points3D = [];

    for i = 1: N
        x1 = x1_2d(i, :);
        x2 = x2_2d(i, :);

        % A = [-P1(2, :) + x1(2) * P1(3, :);
        %       P1(1, :) - x1(1) * P1(3, :);
        %       -x1(2) * P1(1, :) + x1(1) * P1(2, :);
        %       -P2(2, :) + x2(2) * P2(3, :);
        %       P2(1, :) - x2(1) * P2(3, :);
        %       -x2(2) * P2(1, :) + x2(1) * P2(2, :);];

        A = [vector2skew([x1(1) x1(2) 1]) * P1;
            vector2skew([x2(1) x2(2) 1]) * P2;];

        [U, D, V] = svd(A);
        point3D = V(:, end)';
        point3D = point3D(1, 1:3) ./ point3D(1, 4);
        points3D = cat(1, points3D, point3D);
    end

    X = points3D;
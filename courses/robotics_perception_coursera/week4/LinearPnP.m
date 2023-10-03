
function [C, R] = LinearPnP(X, x, K)
%% LinearPnP
% Getting pose from 2D-3D correspondences
% Inputs:
%     X - size (N x 3) matrix of 3D points
%     x - size (N x 2) matrix of 2D points whose rows correspond with X
%     K - size (3 x 3) camera calibration (intrinsics) matrix
% Outputs:
%     C - size (3 x 1) pose transation
%     R - size (3 x 1) pose rotation
%
% IMPORTANT NOTE: While theoretically you can use the x directly when solving
% for the P = [R t] matrix then use the K matrix to correct the error, this is
% more numeically unstable, and thus it is better to calibrate the x values
% before the computation of P then extract R and t directly
    N = size(x, 1);
    x_homo = cat(2, x, ones(N, 1));
    x_opt = (K \ x_homo')';

    A = [];
    for i = 1:N
        x2d = x_opt(i, :);
        X3d = [X(i, :), 1];
        A_current = vector2skew(x2d) * [X3d, zeros(1,4), zeros(1,4);
                                        zeros(1,4), X3d, zeros(1,4);
                                        zeros(1,4), zeros(1,4), X3d;];
        A = cat(1, A, A_current);
    end

    [U, D, V] = svd(A);
    Rt = V(:, end);
    Rt = reshape(Rt, 4, 3)';

    R = Rt(1:3, 1:3);
    t = Rt(:, end);

    % correction
    [Ur, Dr, Vr] = svd(R);
    R = Ur*Vr';
    t = t / Dr(1,1);    
    if det(R) < 0
        R = -R;
        t = -t;
    end

    C = -R' * t;











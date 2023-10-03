
function X = Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1, x2, x3, X0)
%% Nonlinear_Triangulation
% Refining the poses of the cameras to get a better estimate of the points
% 3D position
% Inputs: 
%     K - size (3 x 3) camera calibration (intrinsics) matrix
%     x
% Outputs: 
%     X - size (N x 3) matrix of refined point 3D locations 

    N = size(x1, 1);
    newXs = [];
    for i = 1:N
        x1_2d = x1(i, :)';
        x2_2d = x2(i, :)';
        x3_2d = x3(i, :)';

        newX = Single_Point_Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1_2d, x2_2d, x3_2d, X0(i, :)');
        newXs = cat(1, newXs, newX');
    end

    X = newXs;
end

function X = Single_Point_Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1, x2, x3, X0)
    r = [x1 - project(K, R1, C1, X0);
         x2 - project(K, R2, C2, X0);
         x3 - project(K, R3, C3, X0);];

    J = [Jacobian_Triangulation(C1, R1, K, X0);
         Jacobian_Triangulation(C2, R2, K, X0);
         Jacobian_Triangulation(C3, R3, K, X0);];

    delX = inv(J' * J) * J' * r;
    X = X0 + delX;
end

function x = project(K, R, C, X)
    [u, v, w] = project_uvw(K, R, C, X);
    x = [u / w, v / w]';
end

function [u,v,w] = project_uvw(K, R, C, X)
    proj = K * R * (X - C);
    u = proj(1);
    v = proj(2);
    w = proj(3);
end

function J = Jacobian_Triangulation(C, R, K, X)
    [u, v, w] = project_uvw(K, R, C, X);
    KR = K * R;
    J = [
      (w * dudX(KR) - u * dwdX(KR)) / w^2;
      (w * dvdX(KR) - v * dwdX(KR)) / w^2;
    ];
end

function j = dudX(KR)
    j = KR(1, :);
end

function j = dvdX(KR)
    j = KR(2, :);
end

function j = dwdX(KR)
    j = KR(3, :);
end


function [H] = getHomographyMatrix(affineParams, f, n, d)
    K = zeros(3, 3);
    K(1, 1) = f; K(2, 2) = f; K(3, 3) = 1;
    
    % affineParams contain tx, ty, tz, rx, ry, rz
    T = [affineParams(1); affineParams(2); affineParams(3)];
    theta_x = affineParams(4);
    Rx = [1 0 0; 0 cos(theta_x) -sin(theta_x); 0 sin(theta_x) cos(theta_x)];
    theta_y = affineParams(5);
    Ry = [cos(theta_y) 0 -sin(theta_y); 0  1  0; sin(theta_y) 0 cos(theta_y)];
    theta_z = affineParams(6);
    Rz = [cos(theta_z) -sin(theta_z) 0; sin(theta_z) cos(theta_z) 0; 0 0 1];
    
    R = Rz * Ry * Rx;
    
    H  = K * (R + ((T * n') / d)) * pinv(K);
end
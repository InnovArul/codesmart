function [proj_points, t, R] = ar_cube(H,render_points,K)
%% ar_cube
% Estimate your position and orientation with respect to a set of 4 points on the ground
% Inputs:
%    H - the computed homography from the corners in the image
%    render_points - size (N x 3) matrix of world points to project
%    K - size (3 x 3) calibration matrix for the camera
% Outputs: 
%    proj_points - size (N x 2) matrix of the projected points in pixel
%      coordinates
%    t - size (3 x 1) vector of the translation of the transformation
%    R - size (3 x 3) matrix of the rotation of the transformation
% Written by Stephen Phillips for the Coursera Robotics:Perception course

% YOUR CODE HERE: Extract the pose from the homography
r1 = H(:, 1) / norm(H(:, 1));
r2 = H(:, 2) / norm(H(:, 2));
r3 = cross(r1, r2);
R = [r1 r2 r3];
t = H(:, 3) / norm(H(:, 1));

% YOUR CODE HERE: Project the points using the pose
p_cam = R * render_points' + t;
proj = (K * p_cam)';
proj_points = proj(:, 1:2) ./ proj(:, 3);

end

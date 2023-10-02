function [ H ] = est_homography(video_pts, logo_pts)
% est_homography estimates the homography to transform each of the
% video_pts into the logo_pts
% Inputs:
%     video_pts: a 4x2 matrix of corner points in the video
%     logo_pts: a 4x2 matrix of logo points that correspond to video_pts
% Outputs:
%     H: a 3x3 homography matrix such that logo_pts ~ H*video_pts
% Written for the University of Pennsylvania's Robotics:Perception course

% YOUR CODE HERE
video_pts_homo = cat(2, video_pts, ones(4, 1));
logo_pts_homo = cat(2, logo_pts, ones(4,1));

Xeqns = cat(2, -video_pts_homo, zeros(4,3), video_pts_homo .* logo_pts_homo(:, 1));
Yeqns = cat(2, zeros(4,3), -video_pts_homo, video_pts_homo .* logo_pts_homo(:, 2));
A = cat(1, Xeqns, Yeqns);
[U, D, V] = svd(A);
H = reshape(V(:, end), 3, 3)';

end


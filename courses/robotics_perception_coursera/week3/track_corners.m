function [ corners ] = track_corners(images, img_pts_init)
%TRACK_CORNERS 
% This function tracks the corners in the image sequence and visualizes a
% virtual box projected into the image
% Inputs:
%     images - size (N x 1) cell containing the sequence of images to track
%     img_pts_init - size (4 x 2) matrix containing points to initialize
%       the tracker
% Outputs:
%     corners - size (4 x 2 x N) array of where the corners are tracked to

corners = zeros(4,2,size(images,1));

%%%% INITIALIZATION CODE FOR TRACKER HERE %%%%

img_pts = img_pts_init; % img_pts is where you will store the tracked points
corners(:,:,1) = img_pts;

pointTracker = vision.PointTracker;
initialize(pointTracker, img_pts, images{1});
setPoints(pointTracker, img_pts);

% Iterate through the rest of the images
for i = 2:size(images,1)
    %%%% CODE FOR TRACKING HERE %%%%
    % Store corners and visualize results (if desired)
    img_pts = pointTracker(images{i});
    corners(:,:,i) = img_pts;
end

end


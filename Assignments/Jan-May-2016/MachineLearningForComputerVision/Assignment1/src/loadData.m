function [ face_train, face_test, nonface_train, nonface_test, width, height ] = loadData()
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

rootFolder = '../data/Problem2_data/';

[face_train, width, height] = readPictures(rootFolder, 'face_train');
[face_test, ~, ~] = readPictures(rootFolder, 'face_test');
[nonface_train, ~, ~] = readPictures(rootFolder, 'nonface_train');
[nonface_test, ~, ~] = readPictures(rootFolder, 'nonface_test');

% assert size of the images
assert(size(face_train, 1) == size(face_test, 1), 'sizes of face_train and face_test images vary');

end


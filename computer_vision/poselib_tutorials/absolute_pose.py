import poselib
import numpy as np
import matplotlib.pyplot as plt

# Simulate a cube in camera view
# Define the vertices of a unit cube
cube_points_world = np.array([
    [-0.5, -0.5, -0.5],
    [ 0.5, -0.5, -0.5],
    [-0.5,  0.5, -0.5],
    [ 0.5,  0.5, -0.5],
    [-0.5, -0.5,  0.5],
    [ 0.5, -0.5,  0.5],
    [-0.5,  0.5,  0.5],
    [ 0.5,  0.5,  0.5],
])

# Define a camera intrinsic matrix (example)
K = np.array([
    [800, 0, 320],
    [0, 800, 240],
    [0, 0, 1]
])

# Define a ground truth camera pose (rotation and translation)
R_gt = np.array([
    [ 0.9962, -0.0872,  0.0000],
    [ 0.0872,  0.9962,  0.0000],
    [ 0.0000,  0.0000,  1.0000]
])
t_gt = np.array([0.1, 0.2, 2.0]).reshape(-1, 1)

# Create a camera pose object
pose_gt = poselib.CameraPose()
pose_gt.R = R_gt
pose_gt.t = t_gt

# Project the 3D world points into the camera view
cube_points_camera = pose_gt.R @ cube_points_world.T + pose_gt.t.reshape(3, -1)
cube_points_image = K @ cube_points_camera

# Normalize the image points (divide by the z-coordinate)
cube_points_image = cube_points_image[:2, :] / cube_points_image[2, :]

# Add some noise to the image points
noise = np.random.normal(0, 2, size=cube_points_image.shape)
cube_points_image_noisy = cube_points_image + noise

# Use poselib to estimate the absolute pose
# We need 2D points (image) and 3D points (world)
points2d = cube_points_image_noisy.T
points3d = cube_points_world

# Estimate the pose using P3P + RANSAC
# P3P requires at least 4 points
# The result is a list of possible poses
camera = {'model': 'SIMPLE_PINHOLE', 'width': 640, 'height': 480, 'params': [K[0,0], K[0,2], K[1,2]]}
pose, info = poselib.estimate_absolute_pose(points2d, points3d, camera, {'max_reproj_error': 16.0}, {})

# In this simple case, there should be only one valid pose
# We can compare the estimated pose with the ground truth pose
if pose:
    estimated_pose = pose
    print("Ground Truth Pose:")
    print("Rotation:\n", pose_gt.R)
    print("Translation:\n", pose_gt.t)
    print("\nEstimated Pose:")
    print("Rotation:\n", estimated_pose.R)
    print("Translation:\n", estimated_pose.t)

    # Visualize the projected points from the estimated pose
    estimated_R = estimated_pose.R
    estimated_t = estimated_pose.t.reshape(-1, 1)

    cube_points_camera_estimated = estimated_R @ cube_points_world.T + estimated_t
    cube_points_image_estimated = K @ cube_points_camera_estimated
    cube_points_image_estimated = cube_points_image_estimated[:2, :] / cube_points_image_estimated[2, :]

    plt.figure()
    plt.scatter(cube_points_image_noisy[0, :], cube_points_image_noisy[1, :], label='Noisy Image Points')
    plt.scatter(cube_points_image_estimated[0, :], cube_points_image_estimated[1, :], label='Projected Points (Estimated Pose)')
    plt.title('Projected Points from Estimated Pose')
    plt.xlabel('Image X')
    plt.ylabel('Image Y')
    plt.legend()
    plt.axis('equal')
    plt.show(block=True)



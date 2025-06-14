import numpy as np
import cv2 # For Rodrigues conversion
import pyceres
from scipy.spatial.transform import Rotation

# --- Helper functions for BA ---

def project(points_3d, camera_params, K):
    """
    Projects 3D points to 2D image plane.
    camera_params: array of [rvec (3), tvec (3)]
    K: 3x3 intrinsic matrix
    points_3d: Nx3 array of 3D points
    """
    rvec = camera_params[:3]
    tvec = camera_params[3:6].reshape(3,1)

    # Convert Rodrigues vector to rotation matrix
    R, _ = cv2.Rodrigues(rvec)

    points_cam = R @ points_3d.T + tvec # Transform points to camera coordinates
    points_proj = K @ points_cam       # Project to image plane

    # Normalize by z coordinate
    points_2d_projected = points_proj[:2, :] / points_proj[2, :]
    return points_2d_projected.T # Return as Nx2

def rodrigues_to_matrix(rvec):
    """Convert Rodrigues vector to rotation matrix."""
    return Rotation.from_rotvec(rvec.flatten()).as_matrix()

def matrix_to_rodrigues(R):
    """Convert rotation matrix to Rodrigues vector."""
    return Rotation.from_matrix(R).as_rotvec()

class ReprojectionError(pyceres.CostFunction):
    """
    Cost function for bundle adjustment using pyceres.
    Minimizes the reprojection error between observed 2D points and
    projected 3D points.

    Parameters:
        observed_x, observed_y: The observed 2D coordinates.
        K: The camera intrinsic matrix.
    """
    def __init__(self, observed_x, observed_y, K):
        super().__init__()
        self.set_num_residuals(2) # Residuals are (error_x, error_y)
        self.set_parameter_block_sizes([6, 3]) # Camera (rvec, tvec), Point (x, y, z)

        self.observed_x = observed_x
        self.observed_y = observed_y
        self.K = K

    def Evaluate(self, parameters, residuals, jacobians):
        """
        Evaluate the cost function and optionally its Jacobian.

        parameters: list of numpy arrays for each parameter block
                    [camera_params (6,), point_3d (3,)]
        residuals: numpy array to fill with residuals (2,)
        jacobians: list of numpy arrays to fill with Jacobians (2x6, 2x3)
        """
        camera_params = parameters[0] # [rvec (3), tvec (3)]
        point_3d = parameters[1] # [x, y, z]

        rvec = camera_params[:3]
        tvec = camera_params[3:6]

        # Convert Rodrigues vector to rotation matrix
        # Using cv2.Rodrigues for forward pass, but need to handle derivatives
        # For autodiff, it's better to use a differentiable rotation representation
        # or rely on Ceres's autodiff for the Rodrigues conversion itself if possible.
        # pyceres's autodiff works on the parameter blocks directly.
        # We'll implement the projection using basic matrix operations that autodiff can handle.

        # Ceres autodiff requires operations on template types (Jet).
        # We need to perform the rotation and translation using operations that
        # are defined for these types.

        # Rotation using Rodrigues formula (simplified for autodiff)
        # This is a conceptual representation; actual autodiff requires careful implementation
        # or using a library function that supports autodiff.
        # A common approach is to use angle-axis representation directly in the cost function.

        # Let's use the angle-axis representation directly for rotation
        angle_axis = rvec

        # Compute rotation matrix from angle-axis (using a differentiable method)
        # For autodiff, we'd typically use a Ceres-compatible implementation
        # or implement the Rodrigues formula components in a differentiable way.
        # A simpler approach for autodiff is often to use quaternions or directly
        # implement the rotation using vector operations.

        # Let's assume we have a differentiable function `ceres_rotate_point`
        # that applies the rotation defined by `angle_axis` to `point_3d`.
        # In a real scenario, you'd use Ceres's built-in rotation functions or implement one.
        # For this example, we'll show the structure assuming such a function exists.

        # Example of rotation using angle-axis (conceptual for autodiff)
        # This is NOT the actual implementation you'd write for Ceres autodiff,
        # but shows the mathematical operation.
        # rotated_point = ceres_rotate_point(angle_axis, point_3d)

        # A more direct way for autodiff is to implement the Rodrigues formula
        # or use a different rotation representation (like quaternions) within the cost function.
        # Let's stick to the Rodrigues vector as the parameter block but implement
        # the rotation using operations autodiff can handle.

        theta_sq = angle_axis[0]*angle_axis[0] + angle_axis[1]*angle_axis[1] + angle_axis[2]*angle_axis[2]
        theta = pyceres.sqrt(theta_sq)

        if theta < 1e-9: # Handle near-zero rotation
            point_cam_rotated = point_3d # Identity rotation
        else:
            axis = angle_axis / theta
            cos_theta = pyceres.cos(theta)
            sin_theta = pyceres.sin(theta)
            point_cam_rotated = point_3d * cos_theta + pyceres.cross(axis, point_3d) * sin_theta + axis * pyceres.dot(axis, point_3d) * (1 - cos_theta)

        # Transform 3D point to camera coordinates
        point_cam = point_cam_rotated + tvec

        # Project to image plane
        # Need to perform matrix multiplication K @ point_cam using operations
        # compatible with Ceres autodiff (Jet types).
        # Assuming K is a numpy array of doubles, multiplication with Jet types works.

        projected_x = self.K[0, 0] * point_cam[0] + self.K[0, 1] * point_cam[1] + self.K[0, 2] * point_cam[2]
        projected_y = self.K[1, 0] * point_cam[0] + self.K[1, 1] * point_cam[1] + self.K[1, 2] * point_cam[2]
        projected_z = self.K[2, 0] * point_cam[0] + self.K[2, 1] * point_cam[1] + self.K[2, 2] * point_cam[2]

        # Check if point is behind the camera (z <= 0)
        # Autodiff handles conditional branches, but large errors for points behind
        # might cause issues. A common approach is to penalize points behind the camera
        # or filter them out before BA. For simplicity here, we'll proceed, but
        # in a robust implementation, you'd handle this.
        # if projected_z <= 1e-6:
        # residuals[0] = 1e6
        # residuals[1] = 1e6
        # return True # Or False, depending on desired behavior

        # Normalize by z coordinate
        projected_2d_x = projected_x / projected_z
        projected_2d_y = projected_y / projected_z

                # Compute residuals (observed - projected)
        residuals[0] = self.observed_x - projected_2d_x
        residuals[1] = self.observed_y - projected_2d_y

        # Jacobians are computed automatically by pyceres's autodiff
        # if the operations within Evaluate are compatible with Jet types.
        # We do not need to fill the jacobians list manually when using autodiff.

        return True # Indicate success


def run_bundle_adjustment(initial_poses, initial_points_3d, points_2d_observed,
                          camera_indices, point_indices, K_matrix):
    """
    Performs bundle adjustment.

    initial_poses: list of poselib.CameraPose objects or similar (R, t)
    initial_points_3d: Nx3 numpy array of initial 3D point estimates
    points_2d_observed: Mx2 numpy array of observed 2D points
    camera_indices: M-length array, i-th element is camera index for i-th observation
    point_indices: M-length array, i-th element is 3D point index for i-th observation
    K_matrix: 3x3 camera intrinsic matrix
    """
    n_cameras = len(initial_poses)
    n_points = initial_points_3d.shape[0]

    problem = pyceres.Problem()

    # Prepare initial parameters for optimization
    # Camera params: n_cameras * (3 for rvec + 3 for tvec)
    # 3D points: n_points * 3 for XYZ

    initial_camera_params_flat = []
    for pose in initial_poses:
        R = pose.R
        t = pose.t.flatten() # Ensure t is 1D array (3,)
        rvec = matrix_to_rodrigues(R) # Convert R to Rodrigues vector
        initial_camera_params_flat.extend(rvec)
        initial_camera_params_flat.extend(t)

    # Create parameter blocks for cameras and points
    # pyceres requires parameters to be mutable (e.g., numpy arrays)
    camera_params_blocks = [np.array(initial_camera_params_flat[i*6:(i+1)*6], dtype=np.float64) for i in range(n_cameras)]
    point_params_blocks = [np.array(initial_points_3d[i], dtype=np.float64) for i in range(n_points)]

    # Add parameter blocks to the problem
    for cam_block in camera_params_blocks:
        problem.add_parameter_block(cam_block, 6)
    for pt_block in point_params_blocks:
        problem.add_parameter_block(pt_block, 3)

    # Add residuals to the problem
    for i in range(len(points_2d_observed)):
        cam_idx = camera_indices[i]
        point_idx = point_indices[i]
        observed_x, observed_y = points_2d_observed[i]

        # Create the cost function for this observation
        # Use pyceres.AutoDiffCostFunction to wrap the ReprojectionError
        cost_function = pyceres.AutoDiffCostFunction(
            ReprojectionError(observed_x, observed_y, K_matrix), # Cost function instance
            2, # Number of residuals
            [6, 3]) # Parameter block sizes

        # Add the residual block connecting the camera and point
        problem.add_residual_block(
            cost_function,
            None, # Loss function (None for squared error)
            [camera_params_blocks[cam_idx], point_params_blocks[point_idx]]
        )

    print(f"Optimizing {n_cameras} cameras and {n_points} points.")
    print(f"Total observations: {len(points_2d_observed)}")

    # Configure and run the solver
    options = pyceres.SolverOptions()
    options.linear_solver_type = pyceres.LinearSolverType.SPARSE_NORMAL_CHOLESKY
    options.minimizer_progress_to_stdout = True
    summary = pyceres.SolverSummary()
    pyceres.solve(options, problem, summary)

    # Convert optimized camera params back to R, t format (e.g., list of poselib.CameraPose)
    optimized_poses = []
    for i in range(n_cameras):
        # Note: camera_params_blocks[i] now contains the optimized parameters
        rvec_opt = camera_params_blocks[i][:3]
        tvec_opt = camera_params_blocks[i][3:6]
        R_opt, _ = cv2.Rodrigues(rvec_opt)

        # import poselib
        # pose_opt = poselib.CameraPose()
        # pose_opt.R = R_opt
        # pose_opt.t = tvec.reshape(3,1)
        # optimized_poses.append(pose_opt)

        # For now, just store as (R, t) tuples or dicts
        optimized_poses.append({'R': R_opt, 't': tvec_opt.reshape(3,1)})

    # Extract optimized 3D points
    optimized_points_3d = np.array([pt_block for pt_block in point_params_blocks])

    return optimized_poses, optimized_points_3d, summary.final_cost, summary


# --- Example Usage (Conceptual - you need to provide the inputs) ---
if __name__ == '__main__':
    # This is a placeholder for how you'd call it.
    # You need to populate these variables from your SfM pipeline.

    # --- 0. FAKE DATA SETUP (Replace with your actual SfM output) ---
    import poselib # For CameraPose in fake data generation

    # Camera Intrinsics
    K_matrix = np.array([[800, 0, 320],
                         [0, 800, 240],
                         [0, 0, 1]], dtype=float)

    # Ground truth 3D points (e.g., a small cube)
    points_3d_gt = np.array([
        [0,0,0], [1,0,0], [1,1,0], [0,1,0],
        [0,0,1], [1,0,1], [1,1,1], [0,1,1]
    ], dtype=float)
    n_points = points_3d_gt.shape[0]

    # Ground truth camera poses
    pose_gt1 = poselib.CameraPose() # Identity pose for the first camera
    pose_gt1.R = np.eye(3)
    pose_gt1.t = np.array([0,0,3.0]).reshape(3,1) # Looking at origin from z=3

    pose_gt2 = poselib.CameraPose()
    R2_gt = Rotation.from_euler('xyz', [0, 0.3, 0]).as_matrix() # Small rotation
    pose_gt2.R = R2_gt
    pose_gt2.t = np.array([0.5, 0, 3.5]).reshape(3,1)

    initial_poses_gt = [pose_gt1, pose_gt2]
    n_cameras = len(initial_poses_gt)

    # Generate perfect 2D observations
    points_2d_observed_list = []
    camera_indices_list = []
    point_indices_list = []

    for cam_idx, pose_gt in enumerate(initial_poses_gt):
        projected = project(points_3d_gt,
                            np.hstack((matrix_to_rodrigues(pose_gt.R), pose_gt.t.flatten())),
                            K_matrix)
        for pt_idx in range(n_points):
            points_2d_observed_list.append(projected[pt_idx])
            camera_indices_list.append(cam_idx)
            point_indices_list.append(pt_idx)

    points_2d_observed = np.array(points_2d_observed_list)
    camera_indices = np.array(camera_indices_list)
    point_indices = np.array(point_indices_list)

    # --- Introduce noise to initial estimates for BA ---
    initial_poses_noisy = []
    for pose_gt in initial_poses_gt:
        noisy_pose = poselib.CameraPose()
        noisy_R = pose_gt.R @ Rotation.from_euler('xyz', np.random.randn(3) * 0.05).as_matrix()
        noisy_t = pose_gt.t + np.random.randn(3) * 0.1
        noisy_pose.R = noisy_R
        noisy_pose.t = noisy_t
        initial_poses_noisy.append(noisy_pose)

    initial_points_3d_noisy = points_3d_gt + np.random.randn(*points_3d_gt.shape) * 0.1
    # --- END OF FAKE DATA SETUP ---


    # Run Bundle Adjustment
    print("Running Bundle Adjustment...")
    optimized_poses, optimized_points_3d, final_cost, summary = run_bundle_adjustment(
        initial_poses_noisy,
        initial_points_3d_noisy,
        points_2d_observed, # Use perfect observations for this test
        camera_indices,
        point_indices,
        K_matrix
    )

    print("\nBundle Adjustment Finished.")
    print(f"Solver Summary:\n{summary.FullReport()}")
    print(f"Final cost (sum of squared residuals): {final_cost}")

    # Compare optimized with ground truth (for this synthetic example)
    print("\nOptimized Poses (R, t):")
    for i, pose_opt in enumerate(optimized_poses):
        print(f"Camera {i}:")
        print("R_opt:\n", pose_opt['R'])
        print("t_opt:\n", pose_opt['t'])
        print("R_gt:\n", initial_poses_gt[i].R)
        print("t_gt:\n", initial_poses_gt[i].t)
        print("-" * 20)

    print("\nOptimized 3D Points (first 3):")
    print(optimized_points_3d[:3])
    print("Ground Truth 3D Points (first 3):")
    print(points_3d_gt[:3])

    # You would then visualize these `optimized_poses` and `optimized_points_3d`
    # using matplotlib 3D or libraries like Open3D/PyVista.

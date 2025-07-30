import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial.transform import Rotation

# --- Helper Functions from previous tutorial ---

def skew(v):
    """Converts a 3D vector to a 3x3 skew-symmetric matrix."""
    return np.array([
        [0, -v[2], v[1]],
        [v[2], 0, -v[0]],
        [-v[1], v[0], 0]
    ])

def se3_to_SE3(xi):
    """Exponential map for SE(3). Converts a 6D twist vector to a 4x4 transform."""
    v = xi[:3]
    w = xi[3:]
    w_skew = skew(w)
    theta = np.linalg.norm(w)

    if np.isclose(theta, 0):
        R = np.eye(3)
        V = np.eye(3)
    else:
        # This is the closed-form solution for the matrix exponential,
        # also known as Rodrigues' Rotation Formula.
        A = np.sin(theta) / theta
        B = (1 - np.cos(theta)) / (theta**2)
        R = np.eye(3) + A * w_skew + B * (w_skew @ w_skew)

        # The V matrix is crucial for the translational part. It accounts for
        # the coupling between rotation and translation. It is the result of
        # integrating the rotation matrix over the interval [0, 1].
        C = (1 - A) / (theta**2)
        V = np.eye(3) + B * w_skew + C * (w_skew @ w_skew)

    # The final translation t is not simply v. It is transformed by V
    # to account for the motion path during the simultaneous rotation.
    t = V @ v.reshape(3, 1)
    
    T_out = np.eye(4)
    T_out[:3, :3] = R
    T_out[:3, 3] = t.flatten()
    return T_out

# --- Plotting Functions ---

def setup_plot(title, limits=((-1, 1), (-1, 1), (-1, 1))):
    """Creates a 3D plot with labels and equal aspect ratio."""
    fig = plt.figure(figsize=(8, 8))
    ax = fig.add_subplot(111, projection='3d')
    ax.set_title(title, fontsize=16)
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_xlim(limits[0])
    ax.set_ylim(limits[1])
    ax.set_zlim(limits[2])
    ax.set_aspect('equal')
    return ax

def plot_basis(ax, R=np.eye(3), t=np.zeros(3), label_prefix="", length=0.5):
    """Plots a 3D coordinate frame (basis vectors)."""
    origin = t.flatten()
    # X-axis (red)
    ax.quiver(origin[0], origin[1], origin[2],
              R[0, 0], R[1, 0], R[2, 0],
              color='r', length=length, label=f'{label_prefix} X')
    # Y-axis (green)
    ax.quiver(origin[0], origin[1], origin[2],
              R[0, 1], R[1, 1], R[2, 1],
              color='g', length=length, label=f'{label_prefix} Y')
    # Z-axis (blue)
    ax.quiver(origin[0], origin[1], origin[2],
              R[0, 2], R[1, 2], R[2, 2],
              color='b', length=length, label=f'{label_prefix} Z')


if __name__ == '__main__':
    # --- Part 1: Visualizing SO(3) / so(3) (Rotation) ---
    ax1 = setup_plot("Part 1: SO(3) Rotation from so(3) vector")
    plot_basis(ax1, label_prefix="World")

    # Define an so(3) vector: rotation of 90 degrees (pi/2) around Z-axis
    w_so3 = np.array([0, 0, np.pi / 2])
    print(f"Part 1: so(3) vector w = {w_so3.round(4)}")

    # Exponential Map: so(3) -> SO(3)
    R_SO3 = Rotation.from_rotvec(w_so3).as_matrix()
    print(f"Resulting SO(3) matrix R:\n{R_SO3.round(4)}")

    # Plot the rotated basis
    plot_basis(ax1, R=R_SO3, label_prefix="Rotated")
    ax1.legend()
    plt.show()


    # --- Part 2: Visualizing SE(3) / se(3) (Full Pose) ---
    ax2 = setup_plot("Part 2: SE(3) Pose from se(3) twist", limits=((-1, 2), (-1, 2), (-1, 2)))
    plot_basis(ax2, label_prefix="World")

    # Define an se(3) twist vector:
    # Translation: (1.5, 0.5, 0)
    # Rotation: -90 degrees (-pi/2) around Y-axis
    xi_se3 = np.array([1.5, 0.5, 0.0, 0.0, -np.pi / 2, 0.0])
    print(f"\nPart 2: se(3) twist vector xi = {xi_se3.round(4)}")

    # Exponential Map: se(3) -> SE(3)
    T_SE3 = se3_to_SE3(xi_se3)
    R_pose = T_SE3[:3, :3]
    t_pose = T_SE3[:3, 3]
    print(f"Resulting SE(3) matrix T:\n{T_SE3.round(4)}")

    # Plot the transformed basis
    plot_basis(ax2, R=R_pose, t=t_pose, label_prefix="Transformed")
    ax2.legend()
    plt.show()


    # --- Part 3: Visualizing Pose Updates (The SLAM Use-Case) ---
    ax3 = setup_plot("Part 3: Pose Update via Lie Algebra", limits=((-1, 2), (-1, 2), (-1, 2)))

    # 1. Start with an initial pose estimate (T_old)
    # Let's say it's rotated 45 deg around Z and translated to (1, 0, 0)
    R_old = Rotation.from_euler('z', 45, degrees=True).as_matrix()
    t_old = np.array([1.0, 0.0, 0.0])
    T_old = np.eye(4)
    T_old[:3, :3] = R_old
    T_old[:3, 3] = t_old
    print(f"\nPart 3: Initial Pose T_old:\n{T_old.round(4)}")
    plot_basis(ax3, R=R_old, t=t_old, label_prefix="Old Pose", length=0.4)

    # 2. An optimization algorithm (like in SLAM) computes a small correction
    #    in the tangent space (the algebra).
    #    Let's say the correction is: move a bit along local Y, rotate a bit around local X
    delta_xi = np.array([0.0, 0.4, 0.0, 0.3, 0.0, 0.0]) # [v, w]
    print(f"\nCorrection twist delta_xi = {delta_xi.round(4)}")

    # 3. Map this small correction from the algebra back to the group
    T_delta = se3_to_SE3(delta_xi)
    print(f"\nCorrection Matrix T_delta:\n{T_delta.round(4)}")

    # 4. Apply the update. The standard convention is left-multiplication.
    #    This applies the correction `delta_xi` in the *local coordinate frame* of T_old.
    #
    #    IMPORTANT: For this to work, T_old must represent T_camera_from_world.
    #    - T_new = T_delta @ T_old   (Update in local frame, for T_camera_from_world)
    #
    #    The alternative is updating in the world frame, which uses right-multiplication
    #    and a different pose convention (T_world_from_camera).
    #    - T_new = T_old @ T_delta   (Update in world frame, for T_world_from_camera)
    #
    #    SLAM/SfM optimizers almost always compute updates in the local frame.
    T_new = T_delta @ T_old

    R_new = T_new[:3, :3]
    t_new = T_new[:3, 3]
    print(f"\nUpdated Pose T_new:\n{T_new.round(4)}")
    plot_basis(ax3, R=R_new, t=t_new, label_prefix="New Pose", length=0.5)

    # Also plot the world frame for reference
    plot_basis(ax3, label_prefix="World", length=0.5)
    ax3.legend()
    plt.show()
from utils import *
from scipy import ndimage

def get_dI(imgI, warp_params=np.eye(3)):
    # convolve with dx, dy filters
    # ? why is it not warp and then grad. BUT grad and then warp
    dx_filter = np.array([[-1,-1,-1], [0,0,0], [1,1,1]]).T
    imgI_dx = ndimage.correlate(imgI, dx_filter, mode='constant', cval=0.0)
    imgI_dy = ndimage.correlate(imgI, dx_filter.T, mode='constant', cval=0.0)

    imgI_dx_warped = transform.warp(imgI_dx, warp_params)
    imgI_dy_warped = transform.warp(imgI_dy, warp_params)
    stacked_dI = np.dstack((imgI_dx_warped, imgI_dy_warped))
    return stacked_dI

def get_dw_dp(imgI, p):
    h, w = imgI.shape
    target_coordinates = np.mgrid[0:h, 0:w][::-1] # [::-1] is needed for making x, y directions horizontal and vertical
    # print('target coords: ', target_coordinates[:, :5, :5])
    target_coordinates = target_coordinates.reshape(2, -1).T 
    # print(target_coordinates[:5,:])
    source_coordinates = transform.matrix_transform(target_coordinates, np.linalg.pinv(p))
    # print(source_coordinates[:5,:])
    dw_dp = np.zeros((h*w, 2, 6))
    dw_dp[:, 0, 0] =  source_coordinates[:, 0] # x
    dw_dp[:, 0, 1] =  source_coordinates[:, 1] # y
    dw_dp[:, 0, 2] =  1
    dw_dp[:, 1, 3] =  source_coordinates[:, 0] # x
    dw_dp[:, 1, 4] =  source_coordinates[:, 1] # y
    dw_dp[:, 1, 5] =  1
    #input()
    return dw_dp

def multiply(imgI_dx_dy_w, dw_dp):
    # (h, w, 2), (h*w, 2, 6)
    N, _, _ = dw_dp.shape
    imgI_dx_dy_w = imgI_dx_dy_w.reshape(-1, 1, 2) # (h*w, 1, 2)
    mul_result = np.matmul(imgI_dx_dy_w, dw_dp) # (h*w, 1, 2) x (h*w, 2, 6) => (h*w, 1, 6)
    return mul_result.reshape(N, -1)

def get_A(imgI, p):
    # 3. warp gradient
    imgI_dx_dy_w = get_dI(imgI, warp_params=p) # (h, w, 2)

    # 4. get jacobian dw/dp
    dw_dp = get_dw_dp(imgI, p) # (h*w, 2, 6)

    # 5. get dI * dw_dp
    dI_mul_dwdp = multiply(imgI_dx_dy_w, dw_dp) # (h*w, 6)

    return dI_mul_dwdp

def lucas_kanade_additive(imgT, imgI, eps=1e-8, p=None):
    print('lucas_kanade_additive: imgT shape:{}, imgI shape:{}'.format(imgT.shape, imgI.shape))
    if p is None:
        p = np.eye(3)
    
    p = p[:2, :].reshape(-1, 1)

    for iteration in range(10000):
        # 1. get warped image
        h, w = imgI.shape
        current_p = np.concatenate((p.reshape(2,3), np.array([[0,0,1]])), axis=0)
        imgI_warped = transform.warp(imgI, current_p)

        # show the images
        if iteration % 1000 == 0:
            show_images(imgT, imgI_warped)

        # 2. error image 
        error_img = imgT - imgI_warped
        error_img = error_img.reshape(-1, 1)

        # consider errors only for inliers
        new_coords = transform.matrix_transform(get_traditional_xy_coords(imgI.shape), current_p)
        error_img[new_coords[:,0] < 0] = 0
        error_img[new_coords[:,1] < 0] = 0
        error_img[new_coords[:,0] > w] = 0
        error_img[new_coords[:,1] > h] = 0            
        
        if iteration % 100 == 0:
            print('step: {}, error: {}'.format(iteration, (error_img**2).sum()))
            print('current p', current_p)

        # steps 3, 4, 5
        A = get_A(imgI, current_p)
        
        # 6. calculate dp (similar to optical flow formulation with least square fitting)
        H = np.linalg.pinv(np.matmul(A.T, A))
        after_H = np.matmul(A.T, error_img)
        dp = np.matmul(H, after_H)

        p = p + dp

        # check for the minimum error threshold
        dp_magnitude = (dp**2).sum()
        if dp_magnitude <= eps:
            break
    
    return np.concatenate((p.reshape(2,3), np.array([[0,0,1]])), axis=0), imgI_warped


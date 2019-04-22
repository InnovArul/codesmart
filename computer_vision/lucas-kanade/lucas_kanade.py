from utils import *
from scipy import ndimage

def warp_image(img, w):
    return transform.warp(img, np.linalg.pinv(w))

def get_dI(imgI, warp_params=np.eye(3)):
    # TODO: change grad calculation to warp and correlate
    # convolve with dx, dy filters
    dx_filter = np.array([[1,1,1], [0,0,0], [-1,-1,-1]])
    imgI_dx = ndimage.correlate(imgI, dx_filter, mode='constant', cval=0.0)
    imgI_dy = ndimage.correlate(imgI, dx_filter.T, mode='constant', cval=0.0)

    imgI_dx_warped = warp_image(imgI_dx, warp_params)
    imgI_dy_warped = warp_image(imgI_dy, warp_params)
    stacked_dI = np.stack((imgI_dx_warped, imgI_dy_warped))
    return stacked_dI.transpose(1,2,0)

def get_dw_dp(imgI, p):
    h, w = imgI.shape
    target_coordinates = np.mgrid[0:h, 0:w].reshape(2, -1).T
    source_coordinates = transform.matrix_transform(target_coordinates, np.linalg.pinv(p))
    dw_dp = np.zeros((h*w, 2, 6))
    dw_dp[:, 0, 0] =  source_coordinates[:, 0] # x
    dw_dp[:, 0, 2] =  source_coordinates[:, 1] # y
    dw_dp[:, 0, 4] =  1
    dw_dp[:, 0, 1] =  source_coordinates[:, 0] # x
    dw_dp[:, 0, 3] =  source_coordinates[:, 1] # y
    dw_dp[:, 0, 5] =  1
    return dw_dp

def multiply(imgI_dx_dy_w, dw_dp):
    # (h, w, 2), (h*w, 2, 6)
    N, _, _ = dw_dp.shape
    imgI_dx_dy_w = imgI_dx_dy_w.reshape(-1, 1, 2) # (h*w, 1, 2)
    mul_result = np.matmul(imgI_dx_dy_w, dw_dp)
    return mul_result.reshape(N, -1)

def get_A(imgI, p):
    # 3. warp gradient
    imgI_dx_dy_w = get_dI(imgI, warp_params=p) # (h, w, 2)

    # 4. get jacobian dw/dp
    dw_dp = get_dw_dp(imgI, p)

    # 5. get dI * dw_dp
    dI_mul_dwdp = multiply(imgI_dx_dy_w, dw_dp) # (h*w, 6)

    return dI_mul_dwdp

def lucas_kanade_addititve(imgT, imgI):
    # get A
    p = np.eye(3)[:2, :].reshape(-1, 1)

    for iteration in range(100):
        # 1. get warped image
        current_p = np.concatenate((p.reshape(2,3), np.array([[0,0,1]])), axis=0)
        print(current_p)
        imgI_warped = warp_image(imgI, current_p)

        # show the images
        show_images(imgT, imgI_warped)

        # 2. error image 
        error_img = imgT - imgI_warped
        error_img = error_img.reshape(-1, 1)

        # steps 3, 4, 5
        A = get_A(imgI, current_p)
        
        # 6. calculate dp (similar to optical flow formulation with least square fitting)
        H = np.linalg.pinv(np.matmul(A.T, A))
        after_H = np.matmul(A.T, -error_img)
        dp = np.matmul(H, after_H)

        p = p + dp

def main():
    # read template and instance images
    imgT, imgI, transformer = read_images()
    # show_images(imgT, imgI)
    lucas_kanade_addititve(imgT, imgI)

if __name__ == '__main__':
    main()

from utils import *
from scipy import ndimage

def get_dI(img):
    # convolve with dx, dy filters
    # ? why is it not warp and then grad. BUT grad and then warp
    dx_filter = np.array([[-1,-1,-1], [0,0,0], [1,1,1]]).T
    img_dx = ndimage.correlate(img, dx_filter, mode='constant', cval=0.0)
    img_dy = ndimage.correlate(img, dx_filter.T, mode='constant', cval=0.0)

    stacked_dI = np.dstack((img_dx, img_dy))
    return stacked_dI

def get_dw_dp(img):
    h, w = img.shape
    target_coordinates = np.mgrid[0:h, 0:w][::-1] # [::-1] is needed for making x, y directions horizontal and vertical
    # print('target coords: ', target_coordinates[:, :5, :5])
    target_coordinates = target_coordinates.reshape(2, -1).T 

    dw_dp = np.zeros((h*w, 2, 6))
    dw_dp[:, 0, 0] =  target_coordinates[:, 0] # x
    dw_dp[:, 0, 1] =  target_coordinates[:, 1] # y
    dw_dp[:, 0, 2] =  1
    dw_dp[:, 1, 3] =  target_coordinates[:, 0] # x
    dw_dp[:, 1, 4] =  target_coordinates[:, 1] # y
    dw_dp[:, 1, 5] =  1
    #input()
    return dw_dp

def multiply(imgI_dx_dy_w, dw_dp):
    # (h, w, 2), (h*w, 2, 6)
    N, _, _ = dw_dp.shape
    imgI_dx_dy_w = imgI_dx_dy_w.reshape(-1, 1, 2) # (h*w, 1, 2)
    mul_result = np.matmul(imgI_dx_dy_w, dw_dp) # (h*w, 1, 2) x (h*w, 2, 6) => (h*w, 1, 6)
    return mul_result.reshape(N, -1)

def get_A(img):
    # 3. warp gradient
    img_dx_dy = get_dI(img) # (h, w, 2)

    # 4. get jacobian dw/dp
    dw_dp = get_dw_dp(img) # (h*w, 2, 6)

    # 5. get dI * dw_dp
    dT_mul_dwdp = multiply(img_dx_dy, dw_dp) # (h*w, 6)

    return dT_mul_dwdp

def lucas_kanade_addititve(imgT, imgI):
    # get A
    p = np.eye(3)

    # steps 3, 4, 5
    #  in LK IC, the template image is having the burden of dp and taylor expansion
    # hence, the A matrix (grad * jacobian)can be computed in advance
    A = get_A(imgT)
    
    for iteration in range(10000):
        # 1. get warped image
        current_p = p
        print('current p', current_p)
        imgI_warped = transform.warp(imgI, current_p)

        # show the images
        if iteration % 1000 == 0:
            show_images(imgT, imgI_warped)

        # 2. error image 
        error_img = imgI_warped - imgT
        error_img = error_img.reshape(-1, 1)
        print('step: {}, error: {}'.format(iteration, (error_img**2).sum()))
        
        # 6. calculate dp (similar to optical flow formulation with least square fitting)
        H = np.linalg.pinv(np.matmul(A.T, A))
        after_H = np.matmul(A.T, error_img)
        dp = np.matmul(H, after_H)

        # reformat dp as per LK IC algorithm
        dp = np.eye(3) + np.concatenate((dp.reshape(2,3), np.array([[0,0,0]])), axis=0)

        # multiplication of p with the inverse of dp
        p = np.matmul(p, np.linalg.pinv(dp))

def main():
    # read template and instance images
    imgT, imgI, transformer = read_images()

    # show_images(imgT, imgI)
    lucas_kanade_addititve(imgT, imgI)

if __name__ == '__main__':
    main()

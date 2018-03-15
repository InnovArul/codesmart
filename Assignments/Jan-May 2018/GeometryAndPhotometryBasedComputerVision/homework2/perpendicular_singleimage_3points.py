import os, sys, torch, scipy
import numpy as np
from skimage import io, transform
from utils import *

def get_K(intersection_points, img_shape):
    H_norm = get_normalization_matrix(img_shape, is_normalize=True)
    
    A = np.empty(shape=[0, 4])
    for point_index in range(3):
        x1, y1, h1 = np.dot(H_norm, intersection_points[point_index])
        x2, y2, h2 = np.dot(H_norm, intersection_points[(point_index + 1) % 3])
        A = np.append(A, [[x1*x2 + y1*y2, x1*h2+h1*x2, y1*h2+h1*y2, h1*h2]], axis=0);
    
    U, D, Vt = np.linalg.svd(A)
    params = matinverse(Vt)[:, -1]
    a, c, e, f = params
    W = [[a, 0, c], [0, a, e], [c, e, f]]       
    print(("W", W))
    
    # scipy function always supports Lower triangular * Upper triangular matrix
    HK_inverse_transpose = scipy.linalg.cholesky(W, lower=True)
    HK = np.linalg.inv(HK_inverse_transpose).T
    HK /= HK[2,2]
    print(("HK", HK))
    K = np.dot(np.linalg.inv(H_norm), HK)
    K /= K[2,2]
    print(("K", K))

if __name__ == '__main__':
    filebasepath = './pics/img1.jpg'
    points_buffer = filebasepath + '.buffer'
    buffer_points = []
    if os.path.exists(points_buffer):
        buffer_points = torch.load(points_buffer)
    img = read_image(filebasepath)
    
    points = []
    intersection_points = []
    if not os.path.exists(points_buffer):
        pts, _ = get_points_from_gui(12, None, img, True)
    else:
        pts = buffer_points
    
    print(pts)
    points = pts

    for i in range(3):
        current_points = points[i*4:(i+1)*4]
        line1, line2 = get_lines(current_points, img.shape)
        intersection_point1 = get_intersection_point(line1, line2)
        intersection_points.append(intersection_point1)
        
    torch.save(points, points_buffer)
    get_K(intersection_points, img.shape[:2])

import os, sys, torch
import numpy as np
from skimage import io, transform
from utils import *
import scipy

def get_K(intersection_points, img_shape):
    H_norm = get_normalization_matrix(img_shape, is_normalize=True)
    A = np.empty(shape=[0, 6])
    for img_index in range(5):
        x1, y1, h1 = np.dot(H_norm, intersection_points[img_index * 2])
        x2, y2, h2 = np.dot(H_norm, intersection_points[img_index * 2 + 1])
        #                   a,     d,     b,           c,     e,  f
        A = np.append(A, [[x1*x2, y1*y2, x1*y2+y1*x2, x1*h2+h1*x2, y1*h2+h1*y2, h1*h2]], axis=0);
    
    U, D, Vt = np.linalg.svd(A)
    params = matinverse(Vt)[:, -1]
    a, d, b, c, e, f = params
    W = [[a, b, c], [b, d, e], [c, e, f]]       
    print(("W", W))
    HK_inverse_transpose = scipy.linalg.cholesky(W, lower=True)
    HK = np.linalg.inv(HK_inverse_transpose).T
    print(("HK", HK))
    K = np.dot(np.linalg.inv(H_norm), HK)
    K /= K[2,2]
    print(("K", K))    

if __name__ == '__main__':
    filebasepath = './pics/cb'
    points_buffer = filebasepath + '.buffer'
    buffer_points = []
    if os.path.exists(points_buffer):
        buffer_points = torch.load(points_buffer)
    
    points = []
    intersection_points = []
    for i in range(5):
        filepath = filebasepath + str(i+1) + '.jpg'
        img = read_image(filepath)
        if not os.path.exists(points_buffer):
            img = read_image(filepath)
            pts, _ = get_points_from_gui(8, None, img, True)
        else:
            pts = buffer_points[i*8:(i+1)*8]
        
        #print(pts)
        points += pts
    
        current_points = points[i*8:(i+1)*8]
        #print(current_points)
        line1, line2 = get_lines(current_points[:4], img.shape)
        intersection_point1 = get_intersection_point(line1, line2)
        intersection_points.append(intersection_point1)
        
        line1, line2 = get_lines(current_points[4:], img.shape)
        intersection_point2 = get_intersection_point(line1, line2)
        intersection_points.append(intersection_point2)        

    torch.save(points, points_buffer)
    get_K(intersection_points, img.shape[:2])

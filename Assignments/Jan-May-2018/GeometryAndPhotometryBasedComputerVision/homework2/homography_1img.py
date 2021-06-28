import os, sys, torch, scipy
import numpy as np
from skimage import io, transform
from utils import *

def get_K(homographies):
    
    A = np.empty(shape=[0, 4])
    for img_index in range(len(homographies)):
        h1, h2, h3 = homographies[img_index][:,0], homographies[img_index][:,1], homographies[img_index][:,2]
        # a=d, b=0, c, e, f
        A = np.append(A, [[h1[0]*h2[0] + h1[1]*h2[1],  
                            h1[0]*h2[2]+h1[2]*h2[0], h1[1]*h2[2]+h1[2]*h2[1], h1[2]*h2[2]]], axis=0);
        A = np.append(A, [[(h1[0]*h1[0] - h2[0]*h2[0]) +
                           (h1[1]*h1[1] - h2[1]*h2[1]),
                           2 * h1[0]*h1[2] - 2*h2[0]*h2[2],
                           2*h1[1]*h1[2] - 2*h2[1]*h2[2],
                           h1[2]*h1[2] - h2[2]*h2[2]]], axis=0)
    
    U, D, Vt = np.linalg.svd(A)
    params = matinverse(Vt)[:, -1]
    alpha, x0, y0, f = params
    W = [[alpha, 0, x0], [0, alpha, y0], [x0,y0, f]]       
    print(("W", W))
    K_inverse_transpose = scipy.linalg.cholesky(W, lower=True)
    K = np.linalg.inv(K_inverse_transpose).T
    K /= K[2,2]
    print(("K", K))

if __name__ == '__main__':
    filebasepath = './pics/triple_box'
    points_buffer = filebasepath + '.buffer'
    buffer_points = []
    canonical_points = [(0,0), (0,1), (1,1), (1,0)]

    points = []
    homographies = []
    indices = np.random.permutation(3)[:2]
    for i in indices: #range(2, 5):
        filepath = filebasepath + str(i+1) + '.png'
        img = read_image(filepath)
        pts, _ = get_points_from_gui(4, None, img, True)
        homographies.append(getHomographyMatrix(canonical_points, pts))
        
    get_K(homographies)

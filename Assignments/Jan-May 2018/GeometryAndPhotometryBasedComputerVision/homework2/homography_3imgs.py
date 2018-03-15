import os, sys, torch, scipy, pprint
import numpy as np
from skimage import io, transform
from utils import *
pp = pprint.PrettyPrinter(indent=4)

def get_K(homographies):
    
    A = np.empty(shape=[0, 6])
    for img_index in range(len(homographies)):
        h1, h2, h3 = homographies[img_index][:,0], homographies[img_index][:,1], homographies[img_index][:,2]
        # a, d, b, c, e, f
        A = np.append(A, [[h1[0]*h2[0], h1[1]*h2[1], h1[0]*h2[1]+h1[1]*h2[0], 
                            h1[0]*h2[2]+h1[2]*h2[0], h1[1]*h2[2]+h1[2]*h2[1], h1[2]*h2[2]]], axis=0);
        A = np.append(A, [[h1[0]*h1[0] - h2[0]*h2[0],
                           h1[1]*h1[1] - h2[1]*h2[1],
                           2* h1[0]*h1[1] - 2 * h2[0]*h2[1],
                           2 * h1[0]*h1[2] - 2 * h2[0]*h2[2],
                           2 * h1[1]*h1[2] - 2 * h2[1]*h2[2],
                           h1[2]*h1[2] - h2[2]*h2[2]]], axis=0)
    
    U, D, Vt = np.linalg.svd(A)
    print(('D', D))
    params = matinverse(Vt)[:, -1]
    print(('params', params))
    alpha_x, alpha_y, s, x0, y0, f = params
    W = [[alpha_x, s, x0], [s, alpha_y, y0], [x0,y0, f]] 
    print(np.linalg.eigvalsh(W))  
    
#    print(("beforeW", W))
    #---------------------------
    # modify eigen values
#    w_eig, w_vec = np.linalg.eig(W)
#    W = np.dot(w_vec, np.dot(np.diag(np.abs(w_eig)), w_vec.T))
    #---------------------------
#    print(("afterW", W))
    
#    U, D, Vt = np.linalg.svd(W)
#    pp.pprint((U, D, Vt))
#    pp.pprint(np.linalg.inv(Vt))
#    print(("W", W))
    K_inverse_transpose = scipy.linalg.cholesky(W, lower=True)
    K = np.linalg.inv(K_inverse_transpose).T
    K /= K[2,2]
    print(("K", K)) 

if __name__ == '__main__':
    filebasepath = './pics/cb'
    extn = '.jpg'
    points_buffer = filebasepath + '.buffer'
    buffer_points = []
    canonical_points = [(0,0), (0,1), (1,1), (1,0)]

    points = []
    homographies = []
    
    indices = np.random.permutation(3)[:3]
    for i in indices: #in [0,1,4]: 
        filepath = filebasepath + str(i+1) + extn
        img = read_image(filepath)
        pts, _ = get_points_from_gui(4, None, img, True)
        homographies.append(getHomographyMatrix(canonical_points, pts))
        
    get_K(homographies)

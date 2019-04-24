import os, sys, os.path as osp
from skimage import io, transform, img_as_float
import matplotlib.pyplot as plt
import numpy as np, math
from skimage.color import rgb2gray

def read_image(filename):
    filepath = osp.join(filename)
    img = img_as_float(io.imread(filepath))

    if img.ndim > 2:
        img = rgb2gray(img)
    
    return img[:, :]

def random_transform_image(img):
    # randomly transform the image
    h, w = img.shape
    transformer =   transform.AffineTransform(translation=(-w//2, -h//2)) +\
                    transform.AffineTransform(rotation=np.deg2rad(25), translation=(200, 128)) +\
                    transform.AffineTransform(translation=(w//2, h//2)) 

    img_new = transform.warp(img, np.linalg.pinv(transformer.params))
    print('expected params', transformer.params)
    input()
    return img_new, transformer

def read_images(imgT_path, imgI_path=None):
    imgT = read_image(imgT_path)

    transformer = None
    if imgI_path is None:
        imgI, transformer = random_transform_image(imgT)
        print('imgI min:{}, max:{}, imgT min:{}, max:{}'.format(imgI.min(), imgI.max(), imgT.min(), imgT.max()))
    else:
        imgI = read_image(imgI_path)
    
    return imgT, imgI, transformer

def show_images(img1, img2):
    f = plt.figure()
    print(img1.shape, img2.shape)
    f.add_subplot(1,2,1)
    plt.imshow(img1, cmap='gray')
    f.add_subplot(1,2,2)
    plt.imshow(img2, cmap='gray')
    plt.show(block=True)

def get_traditional_xy_coords(shape):
    h, w = shape
    coordinates = np.mgrid[0:h, 0:w][::-1] # [::-1] is needed for making x, y directions horizontal and vertical
    # print('target coords: ', coordinates[:, :5, :5])
    coordinates = coordinates.reshape(2, -1).T    
    return coordinates 
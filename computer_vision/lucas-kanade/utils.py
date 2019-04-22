import os, sys, os.path as osp
from skimage import io, transform, img_as_float
import matplotlib.pyplot as plt
import numpy as np, math

def read_image(filename):
    filepath = osp.join('./pics', filename)
    img = img_as_float(io.imread(filepath))
    return img[:, :]

def random_transform_image(img):
    # randomly transform the image
    h, w = img.shape
    transformer =   transform.AffineTransform(translation=(-w//2, -h//2)) +\
                    transform.AffineTransform(rotation=0, translation=(5, 4)) +\
                    transform.AffineTransform(translation=(w//2, h//2)) 

    img_new = transform.warp(img, np.linalg.pinv(transformer.params))
    return img_new, transformer

def read_images():
    imgT = read_image('tom_jerry_bw.png')
    imgI, transformer = random_transform_image(imgT)
    return imgT, imgI, transformer

def show_images(img1, img2):
    f = plt.figure()
    print(img1.shape, img2.shape)
    f.add_subplot(1,2,1)
    plt.imshow(img1, cmap='gray')
    f.add_subplot(1,2,2)
    plt.imshow(img2, cmap='gray')
    plt.show(block=True)
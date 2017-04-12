import numpy as np;
import cv2
import math
import sys

# for bilinear interpolate code
sys.path.append('../')

import utils;

def main(imgpath, name):
    # load the image in grey scale
    img = cv2.imread(imgpath, 0);


    # translate the image
    translatedImage = utils.translateImage(img, 3.75, 4.3)

    # rotate the image
    rotatedImage = utils.rotateImage(img, 3)

    # scale the image
    scaledImage = utils.scaleImage(img, 0.8, 1.3)

    cv2.imwrite('./Lab1/tr' + name + '.png', translatedImage)
    cv2.imwrite('./Lab1/rot' + name + '.png', rotatedImage)
    cv2.imwrite('./Lab1/sc' + name + '.png', scaledImage)

    # cv2.namedWindow('image', cv2.WINDOW_NORMAL)
    # cv2.imshow('image', rotatedImage)
    # cv2.imshow('image', translatedImage)
    # cv2.imshow('image', scaledImage)
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()

main("./Lab1/pisa.pgm", 'pisa')
# main("./Lab1/lena.pgm", 'lena')
# main("./Lab1/cells.pgm", 'cells')

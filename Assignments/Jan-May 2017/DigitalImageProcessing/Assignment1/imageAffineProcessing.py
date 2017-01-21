import numpy as np;
import cv2
import math

def bilinearInterpolate(img, x, y):
    # get the dimension of the image
    height, width = img.shape
    if(x < 0 or x > height - 1):
        return 0;
    if(y < 0 or y > width - 1):
        return 0;

    modX = x % 1;
    modY = y % 1;

    if((modX == 0) and (modY == 0)):
        value = img[x, y]
    else:
        # bilinear interpolation
        # find four corners
        topLeft = img[int(math.floor(x)), int(math.floor(y))];
        topRight = img[int(math.floor(x)), int(math.ceil(y))];
        bottomLeft = img[int(math.ceil(x)), int(math.floor(y))];
        bottomRight = img[int(math.ceil(x)), int(math.ceil(y))];

        value = ((1 - modX) * (1 - modY) * topLeft) + \
                ((1 - modX) * modY * topRight) + \
                (modX * (1 - modY) * bottomLeft) + \
                (modX * modY * topRight);


    return value

def rotateImage(img, theta):
    # get the dimension of the image
    height, width = img.shape
    rotatedImage = np.zeros((height, width), np.uint8)
    thetaR = math.radians(theta)

    for i in range(height):
        for j in range(width):
            newCoordX = i - (height / 2);
            newCoordY = j - (width / 2);
            iSourceX = (newCoordX * math.cos(thetaR)) + (newCoordY * math.sin(thetaR));
            iSourceY = (-newCoordX * math.sin(thetaR)) + (newCoordY * math.cos(thetaR));

            # readd the translation done already
            iSourceX = iSourceX + (height / 2);
            iSourceY = iSourceY + (width / 2);

             # if the resultant coordiantes are float, then get bilinear interpolate the pixels
            rotatedImage[i, j] = bilinearInterpolate(img, iSourceX, iSourceY)

    return rotatedImage

def scaleImage(img, sx, sy):
    # get the dimension of the image
    height, width = img.shape
    outHeight = height;  # int(math.ceil(sx * height));
    outWidth = width;  # int(math.ceil(sy * width))
    scaledImage = np.zeros((outHeight, outWidth), np.uint8)

    for i in range(outHeight):
        for j in range(outWidth):
            newCoordX = i - (outHeight / 2);
            newCoordY = j - (outWidth / 2);

            iSourceX = (newCoordX / sx);
            iSourceY = (newCoordY / sy);

            # re translation in source image space
            iSourceX = iSourceX + (height / 2);
            iSourceY = iSourceY + (width / 2);

            # if the resultant coordiantes are float, then get bilinear interpolate the pixels
            scaledImage[i, j] = bilinearInterpolate(img, iSourceX, iSourceY)

    return scaledImage

def translateImage(img, tx, ty):
    # get the dimension of the image
    height, width = img.shape
    translatedImage = np.zeros((height, width), np.uint8)

    for i in range(height):
        for j in range(width):
            iSourceX = i - tx;
            iSourceY = j - ty;

            # if the resultant coordiantes are float, then get bilinear interpolate the pixels
            translatedImage[i, j] = bilinearInterpolate(img, iSourceX, iSourceY)

    return translatedImage

def main(imgpath, name):
    # load the image in grey scale
    img = cv2.imread(imgpath, 0);


    # translate the image
    translatedImage = translateImage(img, 3.75, 4.3)

    # rotate the image
    rotatedImage = rotateImage(img, 3)

    # scale the image
    scaledImage = scaleImage(img, 0.8, 1.3)

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

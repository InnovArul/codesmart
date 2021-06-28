import numpy as np;
import cv2;
import sys;

# for bilinear interpolate code
sys.path.append('../')
matinverse = np.linalg.inv

import utils;

def getHomographyMatrixForInplaneRotAndTrans(img1Points, img2Points):
    A = np.empty(shape=[0, 4])
    b = np.empty(shape=[0, 1])

    # matrix
    #
    # [ x  y  1  0 ] = [x']
    # [ y -x  0  1 ] = [y']
    # .
    # .

    for index in range(len(img1Points)):
        x1 = img1Points[index][0]
        y1 = img1Points[index][1]
        x2 = img2Points[index][0]
        y2 = img2Points[index][1]
        A = np.append(A, [[x1, -y1, 1, 0]], axis=0); b = np.append(b, [[x2]], axis=0);
        A = np.append(A, [[y1, x1, 0, 1]], axis=0); b = np.append(b, [[y2]], axis=0);

    solution = matinverse(A).dot(b);

    h0 = solution[0]; h1 = solution[1]; h2 = solution[2]; h3 = solution[3];
    H = np.asfarray(np.array([[h0, -h1, h2], [h1, h0, h3], [0, 0, 1.0]]))
    print(H)
    print(matinverse(H))
    return H

def getHomographedSourceImage(img, H, sourceSize):
    # get the dimension of the image
    height, width = sourceSize
    sourceImage = np.zeros((height, width), np.uint8)
    Hinv = matinverse(H)

    for i in range(height):
        for j in range(width):
            iSourceCoord = np.dot(Hinv, np.array([[j], [i], [1]]));
            iSourceX = (iSourceCoord[0] / iSourceCoord[2])[0];
            iSourceY = (iSourceCoord[1] / iSourceCoord[2])[0];

            # if the resultant coordinates are float, then get bilinear interpolate the pixels
            # bilinearInterpolate considers 2nd input as along height and 3rd input as along width
            sourceImage[i, j] = utils.bilinearInterpolate(img, iSourceY, iSourceX)

    return sourceImage

def main():
    # load the given images
    img1 = cv2.imread('./Lab2/IMG1.pgm', 0);
    img2 = cv2.imread('./Lab2/IMG2.pgm', 0);

    # correspondences already given in problem statement
    img1Points = [(125, 30), (373, 158)]
    img2Points = [(249, 94), (400, 329)]

    # create A matrix in Ax = 0
    H = getHomographyMatrixForInplaneRotAndTrans(img1Points, img2Points);

    # transform the second image to the view of first image
    transformedImage1to2 = getHomographedSourceImage(img1, H, img2.shape)
    cv2.imwrite('./Lab2/trImg1.png', transformedImage1to2)
    transformedImage2to1 = getHomographedSourceImage(img2, matinverse(H), img1.shape)
    cv2.imwrite('./Lab2/trInvHImg2.png', transformedImage2to1)

    # find the difference between original image and transformed image
    # print(type(img1[1, 1]))
    diffImage = img1 - transformedImage2to1;
    diffImage = np.abs(diffImage)
    diffImage = np.array(diffImage, dtype='uint8')
    # print(diffImage)
    cv2.imwrite('./Lab2/diffImage1.png', diffImage)

    diffImage = img2 - transformedImage1to2;
    diffImage = np.abs(diffImage)
    diffImage = np.array(diffImage, dtype='uint8')
    # print(diffImage)
    cv2.imwrite('./Lab2/diffImage2.png', diffImage)

    ret, threshImage = cv2.threshold(diffImage, 200, 255, cv2.THRESH_TOZERO_INV)
    cv2.imwrite('./Lab2/threshImage.png', threshImage)

main()

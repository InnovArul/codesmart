import numpy as np
import matplotlib.pyplot as plt
import time, cv2, math
from skimage import transform, io, img_as_float

matinverse = np.linalg.inv

def show_image(image):
    dpi = 80
    figsize = (image.shape[1]/float(dpi), image.shape[0]/float(dpi))
    fig = plt.figure(figsize=figsize); 
    plt.imshow(image);
    fig.show()

def read_image(img_path):
    return img_as_float(io.imread(img_path))

def get_arranged_point(point):
    return [[point[0], point[1], 1]]

def get_normalized_coord(point):
    return [point[0]/point[2], point[1]/point[2], 1]

def get_line(point1, point2):
    #print((point1, point2))
    return np.cross(get_normalized_coord(point1), get_normalized_coord(point2))

def get_intersection_point(line1, line2):
    return np.cross(get_normalized_coord(line1), get_normalized_coord(line2))

def get_lines(line_points, img_shape):
    height, width, channels = img_shape
    
    normalized_points = []
    for point in line_points:
        normalized_points += get_arranged_point(point)
    
    print(normalized_points)
    line1 = get_normalized_coord(get_line(normalized_points[0], normalized_points[1]))
    line2 = get_normalized_coord(get_line(normalized_points[2], normalized_points[3]))
    return line1, line2

def get_homogeneous_coords(points):
    return [get_normalized_coord(point) for point in points]

def nullspace(A, atol=1e-13, rtol=0):
    """Compute an approximate basis for the nullspace of A.

    The algorithm used by this function is based on the singular value
    decomposition of `A`.

    Parameters
    ----------
    A : ndarray
        A should be at most 2-D.  A 1-D array with length k will be treated
        as a 2-D with shape (1, k)
    atol : float
        The absolute tolerance for a zero singular value.  Singular values
        smaller than `atol` are considered to be zero.
    rtol : float
        The relative tolerance.  Singular values less than rtol*smax are
        considered to be zero, where smax is the largest singular value.

    If both `atol` and `rtol` are positive, the combined tolerance is the
    maximum of the two; that is::
        tol = max(atol, rtol * smax)
    Singular values smaller than `tol` are considered to be zero.

    Return value
    ------------
    ns : ndarray
        If `A` is an array with shape (m, k), then `ns` will be an array
        with shape (k, n), where n is the estimated dimension of the
        nullspace of `A`.  The columns of `ns` are a basis for the
        nullspace; each element in numpy.dot(A, ns) will be approximately
        zero.
    """

    A = np.atleast_2d(A)
    u, s, vh = np.linalg.svd(A)
    tol = max(atol, rtol * s[0])
    nnz = (s >= tol).sum()
    ns = vh[nnz:].conj()[0]
    print(ns)
    return ns

def getHomographyMatrix(img1Points, img2Points):
    A = np.empty(shape=[0, 9])

    # matrix
    #
    # [ x  y  1  0  0  0  -xx' -yx' -x'] = [0]
    # [ 0  0  0  x  y  1  -xy' -yy' -y'] = [0]
    # .
    # .

    # here x1 corresponds to actual image points,
    # x2 corresponds to virtual points assumed for the problem
    for index in range(len(img1Points)):
        x1 = img1Points[index][0]
        y1 = img1Points[index][1]
        x2 = img2Points[index][0]
        y2 = img2Points[index][1]
        A = np.append(A, [[x1, y1, 1,  0,  0, 0, -x1 * x2, -y1 * x2, -x2]], axis=0); 
        A = np.append(A, [[ 0,  0, 0, x1, y1, 1, -x1 * y2, -y1 * y2, -y2]], axis=0);

    U, D, Vt = np.linalg.svd(A)
    H = np.linalg.inv(Vt)[:, -1]
    H = np.reshape(H, (3,3))

    # print the homography matrix
    print(H)
    print(matinverse(H))
    return H

def getHomographedSourceImage(img, H, sourceSize):
    # get the dimension of the image
    height, width, channels = sourceSize
    sourceImage = np.zeros((height, width, channels), np.uint8)
    Hinv = np.linalg.inv(H)

    for i in range(height):
        for j in range(width):
            iSourceCoord = np.dot(Hinv, np.array([[j], [i], [1]]));
            iSourceX = (iSourceCoord[0] / iSourceCoord[2])[0];
            iSourceY = (iSourceCoord[1] / iSourceCoord[2])[0];

            # if the resultant coordinates are float, then get bilinear interpolate the pixels
            # bilinearInterpolate considers 2nd input as along height and 3rd input as along width
            sourceImage[i, j] = bilinearInterpolate(img, iSourceY, iSourceX)

    return sourceImage

def get_normalization_matrix(img_shape, is_normalize):
    if not is_normalize:
        return np.array([[1, 0, 0],
                     [0, 1, 0],
                     [0, 0, 1]])
    else:
        norm_const = np.max(img_shape)
        return np.array([[2/(norm_const-1), 0, -1],
                     [0, 2/(norm_const-1), -1],
                     [0, 0, 1/np.sqrt(3)]])

def get_points_from_gui(num_points, fig, img, is_close_at_end):
    global coords
    coords = []
    if img is not None:
        fig = plt.figure()
        plt.imshow(img)

    # click event handler for the plt figure
    def onclick(event):
        global ix, iy
        ix, iy = event.xdata, event.ydata
        print('x = %d, y = %d'%(ix, iy))
        plt.plot([ix], [iy], marker='o', markersize=3, color="red")

        global coords
        coords.append((ix, iy))
        fig.canvas.draw()
        
        if len(coords) == num_points:
            fig.canvas.mpl_disconnect(cid)
            time.sleep(1)
            
            plt.close(1)

        return coords

    cid = fig.canvas.mpl_connect('button_press_event', onclick)
    plt.show()
    return coords, fig

def bilinearInterpolate(img, x, y):
    # get the dimension of the image
    height, width = img.shape[:2]
    if(x < 0 or x > height - 1):
        return np.zeros(3);
    if(y < 0 or y > width - 1):
        return np.zeros(3);

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
                (modX * modY * bottomRight);

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

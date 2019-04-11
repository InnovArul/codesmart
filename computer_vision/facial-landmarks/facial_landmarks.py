# USAGE
# python facial_landmarks.py --shape-predictor shape_predictor_68_face_landmarks.dat --image images/example_01.jpg 

# import the necessary packages
from imutils import face_utils
import numpy as np
import argparse
import imutils
import dlib
import cv2, os

import cv2
from skimage import transform
import exifread
import numpy as np
import matplotlib.pyplot as plt

def show_image(img):
    fig = plt.figure()
    plt.imshow(img)
    plt.show()
    

def exif_rotation(rgb, path):
    f = open(path, 'rb')
    tags = exifread.process_file(f)
    transformed_img = rgb    
    
    if 'Image Orientation' in tags:
        orientation = tags['Image Orientation'].values[0]
        if orientation == 1:
            # Nothing
            transformed_img = rgb
        elif orientation == 2:
            # Vertical Mirror
            #mirror = im.transpose(Image.FLIP_LEFT_RIGHT)
            transformed_img = np.fliplr(rgb)
        elif orientation == 3:
            # Rotation 180
            transformed_img = (transform.rotate(rgb, 180) * 255).astype('uint8')
        elif orientation == 4:
            # Horizontal Mirror
            transformed_img = np.flipud(rgb)
        elif orientation == 5:
            # Horizontal Mirror + Rotation 90 CCW
            transformed_img = (transform.rotate(np.flipud(rgb), 90) * 255).astype('uint8')
        elif orientation == 6:
            # Rotation 270
            transformed_img = (transform.rotate(rgb, 270) * 255).astype('uint8')
        elif orientation == 7:
            # Horizontal Mirror + Rotation 270
            transformed_img = (transform.rotate(np.flipud(rgb), 270) * 255).astype('uint8')
        elif orientation == 8:
            # Rotation 90
            transformed_img = (transform.rotate(rgb, 90) * 255).astype('uint8')
        
    return transformed_img

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-p", "--shape-predictor", required=True,
	help="path to facial landmark predictor")
ap.add_argument("-i", "--image", required=False,
	help="path to input image")
args = vars(ap.parse_args())

# initialize dlib's face detector (HOG-based) and then create
# the facial landmark predictor
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(args["shape_predictor"])

def detect(img_path):
    # load the input image, resize it, and convert it to grayscale
    image = cv2.imread(img_path)
    image = imutils.resize(image, width=500)
    image = exif_rotation(image, img_path)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    #show_image(gray)

    # detect faces in the grayscale image
    rects = detector(gray.astype('uint8'), 1)
    print(len(rects))

    # loop over the face detections
    for (i, rect) in enumerate(rects):
        # determine the facial landmarks for the face region, then
        # convert the facial landmark (x, y)-coordinates to a NumPy
        # array
        shape = predictor(gray, rect)
        shape = face_utils.shape_to_np(shape)

        # convert dlib's rectangle to a OpenCV-style bounding box
        # [i.e., (x, y, w, h)], then draw the face bounding box
        (x, y, w, h) = face_utils.rect_to_bb(rect)
        cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)

        # show the face number
        cv2.putText(image, "Face #{}".format(i + 1), (x - 10, y - 10),
            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

        # loop over the (x, y)-coordinates for the facial landmarks
        # and draw them on the image
        for (x, y) in shape:
            cv2.circle(image, (x, y), 1, (0, 0, 255), -1)

    # show the output image with the face detections + facial landmarks
    cv2.imshow("Output", image)
    cv2.waitKey(0)

root_dir = '/media/Buffer/IITM/LYNKhacks/openface/datasets'

for person_folder in os.listdir(root_dir):
    current_folder = os.path.join(root_dir, person_folder)
    
    for img in [os.path.join(current_folder, img_name)
                for img_name in os.listdir(current_folder)]:
        detect(img)

   """
    cascade_frontface_alt = cv2.CascadeClassifier('haarcascade_frontalface_alt.xml')
    cascade_frontface_alt2 = cv2.CascadeClassifier('haarcascade_frontalface_alt2.xml')
    cascade_frontface_alttree = cv2.CascadeClassifier('haarcascade_frontalface_alt_tree.xml')
    cascade_frontface_default = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
    cascade_profileface = cv2.CascadeClassifier('haarcascade_profileface.xml')
    detectors = [cascade_profileface, cascade_frontface_default, cascade_frontface_alttree,
                 cascade_frontface_alt2, cascade_frontface_alt]

    gray = cv2.cvtColor(rgbImg.astype('uint8'), cv2.COLOR_RGB2GRAY)
    print('gray')
    print((np.min(gray), np.max(gray)))
    show_image(gray)
    
    for detector in detectors:
        faces = detector.detectMultiScale(gray, 1.1, 2)
        print(faces)
    """
 

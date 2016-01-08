/*******************************************************************************
 * Copyright (c) 2016 Arulkumar (arul.csecit@ymail.com).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Arulkumar (arul.csecit@ymail.com)
 *******************************************************************************/

#include <stdio.h>
#include<opencv/cv.h>
#include<opencv/highgui.h>
#include<iostream>
using namespace std;

int main()
{
	IplImage* image = cvLoadImage("./pics/thresholding_example.png");

	// create buffer to hold three channels
	IplImage* redChannel = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
	IplImage* greenChannel = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
	IplImage* blueChannel = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);

	// split the channels
	cvSplit(image, blueChannel, greenChannel, redChannel, NULL);

	// our goal is to threshold red channel
	//so, we need to subtract green , blue from red
	//add green + blue, and save it in blue
	cvAdd(greenChannel, blueChannel, blueChannel);
	cvSub(blueChannel, redChannel, redChannel);

	cvThreshold(redChannel, redChannel, 10, 255, CV_THRESH_BINARY_INV);

	//show the images
    cvNamedWindow("original");
    cvNamedWindow("red");
    cvShowImage("original", image);
    cvShowImage("red", redChannel);
    cvWaitKey(0);

    cvSaveImage("./pics/thresholdedRed.jpg", redChannel);

    cvReleaseImage(&image); cvReleaseImage(&redChannel); cvReleaseImage(&greenChannel); cvReleaseImage(&blueChannel);
    cvDestroyAllWindows();
    return 0;
}

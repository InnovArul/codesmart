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

#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <math.h>

/**
 * API to normalize RGB images
 * @param image
 * @return normalized image
 */
IplImage* normalizeImage(IplImage* image)
{
	//to hold original channels
	IplImage* redChannel = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
	IplImage* greenChannel = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
	IplImage* blueChannel = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);

	//to hold averaged channels
	IplImage* redAvg = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
	IplImage* greenAvg = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
	IplImage* blueAvg = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);

	IplImage* normalizedImg = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 3);

	//split the original image
	cvSplit(image, redChannel, greenChannel, blueChannel, NULL);

	for (int x = 0; x < image->width; ++x) {
		for (int y = 0; y < image->height; ++y) {
			int redval = cvGetReal2D(redChannel, y, x);
			int greenval = cvGetReal2D(greenChannel, y, x);
			int blueval = cvGetReal2D(blueChannel, y, x);

			double sum = redval + greenval + blueval;

			// store the normalized values
			cvSetReal2D(redAvg, y, x, (redval / sum) * 255);
			cvSetReal2D(greenAvg, y, x, (greenval / sum) * 255);
			cvSetReal2D(blueAvg, y, x, (blueval / sum) * 255);
		}
	}

	// combine the normalized channels
	cvMerge(redAvg, greenAvg, blueAvg, NULL, normalizedImg);

	// release the memory
	cvReleaseImage(&redChannel);
	cvReleaseImage(&greenChannel);
	cvReleaseImage(&blueChannel);
	cvReleaseImage(&redAvg);
	cvReleaseImage(&greenAvg);
	cvReleaseImage(&blueAvg);

	return normalizedImg;
}

/**
 * main function
 */
int main()
{
	IplImage* image = cvLoadImage("pics/normalize_rgb_tester.png", true);
	IplImage* normalizedImg = normalizeImage(image);

	//save the normalized image
	cvSaveImage("pics/normalize_rgb_result.png", normalizedImg, NULL);

	//release image memory
	cvReleaseImage(&image);
	cvReleaseImage(&normalizedImg);

	return 0;
}

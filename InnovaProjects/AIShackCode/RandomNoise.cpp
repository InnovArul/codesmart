#include <stdio.h>
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <math.h>
#include <float.h>

using namespace std;

//to create uniform distributed random number
double uniform() {
	return (rand() / (float) 0x7fff) - 0.5;
}

IplImage* generateNoise(IplImage* img, float amount = 255) {
	CvSize imgSize = cvGetSize(img);

	//copy the image
	IplImage* imgtemp = cvCloneImage(img);

	//go through for each pixel
	for (int y = 0; y < imgSize.height; ++y) {
		for (int x = 0; x < imgSize.width; ++x) {
			int randomValue = (char) (uniform() * amount);

			int pixelVal = cvGetReal2D(img, y, x) + randomValue;

			//set the noisy value to current pixel
			cvSetReal2D(imgtemp, y, x, pixelVal);
		}
	}

	//return the perturbed image
	return imgtemp;
}

int main() {
	IplImage* img = cvLoadImage("pics/noise_tester.jpg", false);
	IplImage* imgtemp;

	//initialize the windows system
	int trackpos = 20;
	cvNamedWindow("Image");

	cvCreateTrackbar("amount", "Image", &trackpos, 255, NULL);

	while(true)
	{
		imgtemp = generateNoise(img, trackpos);

		//display the image
		cvShowImage("Image", imgtemp);
		cvReleaseImage(&imgtemp);

		//check for key press
		int key = cvWaitKey(10);
		if(key != -1) break;
	}

	//release the original image
	cvReleaseImage(&img);
	return 0;

	return 0;
}

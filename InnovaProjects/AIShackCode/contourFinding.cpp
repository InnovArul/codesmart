#include<iostream>
#include<opencv/cv.h>
#include<opencv/highgui.h>
#include<math.h>

using namespace std;

/**
 * detect the contours and find the quadratic boundaries
 * @param image
 * @return contour drawn image
 */
IplImage* DetectAndDrawQuads(IplImage* image)
{
	//a kind of linked list
	CvSeq* contours;
	CvSeq* result;

	// buffer to store the result
	CvMemStorage *storage  = cvCreateMemStorage(0);

	//buffer to store the contour image
	IplImage* ret = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 3);
	IplImage* temp = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U,1);

	//convert the given image to gray scale
	cvCvtColor(image, temp, CV_BGR2GRAY);

	cvFindContours(temp, storage, &contours, sizeof(CvContour), CV_RETR_LIST, CV_CHAIN_APPROX_NONE, cvPoint(0, 0));

	// loop through all the contours and collect the points
	while(contours)
	{
		result = cvApproxPoly(contours, sizeof(CvContour), storage, CV_POLY_APPROX_DP, cvContourPerimeter(contours) * 0.002, 0);

		if(result->total == 4 && fabs(cvContourArea(result, CV_WHOLE_SEQ)) >= 1)
		{

			CvPoint* pt[4];

			// collect all points
			for (int point = 0; point < 4; ++point) {
				pt[point]  =(CvPoint*) cvGetSeqElem(result, point);
			}

			cvLine(ret, *pt[0], *pt[1], cvScalar(255));
			cvLine(ret, *pt[1], *pt[2], cvScalar(255));
			cvLine(ret, *pt[2], *pt[3], cvScalar(255));
			cvLine(ret, *pt[3], *pt[0], cvScalar(255));
		}

		contours = contours->h_next;
	}

	cvReleaseImage(&temp);
	cvReleaseMemStorage(&storage);

	return ret;

}

int main()
{
	//load the image
	IplImage* thresholded = cvLoadImage("./pics/thresholdedRed.jpg");
	IplImage* contourDrawn = NULL;

	// show the original image
	cvNamedWindow("original");
	cvShowImage("original", thresholded);

	//draw the contours
	contourDrawn = DetectAndDrawQuads(thresholded);
	cvNamedWindow("contour");
	cvShowImage("contour", contourDrawn);

	//wait for the key
	cvWaitKey(0);

	//release the memory
	cvReleaseImage(&thresholded);
	cvReleaseImage(&contourDrawn);

	return 0;
}

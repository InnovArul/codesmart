//
// Created by arul on 4/2/19.
//

#ifndef CS6870_DVP_IMAGE_H
#define CS6870_DVP_IMAGE_H

#include <iostream>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace std;
using namespace cv;

class Image {
private:
    Mat img;
    String img_path;
public:
    Image(String img_path);
    virtual ~Image();
    bool read();

    Mat get_image();
};


#endif //CS6870_DVP_IMAGE_H

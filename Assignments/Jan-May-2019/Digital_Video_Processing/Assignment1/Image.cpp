//
// Created by arul on 4/2/19.
//

#include "Image.h"

Image::Image(String img_path) {
    this->img_path = img_path;
}

Image::~Image() {
    this->img.deallocate();
}

bool Image::read() {
    // read image
    this->img = imread(this->img_path, CV_LOAD_IMAGE_GRAYSCALE);
    if(! this->img.cols )                              // Check for invalid input
    {
        cout <<  "Could not open or find the image. Press any key to exit." << std::endl ;
        return false;
    }

    return true;
}

/**
 * returns the image from the class
 * @return Mat image
 */
Mat Image::get_image() {
    return this->img;
}

//
// Created by arul on 5/2/19.
//

#ifndef CS6870_DVP_PIXELWISEGMM_H
#define CS6870_DVP_PIXELWISEGMM_H

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <boost/filesystem.hpp>
#include <cmath>
#include <tuple>
using namespace cv;
using namespace std;

class PixelwiseGMM {
private:
    Mat* mean = NULL;
    Mat* std = NULL;
    Mat* w = NULL;
    int k;
public:
    PixelwiseGMM(int k, int rows, int cols);
    uchar update(uchar &pixel, const int *position);

    vector<float> get_gmm_probs(float pixel, int row, int col);
    float gauss_probability(float mu, float sigma, float &pixel);
    vector<float> get_corresponding_data_for_pixel(Mat* matrix, int row, int col);
    auto get_sorted_indices(vector<float> values);
};


#endif //CS6870_DVP_PIXELWISEGMM_H

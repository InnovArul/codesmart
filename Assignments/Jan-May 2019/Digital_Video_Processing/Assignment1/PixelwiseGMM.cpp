//
// Created by arul on 5/2/19.
//

#include "PixelwiseGMM.h"

PixelwiseGMM::PixelwiseGMM(int rows, int cols, int k) {
    // declare mean, std for each pixel
    int* param_size = new int[3]{rows, cols, k};
    mean = new Mat(3, param_size, CV_32F, Scalar::all(0));
    std = new Mat(3, param_size, CV_32F, Scalar::all(15));

    int* w_size = new int[3]{rows, cols, k};
    w = new Mat(3, w_size, CV_32F, Scalar::all(1));
    this->k = k;
}

auto PixelwiseGMM::get_sorted_indices(vector<float> values)
{
    std::vector<int> y(values.size());
    std::iota(y.begin(), y.end(), 0);
    auto comparator = [&values](int a, int b){ return values[a] > values[b]; };
    std::sort(y.begin(), y.end(), comparator);
    return make_tuple(y, y);
}

uchar PixelwiseGMM::update(uchar &pixel, const int *position) {
    int row = position[0], col = position[1];

    // get the probability of k gaussians
    vector<float> probabilities = get_gmm_probs((float) pixel, row, col);

    // sort the probabilities to find top-k distributions
    vector<int> sorted_values, sorted_indices;
    tie(sorted_values, sorted_indices) = get_sorted_indices(probabilities);

    // get the cumulative distributions of probabilities
    vector<float> cumsum(probabilities.size());
    std::partial_sum(probabilities.begin(), probabilities.end(), cumsum.begin(), plus<double>());

    // update mean

    // update std


    return uchar(0);
}

vector<float> PixelwiseGMM::get_gmm_probs(float pixel, int row, int col) {
    int k = mean->size[-1];
    vector<float> ws, means, stds, probs;
    for (int i = 0; i < k; ++i) {
        float w = this->w->at<float>(row, col, i);
        float mu = mean->at<float>(row, col, i);
        float sigma = std->at<float>(row, col, i);

        ws.push_back(w); means.push_back(mu); stds.push_back(sigma);
        probs.push_back(gauss_probability(mu, sigma, pixel));
    }

    return probs;
}

float PixelwiseGMM::gauss_probability(float mu, float sigma, float &pixel) {
    float normConstant = 1/ (sqrt(2*M_PI) * sigma);
    float probability = normConstant * exp(-pow(pixel - mu, 2)/ (2*pow(sigma, 2)));
    return probability;
}

vector<float> PixelwiseGMM::get_corresponding_data_for_pixel(Mat* matrix, int row, int col) {
    vector<float> elements;
    for (int i = 0; i < k; ++i) {
        elements.push_back(matrix->at<float>(row, col, i));
    }

    return elements;
}

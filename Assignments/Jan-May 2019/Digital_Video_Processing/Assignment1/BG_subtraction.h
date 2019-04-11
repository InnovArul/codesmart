//
// Created by arul on 5/2/19.
//

#ifndef CS6870_DVP_BG_SUBTRACTION_H
#define CS6870_DVP_BG_SUBTRACTION_H

#include "Video.h"
#include "PixelwiseGMM.h"
#include <chrono>
#include <thread>
using namespace std;

class BG_subtraction {
private:
    Video* video = NULL;
    PixelwiseGMM* gmm = NULL;

    // parameters
    static constexpr float alpha = 0.9;
    static const int k = 4;

public:
    BG_subtraction(String video_path);
    void do_bg_subtraction();
    virtual ~BG_subtraction();

    Video* get_video_instance();

    uchar update_gmm(uchar &point3_, const int *pInt);

    void display_frames(const Mat &frame, const Mat &bg_subtracted_frame) const;
};

#endif //CS6870_DVP_BG_SUBTRACTION_H

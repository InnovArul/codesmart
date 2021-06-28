//
// Created by arul on 5/2/19.
//

#include "BG_subtraction.h"

BG_subtraction::BG_subtraction(String video_path) {
    video = new Video(video_path);
    Mat frame0 = video->get_frame_at_index(1);
    gmm = new PixelwiseGMM(frame0.rows, frame0.cols, k);
}

void BG_subtraction::do_bg_subtraction()
{
    typedef uchar Pixel;
    namedWindow( "video", WINDOW_AUTOSIZE );// Create a window for display.
    while(video->is_next_frame_exists()) {
        Mat frame = video->get_next_frame();
        Mat bg_subtracted_frame = Mat(frame.size(), CV_8UC1, Scalar::all(0));

        frame.forEach<Pixel>(
                [&bg_subtracted_frame, this](Pixel &pixel, const int* position) -> void
                {
                   uchar mask = update_gmm(pixel, position);
                   bg_subtracted_frame.at<uchar>(position[0], position[1]) = mask;
                });

        display_frames(frame, bg_subtracted_frame);
        waitKey(50);
        //this_thread::sleep_for(chrono::milliseconds(500));
    }
}

void BG_subtraction::display_frames(const Mat &frame, const Mat &bg_subtracted_frame) const {
    Mat combine(max(frame.size().height, bg_subtracted_frame.size().height), frame.size().width + bg_subtracted_frame.size().width, CV_8UC1);
    Mat left_roi(combine, Rect(0, 0, frame.size().width, frame.size().height));
    frame.copyTo(left_roi);
    Mat right_roi(combine, Rect(frame.size().width, 0, bg_subtracted_frame.size().width, bg_subtracted_frame.size().height));
    bg_subtracted_frame.copyTo(right_roi);

    imshow("video", combine);
}

BG_subtraction::~BG_subtraction() {
    delete(video);
    delete(gmm);
}

Video* BG_subtraction::get_video_instance() {
    return video;
}

uchar BG_subtraction::update_gmm(uchar &pixel, const int *position) {
    return gmm->update(pixel, position);
}

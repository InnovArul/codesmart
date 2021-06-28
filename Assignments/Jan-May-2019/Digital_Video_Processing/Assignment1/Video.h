//
// Created by arul on 5/2/19.
//

#ifndef CS6870_DVP_PROCESS_VIDEO_H
#define CS6870_DVP_PROCESS_VIDEO_H

#include <iostream>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <boost/filesystem.hpp>
#include "Image.h"

namespace fs = boost::filesystem;

using namespace std;
using namespace cv;

class Video {
private:
    fs::path video_path;
    int frame_counter;
    int total_frames;
public:
    Video(String video_path);
    virtual ~Video();

    Mat get_next_frame();
    Mat get_frame_at_index(int index);
    int get_num_frames();

    bool is_next_frame_exists();


};


#endif //CS6870_DVP_PROCESS_VIDEO_H

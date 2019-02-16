#include <iostream>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include "BG_subtraction.h"

using namespace std;
using namespace cv;

int main() {
    String video_path = "../data/canoe";
    BG_subtraction bgsub(video_path);
    Video* video = bgsub.get_video_instance();
    cout << video->get_num_frames() << " frames in the directory" << endl;
    Mat image = video->get_frame_at_index(1);
    cout << "image dims " << image.rows << ',' << image.cols << endl;
    bgsub.do_bg_subtraction();
    return 0;

}
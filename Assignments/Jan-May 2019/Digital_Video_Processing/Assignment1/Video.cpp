//
// Created by arul on 5/2/19.
//

#include "Video.h"

Video::Video(String video_folder){
    fs::path root_dir(video_folder);
    fs::path input_dir("input");
    fs::path full_path = root_dir / input_dir;
    video_path = full_path;
    cout << "creating video instance for " << video_path << endl;

    // init frame counter
    frame_counter = 0;

    // get total frames
    total_frames = get_num_frames();
}

Video::~Video(){

}

int Video::get_num_frames()
{
    int count = 0;

    try {
        count = std::count_if(fs::directory_iterator(this->video_path),
                              fs::directory_iterator(),
                              static_cast<bool (*)(const fs::path &)>(fs::is_regular_file));
    }
    catch (std::exception const&  ex){
        cout << ex.what() << endl;
    }

    return count;
}

Mat Video::get_frame_at_index(int index)
{
    fs::path current_file_name(format("in%06d.jpg", index));
    fs::path current_frame_path = video_path / current_file_name;
    //cout << "reading file " << current_frame_path << endl;
    Image current_image(current_frame_path.string());
    Mat image_buffer;

    if(current_image.read())
    {
        image_buffer = current_image.get_image();
    }

    return image_buffer;
}

Mat Video::get_next_frame()
{
    return get_frame_at_index(++frame_counter);
}

bool Video::is_next_frame_exists() {
    return (frame_counter+1) <= total_frames;
}

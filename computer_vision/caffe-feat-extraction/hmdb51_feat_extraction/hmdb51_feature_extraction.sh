#wget https://www.dropbox.com/s/qqfrg6h44d4jb46/c3d_resnet18_sports1m_r2_iter_2800000.caffemodel

GLOG_logtostderr=1 ../../build/tools/extract_image_features.bin c3d_resnet18_hmdb51_feature_extraction.prototxt ./models/c3d_hmdb51_iter_20000.caffemodel 0 30 2226 featextract_prefix.lst prob pool5 res5b

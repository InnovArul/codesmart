cmake_minimum_required(VERSION 3.1)
project(CS6870_DVP)

set(CMAKE_CXX_STANDARD 14)
set(BOOST_INCLUDEDIR "/home/arul/miniconda3/envs/pytorch/include")
set(BOOST_LIBRARYDIR "/home/arul/miniconda3/envs/pytorch/lib")

find_package( OpenCV REQUIRED )
message(STATUS "opencv config: ${OpenCV_VERSION}")
message(STATUS "opencv libs: ${OpenCV_LIBS}")
message(STATUS "opencv dirs: ${OpenCV_INCLUDE_DIRS}")

find_package( Boost COMPONENTS system filesystem REQUIRED )
message(STATUS "boost config: ${Boost_VERSION}")
message(STATUS "boost libs: ${Boost_LIBRARIES}")
message(STATUS "boost dirs: ${Boost_INCLUDE_DIRS}")

set(SOURCE_FILES main.cpp Image.cpp Image.h Video.cpp Video.h BG_subtraction.cpp BG_subtraction.h PixelwiseGMM.cpp PixelwiseGMM.h)
add_executable(CS6870_DVP ${SOURCE_FILES})

include_directories(${OpenCV_INCLUDE_DIRS})
include_directories(${Boost_INCLUDE_DIRS})
target_link_libraries( CS6870_DVP ${OpenCV_LIBS} )
target_link_libraries( CS6870_DVP ${Boost_LIBRARIES} )

# go through each folder of the data and create train list and test list
import os
import numpy as np
import imageio
import math
from pathlib import Path
import pickle

# get all the file names from given path
def getFiles(path):
    list_of_files = dict()

    for (dirpath, dirnames, filenames) in os.walk(path):
        for filename in filenames:
            if filename.endswith('.avi'): 
                list_of_files[filename] = os.sep.join([dirpath, filename])
                
    return list_of_files

# get all the folder names
def getAllFolderNames(path):
    allFolders = []
    for name in os.listdir(path):
        if os.path.isdir(os.sep.join([path, name])):
            allFolders.append(name)
        
    return allFolders

#get the number of frames in the image
def getNumberOfFrames(vidpath):
    import imageio
    import cv2
    
    #cap = cv2.VideoCapture(vidpath)
    #length = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))

    vid = imageio.get_reader(vidpath)
    num_frames=vid._meta['nframes']
    
    #assert length == num_frames, 'number of frames is different from cv2 (' + str(length) + ') and imageio (' + str(num_frames) + ')'
    return num_frames

def writeListToFile(listFile, prefixFile, class_name, fullFilePath):
    # for each video, get the frame counts
    totalFrameCount = getNumberOfFrames(fullFilePath)
    totalVidSplitCount = math.floor(totalFrameCount / C3D_framesAtAtime)
    #print(totalVidSplitCount)
    #print(totalFrameCount)
    currentSplitCount = 0
    filename = Path(fullFilePath).name
    
    #print(totalFrameCount)
    for i in range(int(totalVidSplitCount)):
        startFrame = (i * C3D_framesAtAtime)
        
        if((startFrame + (C3D_framesAtAtime * 2) - 1) <= totalFrameCount):
            currentSplitCount = currentSplitCount + 1
            listFile.write(fullFilePath + '   ' + str(startFrame) +  '   ' + str(0) + "\n")
            prefixFile.write(os.path.abspath(os.sep.join([featOutputPath, class_name + '-' + filename + '-' + str(i)])) + "\n")
            continue
			
    return currentSplitCount;
    
###----------------------------------------------------------------------
    
rootPath = '/media/data/Datasets/Olympic/videos'
outputPath = './C3D-v1.1/examples/olympics_features'
featOutputPath = './C3D-v1.1/examples/olympics_features/features'
testSplitNumber = 1
C3D_framesAtAtime = 16

classes = getAllFolderNames(rootPath)

listFile = open(os.sep.join([outputPath, "featextract_files.lst"]), "w")
prefixFile = open(os.sep.join([outputPath, "featextract_prefix.lst"]), "w") 

classNumber = 1
print(classes)
totalFileCount = 0
totalSplitCount = 0
files_config = {}

for foldername in classes:
    all_folder_files = os.listdir(os.path.join(rootPath, foldername));
    all_video_files = [ os.path.join(rootPath, foldername, fi) for fi in all_folder_files if fi.endswith(".avi") ]
    files_config[foldername] = []
    
    for video_file in all_video_files:
        count = writeListToFile(listFile, prefixFile, foldername, video_file)
        totalSplitCount = totalSplitCount + count
        files_config[foldername].append(video_file)
					
        # increment total number of files
        totalFileCount = totalFileCount + 1
      
    print(foldername + '(' + str(classNumber) + ') : total files count : ' + str(len(files_config[foldername])))
    classNumber = classNumber + 1;        

pickle.dump({'classes': classes, 'config': files_config}, open("config.pkl", "wb"))
                           
print('total files avalable in dataset : ' + str(totalFileCount))
print('total split of videos : ' + str(totalSplitCount))

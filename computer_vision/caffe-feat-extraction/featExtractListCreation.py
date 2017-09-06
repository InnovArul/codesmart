# go through each folder of the data and create train list and test list
import os
import numpy as np
import imageio
import math

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
    
    cap = cv2.VideoCapture(vidpath)
    length = int(cap.get(cv2.cv.CV_CAP_PROP_FRAME_COUNT))

    vid = imageio.get_reader(vidpath)
    num_frames=vid._meta['nframes']
    
    assert length == num_frames, 'number of frames is different from cv2 (' + str(length) + ') and imageio (' + str(num_frames) + ')'
    return num_frames

def writeListToFile(listFile, prefixFile, fullFilePath, filename):
    # for each video, get the frame counts
    totalFrameCount = getNumberOfFrames(fullFilePath)
    totalVidSplitCount = math.floor(totalFrameCount / C3D_framesAtAtime)
    #print(totalVidSplitCount)
    #print(totalFrameCount)
    currentSplitCount = 0
    
    #print(totalFrameCount)
    for i in range(int(totalVidSplitCount)):
        startFrame = (i * C3D_framesAtAtime)
        
        if((startFrame + (C3D_framesAtAtime * 2) - 1) <= totalFrameCount):
            currentSplitCount = currentSplitCount + 1
            listFile.write(fullFilePath + '   ' + str(startFrame) +  '   ' + str(0) + "\n")
            prefixFile.write(os.path.abspath(os.sep.join([featOutputPath, filename + '-' + str(i)])) + "\n")
            continue
			
    return currentSplitCount;
    
###----------------------------------------------------------------------
    
rootPath = './hmdb51'
splitConfigPath = './testTrainSplits'
outputPath = './C3D-v1.0/examples/hmdb51_finetuning'
testSplitNumber = 1
C3D_framesAtAtime = 16
featOutputPath = './C3D-v1.0/examples/hmdb51_finetuning/features'

allFolders = getAllFolderNames(rootPath)

listFile = open(os.sep.join([outputPath, "featextract_files.lst"]), "w")
prefixFile = open(os.sep.join([outputPath, "featextract_prefix.lst"]), "w") 

#list_of_files = getFiles('.')
#for filename in list_of_files.keys():
#    file.write(filename + "\n")
classNumber = 1
print(allFolders)
totalFileCount = 0
totalSplitCount = 0

for foldername in allFolders:
    # open the test split-1 file and read the content line by line
    splitFileName = os.sep.join([splitConfigPath, foldername + '_test_split' + str(testSplitNumber) + '.txt'])
    
    # check if the file is existing
    if(os.access(splitFileName, os.R_OK)):
        totalClassFileCount = 0
        
        with open(splitFileName, 'r') as splitFileStream:
            for line in splitFileStream:
                filename, trainOrTest =  line.split()
                fullFilePath = os.path.abspath(os.sep.join([rootPath, foldername, filename]))
                totalClassFileCount = totalClassFileCount + 1

                if(os.path.isfile(fullFilePath)):
					count = writeListToFile(listFile, prefixFile, fullFilePath, filename)
					totalSplitCount = totalSplitCount + count
					# increment total number of files
					totalFileCount = totalFileCount + 1
                else: 
                    print(fullFilePath + ' does not exists!')
        
        print(foldername + '(' + str(classNumber) + ') : total files count : ' + str(totalClassFileCount))
        classNumber = classNumber + 1;        
    else:
        print(splitFileName + ' not found. exiting the program!')
        break
    
print('total files avalable in dataset : ' + str(totalFileCount))
print('total split of videos : ' + str(totalSplitCount))

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

def writeListToFile(listFile, fullFilePath, classNumber):
    # for each video, get the frame counts
    totalFrameCount = getNumberOfFrames(fullFilePath)
    totalVidSplitCount = math.floor(totalFrameCount)
    
    for i in range(int(totalVidSplitCount)):
        startFrame = (i * C3D_framesAtAtime)
        if((startFrame + (C3D_framesAtAtime * 2) + (C3D_framesAtAtime/2)) <= totalFrameCount):
            listFile.write(fullFilePath + '   ' + str(startFrame) +  '   ' + str(classNumber-1) + "\n")
    
###----------------------------------------------------------------------
    
rootPath = './hmdb51'
splitConfigPath = './testTrainSplits'
outputPath = './C3D-v1.0/examples/hmdb51_finetuning'
testSplitNumber = 1
C3D_framesAtAtime = 16

allFolders = getAllFolderNames(rootPath)

trainList = open(os.sep.join([outputPath, "train_files.lst"]), "w")
testList = open(os.sep.join([outputPath, "test_files.lst"]), "w") 

#list_of_files = getFiles('.')
#for filename in list_of_files.keys():
#    file.write(filename + "\n")
classNumber = 1
print(allFolders)
totalFileCount = 0

for foldername in allFolders:
    # open the test split-1 file and read the content line by line
    splitFileName = os.sep.join([splitConfigPath, foldername + '_test_split' + str(testSplitNumber) + '.txt'])
    
    # check if the file is existing
    if(os.access(splitFileName, os.R_OK)):
        currentTrainFileCount = 0
        currentTestFileCount = 0
        totalClassFileCount = 0
        
        with open(splitFileName, 'r') as splitFileStream:
            for line in splitFileStream:
              
                filename, trainOrTest =  line.split()
                fullFilePath = os.path.abspath(os.sep.join([rootPath, foldername, filename]))
                totalClassFileCount = totalClassFileCount + 1
                                
                if(os.path.isfile(fullFilePath)):
                    trainOrTest = int(trainOrTest)

                    if(trainOrTest == 2):
                        # if the id is 2, then write it to test file list
                        writeListToFile(testList, fullFilePath, classNumber)                        
                        currentTestFileCount = currentTestFileCount + 1
                    else:
                        # if the id is 0 or 1, write it to train file list
                        writeListToFile(trainList, fullFilePath, classNumber)  
                        currentTrainFileCount = currentTrainFileCount + 1
                        
                    # incremnt total number of files
                    totalFileCount = totalFileCount + 1
                else:
                    print(fullFilePath + ' does not exists!')
        
        print(foldername + '(' + str(classNumber) + ') : total files count : ' + str(totalClassFileCount))
        print(foldername + ' train files : ' + str(currentTrainFileCount))
        print(foldername + ' test files : ' + str(currentTestFileCount))

        classNumber = classNumber + 1;        
    else:
        print(splitFileName + ' not found. exiting the program!')
        break
    
print('total files avalable in dataset : ' + str(totalFileCount))

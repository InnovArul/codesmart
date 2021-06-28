#########################################################
#      CS6690-Pattern recognition
#      Assignment - 1
#      Author: Arulkumar S
#########################################################

import cv2
import os
import scipy.linalg as linalg
from matplotlib import pyplot as plt
from matplotlib.pyplot import cm
import numpy as np
from numpy import dtype, uint8
from cmath import sqrt
import pylab as pl
import functools
import operator
from cv2 import COLOR_RGB2BGR

imgWriteFolder = "./output/"

# update pyplot legend size
params = {'legend.fontsize': 7,
          'legend.linewidth': 2}
plt.rcParams.update(params)

"""
An enum to indicate the type of data passed to any API 
"""
class Channel():
    RED   = 2
    GREEN = 1
    BLUE  = 0
    GRAY  = 3

"""
An enum to indicate the count of channels
"""
class ChannelCount():
    GRAY = 1
    RGB  = 3

"""
calls the API svd() with the data selected by user (with 'channel' parameter)
"""
def SVD(image, channel=Channel.GRAY):
    U, s, V = 1, 2, 3
    if(channel == Channel.GRAY):
        # if the channel is gray, then get the gray image from the rgb image
        currentChannelData = getGrayImage(image)
        
        # peform svd for single gray channel
        U, s, V = linalg.svd(currentChannelData, full_matrices=False)
    else:
        #perform svd for single channel that is selected by the called
        U, s, V = linalg.svd(image[:,:,channel], full_matrices=False)
    
    print(U.shape, s.shape, V.shape)
    
    return U, s, V



"""
calls the API svd() with the data selected by user (with 'channel' parameter)
"""
def EVD(image, channel=Channel.GRAY):
    singularVals, eigVectors = 1, 2
    if(channel == Channel.GRAY):
        # if the channel is gray, then get the gray image from the rgb image
        currentChannelData = getGrayImage(image)

    else:
        #perform svd for single channel that is selected by the called
        currentChannelData = image[:,:,channel]
    
    if(currentChannelData.shape[0] != currentChannelData.shape[1]):
        if(min(currentChannelData.shape) == currentChannelData.shape[0]):
            currentChannelData = currentChannelData.dot(currentChannelData.T)
        else:
            currentChannelData = currentChannelData.T.dot(currentChannelData)
            
    # peform svd for single gray channel
    singularVals, eigVectors = linalg.eig(currentChannelData)
    
    # prepare Eigen vector in the order of top most eigen values
    order = np.argsort(abs(singularVals))[::-1]
    
    singularVals = singularVals[order]
    eigVectors = eigVectors[:, order]
    eigVectorsInverse = linalg.pinv(eigVectors)
    
    return eigVectors, singularVals, eigVectorsInverse

"""
merge the three channels of the image (r, g, b) and create a color image content
"""
def mergeImgChannels(r, g, b):
    image = np.zeros(sum((r.shape, 3), ()))
    image[:, :, 0] = r;
    image[:, :, 1] = g;
    image[:, :, 2] = b;
    return image

"""
merge the three channels of the image (r, g, b) and create a color image content
"""
def splitImgChannels(image):
    imageTemp = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    r, g, b = cv2.split(imageTemp)
    return image


"""
write the image to the appropriate directory
"""
def writeImage(image, name):
    imageTemp = image
    cv2.imwrite(getOutputPath(name), imageTemp)

"""
read the image from appropriate directory
"""
def readImage(path):
    image = cv2.imread(path, cv2.IMREAD_UNCHANGED)
    return image

"""
get the reconstructed matrix with at most N singular values 
"""
def getManipulatedChannel(U, s, V):    
    return U.dot(np.diag(s).dot(V))

"""
replace the particular channel with the given channelWithTopMostN singular values
"""
def getAllChannelImage(imgOriginal, channelWithTopMostN, channel):
    if(channel == Channel.GRAY):
        return channelWithTopMostN
    else:
        imgTemp = np.copy(imgOriginal)
        imgTemp[:, :, channel] = channelWithTopMostN.astype(int)
        return imgTemp

"""
get the relative mean squared error between two arrays
"""
def getMeanAbsError(imgarray1, imgarray2):
    absErrorImg = abs(imgarray1.astype(int) - imgarray2.astype(int));
    totalAbsError = np.sum(absErrorImg)
    errorValue = abs(sqrt( totalAbsError/ functools.reduce(operator.mul, imgarray1.shape, 1)))
    return errorValue, absErrorImg.astype(uint8)

"""
get the gray image from color image
"""
def getGrayImage(rgbImage):
    copyImg = np.copy(rgbImage)
    return cv2.cvtColor( copyImg, cv2.COLOR_RGB2GRAY )

"""
get the output path of a file
"""
def getOutputPath(filename):
    return os.path.join(imgWriteFolder, filename)

"""
plot XY graph
"""
def plotXYgraph(filename, _xlabel, _ylabel, X, **args):
    #TODO: give options to specify markers
    pl.figure()
    order = X.argsort()
    X.sort()
    
    #color iterator
    color=iter(cm.rainbow(np.linspace(0,1,len(args))))
    
    for Label, value in args.iteritems():
        data = value.get('data');
        markr = value.get('marker', '');
        lineStyle = value.get('linestyle', '-');
        colour = value.get('color', next(color))
        pl.plot(X, data[order], c=colour, label=Label, marker=markr, ls=lineStyle)
    
    pl.title(filename)
    pl.xlabel(_xlabel) 
    pl.ylabel(_ylabel);
    pl.xlim([np.min(X), np.max(X)]);
    pl.legend(loc='upper right')
    pl.draw()
    pl.savefig(getOutputPath(filename))
    pl.close()
    

"""
plot Bar chart
"""
def plotBarChart(filename, _xlabel, _ylabel, X, Y):
    #color iterator
    color=iter(cm.rainbow(np.linspace(0,1,len(Y))))
    
    for index in range(len(X)):
        pl.bar(index, Y[index], color=next(color), align='center')
    
    pl.title(filename)
    pl.xlabel(_xlabel) 
    pl.ylabel(_ylabel);
    pl.xticks(range(len(X)), X, rotation=45, fontsize=6)
    pl.draw()
    pl.savefig(getOutputPath(filename))
    pl.close()

"""
write the information provided to logfile
"""
def writeToLog(string, forceRewrite=False):
    import inspect
    frame = inspect.stack()[1]
    module = inspect.getmodule(frame[0])
    filePath = module.__file__
    logPath = getOutputPath(getFileNameFromPath(filePath) + '.log')
    print string
    
    if forceRewrite:
        #append the text to the file
        with open(logPath, "w") as text_file:
                text_file.write(string)
        
        return
    
    if(os.path.exists(logPath)):
        #append the text to the file
        with open(logPath, "a") as text_file:
                text_file.write(string)
    else:
        #create the file and output the CONTENT_ALPHA
        with open(logPath, "w") as text_file:
                text_file.write(string)


def getFileNameFromPath(filePath):
    fileBaseName = os.path.basename(filePath)
    return os.path.splitext(fileBaseName)[0]
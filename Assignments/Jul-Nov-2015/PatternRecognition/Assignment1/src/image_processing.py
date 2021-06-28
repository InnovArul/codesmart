#########################################################
#      CS6690-Pattern recognition
#      Assignment - 1
#      Author: Arulkumar S
#########################################################

import pr_helper as utils
import numpy as np
from numpy import uint8
from random import sample
utils.writeToLog("", forceRewrite=True)

TOPN = 'top'
RANDOMN = 'random'
SVD = 'SVD'
EVD = 'EVD'
STANDARD_COUNT = 100

smallImgPath = '/media/Buffer/IITM/CS6690PatternRecognition/Assignment1/originalImage29.jpg'
bigImgPath = '/media/Buffer/IITM/CS6690PatternRecognition/Assignment1/svd+eigen.JPG'

# for the given images
for file in [smallImgPath]:
    if(file == bigImgPath): STANDARD_COUNT = 100
    else: STANDARD_COUNT = 2
    
    # read the image
    img = utils.readImage(file)
    filename = utils.getFileNameFromPath(file)
    
    # for each of the channels of the image, do the SVD analysis
    for channel in [utils.Channel.RED, utils.Channel.GREEN, utils.Channel.BLUE, utils.Channel.GRAY]:
        
        # type of selection of N
        for decompositiontype in [EVD]:
            
            # type of selection of N
            for Ntype in [RANDOMN]:
                
                utils.writeToLog("\n\n" + file + "\n" + decompositiontype + ", Channel = " + str(channel) + ", Ntype = " + Ntype)
                
                currentChannelData = 0
                originalImage = img
                
                #get the appropriate channel of the image
                if(channel == utils.Channel.GRAY):
                    originalImage = utils.getGrayImage(originalImage)
            
                # perform SVD for the particular channel data
                U, s, V = getattr(utils, decompositiontype)(img, channel)
                
                #get the number of singular values
                NoOfSingularValues = s.shape[0]
        
                #array to store the error values
                NtoErrorHistory = {}
                simpleFileName = decompositiontype + filename + str(channel) + str(Ntype)
                
                # for each N singular values in the SVD, perform loss analysis
                topMostN = STANDARD_COUNT
                while(topMostN <= NoOfSingularValues):
                    indexrange = 0
                    if Ntype == TOPN: indexrange = range(topMostN) 
                    else: indexrange = sample(range(NoOfSingularValues), topMostN)
                    
                    newSingularVals = np.zeros((NoOfSingularValues))
                    # get the current channel data with only topMostN singular (eigen) values
                    newSingularVals[indexrange] = s[indexrange]
                    channelWithN = utils.getManipulatedChannel(U, newSingularVals, V).astype(int)
                    
                    # combine the channels and get the original image (if needed) 
                    imgTemp = utils.getAllChannelImage(originalImage, channelWithN, channel)
                    
                    # get the mean squared error value and picture 
                    errorValue, imgError = utils.getMeanAbsError(originalImage, imgTemp)
                    
                    #store the error value for graph creation
                    errorValue = float('%0.2f' % errorValue)
                    NtoErrorHistory[topMostN] = errorValue
                                       
                    utils.writeToLog("after the inclusion of top most component - " + str(topMostN) + ', MSE = ' + str(errorValue) + "\n")
                    
                    filenamePart = simpleFileName + str(topMostN)
                    if((topMostN) % 10 == 0): 
                        # write the error image and imageTemp
                        utils.writeImage(imgTemp, filenamePart + ".jpg")
                        utils.writeImage(imgError, "error" + filenamePart + ".jpg")
                        
                        utils.writeToLog("at top " + str(topMostN) + " singular values inclusion, the picture has " + str(errorValue) + "% mean absolute error" )
                
                    topMostN = topMostN + STANDARD_COUNT
                
                # plot the error curve
                indices = sorted(NtoErrorHistory.keys())
                kwargs = {}
                kwargs['error-curve'] = {}
                kwargs['error-curve']['data'] = np.array([NtoErrorHistory[x] for x in indices])
                
                utils.plotXYgraph("graph" + simpleFileName + ".jpg", 'topN singular values', 'relative absolute mean error', np.array(indices), **kwargs)
                
            #--------------------------------------------------------------------------------

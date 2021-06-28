import scipy.io as sio;
import numpy as np;
import random
from math import floor
from numpy import dtype

rootFolder = '../data/task3/imagedata/';
labelsPath = rootFolder + 'Group_14_data.mat';
classes = {1:'cow', 2:'boat', 3:'sheep', 4:'bottle', 5:'bird'}

#===============================================================================
# write all the label and path of images to file
#===============================================================================
def writeCaffeDataFile(labelData, filename):
    data = np.zeros((labelData.__len__(), 2))
    
    with open(rootFolder + filename, 'w') as textfile:
        for (index, labelEntry) in enumerate(labelData):
            imgName = labelEntry[0]
            oneOfK = labelEntry[1:6]
            classL = np.argmax(oneOfK) + 1
            # write into a text file
            textfile.write(rootFolder + str(imgName) + '.jpg  ' + str(classL) + '\n')
            data[index][0] = int(imgName)
            data[index][1] = classL
            
    return data;

#===============================================================================
# get the class from 1 of K representation
#===============================================================================
def getClass(labelEntry):
    oneOfK = labelEntry[1:6]
    return (np.argmax(oneOfK) + 1)

#------------------------------------------------------------------------------ 
# get the indices for training and validation last datapoint
#------------------------------------------------------------------------------ 
def getSplitIndices(count):
    trainLastIndex = int(floor(0.75 * count))
    valLastIndex = trainLastIndex + int(floor((count - trainLastIndex) / 2))
    return trainLastIndex, valLastIndex

#------------------------------------------------------------------------------ 
# split the data as train, validation and test
#------------------------------------------------------------------------------ 
def getSplittedData(labelCollection):
    trainData = []
    validationData = []
    testData = []
    
    for i in range(1,6):
        currentData = labelCollection[i]
        trainlastIndex, valLastIndex = getSplitIndices(currentData.__len__())
        
        print(classes[i] + ': train = ' + str(trainlastIndex) + ', val = ' + str(valLastIndex - trainlastIndex) + ', test = ' + str(currentData.__len__() - valLastIndex) + '\n')
        trainData.extend(currentData[:trainlastIndex]);
        validationData.extend(currentData[trainlastIndex:valLastIndex]);
        testData.extend(currentData[valLastIndex:]);
    
    random.shuffle(trainData)
    random.shuffle(validationData)
    random.shuffle(testData)
    
    return trainData, validationData, testData

#------------------------------------------------------------------------------ 
#the main program
#------------------------------------------------------------------------------ 

labels = sio.loadmat(labelsPath)

# prepare the train, cross-validation and test data
allLabels = labels.get('final_labels')
labelCollection = {}

#collect all the labels and image indices
for labelEntry in allLabels:
    classL = getClass(labelEntry)
    
    if not (classL in labelCollection):
        labelCollection[classL] = []

    labelCollection[classL].append(labelEntry)

#print number of images in each class
for i in range(1, 6):
    print(str(classes[i]) + ': ' + str(labelCollection[i].__len__()))

trainData, validationData, testData = getSplittedData(labelCollection)

#write the label data to appropriate files
train = writeCaffeDataFile(trainData, 'trainConfig')
validation = writeCaffeDataFile(validationData, 'validationConfig')
test = writeCaffeDataFile(testData, 'testConfig')

classLabels = np.zeros((classes.__len__(), 2), dtype=object)
index = 0;

for k, v in classes.iteritems():
    classLabels[index][0] = k
    classLabels[index][1] = v
    index = index + 1;
    

sio.savemat(rootFolder + 'nnconfig', {'train' : train,
                         'test' : test,
                         'validation' : validation,
                         'classes':classLabels,
                         });

print('completed!')
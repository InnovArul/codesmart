#########################################################
#      CS6690-Pattern recognition
#      Assignment - 1
#      Author: Arulkumar S
#########################################################

import numpy as np
from numpy import size, reshape
import random
from numpy.core.numeric import arange
import pr_helper as utils
import scipy.linalg as linalg
import os

utils.writeToLog("", forceRewrite=True)

"""
A helper class that helps in adding non-linear features
"""
class PolynomialDegreeAdder():
    SINUSOID      = 0
    LINEAR        = 1
    QUADRATIC     = 2
    CUBIC         = 3
    DEGREE_4      = 4
    DEGREE_5      = 5
    DEGREE_6      = 6
    DEGREE_7      = 7
    DEGREE_8      = 8
    allModels = [SINUSOID, LINEAR, QUADRATIC, CUBIC, DEGREE_4, DEGREE_5, DEGREE_6, DEGREE_7, DEGREE_8]

    @staticmethod
    def addLinear(Xraw):
        # add polynomial second degree
        EXPR = 'degree-1'
        return Xraw, EXPR

    @staticmethod
    def addQuadratic(Xraw):
        # add polynomial second degree
        EXPR = 'quadratic'
        Xnew = np.concatenate((Xraw, Xraw * Xraw), axis = 1)
        return Xnew, EXPR

    @staticmethod
    def addCubic(Xraw):
        # add polynomial third degree
        EXPR = 'cubic'
        Xnew, dummyExpr = PolynomialDegreeAdder.addQuadratic(Xraw)
        Xnew = np.concatenate((Xnew, Xraw ** 3), axis = 1)
        return Xnew, EXPR

    @staticmethod
    def addDegree4(Xraw):
        # add polynomial second degree & sine
        EXPR = 'degree-4'
        Xnew, dummyExpr = PolynomialDegreeAdder.addCubic(Xraw)
        Xnew = np.concatenate((Xnew, Xraw ** 4), axis = 1)
        return Xnew, EXPR 

    @staticmethod
    def addDegree5(Xraw):
        # add polynomial second degree & sine
        EXPR = 'degree-5'
        Xnew, dummyExpr = PolynomialDegreeAdder.addDegree4(Xraw)
        Xnew = np.concatenate((Xnew, Xraw ** 5), axis = 1)
        return Xnew, EXPR 


    @staticmethod
    def addDegree6(Xraw):
        # add polynomial second degree & sine
        EXPR = 'degree-6'
        Xnew, dummyExpr = PolynomialDegreeAdder.addDegree5(Xraw)
        Xnew = np.concatenate((Xnew, Xraw ** 6), axis = 1)
        return Xnew, EXPR 


    @staticmethod
    def addDegree7(Xraw):
        # add polynomial second degree & sine
        EXPR = 'degree-7'
        Xnew, dummyExpr = PolynomialDegreeAdder.addDegree6(Xraw)
        Xnew = np.concatenate((Xnew, Xraw ** 7), axis = 1)
        return Xnew, EXPR 

    @staticmethod
    def addDegree8(Xraw):
        # add polynomial second degree & sine
        EXPR = 'degree-8'
        Xnew, dummyExpr = PolynomialDegreeAdder.addDegree7(Xraw)
        Xnew = np.concatenate((Xnew, Xraw ** 8), axis = 1)
        return Xnew, EXPR 

    @staticmethod
    def addSinusoid(Xraw):
        # add polynomial second degree & sine
        EXPR = 'bias + X + X^2 + sin(X)'
        Xnew, dummyExpr = PolynomialDegreeAdder.addQuadratic(Xraw)
        Xnew = np.concatenate((Xnew, np.sin(Xraw)), axis = 1)
        return Xnew, EXPR 

    """
    High level API to manage adding non-linear features
    """
    @classmethod
    def addPolynomialFeature(self, Xraw, polynomialOption):
        switcher = {
            PolynomialDegreeAdder.LINEAR   : PolynomialDegreeAdder.addLinear,
            PolynomialDegreeAdder.QUADRATIC: PolynomialDegreeAdder.addQuadratic,
            PolynomialDegreeAdder.CUBIC    : PolynomialDegreeAdder.addCubic,
            PolynomialDegreeAdder.DEGREE_4     : PolynomialDegreeAdder.addDegree4,
            PolynomialDegreeAdder.DEGREE_5     : PolynomialDegreeAdder.addDegree5,
            PolynomialDegreeAdder.DEGREE_6     : PolynomialDegreeAdder.addDegree6,
            PolynomialDegreeAdder.DEGREE_7     : PolynomialDegreeAdder.addDegree7,
            PolynomialDegreeAdder.DEGREE_8     : PolynomialDegreeAdder.addDegree8,
            PolynomialDegreeAdder.SINUSOID     : PolynomialDegreeAdder.addSinusoid,
        }
        
        return switcher.get(polynomialOption)(Xraw)

"""
API to split the data as features and solution
"""
def SplitFeatureAndSolution(rawData):
    # actual examples given
    lastColumn = rawData.shape[1] - 1
    Ytotal = np.transpose(np.array([rawData[:, lastColumn]]))
    Xtotal = np.delete(rawData, lastColumn, axis=1)

    return Xtotal, Ytotal

"""
API to split total data into training, validation, test sets
"""
def PartitionDataSet(Xtotal, Ytotal):

    no_of_examples = Xtotal.shape[0]
    
    # split into training data(70%), validation data (20%) & test data(10%)
    # collect random indices for splitting test data (10%)
    testIndices = range(int(no_of_examples * 0.1)) #random.sample(range(0, no_of_examples - 1), int(no_of_examples * 0.10))
    Xtest = Xtotal[testIndices, :]
    Xremaining = np.delete(Xtotal, tuple(testIndices), axis=0)
    Ytest = Ytotal[testIndices, :]
    Yremaining = np.delete(Ytotal, tuple(testIndices), axis=0)
    
    # now split 20% for validation data
    # the remaining 70% data will be training data
    validationIndices = range(int(no_of_examples * 0.2)) #random.sample(range(0, Xremaining.shape[0] - 1), int(no_of_examples * 0.20))
    Xvalidation = Xremaining[validationIndices, :]
    Xtraining = np.delete(Xremaining, tuple(validationIndices), axis=0)
    Yvalidation = Yremaining[validationIndices, :]
    Ytraining = np.delete(Yremaining, tuple(validationIndices), axis=0)

    #####################################################
    # display the dimensions of the data
    #####################################################
    utils.writeToLog('\ntotal data       : feature vector' + str(Xtotal.shape) + ', target vector' + str(Ytotal.shape))
    utils.writeToLog('\ntraining data    : feature vector' + str(Xtraining.shape) + ', target vector' + str(Ytraining.shape))
    utils.writeToLog('\nvalidation data  : feature vector' + str(Xvalidation.shape) + ', target vector' + str(Yvalidation.shape))
    utils.writeToLog('\ntest data        : feature vector' + str(Xtest.shape) + ', target vector' + str(Ytest.shape))
    
    return Xtraining, Ytraining, Xvalidation, Yvalidation, Xtest, Ytest


"""
read the input text file and reshape it as an ndarray with given number of columns
"""
def readFile(filename, DIMENSION):
    # read the data and store it in numpy array
    filecontents = np.loadtxt(filename)

    # preparation of Training data, Test data
    X = reshape(filecontents, (size(filecontents) / DIMENSION, DIMENSION))
    return X


"""
normalize the training data to be on same scale
Mean = 0, Variation = 1

return the mu and sigma for scaling the cross validation and test data
"""
def scaleTrainingFeatures(Xtraining):
    # normalize the features of (only the) training data
    #===============================================================================
    Xtraining_mean = np.mean(Xtraining, axis = 0)
    Xtraining_std = np.std(Xtraining, axis = 0)
    Xtraining = (Xtraining - Xtraining_mean) / Xtraining_std
    return Xtraining, Xtraining_mean, Xtraining_std

"""
normalize the data to be on same scale, as of training data
"""
def scaleFeatures(features, mu, sigma):
    return (features - mu) / sigma

"""
add the bias term as 1 to all the data sets ( training, validation, test)
"""
def addBiasTerm(Xtraining, Xvalidation, Xtest):
    #insert the bias term in X
    #------------------------------------------------------------------------------
    # add the bias term (=1) to the data
    Xtraining = np.insert(Xtraining, 0, 1, axis=1)
    Xvalidation =  np.insert(Xvalidation, 0, 1, axis=1)
    Xtest =  np.insert(Xtest, 0, 1, axis=1)
    return Xtraining, Xvalidation, Xtest


# fix the learning rate
ALPHA = 0.05

# lambda - regularisation parameter
REGULARIZE_LAMBDA = 5;

"""
computeMSE = calculates the mean squared error between computed output & actual output with current parameter settings
                returns the mean squared error

"""
def computeMSE(trainerX, trainerY, parameters):
    no_of_examples = trainerX.shape[0]
    predicted = np.dot(trainerX, parameters)
    relativeError = predicted - trainerY;
    MSE = (np.sum(relativeError * relativeError) + (REGULARIZE_LAMBDA * np.sum(parameters[1:] * parameters[1:]))) / (2 * no_of_examples);
    return MSE

"""
computeRelativeError = calculates the relative error between computed output & actual output with current parameter settings
                returns the sum of relative error

"""
def computeRelativeError(trainerX, trainerY, parameters):
    relativeError = (np.dot(trainerX, parameters) - trainerY);
    return relativeError

"""
gradientDescent = updates the parameters upto the specified number of iterations.
                Also, stores the cost during each iteration update for graph creation later.
"""
numberOfIterations = 200
    
def gradientDescent(trainerX, trainerY, validatorX, validatorY):
    # initialize parameters
    no_of_examples = trainerX.shape[0]
    parameters = np.zeros((trainerX.shape[1], 1)) 
    costHistory = {}
    
    for index in range(numberOfIterations):
        paramsTemp = np.zeros(parameters.shape); paramsTemp[1:] = parameters[1:];
        dCost_by_dParam = ((np.dot(trainerX.T, computeRelativeError(trainerX, trainerY, parameters))) + (REGULARIZE_LAMBDA * paramsTemp)) / no_of_examples;

        parameters = parameters - ALPHA * dCost_by_dParam;
        cost = computeMSE(trainerX, trainerY, parameters)
        #print(cost)
        costHistory[index] = cost
        
    validationSetError = computeMSE(validatorX, validatorY, parameters)
    trainingSetError = computeMSE(trainerX, trainerY, parameters)
    
    print 'training set error = ', trainingSetError , 'Validation set error = ', validationSetError 
    
    return parameters, validationSetError, costHistory

"""
compute parameters using linear algebra Moose-penrose inverse formula
"""
def linearAlgebraSolution(trainerX, trainerY):
    #compute the params by linear algebra
    params_alg = linalg.pinv((trainerX.T.dot(trainerX))).dot(trainerX.T).dot(trainerY);
    return params_alg

"""

"""
def plotCostFunctionAndSolution(Xtraining, Ytraining, Ypredicted, parameters, dataname):
    kwargs = {'Y predicted': {
                              'data' : Ypredicted,
                              'linestyle': '-'
                            },
              'data points' :
                            {
                             'data': Ytraining,
                             'marker' : 'o',
                             'linestyle': ''
                             }
              }
    
    utils.plotXYgraph(dataname + '_illustration', 'Feature-1', 'Target',  Xtraining[:, 1], **kwargs)
    
    if(parameters.shape[0] > 2): return
    
    import numpy as np
    from mpl_toolkits.mplot3d import Axes3D
    import matplotlib.pyplot as plt
    import collections
    
    ms = np.linspace(parameters[1,0] - 2, parameters[1,0] + 2, 20)
    bs = np.linspace(parameters[0,0] - 2, parameters[0,0] + 2, 20)
    
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    
    M, B = np.meshgrid(ms, bs)
    zs = np.array([computeMSE(Xtraining, Ytraining, np.array([[mp], [bp]])) 
                   for mp, bp in zip(np.ravel(M), np.ravel(B))])
    Z = zs.reshape(M.shape)
    
    ax.plot_surface(M, B, Z, rstride=1, cstride=1, color='b', alpha=0.5)
    
    ax.set_xlabel('parameter-1')
    ax.set_ylabel('bias parameter (parameter-0)')
    ax.set_zlabel('error')

    plt.show() #savefig(dataname + '_3D_Illustration')
    #plt.close()
    
    
#-----------------------------------------------------------------------------------------------------------    
# the data sets to be trained for prediction
dataSets = {
   '/media/Buffer/IITM/CS6690PatternRecognition/Assignment1/LinearData/Dim1/Data_1_r0_s29.txt' : 2,
   '/media/Buffer/IITM/CS6690PatternRecognition/Assignment1/LinearData/Dim2/Data_2_r0_s29.txt' : 3,
   '/media/Buffer/IITM/CS6690PatternRecognition/Assignment1/LinearData/DimR100/Data_100_r1_rd_s29.txt' : 101,
}

# ------------------------MAIN PROGRAM STARTS HERE----------------------------------------------------------

for file in dataSets.keys():
    # read the file contents
    totalColumns = dataSets.get(file)
    rawData = readFile(file, totalColumns)
    
    # performance history buffer
    parametersHolder = {}
    
    # split into features & solution
    Xtotal, Ytotal = SplitFeatureAndSolution(rawData)
    
    # for each type of model, do the training, validation, test
    for typeOfModel in PolynomialDegreeAdder.allModels:
        # add the polynomial feature according to type of model
        utils.writeToLog("\n\n\n" + file)
        Xnew, expression = PolynomialDegreeAdder.addPolynomialFeature(Xtotal, typeOfModel)
        utils.writeToLog("\n\nCURRENT MODEL TO BE TRAINED: " + expression)
        
        #split into training, validation, test sets
        XtrainingUnscaled, Ytraining, XvalidationUnscaled, Yvalidation, XtestUnscaled, Ytest = PartitionDataSet(Xnew, Ytotal)
        
        # normalize training features
        Xtraining, mu, sigma = scaleTrainingFeatures(XtrainingUnscaled)
        Xvalidation = scaleFeatures(XvalidationUnscaled, mu, sigma)
        Xtest = scaleFeatures(XtestUnscaled, mu, sigma)
        
        # add the bias term
        Xtraining, Xvalidation, Xtest = addBiasTerm(Xtraining, Xvalidation, Xtest)
        
        #train the model
        parameters, validationSetError, costHistory = gradientDescent(Xtraining, Ytraining, Xvalidation, Yvalidation)
        
        utils.writeToLog("\nparameters : " + str(parameters.shape) + "\n" + str(parameters) + "\n\nvalidation set error: " + str(validationSetError))
        
        # note down the parameters and validation dataset performance
        parametersHolder[typeOfModel] = {
                                         'parameters' : parameters,
                                         'validationerror' : validationSetError,
                                         'testX' : Xtest,
                                         'testY' : Ytest,
                                         'costhistory' : costHistory,
                                         'expression' : expression
                                        }
        
        #TODO calculate parameters using Moose-penrose inverse and compare the parameters
        testSetError = computeMSE(Xtest, Ytest, parameters)
        utils.writeToLog('\n\ntest set error : ' +  str(testSetError))
        
        #params from linear algebra method
        linAlgParams = linearAlgebraSolution(Xtraining, Ytraining)
        relativeError, dummy = utils.getMeanAbsError(parameters, linAlgParams)
        utils.writeToLog('\n\nlinear algebra parameters : ' + str(linAlgParams.shape) + "\n\n" + str(linAlgParams) + "\n\nRelative MSE between gradient descent & linear algebra results: " + str(relativeError))
        
        # if number of params is 2, then we can plot the cost function & curve fitting
        if(Xtotal.shape[1] == 1):
            kwargs = {'data points' : {'data' : Ytraining, 'marker':'o', 'linestyle':'', 'color':'r'}}
            utils.plotXYgraph(utils.getFileNameFromPath(file) + ' rawdata', 'X', 'Y', XtrainingUnscaled[:, 0], **kwargs)
            plotCostFunctionAndSolution(Xtraining, Ytraining, Xtraining.dot(parameters), parameters, utils.getFileNameFromPath(file) + ' ' + expression)
    
    # generate cost history graph from parametersHolder
    kwargs = {};
    modelList = []
    validationErrList = []
    for modelType in sorted(parametersHolder.keys()):
        model = parametersHolder[modelType]
        label = model['expression']
        modelList.append(label), validationErrList.append(model['validationerror'])        
        kwargs[label] = {}
        kwargs[label]['data'] = np.array([model['costhistory'][x] for x in range(numberOfIterations)]) 
    
    
    utils.plotXYgraph(utils.getFileNameFromPath(file) + '-Gradient Descent', 'Iteration number', 'Mean squared error during training', np.array([x+1 for x in range(numberOfIterations)]), **kwargs)
    
    # generate validation error bar chart from parametersHolder
    utils.plotBarChart(utils.getFileNameFromPath(file) + '_bar', 'Models', 'validation set error after training', modelList, validationErrList)

    


"""
Created on 20-Feb-2016
***********************************************************************
 * Copyright (c) 2016 Arulkumar (arul.csecit@ymail.com).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Arulkumar (arul.csecit@ymail.com)
 ***************************************************************************/
@author: arul
"""
import math

class Sigmoid:
    def __init__(self, beta = 1):
        """
        constructor
        @param beta:
        """
        self.beta = beta
        
    def sigm(self, _input):
        """
        core sigmoid implementation
        @param _input: input vector to be sigmoided
        """
        return (1 / (1 + math.exp(self. beta * _input)))
        
    def forward(self, _input):
        """
        forward the data
        @param _input:
        """
        self.output = self.sigm(_input)
        return self.output
    
    def backward(self, _input, _gradOutput):
        """
        propagate the gradient backward and store the gradient with respect to its current expected changes
        @param _input:
        @param _gradOutput:
        """
        return self.sigm(_input).T * (1 - self.sigm(_input)) * _gradOutput
        
    def updateParameters(self, _learningRate):
        """
        update the parameters using learning rate & gradient
        @param _learningRate:
        """
        pass
    
    def zeroGradParameters(self):
        """
        do nothing
        """
        pass
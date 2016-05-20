
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

import numpy as np

class LinearLayer:
    """
    linear layer
    """

    def __init__(self, _inputCount, _outputCount):
        """
        constructor
        @param inputCount: number of inputs
        @param outputCount: number of outputs
        """
        self.inputCount = _inputCount
        self.outputCount = _outputCount
        self.parameters = np.random.randn(self.outputCount, self.inputCount + 1)
        self.gradParameters = np.zeros_like(self.parameters)
        
    def forward(self, _input):
        """
        forward the input 
        @param _input: input vector
        """
        self.output = self.parameters.dot([1] + _input)
        return self.output
    
    def backward(self, _input, _gradOutput):
        self.gradParameters = self.gradParameters + (_input * _gradOutput);
        self.gradOutput = self.parameters * _gradOutput;
        return self.gradOutput
        
    def updateParameters(self, _learningRate):
        self.parameters = self.parameters - (_learningRate * self.gradParameters)
        
    def zeroGradParameters(self):
        self.gradParameters = np.zeros_like(self.parameters)

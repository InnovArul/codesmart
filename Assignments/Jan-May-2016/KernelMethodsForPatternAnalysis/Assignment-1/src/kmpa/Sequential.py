
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

class Sequential:
    """
    A holder of sequential modules
    """
    
    def __init__(self):
        """
        constructor
        """
        self.modulesList = []
    
    def add(self, module):
        """
        add a layer into sequential circuited neural network
        @param module: module to be added
        @return: the module currently added
        """
        self.modulesList.append(module)
        return module
    
    def forward(self, _input):
        """
        forward the input through all the layers
        @param _input: input vector
        """
        currentInput = _input
        for module in self.modulesList:
            currentInput = module.forward(currentInput) 
        
        return currentInput
    
    def get(self, index):
        """
        get the node at particular index
        @param index: needed index
        """
        node = None
        if(len(self.modulesList) > index):
            node = self.moduleList[index]
        return node
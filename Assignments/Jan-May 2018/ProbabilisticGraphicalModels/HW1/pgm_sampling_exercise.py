# -*- coding: utf-8 -*-
import numpy as np
np.random.seed(100)

def sample_from_BN(parents, cardinalities, conditionals):
#    Sample from a n-node BN with given graph structure and conditionals. The 
#    node ids are from 0 to n-1.
#    
#    Arguments:
#        
#    parents: an n-length list, with the element at position i being a list 
#    containing the parents are node i. Assume that the nodes are in topological
#    sorted order, i.e. the parents have lesser indices than children. Also 
#    assume the list of parents for each node are in ascending order.
#    
#    cardinalities: an n-length list giving the cardinalities of each node. The 
#    values taken by a ‘k’-cardinality random variable are 0,1,...,k-1.
#    
#    conditionals: an n-length list with each element giving the conditional 
#    distribution of the corresponding node given its parents. Each conditional 
#    is represented by a dictionary, with keys as tuples of parent assignments, 
#    and values as cardinality-dimensional vector giving the conditional 
#    probability of the corresponding random variable. Note that the values will
#    always sum to 1. In the case of nodes with no parents, the only key is 
#    indexed by -1.
#	
#    Returns:
#        
#    sample: an n-dimensional numpy array
#    
#	An example of how the arguments would look like for a noisy xor case, with 
#    three random variables is given below. The inputs to the xor gate are the 
#    random variables indexed by 0 and 1, and they both are indpendent and take 
#    values in {0,1} with equal probability. The random variable indexed by 2, 
#    is the xor of its arguments with probability 0.9.
#	
#    parents=[[],[],[0,1]] 
#    cardinalities=[2,2,2]
#    conditionals=[{-1:[0.5,0.5]},{-1:[0.5,0.5]},{(0,0):[0.9,0.1],(0,1):[0.1,0.9],(1,0):[0.1,0.9],(1,1):[0.9,0.1]}]
    pass


               
if __name__=='__main__':
    parents=[[],[],[0,1]] 
    cardinalities=[2,2,2]
    conditionals=[{-1:[0.5,0.5]},{-1:[0.5,0.5]},{(0,0):[0.9,0.1],(0,1):[0.1,0.9],(1,0):[0.1,0.9],(1,1):[0.9,0.1]}]
    for i in range(100):
        sample=sample_from_BN(parents, cardinalities, conditionals)
        print sample
        
        
        
        
        
        
        
        
        
        
        
        
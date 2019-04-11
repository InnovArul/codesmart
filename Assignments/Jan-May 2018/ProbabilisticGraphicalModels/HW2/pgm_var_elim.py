#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 26 13:21:58 2018

@author: Arulkumar S(CS15D202) and harishguruprasad
"""
import numpy as np


def var_elim(factors, cardinalities, elim_order):
    """
    Given factors and an elimination order over n random variables. Computes the 
    partition function. The n variables are indexed X_0,X_1,...,X_{n-1}

    Arguments: 
    Factors: Dictionary with the key being an ordered tuple giving the arguments
    to the factor. If the key consists of k-elements. then the value is a k-dim
    numpy array. You may assume the factor arguments in the key are always in 
    ascending order.
    
    cardinalities: a list of size n, giving the number of values each random 
    variable takes.
    
    elim_order: list giving a permutation of [0,1,...,n-1]. Eliminate the first 
    element in the list first.
    
    Returns:
    norm_const = Sums the terms according to elimination ordering and returns a 
    scalar giving the partition function.    
    
    example: A 3 node Markov network, with binary random variables, and pairwise
    factors such that they prefer the connected variables to be equal rather than
    different is given below:
        
    factors={(0,1):np.array([[5.,1.],[1.,5.]]), 
             (1,2):np.array([[5.,1.],[1.,5.]]),
             (0,2):np.array([[5.,1.],[1.,5.]])}
    cardinalities=[2,2,2]
    elim_order=[0,1,2]
    """
    # for each of the elimination variable, do the variable elimination operation
    
    for var in elim_order:
        # find the factors relevant to current iteration
        current_factor_keys = [key for key in factors
                                if var in key]
        current_unique_keys = []
        all_current_keys_involved = []
        
        # find all the keys from the factors available now
        for key in current_factor_keys:
            all_current_keys_involved += list(key)
        
        # find all the unique keys involved during current elimination
        current_unique_keys = np.unique(all_current_keys_involved)

        # collect all the factors for current involved keys
        current_factors = []
        for key in current_factor_keys:
            current_factors.append(factors[key])
            factors.pop(key, None)

        # for all the factors, expand appropriate dim to multiply
        expanded_factors = []
        for key, factor in zip(current_factor_keys, current_factors):
            diff_keys = set(current_unique_keys) - set(key)
            
            meta_key = list(key)
            for d in diff_keys:
                index = np.searchsorted(meta_key, d)
                meta_key.insert(index, d)
                
                # unsqueeze and repeat the dimensions appropriately
                factor = np.expand_dims(factor, axis=index)
                factor = np.repeat(factor, cardinalities[d], index)
                
            expanded_factors.append(factor)
        
        # now multiply all the factors
        current_result = None
        for factor in expanded_factors:
            if current_result is None:
                current_result = factor
            else:
                current_result = current_result * factor
        
        #append the current result with the key to the factors
        to_be_added_key = tuple(list(set(current_unique_keys) - set([var])))
        current_result = np.sum(current_result, axis=list(current_unique_keys).index(var))

        # add the current result with its key
        # if the key already exists, multiply the current result with already existing one
        if to_be_added_key in factors:
            factors[to_be_added_key] *= current_result
        else:
            factors[to_be_added_key] = current_result

    return factors[()]

if __name__=='__main__':    
    factors={(0,1):np.array([[5.,1.],[1.,5.]]), 
             (1,2):np.array([[5.,1.],[1.,5.]]),
             (0,2):np.array([[5.,1.],[1.,5.]])}
    cardinalities=[2,2,2]
    elim_order=[0,1,2]
    print(var_elim(factors, cardinalities, elim_order)) # correct answer is 280
    print('=======================')
    
    factors={(0,):np.array([0.5, 0.5]), 
             (1,):np.array([0.5, 0.5]), 
             (0,1,2):np.array([[[0.2,0.4],[0.8,0.6]],[[0.6,0.8],[0.4,0.2]]]),
             (0,1,3):np.array([[[0.2,0.4],[0.8,0.6]],[[0.6,0.8],[0.4,0.2]]]) }
    cardinalities=[2,2,2,2]
    elim_order=[0,1,2,3]
    print(var_elim(factors, cardinalities, elim_order)) # correct answer is 1.16
    print('=======================')
    
    factors={(0,):np.array([0.5, 0.5]), 
             (1,):np.array([0.5, 0.5]), 
             (0,1,2):np.array([[[0.2,0.8],[0.4,0.6]],[[0.6,0.4],[0.8,0.2]]]),
             (0,1,3):np.array([[[0.2,0.8],[0.4,0.6]],[[0.6,0.4],[0.8,0.2]]]) }
    cardinalities=[2,2,2,2]
    elim_order=[2,3,0,1]
    print(var_elim(factors, cardinalities, elim_order)) # correct answer is 1.
    

                
    

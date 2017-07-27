import numpy as np
import matplotlib.pyplot as plt
from grid import standard_grid

EPS = 10e-4

def print_values(V, g): # value of states, g = grid
    for i in range(g.width):
        print('---------------------')
        for j in range(g.height):
            v = V.get((i, j), 0)
            print('  %-0.2f  ' % v, end='')
        print('')
        
def print_policy(P, g): # value of states, g = grid
    for i in range(g.width):
        print('-----------------------------')
        for j in range(g.height):
            p = P.get((i, j), 0)
            print('  %s  |' % p, end='')
        print('')

# main loop
if(__name__ == '__main__'):
    grid = standard_grid()
    states = grid.all_states()
    
    # set values of all states = 0
    V = {}
    for v in states:
        V[v] = 0
    
    gamma = 1.0
    
    while(True):
        diff = 0
        
        # for each state, evaluate the value
        for s in states:
            old_v = V[s]
            if(s in grid.actions):
                new_v = 0
                p_a = 1.0 / len(grid.actions[s])
                
                for a in grid.actions[s]:
                    grid.set_state(s)
                    r = grid.move(a)
                    new_v += p_a * (r + gamma * V[grid.current_state()])
                
                V[s] = new_v
                diff = max(diff, abs(old_v - new_v))
        
        if(diff < EPS):
            break
    
    print('values for uniform random actions')
    print_values(V, grid)
    print("\n\n")

    #-------------------------------------------------------------------
    # fixed policy
    policy = {
        (2, 0) : 'U',
        (1, 0) : 'U',
        (0, 0) : 'R',
        (0, 1) : 'R',
        (0, 2) : 'R',
        (1, 2) : 'R',
        (2, 1) : 'R',
        (2, 2) : 'R',
        (2, 3) : 'U'
    }

    print_policy(policy, grid)
    # set values of all states = 0
    V = {}
    for v in states:
        V[v] = 0
    
    gamma = 0.9

    while(True):
        diff = 0
        
        # for each state, evaluate the value
        for s in states:
            if s in policy:
                old_v = V[s]
                a = policy[s]
                grid.set_state(s)
                r = grid.move(a)
                V[s] = (r + gamma * V[grid.current_state()])
                diff = max(diff, abs(old_v - V[s]))
        
        if(diff < EPS):
            break
    
    print('\n\n')
    print('values for fixed policy')
    print_values(V, grid)
    print("\n\n")

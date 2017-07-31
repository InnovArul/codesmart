import numpy as np
import matplotlib.pyplot as plt
from grid import standard_grid, negative_grid
from iterative_policy_evaluation import print_policy, print_values

# policy iteration = policy evaluation followed by policy improvement
EPS = 0.9
GAMMA = 0.9
ALL_POSSIBLE_ACTIONS = ('U', 'D', 'L', 'R')

if __name__ == '__main__':
    grid = negative_grid()
    
    #print rewards
    print_values(grid.rewards, grid)
    
    # initialize policy with random actions
    policy = {}
    for s in grid.actions:
        policy[s] = np.random.choice(ALL_POSSIBLE_ACTIONS)
    
    # initial policy
    print_policy(policy, grid)
    
    # initialize V
    V = {}
    states = grid.all_states()
    for s in states:
        if s in grid.actions:
            V[s] = np.random.random()
        else:
            V[s] = 0
    
    while True:
        
        # policy evaluation
        while True:
            diff = 0
            for s in states:
                if s in grid.actions:
                    old_v = V[s]
                    action = policy[s]
                    grid.set_state(s)
                    r = grid.move(action)
                    V[s] = r + GAMMA * V[grid.current_state()]
                    
                    diff = max(diff, abs(V[s] - old_v))
            
            if diff < EPS:
                break
            
        # policy improvement step
        is_policy_converged = True
        
        for s in policy:
            old_a = policy[s]
            new_a = None
            best_val = float('-inf')
            
            for a in ALL_POSSIBLE_ACTIONS:
                grid.set_state(s)
                r = grid.move(a)
                new_val = r + GAMMA * V[grid.current_state()]
                if(new_val > best_val):
                    best_val = new_val
                    new_a = a
            
            policy[s] = new_a
            if(new_a != old_a):
                is_policy_converged = False
        
        if(is_policy_converged):
            break
    
    # print the values
    print_values(V, grid)
    
    # print policy
    print_policy(policy, grid)
    
    

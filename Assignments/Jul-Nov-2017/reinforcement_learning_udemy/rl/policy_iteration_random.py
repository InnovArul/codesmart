import numpy as np
import matplotlib.pyplot as plt
from grid import standard_grid, negative_grid
from iterative_policy_evaluation import print_policy, print_values

# policy iteration = policy evaluation followed by policy improvement
EPS = 0.9
GAMMA = 0.9
ALL_POSSIBLE_ACTIONS = ('U', 'D', 'L', 'R')

if __name__ == '__main__':
    grid = negative_grid(step_cost=-1.0)
    
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
                    new_v = 0
                    
                    for a in ALL_POSSIBLE_ACTIONS:
                        grid.set_state(s)
                        r = grid.move(a)
                        p = 0
                        
                        if(a == policy[s]):
                            p = 0.5
                        else:
                            p = 0.5 / 3
                        
                        new_v += p * (r + GAMMA * V[grid.current_state()])
                    
                    V[s] = new_v
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
                new_val = 0
                for a2 in ALL_POSSIBLE_ACTIONS:
                    grid.set_state(s)
                    r = grid.move(a2)
                    
                    p = 0
                        
                    if(a == a2):
                        p = 0.5
                    else:
                        p = 0.5 / 3                    
                    
                    new_val += p * (r + GAMMA * V[grid.current_state()])
                    
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
    
    

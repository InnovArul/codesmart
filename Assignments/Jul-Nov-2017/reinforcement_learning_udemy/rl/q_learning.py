import numpy as np
import matplotlib.pyplot as plt
from iterative_policy_evaluation import print_values, print_policy
from grid import standard_grid, negative_grid
from monte_carlo_exploring_starts import max_dict
from td0_learning_policy_evaluation import random_action

EPS = 1e-4
GAMMA = 0.9
ALL_POSSIBLE_ACTIONS = ('U', 'D', 'L', 'R')
ALPHA = 0.1

if __name__ == '__main__':
    grid = negative_grid()
    
    # initlaize Q
    # and counts for learning rate update, like RMSProp/Adagrad
    Q = {}
    update_counts_sa = {}
    update_counts = {}
    
    for s in grid.all_states():
        Q[s] = {}
        update_counts_sa[s] = {}
        for a in ALL_POSSIBLE_ACTIONS:
            Q[s][a] = 0
            update_counts_sa[s][a] = 1.0
        
    # repeat until convergence
    deltas = []
    t = 1.0
    
    for it in range(10000):
        if it % 100 == 0:
            t += 10e-3
        if it % 2000 == 0:
            print('it:' + str(it))
        
        # start state 
        state = (2, 0)
        grid.set_state(state)
        
        # get the max valued action
        a = max_dict(Q[state])[0]
        
        # game play
        biggest_change = 0
        while not grid.game_over():
            a = random_action(a, eps=0.5/t)
            r = grid.move(a)
            state2 = grid.current_state()
            
            # find out next action
            a2 = max_dict(Q[state2])[0]
            
            # determine learning rate
            alpha = ALPHA / update_counts_sa[state][a]
            update_counts_sa[state][a] += 0.005
            
            old_qsa = Q[state][a]
            Q[state][a] = Q[state][a] + alpha * (r + GAMMA * Q[state2][a2] - Q[state][a])
            biggest_change = max(biggest_change, abs(Q[state][a] - old_qsa))
            
            # tracking of how many times a state has been update
            update_counts[state] = update_counts.get(state, 0) + 1.0
            
            # move to next state
            state = state2
            a = a2
            
        deltas.append(biggest_change)
    
    plt.plot(deltas)
    plt.show()
    
    # update counts
    total = np.sum(update_counts.values())
    for s in update_counts:
        update_counts[s] = float(update_counts[s]) / total
    
    print('update counts')
    print_values(update_counts, grid)
    
    # determine the policy* and V*
    V, policy = {}, {}
    for s in Q:
        policy[s], V[s] = max_dict(Q[s])
    
    print('values')
    print_values(V, grid)
    
    print('policy')
    print_policy(policy, grid)
            

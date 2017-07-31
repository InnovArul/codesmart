import numpy as np
import matplotlib.pyplot as plt
from iterative_policy_evaluation import print_values, print_policy
from grid import standard_grid, negative_grid

EPS = 1e-4
GAMMA = 0.9
ALL_POSSIBLE_ACTIONS = ('U', 'D', 'L', 'R')
ALPHA = 0.1

def random_action(a, eps = 0.1):
    # epsilon greedy probabilistic based action
    p = np.random.random()
    if p < (1 - eps):
        return a
    else:
        return np.random.choice(list(ALL_POSSIBLE_ACTIONS))

def play_game(grid, policy):
    # returns a list of states visited from start state
    state = (2, 0)
    grid.set_state(state)
    
    states_and_rewards = [(state, 0)]
    
    while not grid.game_over():
        a = random_action(policy[state]) #soft epsilon action selection        
        r = grid.move(a)
        state = grid.current_state()
        states_and_rewards.append((state, r))
    
    return states_and_rewards

if __name__ == '__main__':
    grid = standard_grid()
    
    # print the initial rewards
    print('rewards')
    print_values(grid.rewards, grid)
    
    policy = {
        (2, 0): 'U',
        (1, 0): 'U',
        (0, 0): 'R',
        (0, 1): 'R',
        (0, 2): 'R',
        (1, 2): 'R',
        (2, 1): 'R',
        (2, 2): 'R',
        (2, 3): 'U'
    }

    # initialize V[s]
    V = {}
    for s in grid.all_states():
        V[s] = 0
    
    for it in range(1000):
        states_and_rewards = play_game(grid, policy)
        
        for t in range(len(states_and_rewards) - 1):
            s, _ = states_and_rewards[t]
            s1, r1 = states_and_rewards[t+1]
            
            V[s] += (ALPHA * (r1 + GAMMA * V[s1] - V[s]))
    
    print('values')
    print_values(V, grid)
    
    print('policy')
    print_policy(policy, grid)

from __future__ import print_function
import numpy as np
from grid import standard_grid, negative_grid
from iterative_policy_evaluation import print_values, print_policy
import matplotlib.pyplot as plt
from monte_carlo_exploring_starts import max_dict

EPS = 1e-4
GAMMA = 0.9
ALL_POSSIBLE_ACTIONS = {'U', 'D', 'L', 'R'}

def random_action(a, eps=0.1):
    p = np.random.random()
    if(p < 1 - eps):
        return a
    else:
        return np.random.choice(list(ALL_POSSIBLE_ACTIONS))

# monte carlo sampling - finding out optimal policy (policy iteration)
def play_game(grid, policy):
    all_states = list(grid.actions.keys())
    state = (2, 0)
    # instead of taking random action at first step, consider the action which is probabilistic with the policy
    a = random_action(policy[state])
    
    grid.set_state(state)
    states_actions_rewards = [(state, a, 0)] # action is corresponding to the one which is going to be taken
    
    while True:
        r = grid.move(a)
        state = grid.current_state()
        #print(prev_state)
        
        # if game over, break the loop
        if  grid.game_over():
            states_actions_rewards.append((state, None, r)) # agent has hit the wall and we should not allow it to happen
            break
        else:
            # collect the next action that we are gonna take and insert into the trace
            a = random_action(policy[state])
            states_actions_rewards.append((state, a, r))
        
    # calculate the returns by working backwards from terminal state
    G = 0
    states_actions_returns = []
    
    for i, state_action_reward in enumerate(reversed(states_actions_rewards)):
        state, action, reward = state_action_reward
        if i != 0:
            states_actions_returns.append((state, action, G))
        G = reward + GAMMA * G
    
    states_actions_returns.reverse()
    return states_actions_returns

def max_dict(hash):
    max_key = None
    max_val = float('-inf')
    for k in hash:
        if(hash[k] > max_val):
            max_key, max_val = k, hash[k]
    
    return max_key, max_val

if __name__ == '__main__':
    #grid = standard_grid()
    grid = negative_grid(-0.1)
    print('grid')
    print_values(grid.rewards, grid)
    
    # init random policy
    policy = {}
    for s in grid.actions:
        policy[s] = np.random.choice(list(ALL_POSSIBLE_ACTIONS))

    print('policy')
    print_policy(policy, grid)
    
    # initialioze Q(s, a)
    Q = {}
    returns = {} # buffer to hold all the returns for a state during monte-carlo game plays
    for s in grid.actions: # if state is non terminal
        Q[s] = {}
        for a in ALL_POSSIBLE_ACTIONS:
            # for all the possible actions, initialize Q(s,a)
            Q[s][a] = 0
            returns[(s, a)] = []
    
    # deltas 
    deltas = []
    for sample in range(5000):
        if sample % 500 == 0:
            print(sample)
        
        biggest_change = 0
        
        # generate an episode and adapt Q(s, a)
        states_actions_returns = play_game(grid, policy)
        seen_states_actions = set()
        
        for s, a, G in states_actions_returns:
            key = (s, a)
            if s not in seen_states_actions:
                old_q = Q[s][a]
                returns[key].append(G)
                Q[s][a] = np.mean(returns[key])
                seen_states_actions.add(key)
                biggest_change = max(biggest_change, abs(G - old_q))
        
        deltas.append(biggest_change)
        
        # policy improvement
        for s in Q:
            policy[s] = max_dict(Q[s])[0]
    
    plt.plot(deltas)
    plt.show()
    
    V = {}
    # policy improvement
    for s in Q:
        V[s] = max_dict(Q[s])[1]
            
    print('grid')
    print_values(V, grid)
    print('policy')
    print_policy(policy, grid)
    

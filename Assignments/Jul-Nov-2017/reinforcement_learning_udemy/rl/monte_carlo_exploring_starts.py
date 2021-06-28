import numpy as np
from grid import standard_grid, negative_grid
from iterative_policy_evaluation import print_values, print_policy
import matplotlib.pyplot as plt

EPS = 1e-4
GAMMA = 0.9
ALL_POSSIBLE_ACTIONS = {'U', 'D', 'L', 'R'}

# monte carlo sampling - finding out optimal policy (policy iteration)
def play_game(grid, policy):
    all_states = list(grid.actions.keys())
    state = all_states[np.random.choice(len(all_states))]
    a = np.random.choice(list(ALL_POSSIBLE_ACTIONS))
    
    grid.set_state(state)
    states_actions_rewards = [(state, a, 0)] # action is corresponding to the one which is going to be taken
    seen_states = set()
    
    while True:
        prev_state = state
        r = grid.move(a)
        state = grid.current_state()
        #print(prev_state)
        
        # the agent should not go to same states
        if state in seen_states:
            states_actions_rewards.append((state, None, -100)) # agent has hit the wall and we should not allow it to happen
            break
        elif grid.game_over():
            states_actions_rewards.append((state, None, r)) # agent has reached the goal
            break
        else:
            # collect the next action that we are gonna take and insert into the trace
            a = policy[state]
            states_actions_rewards.append((state, a, r))
        
        seen_states.add(state)
        
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
    grid = negative_grid(-1)
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
    

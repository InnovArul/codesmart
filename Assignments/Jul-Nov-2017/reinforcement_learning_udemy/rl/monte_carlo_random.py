import numpy as np
from grid import standard_grid, negative_grid
from iterative_policy_evaluation import print_values, print_policy

EPS = 1e-4
GAMMA = 0.9
ALL_POSSIBLE_ACTIONS = {'U', 'D', 'L', 'R'}

def random_action(a):
    if(np.random.random() < 0.5):
        return a
    else:
        tmp = list(ALL_POSSIBLE_ACTIONS)
        tmp.remove(a)
        return np.random.choice(tmp)

# monte carlo sampling policy evaluation
def play_game(grid, policy):
    all_states = grid.actions.keys()
    state = all_states[np.random.choice(len(all_states))]
    
    grid.set_state(state)
    states_and_rewards = [(state, 0)]
    
    while not grid.game_over():
        a = policy[state]
        a = random_action(a)
        r = grid.move(a)
        state = grid.current_state()
        states_and_rewards.append((state, r))
        
    # calculate the returns by working backwards from terminal state
    G = 0
    states_and_returns = []
    
    for i, state_reward in enumerate(reversed(states_and_rewards)):
        state, reward = state_reward
        if i != 0:
            states_and_returns.append((state, G))
        G = reward + GAMMA * G
    
    states_and_returns.reverse()
    return states_and_returns

if __name__ == '__main__':
    grid = standard_grid()
    print 'grid'
    print_values(grid.rewards, grid)
    
    policy = {
        (2, 0): 'U',
        (1, 0): 'U',
        (0, 0): 'R',
        (0, 1): 'R',
        (0, 2): 'R',
        (2, 1): 'L',
        (2, 2): 'U',
        (2, 3): 'L',
        (1, 2): 'U',
    } 

    print 'policy'
    print_policy(policy, grid)
    
    #buffers
    V, returns = {}, {}

    for s in grid.all_states():
        if s in grid.actions:
            returns[s] = []
        else:
            V[s] = 0
    
    for sample in range(100):
        states_and_returns = play_game(grid, policy)
        seen_states = set()
        
        for s, G in states_and_returns:
            if s not in seen_states:
                returns[s].append(G)
                V[s] = np.mean(returns[s])
                seen_states.add(s)
                
    print 'grid'
    print_values(V, grid)
    print 'policy'
    print_policy(policy, grid)
    

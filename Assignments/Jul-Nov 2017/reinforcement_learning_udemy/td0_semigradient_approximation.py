import numpy as np
import matplotlib.pyplot as plt
from iterative_policy_evaluation import print_values, print_policy
from grid import standard_grid, negative_grid
from td0_learning_policy_evaluation import play_game, random_action, EPS, GAMMA, ALPHA, ALL_POSSIBLE_ACTIONS

class Model:
    def __init__(self):
        self.theta = np.random.randn(4)/2
    
    def s2x(self, s):
        return np.array([s[0] - 1, s[1] - 1.5, s[0] * s[1] - 3, 1])
    
    def forward(self, s):
        return self.theta.dot(self.s2x(s))
    
    def grad(self, s):
        return self.s2x(s)

if __name__ == '__main__':
    grid = standard_grid()
    
    print('rewards')
    print_values(grid.rewards, grid)
    
    # define a policy
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
    
    model = Model()
    
    deltas = []
    t = 1.0
    for it in range(20000):
        if it % 10 == 0:
            t = t + 0.01
        
        alpha = ALPHA / t
        biggest_change = 0
        
        states_and_rewards = play_game(grid, policy)
        
        for index in range(len(states_and_rewards) - 1):
            s, _ = states_and_rewards[index]
            s2, r = states_and_rewards[index + 1]
            
            old_theta = model.theta.copy()
            
            if grid.is_terminal(s2):
                target = r
            else:
                target = r + GAMMA * model.forward(s2)
            
            model.theta += alpha * (target - model.forward(s)) * model.grad(s)
            biggest_change = max(biggest_change, np.abs(model.theta - old_theta).sum())
        
        deltas.append(biggest_change)
        
    plt.plot(deltas)
    plt.show()
    
    # get predicted values
    V = {}
    for s in grid.actions:
        V[s] = model.forward(s)
    
    print('values')
    print_values(V, grid)
    
    print('policy')
    print_policy(policy, grid)

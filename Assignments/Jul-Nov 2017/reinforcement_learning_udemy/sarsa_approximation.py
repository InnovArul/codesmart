import numpy as np
import matplotlib.pyplot as plt
from iterative_policy_evaluation import print_values, print_policy
from grid import standard_grid, negative_grid
from sarsa_value_iteration import max_dict, ALPHA, EPS, GAMMA, ALL_POSSIBLE_ACTIONS
from td0_learning_policy_evaluation import random_action

class Model:
    def __init__(self):
        self.theta = np.random.randn(25) / np.sqrt(25)
    
    def get_features_for_action(self, s, a, target_a):
        if a == target_a:
            return np.array([
                s[0] - 1                            if a == 'U' else 0,
                s[1] - 1.5                          if a == 'U' else 0,
                (s[0]*s[1] - 3) / 3                 if a == 'U' else 0,
                (s[0]*s[0] - 2) / 2                 if a == 'U' else 0,
                (s[1]*s[1] - 4.5)/4.5               if a == 'U' else 0,
                1                                   if a == 'U' else 0,
            ])
        else:
            return np.zeros(6)
    
    def s2x(self, s, a):
        out = self.get_features_for_action(s, a, 'U')
        out = np.append(out, self.get_features_for_action(s, a, 'D'))
        out = np.append(out, self.get_features_for_action(s, a, 'L'))
        out = np.append(out, self.get_features_for_action(s, a, 'R'))
        return np.append(out, [1])
        
    def forward(self, s, a):
        return self.theta.dot(self.s2x(s, a))
    
    def grad(self, s, a):
        return self.s2x(s, a)

def getQs(model, s):
    Qs = {}
    for a in ALL_POSSIBLE_ACTIONS:
        Qs[a] = model.forward(s, a)
    
    return Qs

if __name__ == '__main__':
    
    grid = negative_grid()
    
    print('rewards')
    print_values(grid.rewards, grid)
    
    model = Model()
    
    t1, t2 = 1.0, 1.0
    deltas = []
    
    for it in range(20000):
        if it % 100 == 0:
            t1 += 0.001
            t2 += 0.01
        if it % 500 == 0:
            print('it:' + str(it))
        
        alpha = ALPHA / t2

        biggest_change = 0
        
        # start state
        state = (2, 0)
        grid.set_state(state)
        Qs = getQs(model, state)
        a = random_action(max_dict(Qs)[0], eps=0.5/t1)

        while not grid.game_over():
            r = grid.move(a)
            s2 = grid.current_state()
            
            # copy the theta
            old_theta = model.theta.copy()
            
            if grid.is_terminal(s2):
                model.theta += alpha * (r - model.forward(state, a)) * model.grad(state, a)
            else:
                Qs2 = getQs(model, s2)
                a2 = random_action(max_dict(Qs2)[0], eps=0.5/t1)
                model.theta += alpha * (r + GAMMA * model.forward(s2, a2) - model.forward(state, a)) * model.grad(state, a)
                
                # pass the state to next iteration
                state = s2
                a = a2                
            
            biggest_change = max(biggest_change, np.abs(model.theta - old_theta).sum())
        
        deltas.append(biggest_change)
        
    plt.plot(deltas)
    plt.show()        

    V = {}
    for s in grid.actions:
        V[s] = max_dict(getQs(model, s))[1]
    
    print('values')
    print_values(V, grid)
    
    print('policy')
    print_policy(policy, grid)    

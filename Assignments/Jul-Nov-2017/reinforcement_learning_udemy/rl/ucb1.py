import numpy as np
import matplotlib.pyplot as plt
import os

class Bandit:
    def __init__(self, true_mean):
        self.true_mean = true_mean
        self.running_mean = 0
        self.N = 0
        
    # pull the arm
    def pull(self):
        return np.random.randn() + self.true_mean
    
    # update the running mean
    def update(self, Xn):
        self.N += 1
        self.running_mean = (1 - (1.0 / self.N)) * self.running_mean + (1.0 / self.N) * Xn

#
# m1, m2, m3 = rewards of 3 bandits
# N = number of events/tries
# eps = for explore/exploit 
#
def run_experiments(m1, m2, m3, N, eps, isUCB=True):
    # create 3 bandits
    bandits = [Bandit(m1), Bandit(m2), Bandit(m3)]
    data = np.empty(N)
    
    for i in range(N):
        # epsilon explore-exploit dilemma
        p = np.random.random()
        if(not isUCB):
            if(p < eps):
                # if no UCB, then its a default epsilon explore-exploit problem
                j = np.random.choice(3)
            else:
                # incase of default epsilon explore-exploit problem, explore step
                j = np.argmax([b.running_mean for b in bandits])
        else:
            # incase of UCB, explore always the Bandit which has higher mean, as it is not explored much
            j = np.argmax([b.running_mean + np.sqrt(2 * np.log(i + 1.0) / (b.N + 0.000001)) for b in bandits])
            
        X = bandits[j].pull()
        bandits[j].update(X)
        
        data[i] = X
        
    cumulative_avg = np.cumsum(data) / (np.arange(N) + 1)
    return cumulative_avg
    
if(__name__ == '__main__'):
    c_noucb = run_experiments(1., 2., 3., 100000, 0.2, isUCB=False)
    c_ucb = run_experiments(1., 2., 3., 100000, 0.2, isUCB=True)
    
    plt.plot(c_noucb, label='eps = 0.2, no ucb')
    plt.plot(c_ucb, label='eps = 0.2, ucb')
    plt.legend()
    plt.xscale('log')
    plt.savefig('./pics/'+ os.path.splitext(__file__)[0] + '_logplot.jpg')
    plt.clf()

    plt.plot(c_noucb, label='eps = 0.2, no ucb')
    plt.plot(c_ucb, label='eps = 0.2, ucb')
    plt.legend()
    plt.savefig('./pics/'+ os.path.splitext(__file__)[0] + '_plot.jpg')
    plt.clf()

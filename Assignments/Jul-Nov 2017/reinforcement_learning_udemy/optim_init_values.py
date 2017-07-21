import numpy as np
import matplotlib.pyplot as plt
import os

class Bandit:
    def __init__(self, true_mean, running_mean):
        self.true_mean = true_mean
        self.running_mean = running_mean
        self.N = 0
        
    # pull the arm
    def pull(self):
        return np.random.randn() + self.true_mean
    
    # update the running mean
    def update(self, Xn):
        self.N += 1
        self.running_mean = (1 - (1 / self.N)) * self.running_mean + (1 / self.N) * Xn

#
# m1, m2, m3 = rewards of 3 bandits
# N = number of events/tries
# eps = for explore/exploit 
#
def run_experiments(m1, m2, m3, N, eps, start_mean):
    # create 3 bandits
    bandits = [Bandit(m1, start_mean), Bandit(m2, start_mean), Bandit(m3, start_mean)]
    data = np.empty(N)
    
    for i in range(N):
        # epsilon explore-exploit dilemma
        p = np.random.random()
        if(start_mean == 0 and p < eps):
            # if start_mean = 0, then its a default epsilon explore-exploit problem
            j = np.random.choice(3)
        else:
            # incase of default epsilon explore-exploit problem, explore step
            # incase of optimal initial values approach, explore always the Bandit which has higher mean, as it is not explored much
            j = np.argmax([b.running_mean for b in bandits])
            
        X = bandits[j].pull()
        bandits[j].update(X)
        
        data[i] = X
        
    cumulative_avg = np.cumsum(data) / (np.arange(N) + 1)
    return cumulative_avg
    
if(__name__ == '__main__'):
    c_0_mean = run_experiments(1., 2., 3., 100000, 0.2, 0)
    c_10_mean = run_experiments(1., 2., 3., 100000, 0.2, 10)
    
    plt.plot(c_0_mean, label='eps = 0.2, start mean = 0')
    plt.plot(c_10_mean, label='eps = 0.2, start mean = 10')
    plt.legend()
    plt.xscale('log')
    plt.savefig('./pics/'+ os.path.splitext(__file__)[0] + '_logplot.jpg')
    plt.clf()

    plt.plot(c_0_mean, label='eps = 0.2, start mean = 0')
    plt.plot(c_10_mean, label='eps = 0.2, start mean = 10')
    plt.legend()
    plt.savefig('./pics/'+ os.path.splitext(__file__)[0] + '_plot.jpg')
    plt.clf()

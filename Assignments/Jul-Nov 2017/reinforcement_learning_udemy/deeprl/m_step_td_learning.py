import gym
import os, sys, numpy as np
import matplotlib.pyplot as plt
from gym import wrappers
from datetime import datetime

import gym_rbf_mountaincar
from gym_rbf_mountaincar import plot_running_avg, Model, FeatureTransformer, plot_cost_to_go, play_best_policy

class SGDRegressor():
    def __init__(self, **kwargs):
        self.lr = 10e-3
        self.w = None
    
    def partial_fit(self, X, y):
        if self.w is None:
            D = X.shape[1]
            self.w = np.random.randn(D) / np.sqrt(D)
        
        self.w += self.lr * (y - X.dot(self.w)).dot(X)
    
    def predict(self, X):
        return X.dot(self.w)

# replace the default SGDRegressor
gym_rbf_mountaincar.SGDRegressor = SGDRegressor

# return the list of states_and_rewards and the total reward
def play_one(model, eps, gamma, n=5):
    observation = env.reset()
    done  = False
    total_reward = 0
    rewards = []
    states = []
    actions = []
    iters = 0

    # create gamma**n array in advance
    multiplier = np.array([gamma] * n) ** np.arange(n)

    while not done and iters < 200:
        action = model.sample_action(observation, eps)
        states.append(observation)
        actions.append(action)

        observation, reward, done, info = env.step(action)
        rewards.append(reward)

        # update the model if the length of rewards > n
        if len(rewards) > n:
            return_upto_prediction = multiplier.dot(rewards[-n:])
            G = return_upto_prediction + (gamma**n) * np.max(model.predict(observation)[0])
            model.update(states[-n], actions[-n], G)

        total_reward += reward
        iters += 1
    
    # empty the cache
    rewards = rewards[-n + 1:]
    actions = actions[-n + 1:]
    states = states[-n+1:]

    # to penalize model if it didnt reach goal
    if observation[0] >= 0.5:
        # we reached goal
        while len(rewards) > 0:
            G = multiplier[:len(rewards)].dot(rewards)
            model.update(states[0], actions[0], G)
            rewards.pop(0)
            actions.pop(0)
            states.pop(0)
        
    else:
        # we did not reach goal
        while len(rewards) > 0:
            guess_rewards = rewards + [-1] * (n - len(rewards))
            G = multiplier.dot(guess_rewards)
            model.update(states[0], actions[0], G)
            rewards.pop(0)
            actions.pop(0)
            states.pop(0)
    
    return total_reward

if __name__ == '__main__':
    env = gym.make('MountainCar-v0')
    ft = FeatureTransformer(env)
    model = Model(env, ft, 'constant')
    gamma = 0.99

    if 'monitor' in sys.argv:
        filename = os.path.basename(__file__).split('.')[0]
        monitor_dir = './' + filename + '_' + str(datetime.now())
        env = wrappers.monitor(env, monitor_dir)
    
    N = 300
    total_rewards = np.empty(N)
    costs = np.empty(N)

    for n in range(N):
        eps = 0.1 * (0.97 ** n)
        total_reward = play_one(model, eps, gamma)
        total_rewards[n] = total_reward
        print('episode', n, 'total reward', total_reward)
    
    print('avg reward of last 100 episodes ', total_rewards[-100:].mean())
    print('total steps ', -total_rewards[-100:].sum())
    
    plot_running_avg(total_rewards)

    # plot optimal state value function
    plot_cost_to_go(env, model)

    # play best policy
    play_best_policy(model, env)    


# imports

import matplotlib, time
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import os, sys, gym
from gym import wrappers
from datetime import datetime
from sklearn.pipeline import FeatureUnion
from sklearn.preprocessing import StandardScaler
from sklearn.kernel_approximation import RBFSampler
from sklearn.linear_model import SGDRegressor
import numpy as np


class FeatureTransformer:
    def __init__(self, env):
        # sample the states and scale them
        observation_examples = np.array([env.observation_space.sample() for _ in range(10000)])
        scaler = StandardScaler()
        scaler.fit(observation_examples)

        # featurizer to union the RBF features
        featurizer = FeatureUnion([
            ("rbf1", RBFSampler(gamma=5.0, n_components=500)),
            ("rbf2", RBFSampler(gamma=2.0, n_components=500)),
            ("rbf3", RBFSampler(gamma=1.0, n_components=500)),
            ("rbf4", RBFSampler(gamma=0.5, n_components=500)),
        ])

        featurizer.fit_transform(scaler.transform(observation_examples))

        self.scaler = scaler
        self.featurizer = featurizer

    def transform(self, observations):
        # scale the states
        scaled = self.scaler.transform(observations)
        # featurize
        return self.featurizer.transform(scaled)


class Model:
    def __init__(self, env, feature_transformer, learning_rate):
        self.env = env
        self.feature_transformer = feature_transformer
        self.models = []

        # create a model for each action
        for action in range(env.action_space.n):
            model = SGDRegressor(learning_rate=learning_rate)
            # SGDRegressor expects the partial_fit to be called atleast once before predicting
            model.partial_fit(feature_transformer.transform([env.reset()]), [0])
            self.models.append(model)

    def predict(self, observation):
        X = self.feature_transformer.transform([observation])
        return np.array([m.predict(X)[0] for m in self.models])

    def update(self, observation, action, G):
        X = self.feature_transformer.transform([observation])
        self.models[action].partial_fit(X, [G])

    # sample action : epsilon greedy strategy
    def sample_action(self, s, eps):
        if np.random.random() < eps:
            return self.env.action_space.sample()
        else:
            p = self.predict(s)
            return np.argmax(p)


def play_one(model, eps, gamma):
    observation = env.reset()
    done = False
    totalreward = 0

    # play the game starting from init state
    while not done:
        action = model.sample_action(observation, eps)
        prev_observation = observation
        observation, reward, done, info = env.step(action)

        # update the model with actual return
        #print(model.predict(observation).shape)
        G = reward + gamma * np.max(model.predict(observation)[0])
        model.update(prev_observation, action, G)

        totalreward += reward

    return totalreward


def plot_cost_to_go(env, estimator, num_tiles=20):
    # get X Y values
    x = np.linspace(env.observation_space.low[0], env.observation_space.high[0], num=num_tiles)
    y = np.linspace(env.observation_space.low[0], env.observation_space.high[0], num=num_tiles)
    X, Y = np.meshgrid(x, y)

    Z = np.apply_along_axis(lambda _: -np.max(estimator.predict(_)), 2, np.dstack([X, Y]))
    fig = plt.figure(figsize=(10, 5))
    ax = fig.add_subplot(111, projection='3d')
    surf = ax.plot_surface(X, Y, Z,
                           rstride=1, cstride=1, cmap=matplotlib.cm.coolwarm, vmin=-1.0, vmax=1.0)
    ax.set_xlabel('Position')
    ax.set_ylabel('Velocity')
    ax.set_zlabel('Cost-To-Go == -V(s)')
    ax.set_title("Cost-To-Go Function")
    fig.colorbar(surf)
    plt.show()


# calculate moving average
def moving_average (values, window):
    weights = np.repeat(1.0, window)/window
    sma = np.convolve(values, weights, 'valid')
    return sma

# plotthe rewards for all episodes
def plot_running_avg(total_rewards):
    ma = moving_average(total_rewards, 10)
    plt.plot(total_rewards)
    plt.plot(ma)
    plt.title("Moving average plot")
    plt.show()

def play_best_policy(model, env):
    print('running best policy')
    observation = env.reset()
    done = False
    total_reward = 0
    env.render()

    while not done:
        action_values = model.predict(observation)
        action = np.argmax(action_values)
        observation, reward, done, _ = env.step(action)
        total_reward += 1
        env.render()
        time.sleep(0.2)

    print('total reward : ' + str(total_reward))

if __name__ == '__main__':
    env = gym.make('MountainCar-v0')
    feature_transformer = FeatureTransformer(env)
    learning_rate = 0.01
    model = Model(env, feature_transformer, "constant")

    gamma = 0.99
    total_rewards = []
    N = 300

    if "monitor" in sys.argv:
        filename = os.path.basename(__file__).split(".")[0]
        monitor_dir = "./" + filename + "_" + str(datetime.now())
        env = wrappers.Monitor(env, monitor_dir)

    # play 10000 episodes
    for n in range(N):
        eps = 0.1 * (0.97**n)
        total_reward = play_one(model, eps, gamma)
        total_rewards.append(total_reward)

        if n % 10 == 0:
            print("episode #", n, ", total reward: ", total_reward, ", eps: ", eps)

    print ("avg reward for last 10 episodes: ", np.mean(total_rewards[-10:]))
    print("total steps : ", np.sum(total_rewards))
    plot_running_avg(total_rewards)

    # plot optimal state value function
    plot_cost_to_go(env, model)

    # play best policy
    play_best_policy(model, env)
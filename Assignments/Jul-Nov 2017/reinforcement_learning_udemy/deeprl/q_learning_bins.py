import gym, sys, os
from gym import wrappers
import numpy as np
from datetime import datetime
import matplotlib.pyplot as plt

def build_state(quantized_state):
    return int("".join(map(lambda feature: str(int(feature)), quantized_state)))

def to_bin(value, bins):
    return np.digitize(x=[value], bins=bins)[0]

# quantized states
class FeatureTransformer:
    def __init__(self, num_bins=9):
        self.cart_position_bins = np.linspace(-2.4, 2.4, num_bins)
        self.cart_velocity_bins = np.linspace(-2, 2, num_bins)
        self.pole_angle_bins = np.linspace(-0.4, 0.4, num_bins)
        self.pole_velocity_bins = np.linspace(-3.5, 3.5, num_bins)

    def transform(self, observation):
        cart_position, cart_velocity, pole_angle, pole_velocity = observation
        # build a state with quantized bins 
        return build_state([
                to_bin(cart_position, self.cart_position_bins),
                to_bin(cart_velocity, self.cart_velocity_bins),
                to_bin(pole_angle, self.pole_angle_bins),
                to_bin(pole_velocity, self.pole_velocity_bins)])

class Model:
    def __init__(self, env, feature_transformer):
        self.env = env
        self.feature_transformer = feature_transformer
        self.num_states = 10 ** env.observation_space.shape[0]
        self.num_actions = env.action_space.n
        
        # Q(s, a) is an array of size (#states, #actions)
        # #states is the 10 power of #state components(cart_velocity, cart_position etc)
        self.Q = np.random.uniform(low=-1, high=1, size=(self.num_states, self.num_actions))
    
    # get the values for particular state
    def predict(self, s):
        x = self.feature_transformer.transform(s)
        return self.Q[x]
        
    # Q update step
    def update(self, s, a, G):
        x = self.feature_transformer.transform(s)
        self.Q[x,a] += 10e-3*(G - self.Q[x,a])
    
    # sample action : epsilon greedy strategy
    def sample_action(self, s, eps):
        if np.random.random()< eps:
            return self.env.action_space.sample()
        else:
            p = self.predict(s)
            return np.argmax(p)

# play one episode
def play_one(model, eps, gamma):
    observation = env.reset()
    done = False
    iters = 0
    total_reward = 0

    # while the game is not completed
    while not done:
        # sample an action according to epsilon greedy strategy
        action = model.sample_action(observation, eps)
        prev_observation = observation
        observation, reward, done, info = env.step(action)
        
        # add up the rewards
        total_reward += reward
        if done and iters < 199:
            reward = -300
        
        # calculate return
        G = reward + gamma * np.max(model.predict(observation))
        model.update(prev_observation, action, G)
        
        iters += 1

    return total_reward

# calculate moving average
def moving_average (values, window):
    weights = np.repeat(1.0, window)/window
    sma = np.convolve(values, weights, 'valid')
    return sma

# plotthe rewards for all episodes
def plot_running_avg(total_rewards):
    ma = moving_average(total_rewards, 100)
    plt.plot(total_rewards)
    plt.plot(ma)
    plt.title("Moving average plot")
    plt.show()

if __name__ == "__main__":
    env = gym.make("CartPole-v0")
    ft = FeatureTransformer()
    model = Model(env, ft)
    
    gamma = 0.9
    total_rewards = []
    N = 5000
    
    if "monitor" in sys.argv:
        filename = os.path.basename(__file__).split(".")[0]
        monitor_dir = "./" + filename + "_" + str(datetime.now())
        env = wrappers.Monitor(env, monitor_dir)
    
    # play 10000 episodes
    for n in range(N):
        eps = 1. / np.sqrt(n + 1)
        total_reward = play_one(model, eps, gamma)
        total_rewards.append(total_reward)
        
        if n%100 == 0:
            print("episode #", n, ", total reward: ", total_reward, ", eps: ", eps)
        
    print ("avg reward for last 100 episodes: ", np.mean(total_rewards[-100:]))
    print("total steps : ", np.sum(total_rewards))
    plot_running_avg(total_rewards)
    
    
    

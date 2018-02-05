# import gym package
import gym
from gym import wrappers
import numpy as np
import matplotlib.pyplot as plt

def get_action(pos, weight):
    return 0 if pos.dot(weight) < 0 else 1

def play_episode(environment, weight):
    steps = 0
    done = False
    pos = env.reset()
    while not done:
        pos, reward, done, _ = env.step(get_action(pos, weight))
        steps += 1
    
    return steps
        
def play_multiple_episodes(environment, N, weight):
    lengths = []
    for it in range(N):
        length = play_episode(environment, weight)
        lengths.append(length)
    
    print('average length = ' + str(np.mean(lengths)))
    return np.mean(lengths)

def random_search(environment):
    max_weight = None
    max_avg_length = float('-inf')
    lengths = []
    
    for it in range(100):
        weight = np.random.randn(4)
        curr_avg_length = play_multiple_episodes(environment, 100, weight)
        lengths.append(curr_avg_length)
        
        if curr_avg_length > max_avg_length:
            max_avg_length = curr_avg_length
            max_weight = weight
    
    return lengths, max_weight

if __name__ == '__main__' :
    
    # load an environment
    # https://gym.openai.com/envs
    env = gym.make('CartPole-v0')

    # reset the env to start state
    # wiki: https://github.com/openai/gym/wiki/Table-of-environments
    start_state = env.reset()
    print(start_state)

    episode_length_avgs, final_weight = random_search(env)
    plt.plot(episode_length_avgs)
    plt.savefig('pics/random_search_cartpole.jpg')
    
    env = wrappers.Monitor(env, 'pics', force=True)
    start_state = env.reset()
    final_avg_length = play_episode(env, final_weight)
    print('final avg episode length = ' + str(final_avg_length))


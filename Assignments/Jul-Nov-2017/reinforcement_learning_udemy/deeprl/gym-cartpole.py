# import gym package
import gym

# load an environment
# https://gym.openai.com/envs
env = gym.make('CartPole-v0')

# reset the env to start state
# wiki: https://github.com/openai/gym/wiki/Table-of-environments
start_state = env.reset()
print(start_state)

box = env.observation_space
print(box)

actions = env.action_space
print(actions)

# to do a step from a sampled action
pos, reward, done, info = env.step(actions.sample())

# calculate average amount of steps
avg = 0
for it in range(1000):
    steps = 0
    done = False
    env.reset()
    while not done:
        pos, reward, done, _ = env.step(actions.sample())
        steps += 1
    
    N = it + 1
    avg = ((N-1.0)/N) * avg + steps * 1.0 / N

# close to 22.5 steps
print('Avg steps : ' + str(avg))

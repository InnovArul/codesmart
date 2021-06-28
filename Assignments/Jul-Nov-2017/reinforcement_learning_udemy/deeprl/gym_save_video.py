import gym
from gym import wrappers

env = gym.make('CartPole-v0')
actions = env.action_space
env = wrappers.Monitor(env, 'pics', force=True)
env.reset()

# do action until the game is over
done = False
while not done:
    env.render()
    _, _, done, _ = env.step(actions.sample())
